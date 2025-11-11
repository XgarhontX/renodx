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

float3 EOTFEmulate(float3 color, float gamma, float threshold) {
  // return min(color, threshold);

  if (gamma <= 0.f) return color;
  if (threshold <= 0.f) return renodx::color::correct::Gamma(color, false, gamma);

  color /= threshold;

  //do
  if (1 - color.x >= 0) color.x = renodx::color::correct::Gamma(color.x, false, gamma);
  if (1 - color.y >= 0) color.y = renodx::color::correct::Gamma(color.y, false, gamma);
  if (1 - color.z >= 0) color.z = renodx::color::correct::Gamma(color.z, false, gamma);

  color *= threshold;

  return color;
}

// float3 Lens_Do(float3 color) {
//   return color * CUSTOM_LENS_MULTIPLIER;
// }

float3 Tonemap_Decode(float3 x) {
  return renodx::color::srgb::Decode(x);
}
float3 Tonemap_DecodeSafe(float3 x) {
  return renodx::color::srgb::DecodeSafe(x);
}

float3 Tonemap_PerChannelCorrect(float3 colorT, float3 colorU, float maxVal = 10000) {
  [branch]
  if (RENODX_TONE_MAP_TYPE > 0 && CUSTOM_PCC_STRENGTH > 0) {
    renodx::draw::ApplyPerChannelCorrectionResult pccResult = renodx::draw::ApplyPerChannelCorrectionInternal(colorU, colorT/* , 0.5f, 1.0f, 1.0f, 0.0f */);

    float strength = pccResult.tonemapped_luminance;
    /* [branch] if (CUSTOM_PCC_POW != 1.0f)  */strength = pow(strength, CUSTOM_PCC_POW);
    strength *= CUSTOM_PCC_STRENGTH;
    strength = saturate(strength);
    // return strength; //debug

    pccResult.color = min(maxVal, pccResult.color);
    colorT = lerp(colorT, pccResult.color, strength);
  } else {
    //noop
  }
  return colorT;
}

float3 Tonemap_VanillaInternal(float3 colorU) { //https://www.desmos.com/calculator/hpi8kuyes6 
  float3 r0, r1, r2;
  r0 = float3(colorU);

  r1.xyz = r0.xyz * 0.971251667 + 0.0578126311;
  r1.xyz = r1.xyz * r0.xyz;
  r2.xyz = r0.xyz * 0.600000501 + 0.999998152;
  r0.xyz = r0.xyz * r2.xyz + 0.0599999018;
  r0.xyz = r1.xyz / r0.xyz;
  r0.xyz = sqrt(r0.xyz);

  return r0.xyz;
}

void Tonemap_Vanilla(in float3 colorU, inout float3 colorT) {
  colorT = Tonemap_VanillaInternal(colorT);
  colorU *= 0.4 / 0.18; //midgray exposure trick
  colorT = Tonemap_PerChannelCorrect(colorT, colorU, 1.27);
}

//bruh
float3 Tonemap_VanillaInternal1(float3 colorU) { //https://www.desmos.com/calculator/fqrhp7m6rr
  float3 r0, r1, r2;
  r0 = colorU;

  r0.xyz = r0.xyz + -0.00400000019;
  r0.xyz = max(0, r0.xyz);
  r1.xyz = r0.xyz * 6.19999981 + 0.5;
  r1.xyz = r1.xyz * r0.xyz;
  r2.xyz = r0.xyz * 6.19999981 + 1.70000005;
  r0.xyz = r0.xyz * r2.xyz + 0.0599999987;
  r0.xyz = r1.xyz / r0.xyz;

  return r0.xyz;
}

void Tonemap_Vanilla1(in float3 colorU, inout float3 colorT) {
  colorT = Tonemap_VanillaInternal1(colorT);
  colorU *= 0.5 / 0.18; //midgray exposure trick
  colorT = Tonemap_PerChannelCorrect(colorT, colorU);
}

void Tonemap_InvGamma(in float3 colorU, inout float3 colorT, float3 invGamma) {
  colorT = pow(colorT, invGamma.xyz);
  colorU *= renodx::color::y::from::BT709(pow(0.18, invGamma.xyz)) / 0.18;
  colorT = Tonemap_PerChannelCorrect(colorT, colorU);
}

void Tonemap_FilmGrain(inout float3 colorT, inout float3 colorU, float4 filmGrainTextureScaleAndOffset, float3 filmGrainColorScale, SamplerState filmGrainTextureSampler_s, Texture2D<float4> filmGrainTexture, float2 v2) {
  float3 r1;
  r1.xy = v2.xy * filmGrainTextureScaleAndOffset.xy + filmGrainTextureScaleAndOffset.zw;
  r1.z = filmGrainTexture.Sample(filmGrainTextureSampler_s, r1.xy).x;
  r1.z = -0.5 + r1.z;
  r1.z *= CUSTOM_FILMGRAIN_MULTIPLIER;
  float3 add = r1.z * filmGrainColorScale.xyz;
  colorT += r1.z * filmGrainColorScale.xyz;
  colorU += Tonemap_DecodeSafe(add);

  // r1.xy = v2.xy * filmGrainTextureScaleAndOffset.xy + filmGrainTextureScaleAndOffset.zw;
  // r0.w = filmGrainTexture.Sample(filmGrainTextureSampler_s, r1.xy).x;
  // r0.w = -0.5 + r0.w;
  // r0.xyz = r0.www * filmGrainColorScale.xyz + r0.xyz;
}

float3 Tonemap_Vignette(float3 color, float4 vignetteScaleAndOffset, float3 vignetteParams, float2 v2) {
  float2 r0;
  r0.xy = v2.xy * vignetteScaleAndOffset.xy + vignetteScaleAndOffset.zw;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = 1 + -r0.x;
  r0.x = max(0, r0.x);
  r0.x = pow(r0.x, vignetteParams.z);

  return color *= r0.x;
}

void Tonemap_Lut(inout float3 colorU, inout float3 colorT, in SamplerState samp, Texture3D<float4> lut) {
  const float midgray = 0.625;
  colorU *= renodx::color::y::from::BT709(lut.Sample(samp, midgray).xyz) / midgray;

  float3 colorTBeforeLut = colorT;
  colorT = colorT * 0.96875 + 0.015625;
  colorT = lut.Sample(samp, colorT).xyz;

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

float3 Tonemap_Do(float3 colorUntonemapped, float3 colorTonemapped, float2 uv, Texture2D<float4> texColor) {
  colorTonemapped = max(0, colorTonemapped);
  colorTonemapped = Tonemap_Decode(colorTonemapped);
  
  [branch] 
  if (RENODX_TONE_MAP_TYPE > 0) {
    colorUntonemapped = max(0, colorUntonemapped);
    colorUntonemapped *= CUSTOM_PREEXPOSURE_MULTIPLIER;
    [branch] if (CUSTOM_PREEXPOSURE_CONTRAST != 1.f) colorUntonemapped = renodx::color::grade::Contrast(colorUntonemapped, CUSTOM_PREEXPOSURE_CONTRAST, CUSTOM_PREEXPOSURE_CONTRAST_MID);

    renodx::draw::Config config = renodx::draw::BuildConfig();
    colorTonemapped = renodx::draw::ToneMapPass(colorUntonemapped, colorTonemapped, renodx::tonemap::Reinhard(colorUntonemapped), config);
  } else {
    colorTonemapped = min(colorTonemapped, 1);
  }

  //RenderIntermediatePass
  colorTonemapped = renodx::draw::RenderIntermediatePass(colorTonemapped);

  return colorTonemapped;
}