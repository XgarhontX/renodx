#include "../shared.h"

// // (Copied from: ff7rebirth)
// // AdvancedAutoHDR pass to generate some HDR brightess out of an SDR signal.
// // This is hue conserving and only really affects highlights.
// // "sdr_color" is meant to be in "SDR range", as in, a value of 1 matching SDR white (something between 80, 100, 203, 300 nits, or whatever else)
// // https://github.com/Filoppi/PumboAutoHDR
// float3 PumboAutoHDR(float3 sdr_color) {
//   const float shoulder_pow = CUSTOM_MOV_SHOULDERPOW;
//   const float SDRRatio = max(renodx::color::y::from::BT2020(sdr_color), 0.f);

//   // Limit AutoHDR brightness, it won't look good beyond a certain level.
//   // The paper white multiplier is applied later so we account for that.
//   float target_max_luminance = min(RENODX_PEAK_WHITE_NITS, pow(10.f, ((log10(RENODX_DIFFUSE_WHITE_NITS) - 0.03460730900256) / 0.757737096673107)));
//   target_max_luminance = lerp(1.f, target_max_luminance, .5f);

//   const float auto_HDR_max_white = max(target_max_luminance / RENODX_DIFFUSE_WHITE_NITS, 1.f);
//   const float auto_HDR_shoulder_ratio = 1.f - max(1.f - SDRRatio, 0.f);
//   const float auto_HDR_extra_ratio = pow(max(auto_HDR_shoulder_ratio, 0.f), shoulder_pow) * (auto_HDR_max_white - 1.f);
//   const float auto_HDR_total_ratio = SDRRatio + auto_HDR_extra_ratio;
//   return sdr_color * renodx::math::SafeDivision(auto_HDR_total_ratio, SDRRatio, 1);  // Fallback on a value of 1 in case of division by 0
// }

#define RHSC_E (50.f/41.f)
float3 ReinhardScalableCached(float3 x) {
  return (x * RHSC_E) / (x * RHSC_E + 1.f);
}

// //https://github.com/ronja-tutorials/ShaderTutorials/blob/master/Assets/047_InverseInterpolationAndRemap/Interpolation.cginc
// float invLerp(float from, float to, float value) {
//   return (value - from) / (to - from);
// }
// float4 invLerp(float4 from, float4 to, float4 value) {
//   return (value - from) / (to - from);
// }
// float remap(float origFrom, float origTo, float targetFrom, float targetTo, float value){
//   float rel = invLerp(origFrom, origTo, value);
//   return lerp(targetFrom, targetTo, rel);
// }
// float4 remap(float4 origFrom, float4 origTo, float4 targetFrom, float4 targetTo, float4 value){
//   float4 rel = invLerp(origFrom, origTo, value);
//   return lerp(targetFrom, targetTo, rel);
// }

float Max(in float3 v) {return renodx::math::Max(v.x, v.y, v.z);}

float Tonemap_GetY(float3 color) {
  return renodx::color::y::from::BT709(color);
}

// void Tonemap_Compressor(inout float3 x) {
//   if (CUSTOM_COMPRESSOR_POWER == 1) return;

//   x /= CUSTOM_COMPRESSOR_THRESHOLD;

//   float colorY = renodx::color::y::from::BT709(x);
//   x = colorY < 1 ? x : renodx::math::SignPow(x, CUSTOM_COMPRESSOR_POWER); 

//   x *= CUSTOM_COMPRESSOR_THRESHOLD;
// }
// float Tonemap_Compressor(float x) {
//   x /= CUSTOM_COMPRESSOR_THRESHOLD;
//   x = x < 1 ? x : renodx::math::SignPow(x, CUSTOM_COMPRESSOR_POWER); 
//   x *= CUSTOM_COMPRESSOR_THRESHOLD;
//   return x;
// }

void Tonemap_SaveBlacks(in float3 colorUntonemapped, inout float4 r0) {
  // if (CUSTOM_UPGRADETONEMAP_SAVEBLACKS == 0) return;
  if (Tonemap_GetY(r0.xyz) <= CUSTOM_UPGRADETONEMAP_SAVEBLACKS)
    r0.xyz = renodx::color::correct::Luminance(colorUntonemapped, Tonemap_GetY(colorUntonemapped), CUSTOM_UPGRADETONEMAP_SAVEBLACKS);
}

void Tonemap_UpgradeTonemap0(inout float3 colorUntonemapped, inout float4 r0) {
  if (RENODX_TONE_MAP_TYPE == 0) return;

  //save blacks
  Tonemap_SaveBlacks(colorUntonemapped, r0);
}

void ADSSights_Scale(inout float4 o0) {
  o0.xyz *= CUSTOM_ADSSIGHT_MULTIPLIER;
}

void Tonemap_BloomScale(inout float4 color) {
  color.xyz *= CUSTOM_BLOOM_MULTIPLIER; 
  color.w = 1;
}

float Tonemap_CalculatePreExposureMultiplier(float4 v0, float4 v1, float4 v2) 
{
  //v0.xyz = high, mid, low thresholds
  //v1.xyz = high, mid, low multipliers
  //v2 = color corrections?

  // float target;
  // // float t1 = Max(v0.xyz) * CUSTOM_PREEXPOSURE_OFFSET_MULTIPLIER;
  // float t1 = max(v0.y, v0.z) * CUSTOM_PREEXPOSURE_OFFSET_MULTIPLIER;
  // float t2 = Max(v1.xyz) * CUSTOM_PREEXPOSURE_AUTO_MULTIPLIER;
  // // float t3 = max(1 - v0.x, 0) * CUSTOM_PREEXPOSURE_OFFSET_MULTIPLIER;
  // target = t1 + t2;
  // // target /= 2;

  float target;
  
  target = 0;
  target += max(v0.y, v0.z) * CUSTOM_PREEXPOSURE_OFFSET_MULTIPLIER;
  target += max(v1.y, v1.z) * CUSTOM_PREEXPOSURE_AUTO_MULTIPLIER;

  float v0diff = (1 - v0.x);
  target += max(target, v0diff);
  target /= 2;

  target *= CUSTOM_PREEXPOSURE_FINAL;
  return target;
}

// void Tonemap_PrepColorUntonemapped(inout float3 colorUntonemapped, inout float4 r0) {
//   colorUntonemapped = r0.xyz;
//   colorUntonemapped = renodx::color::correct::Luminance(colorUntonemapped, Tonemap_GetY(colorUntonemapped), r0.w);
//   // colorUntonemapped = max(float3(0,0,0), colorUntonemapped); //clamp
//   r0.w = 1; //reset
// }

void Tonemap_RecoverYFromW(inout float4 r0) {
  if (RENODX_TONE_MAP_TYPE == 0) return;

  r0.xyz = renodx::color::correct::Luminance(r0.xyz, Tonemap_GetY(r0.xyz), r0.w, 1); //correct
  r0.w = 1; //reset
}

static renodx::debug::graph::Config graph_config; 
void Tonemap_Do(inout float4 r0, float3 colorUntonemapped, float3 colorTonemapped/* , float3 colorSDRNeutral */, float2 uv, Texture2D<float4> texColor) {
  //colorTonemapped decode
  colorTonemapped = renodx::color::srgb::DecodeSafe(colorTonemapped);

  if (RENODX_TONE_MAP_TYPE > 0) {
    //graph start
    if (CUSTOM_IS_CALIBRATION == 1) graph_config = renodx::debug::graph::DrawStart(uv, colorUntonemapped, texColor, RENODX_PEAK_WHITE_NITS, RENODX_DIFFUSE_WHITE_NITS);

    //colorUntonemapped blowout
    colorUntonemapped = CUSTOM_GRADE_CHROMA < 1 ? renodx::tonemap::frostbite::BT709(colorUntonemapped, 10000, 0.25f, CUSTOM_GRADE_CHROMA, 1.f) : colorUntonemapped;
    //CUSTOM_GRADE_CHROMA
    colorTonemapped = renodx::tonemap::UpgradeToneMap(
      colorTonemapped, colorUntonemapped, colorUntonemapped, 
      1-CUSTOM_GRADE_CHROMA, 0
    );

    //CUSTOM_GRADE_LUMA
    float3 colorSDRNeutral;
    {
      colorSDRNeutral = colorUntonemapped;
      colorSDRNeutral = ReinhardScalableCached(colorSDRNeutral);
      colorSDRNeutral = lerp(colorTonemapped, colorSDRNeutral, CUSTOM_GRADE_LUMA);
    }

    // ToneMapPass
    r0.xyz = renodx::draw::ToneMapPass(colorUntonemapped, colorTonemapped, colorSDRNeutral);

    //graph end
    if (CUSTOM_IS_CALIBRATION == 1) r0.xyz = renodx::debug::graph::DrawEnd(r0.xyz, graph_config);
  } else {
    //just decode original
    r0.xyz = colorTonemapped;
    r0.xyz = saturate(r0.xyz); //SDR 0-1.
  }

  //RenderIntermediatePass
  r0.xyz = renodx::draw::RenderIntermediatePass(r0.xyz);
  r0 = max(r0, float4(0,0,0,0));
}

void Tonemap_Do_Bypassed(inout float4 r0) {
  //just decode original
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  r0.xyz = saturate(r0.xyz); //emulate SDR 0-1. yes, i checked, they do rely on the inherit r8g8b8 clamping.

  //RenderIntermediatePass
  r0.xyz = renodx::draw::RenderIntermediatePass(r0.xyz);
  r0 = max(r0, float4(0,0,0,0));
}