#include "../shared.h"

#define PREEXPOSURE_FINAL_MULTIPLIER 0.15;
#define TONEMAP_MAXNITS 10000;

// (Copied from: ff7rebirth)
// AdvancedAutoHDR pass to generate some HDR brightess out of an SDR signal.
// This is hue conserving and only really affects highlights.
// "sdr_color" is meant to be in "SDR range", as in, a value of 1 matching SDR white (something between 80, 100, 203, 300 nits, or whatever else)
// https://github.com/Filoppi/PumboAutoHDR
float3 PumboAutoHDR(float3 sdr_color) {
  const float shoulder_pow = CUSTOM_MOV_SHOULDERPOW;
  const float SDRRatio = max(renodx::color::y::from::BT2020(sdr_color), 0.f);

  // Limit AutoHDR brightness, it won't look good beyond a certain level.
  // The paper white multiplier is applied later so we account for that.
  float target_max_luminance = min(RENODX_PEAK_WHITE_NITS, pow(10.f, ((log10(RENODX_DIFFUSE_WHITE_NITS) - 0.03460730900256) / 0.757737096673107)));
  target_max_luminance = lerp(1.f, target_max_luminance, .5f);

  const float auto_HDR_max_white = max(target_max_luminance / RENODX_DIFFUSE_WHITE_NITS, 1.f);
  const float auto_HDR_shoulder_ratio = 1.f - max(1.f - SDRRatio, 0.f);
  const float auto_HDR_extra_ratio = pow(max(auto_HDR_shoulder_ratio, 0.f), shoulder_pow) * (auto_HDR_max_white - 1.f);
  const float auto_HDR_total_ratio = SDRRatio + auto_HDR_extra_ratio;
  return sdr_color * renodx::math::SafeDivision(auto_HDR_total_ratio, SDRRatio, 1);  // Fallback on a value of 1 in case of division by 0
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

// float Min(in float2 v) return min()

float Tonemap_GetY(float3 color) {
  return renodx::color::y::from::BT709(color);
}

void Tonemap_SaveBlacks(in float3 colorUntonemapped, inout float4 r0) {
  // if (CUSTOM_UPGRADETONEMAP_SAVEBLACKS == 0) return;
  if (Tonemap_GetY(r0.xyz) <= CUSTOM_UPGRADETONEMAP_SAVEBLACKS)
    r0.xyz = renodx::color::correct::Luminance(colorUntonemapped, Tonemap_GetY(colorUntonemapped), CUSTOM_UPGRADETONEMAP_SAVEBLACKS);
}

void Tonemap_UpgradeTonemap0(inout float3 colorUntonemapped, inout float4 r0) {
  if (RENODX_TONE_MAP_TYPE == 0) return;

  //save blacks
  Tonemap_SaveBlacks(colorUntonemapped, r0);

  //upgrade
  colorUntonemapped = renodx::tonemap::UpgradeToneMap(
    colorUntonemapped, r0.xyz, r0.xyz, 
    CUSTOM_UPGRADETONEMAP_POSTPROCESS, 0
  );
}


void ADSSights_Scale(inout float4 o0) {
  o0.xyz *= CUSTOM_ADSSIGHT_MULTIPLIER;
}

void Tonemap_BloomScale(inout float4 color) {
  color.xyz *= CUSTOM_BLOOM_MULTIPLIER; 
  color.w = 1;
}

float3 Tonemap_BloomScale(float3 color) {
  return color.xyz * CUSTOM_BLOOM_MULTIPLIER; 
}

float PreExposure_GetOffset(in float4 v) {
  float result;
  result = max(v.y, v.z);
  result *= CUSTOM_PREEXPOSURE_OFFSET_MULTIPLIER;
  return result;
}

float PreExposure_GetAutoexposure(in float4 v) {
  float result;
  result = v.y;
  result *= CUSTOM_PREEXPOSURE_AUTO_MULTIPLIER;
  return result;
}

float Tonemap_CalculatePreExposureMultiplier(in float3 v1, in float3 v2, in float3 v3) 
{
  float target;
  
  target = 0;
  target += max(v1.y, v1.z) /* * CUSTOM_PREEXPOSURE_OFFSET_MULTIPLIER */;
  target += max(v2.y, v2.z) /* * CUSTOM_PREEXPOSURE_AUTO_MULTIPLIER */;
  // target *= CUSTOM_PREEXPOSURE_FINAL;
  float v1diff = (1 - v1.x);
  target = max(target, v1diff);
  target *= PREEXPOSURE_FINAL_MULTIPLIER;
  return target;
}

void Tonemap_PrepColorUntonemapped(inout float3 colorUntonemapped, inout float4 r0) {
  colorUntonemapped = r0.xyz;
  colorUntonemapped = renodx::color::correct::Luminance(colorUntonemapped, Tonemap_GetY(colorUntonemapped), r0.w);
  // colorUntonemapped = max(float3(0,0,0), colorUntonemapped); //clamp
  r0.w = 1; //reset
}

void Tonemap_RecoverYFromW(inout float4 r0) {
  if (RENODX_TONE_MAP_TYPE == 0) return;
  
  r0.xyz = renodx::color::correct::Luminance(r0.xyz, Tonemap_GetY(r0.xyz), r0.w, 1); //correct
  r0.w = 1; //reset
}

// float3 Tonemap_Compressor(float3 x) {
//   x /= CUSTOM_COMPRESSOR_GAIN;

//   float colorY = renodx::color::y::from::BT709(x);
//   x = colorY < 1 ? x : renodx::math::SignPow(x, CUSTOM_COMPRESSOR_POW); 

//   x *= CUSTOM_COMPRESSOR_GAIN;
//   return x;
// }
// float Tonemap_Compressor(float x) {
//   x /= CUSTOM_COMPRESSOR_GAIN;
//   x = x < 1 ? x : renodx::math::SignPow(x, CUSTOM_COMPRESSOR_POW); 
//   x *= CUSTOM_COMPRESSOR_GAIN;
//   return x;
// }

static renodx::debug::graph::Config graph_config; 
void Tonemap_Do(inout float4 r0, float3 colorUntonemapped, float3 colorTonemapped, float3 colorSDRNeutral, float2 uv, Texture2D<float4> texColor) {
  if (RENODX_TONE_MAP_TYPE > 0) {
    //graph start
    if (CUSTOM_IS_CALIBRATION) graph_config = renodx::debug::graph::DrawStart(uv, colorUntonemapped, texColor, RENODX_PEAK_WHITE_NITS, RENODX_DIFFUSE_WHITE_NITS);

    //decode
    // colorSDRNeutral = renodx::color::srgb::DecodeSafe(colorSDRNeutral);
    colorTonemapped = renodx::color::srgb::DecodeSafe(colorTonemapped);

    //ToneMapPass
    r0.xyz = renodx::draw::ToneMapPass(colorUntonemapped, colorTonemapped, colorSDRNeutral);

    //graph end
    if (CUSTOM_IS_CALIBRATION) r0.xyz = renodx::debug::graph::DrawEnd(r0.xyz, graph_config);
  } else {
    //just decode original
    r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
    r0.xyz = saturate(r0.xyz); //emulate SDR 0-1. yes, i checked, they do rely on the inherit r8g8b8 clamping.
  }

  //RenderIntermediatePass
  r0.xyz = renodx::draw::RenderIntermediatePass(r0.xyz);
  r0 = max(r0, float4(0,0,0,0));
}

float3 Tonemap_Do(float3 colorUntonemapped, float3 colorTonemapped, float3 colorSDRNeutral) {
  if (RENODX_TONE_MAP_TYPE > 0) {
    //decode
    // colorSDRNeutral = renodx::color::srgb::DecodeSafe(colorSDRNeutral);
    colorTonemapped = renodx::color::srgb::DecodeSafe(colorTonemapped);

    //ToneMapPass
    colorTonemapped.xyz = renodx::draw::ToneMapPass(colorUntonemapped, colorTonemapped, colorSDRNeutral);
  } else {
    //just decode original
    colorTonemapped.xyz = renodx::color::srgb::DecodeSafe(colorTonemapped.xyz);
    colorTonemapped.xyz = saturate(colorTonemapped.xyz); //emulate SDR 0-1. yes, i checked, they do rely on the inherit r8g8b8 clamping.
  }

  //RenderIntermediatePass
  colorTonemapped.xyz = renodx::draw::RenderIntermediatePass(colorTonemapped.xyz);
  colorTonemapped = max(colorTonemapped, float3(0,0,0));
  return colorTonemapped;
}

float3 Tonemap_DoIW7(in float3 colorUntonemapped, in float3 colorTonemapped, in float3 colorSDRNeutral) {
  float3 result;

  //colorSDRNeutral
  // colorSDRNeutral = colorUntonemapped;
  // colorSDRNeutral = renodx::tonemap::Reinhard(colorUntonemapped);

  //colorTonemapped
  colorTonemapped = renodx::color::srgb::Decode(colorTonemapped);
  
  //upgrade colorUntonemapped
  colorUntonemapped = renodx::tonemap::UpgradeToneMap(
    colorUntonemapped, colorSDRNeutral, colorTonemapped,
    1, 0
  );

  // colorTonemapped = renodx::draw::ApplyPerChannelCorrection(colorUntonemapped);

  //tonemap
  renodx::tonemap::renodrt::Config current_config = renodx::tonemap::renodrt::config::Create();
  current_config.nits_peak = TONEMAP_MAXNITS;
  // current_config.dechroma = 1;

  result = renodx::tonemap::renodrt::BT709(colorUntonemapped, current_config);
  
  //enocode
  result = renodx::color::srgb::Encode(result);
  result = renodx::color::correct::GammaSafe(result, true);
  // result = renodx::draw::RenderIntermediatePass(result);
  // result = renodx::draw::EncodeColor(result, );

  return result;
}

void Tonemap_RenderIntermediatePass() {

}