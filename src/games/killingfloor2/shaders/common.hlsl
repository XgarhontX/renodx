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

// float3 Lens_Do(float3 color) {
//   return color * CUSTOM_LENS_MULTIPLIER;
// }

float3 Tonemap_Decode(float3 x) {
  return renodx::color::srgb::Decode(x);
  // return renodx::color::gamma::Decode(x);
  // return renodx::color::gamma::Decode(x, 2.4);
}
float3 Tonemap_DecodeSafe(float3 x) {
  return renodx::color::srgb::DecodeSafe(x);
  // return renodx::color::gamma::DecodeSafe(x);
  // return renodx::color::gamma::DecodeSafe(x, 2.4);
}

// float3 Tonemap_PerChannelCorrect(float3 colorT, float3 colorU) {
//   [branch]
//   if (RENODX_TONE_MAP_TYPE > 0 && CUSTOM_PCC_STRENGTH > 0) {
//     colorT *= colorT;
    
//     renodx::draw::ApplyPerChannelCorrectionResult pccResult = renodx::draw::ApplyPerChannelCorrectionInternal(colorU, colorT/* , 0.5f, 1.0f, 1.0f, 0.0f */);

//     float strength = pccResult.tonemapped_luminance;
//     if (CUSTOM_PCC_POW != 1.0f) strength = pow(strength, CUSTOM_PCC_POW);
//     strength *= CUSTOM_PCC_STRENGTH;
//     strength = saturate(strength);
//     colorT = lerp(colorT, pccResult.color, strength);

//     // //max channel clamp
//     // float cmax = max(max(colorT.x, colorT.y), colorT.z);
//     // if (cmax > 1.f) colorT /= cmax;

//     colorT = sqrt(colorT);
//   } 

//   return colorT;
// }

// void Tonemap_FilmGrain(inout float3 colorT, inout float3 colorU, float4 filmGrainTextureScaleAndOffset, float3 filmGrainColorScale, SamplerState filmGrainTextureSampler_s, Texture2D<float4> filmGrainTexture, float2 v2) {
//   float3 r1;
//   r1.xy = v2.xy * filmGrainTextureScaleAndOffset.xy + filmGrainTextureScaleAndOffset.zw;
//   r1.z = filmGrainTexture.Sample(filmGrainTextureSampler_s, r1.xy).x;
//   r1.z = -0.5 + r1.z;
//   r1.z *= ;
//   colorT += r1.z * filmGrainColorScale.xyz;
//   colorU += Tonemap_DecodeSafe(r1.z * filmGrainColorScale.xyz);

//   // r1.xy = v2.xy * filmGrainTextureScaleAndOffset.xy + filmGrainTextureScaleAndOffset.zw;
//   // r0.w = filmGrainTexture.Sample(filmGrainTextureSampler_s, r1.xy).x;
//   // r0.w = -0.5 + r0.w;
//   // r0.xyz = r0.www * filmGrainColorScale.xyz + r0.xyz;
// }

// float3 Tonemap_Vignette(float3 color, float3 vignetteParams, float4 vignetteColor, float2 v2) {
//   float4 r0;
//   r0.xy = float2(-0.5,-0.5) + v2.xy;
//   r0.xy = vignetteParams.xy * r0.xy;
//   r0.x = dot(r0.xy, r0.xy);
//   r0.x *= CUSTOM_VIGNETTE_MULTIPLIER;
//   r0.x = saturate(-r0.x * vignetteColor.w + 1);
//   r0.x = pow(r0.x, vignetteParams.z);

//   return color *= r0.x;
// }

// void Tonemap_Lut(inout float3 colorU, inout float3 colorT, in SamplerState samp, Texture3D<float4> lut) {
//   const float midgray = 0.625;
//   colorU *= renodx::color::y::from::BT709(lut.Sample(samp, midgray).xyz) / midgray;

//   float3 colorTBeforeLut = colorT;
//   colorT = colorT * 0.96875 + 0.015625;
//   colorT = lut.Sample(samp, colorT).xyz;

//   //dual lut
//   [branch]
//   if (RENODX_TONE_MAP_TYPE > 0 && CUSTOM_DUALLUT_STRENGTH > 0) {
//     float3 t2 = colorTBeforeLut * CUSTOM_DUALLUT_SAMPLEMULTIPLIER;
//     t2 = t2 * 0.96875 + 0.015625;
//     t2 = lut.Sample(samp, t2).xyz;

//     float colorTy = renodx::color::y::from::BT709(colorT);
//     float strength = colorTy;
//     [branch] if (CUSTOM_DUALLUT_POW != 1.0f) strength = pow(colorTy, CUSTOM_DUALLUT_POW);
//     strength *= CUSTOM_DUALLUT_STRENGTH;
//     strength = saturate(strength);

//     t2 = renodx::color::correct::Luminance(t2, renodx::color::y::from::BT709(t2), colorTy);
//     colorT = lerp(colorT, t2, strength);
//   }
// }

void Tonemap_BloomScale(inout float3 color) {
  color.xyz *= CUSTOM_BLOOM_MULTIPLIER; 
}

float3 Tonemap_Do(float3 colorU, float3 colorT, float2 uv) {
  colorT = max(0, colorT);
  colorT = Tonemap_Decode(colorT);
  // float3 colorTSat = min(colorT, 1);
  
  if (RENODX_TONE_MAP_TYPE > 0) {
    colorU = max(0, colorU); //needed for nans
    colorU *= CUSTOM_PREEXPOSURE_MULTIPLIER;
    if (CUSTOM_PREEXPOSURE_CONTRAST != 1.f) colorU = renodx::color::grade::Contrast(colorU, CUSTOM_PREEXPOSURE_CONTRAST, CUSTOM_PREEXPOSURE_CONTRAST_MID);

    renodx::draw::Config config = renodx::draw::BuildConfig();
    config.reno_drt_tone_map_method = CUSTOM_RENODRT_TONE_MAP_METHOD == 0 ?
      renodx::tonemap::renodrt::config::tone_map_method::REINHARD_PIECEWISE : 
      renodx::tonemap::renodrt::config::tone_map_method::EXP;
    colorT = renodx::draw::ToneMapPass(colorU, min(colorT, 1), renodx::tonemap::Reinhard(colorU), config);

    if (CUSTOM_FILMGRAIN_MULTIPLIER > 0) colorT = renodx::effects::ApplyFilmGrainColored(colorT, uv, SEED, CUSTOM_FILMGRAIN_MULTIPLIER);
  } else {
    colorT =  min(colorT, 1);
  }

  //RenderIntermediatePass
  colorT = renodx::draw::RenderIntermediatePass(colorT);

  return colorT;
}