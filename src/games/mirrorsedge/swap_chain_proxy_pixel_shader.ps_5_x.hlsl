#include "./shared.h"

Texture2D t0 : register(t0);
SamplerState s0 : register(s0);
float4 main(float4 vpos: SV_POSITION, float2 uv: TEXCOORD0) : SV_TARGET {
  float4 color = t0.Sample(s0, uv);

  // renodx::draw::Config draw_config = renodx::draw::BuildConfig();
  // renodx::tonemap::Config tone_map_config = renodx::tonemap::config::Create();
  // {
  //   tone_map_config.peak_nits = draw_config.peak_white_nits;
  //   tone_map_config.game_nits = draw_config.diffuse_white_nits;
  //   tone_map_config.type = min(draw_config.tone_map_type, 3);
  //   tone_map_config.gamma_correction = draw_config.gamma_correction;
  //   tone_map_config.exposure = draw_config.tone_map_exposure;
  //   tone_map_config.highlights = draw_config.tone_map_highlights;
  //   tone_map_config.shadows = draw_config.tone_map_shadows;
  //   tone_map_config.contrast = draw_config.tone_map_contrast;
  //   tone_map_config.saturation = draw_config.tone_map_saturation;

  //   tone_map_config.reno_drt_highlights = 1.0f;
  //   tone_map_config.reno_drt_shadows = 1.0f;
  //   tone_map_config.reno_drt_contrast = 1.0f;
  //   tone_map_config.reno_drt_saturation = 1.0f;
  //   tone_map_config.reno_drt_blowout = -1.f * (draw_config.tone_map_highlight_saturation - 1.f);
  //   tone_map_config.reno_drt_dechroma = draw_config.tone_map_blowout;
  //   tone_map_config.reno_drt_flare = 0.10f * pow(draw_config.tone_map_flare, 10.f);
  //   tone_map_config.reno_drt_working_color_space = draw_config.tone_map_working_color_space;
  //   tone_map_config.reno_drt_per_channel = draw_config.tone_map_per_channel == 1.f;
  //   tone_map_config.reno_drt_hue_correction_method = draw_config.tone_map_hue_processor;
  //   tone_map_config.reno_drt_clamp_color_space = draw_config.tone_map_clamp_color_space;
  //   tone_map_config.reno_drt_clamp_peak = draw_config.tone_map_clamp_peak;
  //   tone_map_config.reno_drt_tone_map_method = draw_config.reno_drt_tone_map_method;
  //   tone_map_config.reno_drt_white_clip = draw_config.reno_drt_white_clip;
  // }
  // color.xyz = renodx::tonemap::config::Apply(color, tone_map_config).xyz;

  color = renodx::draw::SwapChainPass(color);
  return color;
}
