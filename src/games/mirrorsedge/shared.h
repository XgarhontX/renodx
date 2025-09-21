// From SpecOpsTheLine

#ifndef SRC_TEMPLATE_SHARED_H_
#define SRC_TEMPLATE_SHARED_H_

#define CBUFFER  13
#define CBUFFERB b13

// #define RENODX_PEAK_WHITE_NITS                 1000.f
// #define RENODX_DIFFUSE_WHITE_NITS              renodx::color::bt2408::REFERENCE_WHITE
// #define RENODX_GRAPHICS_WHITE_NITS             renodx::color::bt2408::GRAPHICS_WHITE
// #define RENODX_COLOR_GRADE_STRENGTH            1.f
// #define RENODX_TONE_MAP_TYPE                   TONE_MAP_TYPE_RENO_DRT
// #define RENODX_TONE_MAP_EXPOSURE               1.f
// #define RENODX_TONE_MAP_HIGHLIGHTS             1.f
// #define RENODX_TONE_MAP_SHADOWS                1.f
// #define RENODX_TONE_MAP_CONTRAST               1.f
// #define RENODX_TONE_MAP_SATURATION             1.f
// #define RENODX_TONE_MAP_HIGHLIGHT_SATURATION   1.f
// #define RENODX_TONE_MAP_BLOWOUT                0
// #define RENODX_TONE_MAP_FLARE                  0
#define RENODX_COLOR_GRADE_STRENGTH 1.f
// #define RENODX_TONE_MAP_HUE_CORRECTION      1.f
// #define RENODX_TONE_MAP_HUE_SHIFT           0
#define RENODX_TONE_MAP_WORKING_COLOR_SPACE color::convert::COLOR_SPACE_BT709
#define RENODX_TONE_MAP_CLAMP_COLOR_SPACE   color::convert::COLOR_SPACE_NONE
#define RENODX_TONE_MAP_CLAMP_PEAK          color::convert::COLOR_SPACE_BT709
#define RENODX_TONE_MAP_HUE_PROCESSOR       HUE_PROCESSOR_NONE
#define RENODX_TONE_MAP_PER_CHANNEL         0
// #define RENODX_GAMMA_CORRECTION                GAMMA_CORRECTION_GAMMA_2_2
// #define RENODX_INTERMEDIATE_SCALING            (RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS)
// #define RENODX_INTERMEDIATE_ENCODING           ENCODING_NONE
#define RENODX_INTERMEDIATE_COLOR_SPACE color::convert::COLOR_SPACE_BT709
// #define RENODX_SWAP_CHAIN_DECODING             RENODX_INTERMEDIATE_ENCODING
// #define RENODX_SWAP_CHAIN_DECODING_COLOR_SPACE RENODX_INTERMEDIATE_COLOR_SPACE
// #define RENODX_SWAP_CHAIN_CUSTOM_COLOR_SPACE   COLOR_SPACE_CUSTOM_BT709D65
// #define RENODX_SWAP_CHAIN_SCALING_NITS         RENODX_GRAPHICS_WHITE_NITS
// #define RENODX_SWAP_CHAIN_CLAMP_NITS           RENODX_PEAK_WHITE_NITS
// #define RENODX_SWAP_CHAIN_CLAMP_COLOR_SPACE    color::convert::COLOR_SPACE_UNKNOWN
// #define RENODX_SWAP_CHAIN_ENCODING             ENCODING_NONE
#define RENODX_SWAP_CHAIN_ENCODING_COLOR_SPACE color::convert::COLOR_SPACE_BT709
#define RENODX_RENO_DRT_TONE_MAP_METHOD        renodx::tonemap::renodrt::config::tone_map_method::REINHARD

// static const float GAMMA_CORRECTION_NONE = 0;
// static const float GAMMA_CORRECTION_SRGB = 0;
// static const float GAMMA_CORRECTION_GAMMA_2_2 = 1.f;
// static const float GAMMA_CORRECTION_GAMMA_2_4 = 2.f;

// static const float ENCODING_NONE = 0;
// static const float ENCODING_SRGB = 1.f;
// static const float ENCODING_GAMMA_2_2 = 2.f;
// static const float ENCODING_GAMMA_2_4 = 3.f;
// static const float ENCODING_PQ = 4.f;
// static const float ENCODING_SCRGB = 5.f;

// static const float COLOR_SPACE_CUSTOM_BT709D65 = 0;
// static const float COLOR_SPACE_CUSTOM_BT709D93 = 1.f;
// static const float COLOR_SPACE_CUSTOM_NTSCU = 2.f;
// static const float COLOR_SPACE_CUSTOM_NTSCJ = 3.f;

// static const float HUE_PROCESSOR_NONE = -1.f;
// static const float HUE_PROCESSOR_OKLAB = 0;
// static const float HUE_PROCESSOR_ICTCP = 1.f;
// static const float HUE_PROCESSOR_DTUCS = 2.f;

// static const float HUE_SHIFT_METHOD_CLIP = 0.f;
// static const float HUE_SHIFT_METHOD_SDR_MODIFIED = 1.f;
// static const float HUE_SHIFT_METHOD_AP1_ROLL_OFF = 2.f;
// static const float HUE_SHIFT_METHOD_ACES_FITTED_BT709 = 3.f;
// static const float HUE_SHIFT_METHOD_ACES_FITTED_AP1 = 4.f;

// static const float HUE_SHIFT_METHOD_MODIFIER = 0.f;

// static const float TONE_MAP_TYPE_VANILLA = 0;
// static const float TONE_MAP_TYPE_UNTONEMAPPED = 1.f;
// static const float TONE_MAP_TYPE_ACES = 2.f;
// static const float TONE_MAP_TYPE_RENO_DRT = 3.f;

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float peak_white_nits;
  float diffuse_white_nits;
  float graphics_white_nits;
  float gamma_correction;

  float tone_map_type;
  float tone_map_exposure;
  float tone_map_highlights;
  float tone_map_shadows;

  float tone_map_contrast;
  float tone_map_saturation;
  float tone_map_highlight_saturation;
  float tone_map_blowout;

  float tone_map_flare;
  float custom_mov;
  float custom_grade_chroma;
  float custom_grade_luma;

  float custom_bloom;
  float custom_whiteclip_lerp;
  float custom_speedlines;
  float tone_map_white_clip;

  float custom_preexposure;
  float custom_preexposure_contrast;
  float custom_preexposure_ratio;
  float custom_prexposure_decode;

  float custom_sunglare;
  float custom_sunsize;
  float custom_sunlens;
  float pad3;

  // float intermediate_encoding;
  // float swap_chain_decoding;
  // float swap_chain_encoding;
  // float swap_chain_gamma_correction;
};

#ifndef __cplusplus
#if (__SHADER_TARGET_MAJOR == 3)

float4 shader_injection[8] : register(c50);

#define RENODX_PEAK_WHITE_NITS     shader_injection[0][0]
#define RENODX_DIFFUSE_WHITE_NITS  shader_injection[0][1]
#define RENODX_GRAPHICS_WHITE_NITS shader_injection[0][2]
#define RENODX_GAMMA_CORRECTION    shader_injection[0][3]

#define RENODX_TONE_MAP_TYPE       shader_injection[1][0]
#define RENODX_TONE_MAP_EXPOSURE   shader_injection[1][1]
#define RENODX_TONE_MAP_HIGHLIGHTS shader_injection[1][2]
#define RENODX_TONE_MAP_SHADOWS    shader_injection[1][3]

#define RENODX_TONE_MAP_CONTRAST             shader_injection[2][0]
#define RENODX_TONE_MAP_SATURATION           shader_injection[2][1]
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection[2][2]
#define RENODX_TONE_MAP_BLOWOUT              shader_injection[2][3]

#define RENODX_TONE_MAP_FLARE shader_injection[3][0]
#define CUSTOM_MOV            shader_injection[3][1]
#define CUSTOM_GRADE_CHROMA   shader_injection[3][2]
#define CUSTOM_GRADE_LUMA     shader_injection[3][3]

#define CUSTOM_BLOOM               shader_injection[4][0]
#define CUSTOM_WHITECLIP_LERP      shader_injection[4][1]
#define CUSTOM_SPEEDLINES          shader_injection[4][2]
#define RENODX_RENO_DRT_WHITE_CLIP shader_injection[4][3]

#define CUSTOM_PREEXPOSURE          shader_injection[5][0]
#define CUSTOM_PREEXPOSURE_CONTRAST shader_injection[5][1]
#define CUSTOM_PREEXPOSURE_RATIO    shader_injection[5][2]
#define CUSTOM_PREXPOSURE_DECODE    shader_injection[5][3]

#define CUSTOM_SUNGLARE shader_injection[6][0]
#define CUSTOM_SUNSIZE  shader_injection[6][1]
#define CUSTOM_SUNLENS  shader_injection[6][2]
#define PAD3            shader_injection[6][3]

// #define RENODX_INTERMEDIATE_ENCODING       shader_injection[7][0]
// #define RENODX_SWAP_CHAIN_DECODING         shader_injection[7][1]
// #define RENODX_SWAP_CHAIN_ENCODING         shader_injection[7][2]
// #define RENODX_SWAP_CHAIN_GAMMA_CORRECTION shader_injection[7][3]

#else
#if ((__SHADER_TARGET_MAJOR == 5 && __SHADER_TARGET_MINOR >= 1) || __SHADER_TARGET_MAJOR >= 6)
cbuffer shader_injection : register(CBUFFERB, space50) {
  ShaderInjectData shader_injection : packoffset(c0);
}
#elif (__SHADER_TARGET_MAJOR < 5) || ((__SHADER_TARGET_MAJOR == 5) && (__SHADER_TARGET_MINOR < 1))
cbuffer shader_injection : register(CBUFFERB) {
  ShaderInjectData shader_injection : packoffset(c0);
}

#define RENODX_PEAK_WHITE_NITS     shader_injection.peak_white_nits
#define RENODX_DIFFUSE_WHITE_NITS  shader_injection.diffuse_white_nits
#define RENODX_GRAPHICS_WHITE_NITS shader_injection.graphics_white_nits
#define RENODX_TONE_MAP_TYPE       shader_injection.tone_map_type

#define RENODX_GAMMA_CORRECTION    shader_injection.gamma_correction
#define RENODX_TONE_MAP_EXPOSURE   shader_injection.tone_map_exposure
#define RENODX_TONE_MAP_HIGHLIGHTS shader_injection.tone_map_highlights
#define RENODX_TONE_MAP_SHADOWS    shader_injection.tone_map_shadows

#define RENODX_TONE_MAP_CONTRAST             shader_injection.tone_map_contrast
#define RENODX_TONE_MAP_SATURATION           shader_injection.tone_map_saturation
#define RENODX_TONE_MAP_HIGHLIGHT_SATURATION shader_injection.tone_map_highlight_saturation
#define RENODX_TONE_MAP_BLOWOUT              shader_injection.tone_map_blowout

#define RENODX_TONE_MAP_FLARE shader_injection.tone_map_flare
#define CUSTOM_MOV            shader_injection.custom_mov
#define CUSTOM_GRADE_CHROMA   shader_injection.custom_grade_chroma
#define CUSTOM_GRADE_LUMA     shader_injection.custom_grade_luma

#define CUSTOM_BLOOM               shader_injection.custom_bloom
#define CUSTOM_WHITECLIP_LERP      shader_injection.custom_whiteclip_lerp
#define CUSTOM_SPEEDLINES          shader_injection.custom_speedlines
#define RENODX_RENO_DRT_WHITE_CLIP shader_injection.tone_map_white_clip

#define CUSTOM_PREEXPOSURE          shader_injection.custom_preexposure
#define CUSTOM_PREEXPOSURE_CONTRAST shader_injection.custom_preexposure_contrast
#define CUSTOM_PREEXPOSURE_RATIO    shader_injection.custom_preexposure_ratio
#define CUSTOM_PREXPOSURE_DECODE    shader_injection.custom_prexposure_decode

#define CUSTOM_SUNGLARE shader_injection.custom_sunglare
#define CUSTOM_SUNSIZE  shader_injection.custom_sunsize
#define CUSTOM_SUNLENS  shader_injection.custom_sunlens
#define PAD3            shader_injection.pad3

// #define RENODX_INTERMEDIATE_ENCODING       shader_injection.intermediate_encoding
// #define RENODX_SWAP_CHAIN_DECODING         shader_injection.swap_chain_decoding
// #define RENODX_SWAP_CHAIN_ENCODING         shader_injection.swap_chain_encoding
// #define RENODX_SWAP_CHAIN_GAMMA_CORRECTION shader_injection.swap_chain_gamma_correction

#endif

#endif

#include "../../shaders/renodx.hlsl"

#endif

#endif  // SRC_TEMPLATE_SHARED_H_
