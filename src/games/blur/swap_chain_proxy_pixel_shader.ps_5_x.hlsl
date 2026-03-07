#include "./shared.h"

Texture2D t0 : register(t0);
SamplerState s0 : register(s0);

float3 EOTFEmulate(float3 color, float gamma) {
  const float scale = shader_injection.gamma_correction / 80.f;
  color /= scale;

  if (abs(color.x) < 1) color.x = pow(renodx::color::srgb::EncodeSafe(color.x), gamma);
  if (abs(color.y) < 1) color.y = pow(renodx::color::srgb::EncodeSafe(color.y), gamma);
  if (abs(color.z) < 1) color.z = pow(renodx::color::srgb::EncodeSafe(color.z), gamma);

  color *= scale;

  color = max(0, color);
  return color;
}

float3 Oklab_From_BT2020(float3 bt709) {
  static const float3x3 BT2020_2_OKLABLMS = {
    0.616688430f, 0.360159069f, 0.0230432935f,
    0.265140205f, 0.635856509f, 0.0990302339f,
    0.100150644f, 0.204004317f, 0.696324706f
  };
  static const float3x3 OKLABLMS_2_OKLAB = {
    0.2104542553f, 0.7936177850f, -0.0040720468f,
    1.9779984951f, -2.4285922050f, 0.4505937099f,
    0.0259040371f, 0.7827717662f, -0.8086757660f
  };

  float3 lms = mul(BT2020_2_OKLABLMS, bt709);

  lms = renodx::math::Cbrt(lms);

  return mul(OKLABLMS_2_OKLAB, lms);
}

float3 BT2020_From_Oklab(float3 oklab) {
  static const float3x3 OKLAB_2_OKLABLMS = {
    1.f, 0.3963377774f, 0.2158037573f,
    1.f, -0.1055613458f, -0.0638541728f,
    1.f, -0.0894841775f, -1.2914855480f
  };

  static const float3x3 OKLABLMS_2_BT2020 = {
    2.14014029f,   -1.24635589f,   0.106431722f,
    -0.884832441f,   2.16317272f,  -0.278361588f,
    -0.0485790595f, -0.454490900f,  1.50235629f
  };

  float3 lms = mul(OKLAB_2_OKLABLMS, oklab);

  lms = lms * lms * lms;

  return mul(OKLABLMS_2_BT2020, lms);
}

//https://github.com/Filoppi/Luma-Framework/blob/main/Shaders/Includes/Math.hlsl
float3 Sign_UltraFast(float3 x)
{
  return asfloat((asuint(x) & 0x80000000u) | 0x3F800000u);
}

//https://github.com/Filoppi/Luma-Framework/blob/main/Shaders/Includes/ColorGradingLUT.hlsl
// Restores the source color hue (and optionally brightness) through Oklab (this works on colors beyond SDR in brightness and gamut too).
// The strength sweet spot for a strong hue restoration seems to be 0.75, while for chrominance, going up to 1 is ok.
float3 RestoreHueAndChrominanceBT2020(float3 targetColor, float3 sourceColor, float hueStrength = 1.0, float chrominanceStrength = 1.0, float lightnessStrength = 0.0, float saturation = 1.0)
{
  const static float minChrominanceChange = 0;
  const static float maxChrominanceChange = 999999;
  
  // Invalid or black colors fail oklab conversions or ab blending so early out
  if (renodx::color::y::from::BT2020(targetColor) <= 0)
    return targetColor; // Optionally we could blend the target towards the source, or towards black, but there's no need until proven otherwise

	const float3 sourceUcsLab = Oklab_From_BT2020(sourceColor);
	float3 targetUcsLab = Oklab_From_BT2020(targetColor);
   
  targetUcsLab.x = lerp(targetUcsLab.x, sourceUcsLab.x, lightnessStrength);
  
	float currentChrominance = length(targetUcsLab.yz);

  if (hueStrength != 0.0)
  {
    // First correct both hue and chrominance at the same time (oklab a and b determine both, they are the color xy coordinates basically).
    // As long as we don't restore the hue to a 100% (which should be avoided?), this will always work perfectly even if the source color is pure white (or black, any "hueless" and "chromaless" color).
    // This method also works on white source colors because the center of the oklab ab diagram is a "white hue", thus we'd simply blend towards white (but never flipping beyond it (e.g. from positive to negative coordinates)),
    // and then restore the original chrominance later (white still conserving the original hue direction, so likely spitting out the same color as the original, or one very close to it).
    const float chrominancePre = currentChrominance;
    targetUcsLab.yz = lerp(targetUcsLab.yz, sourceUcsLab.yz, hueStrength);
    const float chrominancePost = length(targetUcsLab.yz);
    // Then restore chrominance to the original one
    float chrominanceRatio = renodx::math::SafeDivision(chrominancePre, chrominancePost, 1);
    targetUcsLab.yz *= chrominanceRatio;
    //currentChrominance = chrominancePre; // Redundant
  }

  if (chrominanceStrength != 0.0)
  {
    const float sourceChrominance = length(sourceUcsLab.yz);
    // Scale original chroma vector from 1.0 to ratio of target to new chroma
    // Note that this might either reduce or increase the chroma.
    float targetChrominanceRatio = renodx::math::SafeDivision(sourceChrominance, currentChrominance, 1);
    // Optional safe boundaries (0.333x to 2x is a decent range)
    targetChrominanceRatio = clamp(targetChrominanceRatio, minChrominanceChange, maxChrominanceChange);
    targetUcsLab.yz *= lerp(1.0, targetChrominanceRatio, chrominanceStrength);
  }

  //Saturation
  targetUcsLab.yz *= saturation;

	return BT2020_From_Oklab(targetUcsLab);
}

float3 FakeWCG(float3 color, float DecodeGamma = 2.2, float CorrectionChrominance = 0.5, float CorrectionLuminance = 0.6, float Saturation = 1.0) {
  float3 colorRef = color;
  if (DecodeGamma <= 0) return colorRef; //RETURN: inactive
  float3 colorExp = renodx::color::bt709::from::BT2020(color);

  //expand
  colorExp = Sign_UltraFast(colorExp) * pow(abs(colorExp), rcp(DecodeGamma));
  colorExp = renodx::color::bt2020::from::BT709(colorExp);
  colorExp = Sign_UltraFast(colorExp) * pow(abs(colorExp), DecodeGamma);

  //correct
  colorExp = RestoreHueAndChrominanceBT2020(colorExp, colorRef, 1.0, CorrectionChrominance, CorrectionLuminance, Saturation);

  return colorExp = /* renodx::color::bt2020::from::BT709 */(colorExp);
}

float4 main(float4 vpos: SV_POSITION, float2 uv: TEXCOORD0)
    : SV_TARGET {
  float3 x = t0.Sample(s0, uv).xyz;

  //to linear
  x = renodx::color::srgb::DecodeSafe(x);

  //intemediate scaling
  x *= shader_injection.graphics_white_nits / 80.0;

  // tonemap
  // float3 sign = Sign_UltraFast(x);
  // x = abs(x);
  x = max(0, x);
  [branch]
  if (shader_injection.tone_map_type == 1.f) x = renodx::tonemap::HermiteSplinePerChannelRolloff(x, shader_injection.peak_white_nits / 80., shader_injection.expected_peak_white_nits / 80.);
  else if (shader_injection.tone_map_type == 2.f) x = renodx::tonemap::neutwo::PerChannel(x, shader_injection.peak_white_nits / 80.);

  //to BT2020
  x = renodx::color::bt2020::from::BT709(x);

  //EOTF Emulate (bt2020)
  if (shader_injection.gamma_correction > 0.f) x = EOTFEmulate(x, 2.2);

  //fake wcg (bt2020)
  x = FakeWCG(x, shader_injection.fakewcgcorrect_gamma, shader_injection.fakewcgcorrect_chroma, shader_injection.fakewcgcorrect_luma, shader_injection.fakewcgcorrect_sat);
  x = max(0, x);

  //to bt709
  x = renodx::color::bt709::from::BT2020(x);

  return float4(x, 1.0);
}
