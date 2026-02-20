// From SpecOpsTheLine

#ifndef SRC_TEMPLATE_SHARED_H_
#define SRC_TEMPLATE_SHARED_H_

#define CBUFFER  13
#define CBUFFERB b13

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
  float seed;
  float c_filmgrain;
  float c_tint;
  
  float c_bloom_strength;
  float c_bloom_pow;
  float c_vignette;
  float c_lut_highlightsat;

  float c_cg_highlights;
  float c_cg_highlights_mid;
  float c_cg_shadows;
  float c_cg_shadows_mid;

  float c_bloom_sat;
  float c_mb_blend;
  float c_mb_lenience;
  float c_lut;

  float c_gammaoffset;
  float tone_map_type;
  float c_ca;
  float c_glitch;

  float c_ui;
  float pad0;
  float pad1;
  float pad2;
};

// #define EXPOSURE_REVERSAL 3.26
// #define EXPOSURE_REVERSAL 2.4
#define EXPOSURE_REVERSAL 2. 
// #define EXPOSURE_REVERSAL 1.87 
// #define EXPOSURE_REVERSAL 1.56
// #define EXPOSURE_REVERSAL 1.42
// #define EXPOSURE_REVERSAL 1.

// #define EXPOSURE_FINAL_FUDGE 1.1
// #define EXPOSURE_FINAL_FUDGE 1.09
#define EXPOSURE_FINAL_FUDGE 1.077
// #define EXPOSURE_FINAL_FUDGE 1.075
// #define EXPOSURE_FINAL_FUDGE 1.0625
// #define EXPOSURE_FINAL_FUDGE 1.05
// #define EXPOSURE_FINAL_FUDGE 1.

#define EXPOSURE_BRIGHT_GLOBAL 1/EXPOSURE_REVERSAL
#define EXPOSURE_CAR_FRESNEL 1/EXPOSURE_REVERSAL
#define EXPOSURE_BILLBOARDS 1/EXPOSURE_REVERSAL

#ifndef __cplusplus
#if (__SHADER_TARGET_MAJOR == 3)

float4 shader_injection[8] : register(c50);

#define RENODX_PEAK_WHITE_NITS             shader_injection[0][0]
#define RENODX_DIFFUSE_WHITE_NITS          shader_injection[0][1]
#define RENODX_GRAPHICS_WHITE_NITS         shader_injection[0][2]
#define RENODX_EXPECTED_PEAK_WHITE_NITS    shader_injection[0][3]

// #define pad0 shader_injection[1][0]
// #define pad0 shader_injection[1][1]
// #define pad1 shader_injection[1][2]
// #define pad2 shader_injection[1][3]

// #define RENODX_GAMMA_CORRECTION            shader_injection[2][0]
#define RENODX_SEED                        shader_injection[2][1]
#define C_FILMGRAIN                        shader_injection[2][2]
#define C_TINT                             shader_injection[2][3]

#define C_BLOOM_STRENGTH                   shader_injection[3][0]
#define C_BLOOM_POW                        shader_injection[3][1]
#define C_VIGNETTE                         shader_injection[3][2]
#define C_LUT_HIGHLIGHTSAT                     shader_injection[3][3]

#define C_CG_HIGHLIGHTS                    shader_injection[4][0]
#define C_CG_HIGHLIGHTS_MID                shader_injection[4][1]
#define C_CG_SHADOWS                       shader_injection[4][2]
#define C_CG_SHADOWS_MID                   shader_injection[4][3]

#define C_BLOOM_SAT                        shader_injection[5][0]
#define C_MB_BLEND                         shader_injection[5][1]
#define C_MB_LENIENCE                      shader_injection[5][2]
#define C_LUT                              shader_injection[5][3]

#define C_GAMMAOFFSET                      shader_injection[6][0]
// #define p1                                 shader_injection[6][1]
#define C_CA                               shader_injection[6][2]
#define C_GLITCH                           shader_injection[6][3]

#define C_UI                               shader_injection[7][0]
// #define p1                                 shader_injection[7][1]
// #define p1                                 shader_injection[7][2]
// #define p1                                 shader_injection[7][3]


#else
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer shader_injection : register(CBUFFERB, space50) {
  ShaderInjectData shader_injection : packoffset(c0);
}
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer shader_injection : register(CBUFFERB) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#endif

#endif

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_TEMPLATE_SHARED_H_
