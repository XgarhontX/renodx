#include "../shared.h"
#include "./Includes/JzAzBz.hlsl"

float3 ICtCpFromBT2020(float3 x, float scaling = 100.f) {
    float3 lms = mul(mul(renodx::color::ictcp::XYZ_TO_DOLBY_LMS_MAT, renodx::color::BT2020_TO_XYZ_MAT), x);
  float3 plms = renodx::color::pq::Encode(max(0, lms), scaling);
  float3 ictcp_color = mul(renodx::color::ictcp::PLMS_TO_ICTCP_MAT, plms);
  return ictcp_color;
}

float3 BT2020FromICtCp(float3 ictcp_color, float scaling = 100.f) {
  float3 plms_color = mul(renodx::math::Invert3x3(renodx::color::ictcp::PLMS_TO_ICTCP_MAT), ictcp_color);
  float3 lms_color = renodx::color::pq::Decode(plms_color, scaling);
  float3 x = mul(
      mul(
          renodx::math::Invert3x3(renodx::color::BT2020_TO_XYZ_MAT),
          renodx::math::Invert3x3(renodx::color::ictcp::XYZ_TO_DOLBY_LMS_MAT)),
      lms_color);
  return x;
}

//coeff from Lilium's
static const float3x3 DCIP3_To_BT2020 = float3x3 (
   0.753833055f,   0.198597371f,  0.0475695952f,
   0.0457438491f,  0.941777229f,  0.0124789308f,
  -0.00121034029f, 0.0176017172f, 0.983608603f
);
static const float3x3 DCIP3_To_XYZ = float3x3 (
  0.486570954f, 0.265667706f,  0.198217287f,
  0.228974565f, 0.691738545f,  0.0792869105f,
  0.f,          0.0451133809f, 1.04394435f
);

float GetLuminanceP3(float3 color) {
    return dot(color, DCIP3_To_XYZ[1]);
}

float3 UpgradeToneMap(float3 color_untonemapped, float3 color_tonemapped_graded) {
  // color_untonemapped = mul(Csp::Mat::DCIP3_To_BT2020, color_untonemapped); 
  // return color_untonemapped;
  
  //y
  float y_tonemapped_graded = renodx::color::y::from::BT2020(color_tonemapped_graded);
  float y_tonemapped_graded_original = y_tonemapped_graded;
  if (SI.tone_map_type == 2.f) y_tonemapped_graded *= 2;

  #if 1
    //upgrade (stitch back cutoff luminance)
    float y_untonemapped = GetLuminanceP3(color_untonemapped);
    // if (SI.tone_map_type == 2.f) return color_untonemapped *= renodx::color::grade::Contrast(y_untonemapped, 1.2, 0.12) / y_untonemapped;
    if (SI.tone_map_type == 2.f) y_untonemapped = renodx::color::grade::Contrast(y_untonemapped, 1.2, 0.12);

    float y_tonemapped;
    const float p = SI.tone_map_type == 1.f ? 1000.f / 203.f : 10000.f / 203.f;
    const float m = SI.tone_map_type == 1.f ? 80000.f/203.f : 100000.f / 203.f;
    y_tonemapped = renodx::tonemap::HermiteSplineLuminanceRolloff(y_untonemapped, p, m); //mimic spline tonemap from lut builder

    float ratio = 1.f;
    if (y_untonemapped < y_tonemapped) {
      ratio = y_untonemapped / y_tonemapped;
    } else {
      float y_delta = y_untonemapped - y_tonemapped;
      y_delta = max(0, y_delta);
      const float y_new = y_tonemapped_graded + y_delta;
      ratio = y_tonemapped_graded > 0 ? (y_new / y_tonemapped_graded) : 0;
    }
    y_tonemapped_graded *= ratio;
  #endif

  //Color Grade
  if (y_tonemapped_graded > 0) {
    y_tonemapped_graded *= SI.cg_exposure;
    y_tonemapped_graded = renodx::color::grade::Contrast(y_tonemapped_graded, SI.cg_contrast, SI.cg_midgray);
    y_tonemapped_graded = renodx::color::grade::Highlights(y_tonemapped_graded, SI.cg_highlights, SI.cg_midgray);
    y_tonemapped_graded = renodx::color::grade::Shadows(y_tonemapped_graded, SI.cg_shadows, SI.cg_midgray);
    y_tonemapped_graded = max(0, y_tonemapped_graded);
  }

  //apply above
  color_tonemapped_graded *= y_tonemapped_graded / y_tonemapped_graded_original;

  // color_tonemapped_graded = lerp(color_untonemapped, color_tonemapped_graded, SI.cg_exposure); //TODO:
  
  return color_tonemapped_graded;
}

// float3 GRIDEncode(float3 x) {
//     x = max(x, 0.002668f); //clamp bt2020
//     x = log2(x);
//     x = x * 0.071429f + 0.610727f;
//     x = saturate(x); 
//     return x;
// }
// 
// float3 GRIDDecode(float3 x) {
//     x = x - 0.610727f;
//     x = x / 0.071429f;
//     x = exp2(x);
//     x = max(x - 0.002668f, 0.0f); //clamp bt2020
//     return x;
// }

//https://github.com/Filoppi/Luma-Framework/blob/main/Shaders/Includes/ColorGradingLUT.hlsl
float3 RestoreHueAndChrominance(float3 targetUcsLab, float3 sourceUcsLab, float hueStrength = 1.0f, float chrominanceStrength = 1.0f, /* float lightnessStrength = 0.0f, */ float saturation = 1.0f)
{   
  // targetUcsLab.x = lerp(targetUcsLab.x, sourceUcsLab.x, lightnessStrength);
  
  float currentChrominance = length(targetUcsLab.yz);

  if (hueStrength != 0.0f)
  {
    const float chrominancePre = currentChrominance;
    targetUcsLab.yz = lerp(targetUcsLab.yz, sourceUcsLab.yz, hueStrength);
    const float chrominancePost = length(targetUcsLab.yz);
    float chrominanceRatio = renodx::math::SafeDivision(chrominancePre, chrominancePost, 1);
    targetUcsLab.yz *= chrominanceRatio;
  }

  if (chrominanceStrength != 0.0f)
  {
    const float sourceChrominance = length(sourceUcsLab.yz);
    float targetChrominanceRatio = renodx::math::SafeDivision(sourceChrominance, currentChrominance, 1);
    targetChrominanceRatio = max(targetChrominanceRatio, 0);
    targetUcsLab.yz *= lerp(1.0f, targetChrominanceRatio, chrominanceStrength);
  }

  targetUcsLab.yz *= saturation;

  return targetUcsLab;
}