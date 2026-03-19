#ifndef SRC_TEMPLATE_SHARED_H_
#define SRC_TEMPLATE_SHARED_H_

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float expected_peak_white_nits;

  float gamma_correction;
  float swap_chain_encoding;
  float tone_map_type;
  float tone_map_type_hdr;

  float cg_exposure;
  float cg_midgray;
  float cg_contrast;
  float cg_highlights;

  float cg_shadows;
  float p0;
  float bloom;
  float chromaticaberration;

  float vignette;
  float lensdust;
  float godrays;
  float exposure;

  float lut_whitebalance;
  float lut_expandgamut;
  float lut_colorgrade;
  float lut_hueshiftblowout;

  float lut_desaturation;
  float lutpcb_hue;
  float lutpcb_chroma;
  float lutpcb_saturation;
};

#define SI shader_injection

#ifndef __cplusplus
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer shader_injection : register(b13, space50) {
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer shader_injection : register(b13) {
#endif
  ShaderInjectData shader_injection : packoffset(c0);
}

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_TEMPLATE_SHARED_H_
