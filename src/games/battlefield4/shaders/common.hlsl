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

float3 Lens_Do(float3 color) {
  return color * CUSTOM_LENS_MULTIPLIER;
}

float3 Tonemap_Decode(float3 x) {
  return renodx::color::srgb::Decode(x);
}
float3 Tonemap_DecodeSafe(float3 x) {
  return renodx::color::srgb::DecodeSafe(x);
}

float Tonemap_GetY(float3 color) {
  return renodx::color::y::from::BT709(color);
}

float3 Tonemap_PerChannelCorrect(float3 colorT, float3 colorU) {
  [branch]
  if (RENODX_TONE_MAP_TYPE > 0 && CUSTOM_PCC_STRENGTH > 0) {
    renodx::draw::ApplyPerChannelCorrectionResult pccResult = renodx::draw::ApplyPerChannelCorrectionInternal(colorU, colorT/* , 0.5f, 1.0f, 1.0f, 0.0f */);

    float strength = pccResult.tonemapped_luminance;
    [branch] if (CUSTOM_PCC_POW != 1.0f) strength = pow(strength, CUSTOM_PCC_POW);
    strength *= CUSTOM_PCC_STRENGTH;
    strength = saturate(strength);
    // return strength; //debug

    colorT = lerp(colorT, pccResult.color, strength);
  } else {
    //noop
  }
  return colorT;
}

float3 Tonemap_VanillaInternal(float3 colorU) { //https://www.desmos.com/calculator/ocefue87gg
  float3 r0, r1, r2;
  r0 = float3(colorU);

  r1.xyz = 0.985521019 * r0.xyz;
  r2.xyz = r0.xyz * 0.985521019 + 0.058662001;
  r1.xyz = r2.xyz * r1.xyz;
  r2.xyz = r0.xyz * 0.774596989 + 0.0482814983;
  r0.xyz = r0.xyz * 0.774596989 + 1.24270999;
  r0.xyz = r2.xyz * r0.xyz;
  r0.xyz = r1.xyz / r0.xyz;
  r0.xyz = sqrt(r0.xyz);

  return r0.xyz;
}

void Tonemap_Vanilla(in float3 colorU, inout float3 colorT) {
  colorT = Tonemap_VanillaInternal(colorT);
  colorU *= 0.4 / 0.18; //midgray exposure trick
  colorT = Tonemap_PerChannelCorrect(colorT, colorU);
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
  colorT += r1.z * filmGrainColorScale.xyz;
  colorU += Tonemap_DecodeSafe(r1.z * filmGrainColorScale.xyz);

  // r1.xy = v2.xy * filmGrainTextureScaleAndOffset.xy + filmGrainTextureScaleAndOffset.zw;
  // r0.w = filmGrainTexture.Sample(filmGrainTextureSampler_s, r1.xy).x;
  // r0.w = -0.5 + r0.w;
  // r0.xyz = r0.www * filmGrainColorScale.xyz + r0.xyz;
}

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
  const float midgray = 0.18;
  colorU *= renodx::color::y::from::BT709(lut.Sample(samp, midgray).xyz) / midgray;

  float3 colorTBeforeLut = colorT;
  colorT = colorT * 0.96875 + 0.015625;
  colorT = lut.Sample(samp, colorT).xyz;

  // //dual lut
  // if (RENODX_TONE_MAP_TYPE > 0 && CUSTOM_DUALLUT_STRENGTH > 0) {
  //   float3 t2 = renodx::tonemap::uncharted2::BT709(colorU);
  //   t2 = lut.Sample(samp, t2).xyz;
  //   float strength = pow(renodx::color::y::from::BT709(t2), CUSTOM_DUALLUT_POW);
  //   strength = saturate(strength);
  //   strength *= CUSTOM_DUALLUT_STRENGTH;
  //   float3 colorT1 = lerp(colorT, t2, strength);
  //   // colorT = renodx::color::correct::Chrominance(colorT, t2, strength, 1);
  //   colorT = renodx::color::correct::Luminance(colorT1, colorT);
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

  // renodx::lut::Config lut_config = renodx::lut::config::Create();
  // lut_config.lut_sampler = samp;
  // lut_config.strength = 1;
  // lut_config.scaling = 0.f;
  // lut_config.type_input = renodx::lut::config::type::SRGB;
  // lut_config.type_output = renodx::lut::config::type::SRGB;
  // lut_config.size = 32;
  // lut_config.tetrahedral = true;

  // renodx::draw::Config draw_config = renodx::draw::BuildConfig();
  // draw_config.peak_white_nits = 100000;
  // renodx::tonemap::Config tone_map_config = renodx::tonemap::config::Create();
  // tone_map_config.peak_nits = draw_config.peak_white_nits;
  // tone_map_config.game_nits = draw_config.diffuse_white_nits;
  // tone_map_config.type = draw_config.tone_map_type;
  // tone_map_config.gamma_correction = draw_config.gamma_correction;
  // tone_map_config.exposure = draw_config.tone_map_exposure;
  // tone_map_config.highlights = draw_config.tone_map_highlights;
  // tone_map_config.shadows = draw_config.tone_map_shadows;
  // tone_map_config.contrast = draw_config.tone_map_contrast;
  // tone_map_config.saturation = draw_config.tone_map_saturation;
  // tone_map_config.reno_drt_highlights = 1.0f;
  // tone_map_config.reno_drt_shadows = 1.0f;
  // tone_map_config.reno_drt_contrast = 1.0f;
  // tone_map_config.reno_drt_saturation = 1.0f;
  // tone_map_config.reno_drt_blowout = -1.f * (draw_config.tone_map_highlight_saturation - 1.f);
  // tone_map_config.reno_drt_dechroma = draw_config.tone_map_blowout;
  // tone_map_config.reno_drt_flare = 0.10f * pow(draw_config.tone_map_flare, 10.f);
  // tone_map_config.reno_drt_working_color_space = draw_config.tone_map_working_color_space;
  // tone_map_config.reno_drt_per_channel = draw_config.tone_map_per_channel == 1.f;
  // tone_map_config.reno_drt_hue_correction_method = draw_config.tone_map_hue_processor;
  // tone_map_config.reno_drt_clamp_color_space = draw_config.tone_map_clamp_color_space;
  // tone_map_config.reno_drt_clamp_peak = draw_config.tone_map_clamp_peak;
  // tone_map_config.reno_drt_tone_map_method = draw_config.reno_drt_tone_map_method;
  // tone_map_config.reno_drt_white_clip = draw_config.reno_drt_white_clip;
  // tone_map_config.hue_correction_strength = draw_config.tone_map_hue_correction;

  // colorU = renodx::tonemap::config::Apply(colorU, tone_map_config, lut_config, lut);
}

void Tonemap_BloomScale(inout float3 color) {
  color.xyz *= CUSTOM_BLOOM_MULTIPLIER; 
}

void Tonemap_RecoverYFromW(inout float4 r0) {
  if (RENODX_TONE_MAP_TYPE == 0) return;
  
  r0.xyz = renodx::color::correct::Luminance(r0.xyz, Tonemap_GetY(r0.xyz), r0.w, 1); //correct
  r0.w = 1; //reset
}

float3 Tonemap_Do(float3 colorUntonemapped, float3 colorTonemapped, float2 uv, Texture2D<float4> texColor) {
  colorTonemapped = max(0, colorTonemapped);
  colorTonemapped = Tonemap_DecodeSafe(colorTonemapped);
  
  if (RENODX_TONE_MAP_TYPE > 0) {
    colorUntonemapped = max(0, colorUntonemapped);

    float3 colorSDRNeutral = renodx::tonemap::Reinhard(colorUntonemapped);

    renodx::draw::Config config = renodx::draw::BuildConfig();
    colorTonemapped = renodx::draw::ToneMapPass(colorUntonemapped, colorTonemapped, colorSDRNeutral, config);
  } else {
    colorTonemapped = min(colorTonemapped, 1);
  }

  //RenderIntermediatePass
  colorTonemapped = renodx::draw::RenderIntermediatePass(colorTonemapped);

  return colorTonemapped;
}