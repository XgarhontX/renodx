#ifndef COMMONHLSL
  #include "../shared.h"
#endif

struct DualToneMap {
  float3 color_hdr;
  float3 color_sdr;
};

float4 Tonemap_VanillaInternal4(float4 colorU) { //BF1 Main https://www.desmos.com/calculator/ocefue87gg
  float4 r0, r1, r2;
  r0 = float4(colorU);

  r1 = 0.985521019 * r0;
  r2 = r0 * 0.985521019 + 0.058662001;
  r1 = r2 * r1;
  r2 = r0 * 0.774596989 + 0.0482814983;
  r0 = r0 * 0.774596989 + 1.24270999;
  r0 = r2 * r0;
  r0 = r1 / r0;

  return r0;
}

float4 Reinhard(float4 x, float peak = 1.f) {
  return x / (x / peak + 1.f);
}

DualToneMap ApplyToneMaps_Vanilla(float3 color_input, renodx::tonemap::Config tm_config) {
  renodx::tonemap::Config sdr_config = tm_config;
  sdr_config.reno_drt_highlights /= tm_config.highlights;
  sdr_config.reno_drt_shadows /= tm_config.shadows;
  sdr_config.reno_drt_contrast /= tm_config.contrast;
  sdr_config.gamma_correction = 0;
  sdr_config.peak_nits = 100.f;
  sdr_config.game_nits = 100.f;
  tm_config.hue_correction_type = renodx::tonemap::config::hue_correction_type::INPUT;

  DualToneMap dual_tone_map;
  //HDR
  {
    tm_config.reno_drt_per_channel = true;
    dual_tone_map.color_hdr = renodx::tonemap::config::Apply(color_input /* * (0.18 / 0.1614) */, tm_config);
  }
  //SDR
  {
    float color_input_y = renodx::color::y::from::BT709(color_input);
    float4 color_input_rgby = Tonemap_VanillaInternal4(float4(color_input, color_input_y));
    // float4 color_input_rgby = Reinhard(float4(color_input, color_input_y));

    float3 color_sdr_pc = color_input_rgby.xyz;
    float3 color_sdr_y = renodx::color::correct::Luminance(color_input, color_input_y, color_input_rgby.w);

    dual_tone_map.color_sdr = lerp(color_sdr_pc, color_sdr_y, CUSTOM_PCC_STRENGTH);
  }
  return dual_tone_map;
}

#define TONE_MAP_FUNCTION_GENERATOR(textureType)                                                                \
  float3 DualTonemap_Vanilla(float3 color_input, renodx::tonemap::Config tm_config, renodx::lut::Config lut_config, textureType lut_texture) { \
    [branch]                                                                                                    \
    if (lut_config.strength == 0.f || tm_config.type == 1.f) {                                                  \
      return renodx::tonemap::config::Apply(color_input, tm_config);                                                                     \
    } else {                                                                                                    \
      DualToneMap tone_maps = ApplyToneMaps_Vanilla(color_input, tm_config);                                            \
      float3 color_hdr = tone_maps.color_hdr;                                                                   \
      float3 color_sdr = tone_maps.color_sdr;                                                                   \
                                                                                                                \
      float previous_lut_config_strength = lut_config.strength;                                                 \
      lut_config.strength = 1.f;                                                                                \
      float3 color_lut;                                                                                         \
      if (                                                                                                      \
          lut_config.type_input == renodx::lut::config::type::SRGB                                                      \
          || lut_config.type_input == renodx::lut::config::type::GAMMA_2_4                                              \
          || lut_config.type_input == renodx::lut::config::type::GAMMA_2_2                                              \
          || lut_config.type_input == renodx::lut::config::type::GAMMA_2_0) {                                           \
        color_lut = renodx::lut::Sample(lut_texture, lut_config, color_sdr);                                    \
      } else {                                                                                                  \
        color_lut = min(1.f, renodx::lut::Sample(lut_texture, lut_config, color_hdr));                          \
      }                                                                                                         \
                                                                                                                \
      [branch]                                                                                                  \
      if (tm_config.type == renodx::tonemap::config::type::VANILLA) {                                                            \
        return lerp(color_input, color_lut, previous_lut_config_strength);                                      \
      } else {                                                                                                  \
        return renodx::tonemap::UpgradeToneMap(color_hdr, color_sdr, color_lut, previous_lut_config_strength);                   \
      }                                                                                                         \
    }                                                                                                           \
  }

TONE_MAP_FUNCTION_GENERATOR(Texture2D<float4>);
TONE_MAP_FUNCTION_GENERATOR(Texture2D<float3>);
TONE_MAP_FUNCTION_GENERATOR(Texture3D<float4>);
TONE_MAP_FUNCTION_GENERATOR(Texture3D<float3>);