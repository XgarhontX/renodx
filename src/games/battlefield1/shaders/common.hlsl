#include "../shared.h"

// #define DUAL

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
}
float3 Tonemap_DecodeSafe(float3 x) {
  return renodx::color::srgb::DecodeSafe(x);
}

float3 Tonemap_PerChannelCorrect(float3 colorT, float3 colorU) {
  if (RENODX_TONE_MAP_TYPE > 0 && CUSTOM_PCC_STRENGTH > 0) {
    renodx::draw::ApplyPerChannelCorrectionResult pccResult = renodx::draw::ApplyPerChannelCorrectionInternal(colorU, colorT, 1/* , 0.5f, 1.0f, 1.0f, 0.0f */);

    float strength = pccResult.tonemapped_luminance;
    if (CUSTOM_PCC_POW != 1.0f) strength = pow(strength, CUSTOM_PCC_POW);
    strength *= CUSTOM_PCC_STRENGTH;
    strength = saturate(strength);
    // return strength; //debug

    colorT = lerp(colorT, pccResult.color, strength);
  }
  return colorT;
}

float3 Tonemap_VanillaInternal(float3 colorU) { //https://www.desmos.com/calculator/ocefue87gg
  float3 r0, r1, r2;
  r0 = colorU;

  r1 = 0.985521019 * r0;
  r2 = r0 * 0.985521019 + 0.058662001;
  r1 = r2 * r1;
  r2 = r0 * 0.774596989 + 0.0482814983;
  r0 = r0 * 0.774596989 + 1.24270999;
  r0 = r2 * r0;
  r0 = r1 / r0;
  // r0.xyz = sqrt(r0.xyz); //replaced in BF1 with actual sRGB Encode

  return r0;
}

void Tonemap_Vanilla(inout float3 colorU, inout float3 colorT) {
  colorT = Tonemap_VanillaInternal(colorU);
  colorT = Tonemap_PerChannelCorrect(colorT, colorU);
  colorU *= (0.18 / 0.16); //midgray exposure trick
}

// DUAL
// float3 Tonemap_VanillaInternal1(float3 colorU) { //https://www.desmos.com/calculator/fqrhp7m6rr
//   float3 r0, r1, r2;
//   r0 = colorU;

//   r0.xyz = r0.xyz + -0.00400000019;
//   r0.xyz = max(0, r0.xyz);
//   r1.xyz = r0.xyz * 6.19999981 + 0.5;
//   r1.xyz = r1.xyz * r0.xyz;
//   r2.xyz = r0.xyz * 6.19999981 + 1.70000005;
//   r0.xyz = r0.xyz * r2.xyz + 0.0599999987;
//   r0.xyz = r1.xyz / r0.xyz;

//   return r0.xyz;
// }

// void Tonemap_Vanilla1(inout float3 colorU, inout float3 colorT) {
//   colorT = Tonemap_VanillaInternal1(colorT);
//   colorU *= 0.5 / 0.18; //midgray exposure trick
//   colorT = Tonemap_PerChannelCorrect(colorT, colorU);
// }

void Tonemap_FilmGrain(inout float3 colorT, inout float3 colorU, float4 filmGrainTextureScaleAndOffset, float3 filmGrainColorScale, SamplerState filmGrainTextureSampler_s, Texture2D<float4> filmGrainTexture, float2 v2) {
  float3 r1;
  r1.xy = v2.xy * filmGrainTextureScaleAndOffset.xy + filmGrainTextureScaleAndOffset.zw;
  r1.z = filmGrainTexture.Sample(filmGrainTextureSampler_s, r1.xy).x;
  r1.z = -0.5 + r1.z;
  r1.z *= CUSTOM_FILMGRAIN_MULTIPLIER;
  colorT += r1.z * filmGrainColorScale.xyz;
  colorU += Tonemap_DecodeSafe(r1.z * filmGrainColorScale.xyz);

  // r1.xy = v2.xy * filmGrainTextureScaleAndOffset.xy + filmGrainTextureScaleAndOffset.zw;
  // r0.w = filmGrainTexture.Sample(filmGrainTextureSampler_s, r1.xy).x;
  // r0.w = -0.5 + r0.w;
  // r0.xyz = r0.www * filmGrainColorScale.xyz + r0.xyz;
}

// void Tonemap_InvGamma(inout float3 colorU, inout float3 colorT, float3 invGamma) {
//   colorT = pow(colorT, invGamma.xyz);
//   colorU *= renodx::color::y::from::BT709(pow(0.18, invGamma.xyz)) / 0.18;
//   colorT = Tonemap_PerChannelCorrect(colorT, colorU);
// }

float3 Tonemap_Vignette(float3 color, float3 vignetteParams, float4 vignetteColor, float2 v2) {
  float4 r0;
  r0.xy = float2(-0.5,-0.5) + v2.xy;
  r0.xy = vignetteParams.xy * r0.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x *= CUSTOM_VIGNETTE_MULTIPLIER;
  r0.x = saturate(-r0.x * vignetteColor.w + 1);
  r0.x = pow(r0.x, vignetteParams.z);
  return color *= r0.x;
}


void Tonemap_Lut(inout float3 colorU, inout float3 colorT, in SamplerState samp, Texture3D<float4> lut) {
  {
    float3 a = lut.Sample(samp, 0.46).xyz;
    float b = renodx::color::y::from::BT709(a);
    float c = pow(b, 2.2);
    float d = c / 0.18;
    colorU *= d;
  }

  // if (CUSTOM_PREEXPOSURE_CONTRAST_MID > 0.18) return;
  float3 colorTBeforeLut = colorT;
  colorT = colorT * 0.96875 + 0.015625;
  // if (CUSTOM_PREEXPOSURE_CONTRAST_MID > 0.18) {
  //   renodx::lut::Config lut_config = renodx::lut::config::Create();
  //   lut_config.lut_sampler = samp;
  //   lut_config.strength = RENODX_COLOR_GRADE_STRENGTH;
  //   lut_config.scaling = 1.f;
  //   lut_config.type_input = renodx::lut::config::type::SRGB;
  //   lut_config.type_output = renodx::lut::config::type::SRGB;
  //   lut_config.size = 32;
  //   lut_config.tetrahedral = true;

  //   colorT = renodx::lut::SampleColor(colorT, lut_config, lut);
  // } else {
    colorT = lut.Sample(samp, colorT).xyz;
  // }
  
  //dual lut
  [branch]
  if (RENODX_TONE_MAP_TYPE > 0 && CUSTOM_DUALLUT_STRENGTH > 0) {
    float3 t2 = colorTBeforeLut * CUSTOM_DUALLUT_SAMPLEMULTIPLIER;
    t2 = t2 * 0.96875 + 0.015625;
    t2 = lut.Sample(samp, t2).xyz;

    float colorTy = renodx::color::y::from::BT709(colorT);
    float strength = colorTy;
    [branch] if (CUSTOM_DUALLUT_POW != 1.0f) strength = pow(colorTy, CUSTOM_DUALLUT_POW);
    strength *= CUSTOM_DUALLUT_STRENGTH;
    strength = saturate(strength);

    t2 = renodx::color::correct::Luminance(t2, renodx::color::y::from::BT709(t2), colorTy);
    colorT = lerp(colorT, t2, strength);
  }
}


void Tonemap_BloomScale(inout float3 color) {
  color.xyz *= CUSTOM_BLOOM_MULTIPLIER; 
}

float3 Tonemap_Do(float3 colorU, float3 colorT, float2 uv, Texture2D<float4> texColor) {
  colorT = max(0, colorT);
  colorT = Tonemap_DecodeSafe(colorT);
  
  if (RENODX_TONE_MAP_TYPE > 0) {
    colorU = max(0, colorU);
    colorU *= CUSTOM_PREEXPOSURE_MULTIPLIER;
    [branch] if (CUSTOM_PREEXPOSURE_CONTRAST != 1.f) colorU = renodx::color::grade::Contrast(colorU, CUSTOM_PREEXPOSURE_CONTRAST, CUSTOM_PREEXPOSURE_CONTRAST_MID);

    float3 colorSDRNeutral = Tonemap_VanillaInternal(colorU);
    colorT = renodx::draw::ToneMapPass(colorU, colorT, colorSDRNeutral);

    if (CUSTOM_FILMGRAIN_MULTIPLIER_RENO > 0) colorT = renodx::effects::ApplyFilmGrainColored(colorT, uv, SEED, CUSTOM_FILMGRAIN_MULTIPLIER_RENO);
  } else {
    colorT = min(colorT, 1);
  }

  //RenderIntermediatePass
  colorT = renodx::draw::RenderIntermediatePass(colorT);

  return colorT;
}