#include "../shared.h"
#include "./drawbinary.hlsl"

#define SDR_NORMALIZATION_MAX 32768.0 //1 / 3.05175781e-005
#define RENODX_TONE_MAP_TYPE_IS_ON RENODX_TONE_MAP_TYPE > 0

float Sum3(in float3 v) {
  return (v.x + v.y + v.z);
}

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

// float3 Tonemap_PerChannelCorrect(float3 colorT, float3 colorU) {
//   [branch]
//   if (RENODX_TONE_MAP_TYPE > 0 && CUSTOM_PCC_STRENGTH > 0) {
//     renodx::draw::ApplyPerChannelCorrectionResult pccResult = renodx::draw::ApplyPerChannelCorrectionInternal(colorU, colorT/* , 0.5f, 1.0f, 1.0f, 0.0f */);

//     float strength = pccResult.tonemapped_luminance;
//     [branch] if (CUSTOM_PCC_POW != 1.0f) strength = pow(strength, CUSTOM_PCC_POW);
//     strength *= CUSTOM_PCC_STRENGTH;
//     strength = saturate(strength);
//     // return strength; //debug

//     colorT = lerp(colorT, pccResult.color, strength);
//   } else {
//     //noop
//   }
//   return colorT;
// }

// void Tonemap_FilmGrain(inout float3 colorT, inout float3 colorU, float4 filmGrainTextureScaleAndOffset, float3 filmGrainColorScale, SamplerState filmGrainTextureSampler_s, Texture2D<float4> filmGrainTexture, float2 v2) {
//   float3 r1;
//   r1.xy = v2.xy * filmGrainTextureScaleAndOffset.xy + filmGrainTextureScaleAndOffset.zw;
//   r1.z = filmGrainTexture.Sample(filmGrainTextureSampler_s, r1.xy).x;
//   r1.z = -0.5 + r1.z;
//   r1.z *= CUSTOM_FILMGRAIN;
//   colorT += r1.z * filmGrainColorScale.xyz;
//   colorU += Tonemap_DecodeSafe(r1.z * filmGrainColorScale.xyz);
// }

// float3 Tonemap_Vignette(float3 color, float3 vignetteParams, float4 vignetteColor, float2 v2) {
//   float4 r0;
//   r0.xy = float2(-0.5,-0.5) + v2.xy;
//   r0.xy = vignetteParams.xy * r0.xy;
//   r0.x = dot(r0.xy, r0.xy);
//   r0.x *= CUSTOM_VIGNETTE;
//   r0.x = saturate(-r0.x * vignetteColor.w + 1);
//   r0.x = pow(r0.x, vignetteParams.z);

//   return color *= r0.x;
// }

void Tonemap_Lut(inout float3 colorU, inout float4 colorT, in SamplerState samp, Texture3D<float4> lut, in float4 ColourCubeScalesOffsets) {
  float3 colorTBeforeLut = colorT.xyz;

  colorT.xyz = colorT.xyz * ColourCubeScalesOffsets.xyz + ColourCubeScalesOffsets.www;
  colorT = lut.Sample(samp, colorT.xyz);

  //dual lut
  [branch]
  if (RENODX_TONE_MAP_TYPE > 0 && CUSTOM_DUALLUT_STRENGTH > 0) {
    float3 t2 = colorTBeforeLut;
    // t2 = renodx::color::srgb::Decode(t2);
    // t2 *= t2;
    t2 *= CUSTOM_DUALLUT_SAMPLEMULTIPLIER;
    // t2 = renodx::color::srgb::Encode(t2);
    // t2 *= sqrt(t2);

    t2 = t2 * ColourCubeScalesOffsets.xyz + ColourCubeScalesOffsets.www;
    t2 = lut.Sample(samp, t2).xyz;

    float colorTy = renodx::color::y::from::BT709(colorT.xyz);
    float strength = colorTy;
    [branch] if (CUSTOM_DUALLUT_POW != 1.0f) strength = pow(colorTy, CUSTOM_DUALLUT_POW);
    strength *= CUSTOM_DUALLUT_STRENGTH;
    strength = saturate(strength);

    t2 = renodx::color::correct::Luminance(t2, renodx::color::y::from::BT709(t2), colorTy);
    colorT.xyz = lerp(colorT.xyz, t2, strength).xyz;
  }

  //mid gray exposure
  [branch]
  if (RENODX_TONE_MAP_TYPE > 0)
  {
    float a = 0.461;
    float3 b = lut.Sample(samp, a).xyz;
    float c = renodx::color::y::from::BT709(b);
    float d = renodx::color::srgb::Decode(c);
    colorU *= d / 0.18;
  }
}

// void Tonemap_BloomScale(inout float3 color) {
//   color.xyz *= CUSTOM_BLOOM; 
// }

float3 Tonemap_Do(float3 colorU, float3 colorT, float2 uv/* , Texture2D<float4> texColor */) {
  colorT = max(0, colorT);
  // colorT = renodx::color::srgb::Decode(colorT);
  colorT *= colorT;

  if (RENODX_TONE_MAP_TYPE > 0) {
    colorU *= CUSTOM_PREEXPOSURE_MULTIPLIER;
    [branch] if (CUSTOM_PREEXPOSURE_CONTRAST != 1.f) colorU = renodx::color::grade::Contrast(colorU, CUSTOM_PREEXPOSURE_CONTRAST, CUSTOM_PREEXPOSURE_CONTRAST_MID);

    renodx::draw::Config config = renodx::draw::BuildConfig();
    // config.reno_drt_tone_map_method = 1.f;
    colorT = renodx::draw::ToneMapPass(colorU, colorT, renodx::tonemap::Reinhard(colorU), config);

    // colorT = renodx::effects::ApplyFilmGrainColored(colorT, uv, SEED, CUSTOM_FILMGRAIN_RENO);
  } else {
    colorT = min(colorT, 1);
  }

  //RenderIntermediatePass
  colorT = renodx::draw::RenderIntermediatePass(colorT);

  return colorT;
}

// float3 Tonemap_Bypassed(float3 color, float2 uv, Texture2D<float4> texColor) {
//   color = max(0, color);
//   color = Tonemap_DecodeSafe(color);
  
//   //RenderIntermediatePass
//   color = renodx::draw::RenderIntermediatePass(color);

//   return color;
// }