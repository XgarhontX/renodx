#include "../shared.h"

float InverseLerp1(float a, float b, float v) {
  return saturate((v - a) / (b - a));
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

namespace renodx {
namespace color {
namespace ictcp {
namespace from {
float3 BT2020(float3 bt2020_color, float scaling = 100.f) {
  float3 lms = mul(mul(XYZ_TO_DOLBY_LMS_MAT, BT2020_TO_XYZ_MAT), bt2020_color);
  float3 plms = pq::Encode(max(0, lms), scaling);
  float3 ictcp_color = mul(PLMS_TO_ICTCP_MAT, plms);
  return ictcp_color;
}

float4 BT709WithY(float3 bt709_color, float scaling = 100.f) {
  // float3 lms = mul(mul(XYZ_TO_DOLBY_LMS_MAT, BT709_TO_XYZ_MAT), bt709_color);
  float3 xyz = mul(BT709_TO_XYZ_MAT, bt709_color);
  float3 lms = mul(XYZ_TO_DOLBY_LMS_MAT, xyz);
  float3 plms = pq::Encode(max(0, lms), scaling);
  float3 ictcp_color = mul(PLMS_TO_ICTCP_MAT, plms);
  return float4(ictcp_color, xyz.y);
}
}}}}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//https://github.com/Filoppi/Luma-Framework/blob/main/Shaders/Includes/ColorGradingLUT.hlsl
// Restores the source color hue (and optionally brightness) through Oklab (this works on colors beyond SDR in brightness and gamut too).
// The strength sweet spot for a strong hue restoration seems to be 0.75, while for chrominance, going up to 1 is ok.
float3 RestoreHueAndChrominance(float3 targetUcsLab, float3 sourceUcsLab, float hueStrength = 1.0, float chrominanceStrength = 1.0, float lightnessStrength = 0.0, float saturation = 1.0)
{
  const static float minChrominanceChange = 0;
  const static float maxChrominanceChange = renodx::math::FLT16_MAX;
   
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
  colorExp = renodx::color::ictcp::from::BT2020(colorExp);
  colorRef = renodx::color::ictcp::from::BT2020(colorRef);
  colorExp = RestoreHueAndChrominance(colorExp, colorRef, 1.0, CorrectionChrominance, CorrectionLuminance, Saturation);
  colorExp = renodx::color::bt709::from::ICtCp(colorExp);

  return colorExp;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// #include "./Luma/JzAzBz.hlsl"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

float3 UpgradeToneMap1(
    float3 color_untonemapped,
    float3 color_tonemapped,
    float3 color_tonemapped_graded,
    float post_process_strength = 1.f,
    float auto_correction = 0.f) {
  float ratio = 1.f;

  float y_untonemapped = renodx::color::y::from::BT709(color_untonemapped);
  float y_tonemapped = renodx::color::y::from::BT709(color_tonemapped);
  float y_tonemapped_graded = renodx::color::y::from::BT709(color_tonemapped_graded);

  if (y_untonemapped < y_tonemapped) {
    // If substracting (user contrast or paperwhite) scale down instead
    // Should only apply on mismatched HDR
    ratio = y_untonemapped / y_tonemapped;
  } else {
    float y_delta = y_untonemapped - y_tonemapped;
    y_delta = max(0, y_delta);  // Cleans up NaN
    const float y_new = y_tonemapped_graded + y_delta;

    const bool y_valid = (y_tonemapped_graded > 0);  // Cleans up NaN and ignore black
    ratio = y_valid ? (y_new / y_tonemapped_graded) : 0;
  }
  float auto_correct_ratio = lerp(1.f, ratio, saturate(y_untonemapped));
  ratio = lerp(ratio, auto_correct_ratio, auto_correction);

  float3 color_scaled = color_tonemapped_graded * ratio;
  // Match hue
  color_scaled = renodx::color::correct::HueICtCp(color_scaled, color_tonemapped_graded);
  return lerp(color_untonemapped, color_scaled, post_process_strength);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

float3 SunPass(in float3 color, in sampler2D tex, in float2 uv, in float strength) {
  if (TONE_MAP_TYPE == 0) return color;

  color = renodx::color::grade::Saturation(color, 1.5); //counteract blowout

  // boost
  float3 colorO = color;
  // color = renodx::color::grade::Contrast(color, 1.9, .5);
  color *= C_SUNGLARE * 1.9;
  // color = renodx::color::grade::Saturation(color, 1.5);

  // sun
  const float sunSizeScaled = C_SUNSIZE * 0.002f;
  if (sunSizeScaled > 0) {
    float3 colorCenter = tex2D(tex, (float2)0.5f).xyz;
    
    float dist = distance((float2)0.5f, uv);
    const float glowSizeOffset = 0.0075f;
    if (dist < sunSizeScaled + glowSizeOffset && strength > 0.75f) {
      // if (dist < sunSizeScaled) {
      //   float y = renodx::color::y::from::BT709(colorO);
      //   color = colorCenter;
      //   color *= (lerp(0, 10000, saturate(strength * strength)) / 203.) / renodx::color::y::from::BT709(color);  // TODO sun brightness
      // } else {
        float s = InverseLerp1(sunSizeScaled, sunSizeScaled + glowSizeOffset, dist);
        s = 1 - s;
        s = pow(s, 3);
        color += lerp(0, 20000 / 203, s);
      // }
    }
  } 

  return color;
}
