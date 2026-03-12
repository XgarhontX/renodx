#ifndef SRC_TEMPLATE_SHARED_H_
#define SRC_TEMPLATE_SHARED_H_

#define CBUFFER  13
#define CBUFFERB b13

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float gamma_correction; //swapchain only
  float swap_chain_encoding; //swapchain only
  float fakewcgcorrect_gamma; 
  float fakewcgcorrect_chroma; 

  float fakewcgcorrect_luma;
  float fakewcgcorrect_sat; 
  float peak_white_nits;
  float graphics_white_nits;

  float diffuse_white_nits;
  float expected_white_nits;
  float tone_map_type;
  float vcg_lut;

  float vcg_other;
  float vcg_colornwc;
  float vcg_exposure;
  float c_worldflare;

  float c_worldflare_addblur;
  float c_sunglare;
  float c_sunsize;
  float c_sunlens;

  float cg_middle;
  float cg_contrast;
  float cg_highlights;
  float cg_shadows;

  float pblow_chue;
  float pblow_csat;
  float pblow_start;
  float pblow_max;

  float pblow_satboost;
  float pblow_guaranteed;
  float c_bloom;
  float c_bloom_contrast;

  float c_dof;
  float c_speedlines;
  float c_mov;
  float ui;
};
#define SI shader_injection


#define GAMMA_CORRECTION   shader_injection[0][0]
#define SWAP_CHAIN_ENCODING   shader_injection[0][1]
#define FAKEWCGCORRECT_GAMMA   shader_injection[0][2]
#define FAKEWCGCORRECT_CHROMA   shader_injection[0][3]

#define FAKEWCGCORRECT_LUMA   shader_injection[1][0]
#define FAKEWCGCORRECT_SAT   shader_injection[1][1]
#define PEAK_WHITE_NITS   shader_injection[1][2]
#define GRAPHICS_WHITE_NITS   shader_injection[1][3]

#define DIFFUSE_WHITE_NITS   shader_injection[2][0]
#define EXPECTED_WHITE_NITS   shader_injection[2][1]
#define TONE_MAP_TYPE   shader_injection[2][2]
#define VCG_LUT   shader_injection[2][3]

#define VCG_OTHER   shader_injection[3][0]
#define VCG_COLORNWC   shader_injection[3][1]
#define VCG_EXPOSURE   shader_injection[3][2]
#define C_WORLDFLARE   shader_injection[3][3]

#define C_WORLDFLARE_ADDBLUR   shader_injection[4][0]
#define C_SUNGLARE   shader_injection[4][1]
#define C_SUNSIZE   shader_injection[4][2]
#define C_SUNLENS   shader_injection[4][3]

#define CG_MIDDLE   shader_injection[5][0]
#define CG_CONTRAST   shader_injection[5][1]
#define CG_HIGHLIGHTS   shader_injection[5][2]
#define CG_SHADOWS   shader_injection[5][3]

#define PBLOW_CHUE   shader_injection[6][0]
#define PBLOW_CSAT   shader_injection[6][1]
#define PBLOW_START   shader_injection[6][2]
#define PBLOW_MAX   shader_injection[6][3]

#define PBLOW_SATBOOST   shader_injection[7][0]
#define PBLOW_GUARANTEED   shader_injection[7][1]
#define C_BLOOM   shader_injection[7][2]
#define C_BLOOM_CONTRAST   shader_injection[7][3]

#define C_DOF   shader_injection[8][0]
#define C_SPEEDLINES   shader_injection[8][1]
#define C_MOV   shader_injection[8][2]
#define UI   shader_injection[8][3]



#ifndef __cplusplus
#if (__SHADER_TARGET_MAJOR == 3)

float4 shader_injection[9] : register(c50);

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
