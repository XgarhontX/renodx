#include "../shared.h"

// https://github.com/ronja-tutorials/ShaderTutorials/blob/master/Assets/047_InverseInterpolationAndRemap/Interpolation.cginc
float invLerp(float from, float to, float value) {
  return (value - from) / (to - from);
}
float3 invLerp(float3 from, float3 to, float3 value) {
  return (value - from) / (to - from);
}
// float remap(float origFrom, float origTo, float targetFrom, float targetTo, float value){
//   float rel = invLerp(origFrom, origTo, value);
//   return lerp(targetFrom, targetTo, rel);
// }
// float3 remap(float3 origFrom, float3 origTo, float3 targetFrom, float3 targetTo, float3 value){
//   float3 rel = invLerp(origFrom, origTo, value);
//   return lerp(targetFrom, targetTo, rel);
// }

float3 Tonemap_Do(float3 colorUntonemapped, float3 colorTonemapped, float2 uv) {
  //decode
  colorTonemapped = renodx::color::srgb::Decode(colorTonemapped);
  const float3 colorTSat = min(colorTonemapped, 1);

  if (RENODX_TONE_MAP_TYPE > 0) {
    colorUntonemapped *= CUSTOM_PREEXPOSURE_FINAL * 80;
    colorTonemapped = renodx::draw::ToneMapPass(colorUntonemapped, colorTonemapped, RENODX_COLOR_GRADE_STRENGTH > 0 ? renodx::tonemap::Reinhard(colorUntonemapped) : 0);
  } else {
    colorTonemapped = colorTSat;
  }

  //RenderIntermediatePass
  colorTonemapped = renodx::draw::RenderIntermediatePass(colorTonemapped);

  return colorTonemapped;
}