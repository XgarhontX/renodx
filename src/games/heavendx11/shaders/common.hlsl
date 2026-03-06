#include "../shared.h"

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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//https://github.com/Filoppi/Luma-Framework/blob/main/Shaders/Includes/ColorGradingLUT.hlsl
// Restores the source color hue (and optionally brightness) through Oklab (this works on colors beyond SDR in brightness and gamut too).
// The strength sweet spot for a strong hue restoration seems to be 0.75, while for chrominance, going up to 1 is ok.
float3 RestoreHueAndChrominance(float3 targetUcsLab, float3 sourceUcsLab, float hueStrength = 1.0, float chrominanceStrength = 1.0, float lightnessStrength = 0.0, float saturation = 1.0)
{
  const static float minChrominanceChange = 0;
  const static float maxChrominanceChange = 999999;
   
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

  return targetUcsLab;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

float3 FakeWCGBT709(float3 color, float DecodeGamma = 2.2, float CorrectionChrominance = 0.5, float CorrectionLuminance = 0.6, float Saturation = 1.0) {
  if (DecodeGamma <= 0) return color; //RETURN: inactive

  float3 colorRef = renodx::color::bt2020::from::BT709(color);
  float3 colorExp = color;

  //expand
  colorExp = renodx::color::gamma::EncodeSafe(colorExp, DecodeGamma);
  colorExp = renodx::color::bt2020::from::BT709(colorExp);
  colorExp = renodx::color::gamma::DecodeSafe(colorExp, DecodeGamma);

  //correct
  colorExp = Oklab_From_BT2020(colorExp);
  colorRef = Oklab_From_BT2020(colorRef);
  colorExp = RestoreHueAndChrominance(colorExp, colorRef, 1.0, CorrectionChrominance, CorrectionLuminance, Saturation);
  colorExp = BT2020_From_Oklab(colorExp);

  //back to BT709
  colorExp = renodx::color::bt709::from::BT2020(colorExp);
  return colorExp;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void Sun_Boost(inout float x) {
  if (SI.sun_boost > 0 && SI.tone_map_type != 1.f) x = renodx::color::grade::Contrast(x, SI.sun_boost, 0.7);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void T_LensDirt(inout float3 x) {
  x = lerp(0.25, x, SI.lens_dirt);
}

float3 T_ResolveLutAndGamma(float3 x, Texture3D<float4> s_texture_14, SamplerState s_sampler_14_s, float2 texcoord) {
  //color Untonemapped (source of HDR luminance)
  float3 colorU = x;

  //Return: redunant black color, prevents div 0
  if (max(max(colorU.r, colorU.g), colorU.b) <= 0.f) return 0.f;

  // Return: SDR
  if (SI.tone_map_type == 1.f) {
    //LUT
    x = renodx::color::gamma::Encode(x); 
    x = x * (31.0 / 32.0) + 1.0 / 64.0; 
    x = s_texture_14.Sample(s_sampler_14_s, x).xyz;
    x = renodx::color::srgb::Decode(x);
    x = lerp(colorU, x, SI.lut);
    return x;
  }

  // colorU blowout
  if (SI.pblow_enabled > 0.f)
  {
    //custom perchannel blownout color from near SDR tonemap 
    const float sdrMax = SI.pblow_max; //(arbitrary, just if it look nice!)
    const float sdrStart = SI.pblow_start;
    float3 colorUBlow = renodx::tonemap::ReinhardPiecewise(colorU, sdrMax, sdrStart);
    // float3 colorUBlow = renodx::tonemap::ExponentialRollOff(colorU, sdrStart, sdrMax);

    //hue and chrominance
    const float hueStrength = SI.pblow_chue;
    const float chrominanceStrength = SI.pblow_csat;

    colorU = renodx::color::oklab::from::BT709(colorU);
    colorUBlow = renodx::color::oklab::from::BT709(colorUBlow);
    colorU = RestoreHueAndChrominance(colorU, colorUBlow, hueStrength, chrominanceStrength);
    colorU = renodx::color::bt709::from::OkLab(colorU);
  }

  //color Neutral (will be used to sample LUT)
  float3 colorN = colorU; {
    //max channel tonemap (chrominance/hue preserving)
    float m = max(max(colorN.r, colorN.g), colorN.b); //max
    // float m = renodx::color::y::from::BT709(m); //luma

    //rolloff to 1
    float m1 = m; {
      m1 = renodx::tonemap::ReinhardExtended(m1, 4.5, 1);
      m1 = min(m1, 1); //clamp just in case
    }
    colorN *= (m1 / m); //scale from m to m1, preserving chroma.
  }

  //LUT
  x = colorN; { //use colorN to sample LUT!
    x = renodx::color::gamma::Encode(x);  // to gamma
    x = x * (31.0 / 32.0) + 1.0 / 64.0; //pad
    x = s_texture_14.Sample(s_sampler_14_s, x).xyz;

    x = renodx::color::gamma::Decode(x);
    // x = renodx::color::srgb::Decode(x);
  }
  // //debug compare
  // if (texcoord.x < 1/2.) return colorN;
  // else return x;

  //UpgradeToneMap() (Superimpose HDR luma onto SDR graded chroma, influenced by SDR luma delta)
  x = renodx::tonemap::UpgradeToneMap(colorU, colorN, x, SI.lut); //all linear

  //2.2 to sRGB (this give more saturation/warmth than if LUT color is sRGB Decoded.)
  x = renodx::color::correct::Gamma(x, true, 2.2);

  // color grade
  {
    const float l = renodx::color::y::from::BT709(colorU);
    float l1 = l;

    l1 *= SI.cg_exposure;
    l1 = renodx::color::grade::Contrast(l1, SI.cg_contrast);
    l1 = renodx::color::grade::Shadows(l1, SI.cg_shadows);
    l1 = renodx::color::grade::Highlights(l1, SI.cg_highlights);

    x *= l1 / l;
    if (max(max(x.r, x.g), x.b) <= 0.f) return 0.f;
  }

  // HDR Tonemap
  if (SI.tone_map_type > 0)
  {
    const float peak = SI.peak_white_nits / SI.diffuse_white_nits;
    const float expMax = SI.expected_peak_white_nits / 203.;

    if (SI.pblow_enabled > 0.f) {
      // luma, since blowout was handled prior
       const float l = renodx::color::y::from::BT2020(x);
      // const float l = max(max(x.r, x.g), x.b);
      float l1 = l;
      l1 = renodx::tonemap::HermiteSplineLuminanceRolloff(l1, peak, expMax);
      x *= l1 / l;
    } else {
      //perchannel
      x = renodx::tonemap::HermiteSplinePerChannelRolloff(x, peak, expMax);
    }
  }

  // fake wcg
  x = FakeWCGBT709(
    x, 
    SI.fakewcgcorrect_gamma, 
    SI.fakewcgcorrect_chroma, 
    SI.fakewcgcorrect_luma, 
    SI.fakewcgcorrect_sat
  );

  return x; //out linear
}

float3 T_RenderIntermediatePass(float3 x) {
  x *= SI.diffuse_white_nits / SI.graphics_white_nits; //intermediate scaling
  x = renodx::color::srgb::EncodeSafe(x); //intermediate encode
  return x; 
}