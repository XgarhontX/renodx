#ifndef SRC_TEMPLATE_SHARED_H_
#define SRC_TEMPLATE_SHARED_H_

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float expected_peak_white_nits;
  
  float fakewcgcorrect_gamma;
  float fakewcgcorrect_chroma;
  float fakewcgcorrect_luma;
  float fakewcgcorrect_sat;

  float gamma_correction;
  float tone_map_type;
  float lut;
  float swap_chain_encoding;

  float cg_exposure;
  float cg_contrast;
  float cg_highlights;
  float cg_shadows;

  float bloom;
  float ui;
  float p2;
  float p3;

  float pblow_chue;
  float pblow_csat;
  float pblow_start;
  float pblow_max;

  float pblow_enabled;
  float sun_boost;
  float lens_flare;
  float lens_dirt;

  float bloom_streakslength;
  float bloom_streaks;
  float bloom_streaksrolloff;
  float p1;
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
