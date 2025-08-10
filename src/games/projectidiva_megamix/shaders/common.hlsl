#include "../shared.h"

void Tonemap_Do(float3 colorUntonemapped, inout float3 r0) {
  if (RENODX_TONE_MAP_TYPE > 0) {
    
    colorUntonemapped.xyz = renodx::color::srgb::DecodeSafe(colorUntonemapped.xyz);
    // colorUntonemapped.xyz *= 0.5;

    r0.xyz = saturate(r0.xyz); //it does go over 1, and relies on output texture to clamp.
    r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
    r0.xyz = renodx::draw::ToneMapPass(colorUntonemapped, r0.xyz);

    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz); //for rest of shaders until RenderIntermediatePass
  }
}

// (Copied from: ff7rebirth)
// AdvancedAutoHDR pass to generate some HDR brightess out of an SDR signal.
// This is hue conserving and only really affects highlights.
// "sdr_color" is meant to be in "SDR range", as in, a value of 1 matching SDR white (something between 80, 100, 203, 300 nits, or whatever else)
// https://github.com/Filoppi/PumboAutoHDR
float3 PumboAutoHDR(float3 sdr_color, float shoulder_pow = 2.75f) {
  const float SDRRatio = max(renodx::color::y::from::BT2020(sdr_color), 0.f);

  // Limit AutoHDR brightness, it won't look good beyond a certain level.
  // The paper white multiplier is applied later so we account for that.
  float target_max_luminance = min(RENODX_PEAK_WHITE_NITS, pow(10.f, ((log10(RENODX_DIFFUSE_WHITE_NITS) - 0.03460730900256) / 0.757737096673107)));
  target_max_luminance = lerp(1.f, target_max_luminance, .5f);

  const float auto_HDR_max_white = max(target_max_luminance / RENODX_DIFFUSE_WHITE_NITS, 1.f);
  const float auto_HDR_shoulder_ratio = 1.f - max(1.f - SDRRatio, 0.f);
  const float auto_HDR_extra_ratio = pow(max(auto_HDR_shoulder_ratio, 0.f), shoulder_pow) * (auto_HDR_max_white - 1.f);
  const float auto_HDR_total_ratio = SDRRatio + auto_HDR_extra_ratio;
  return sdr_color * renodx::math::SafeDivision(auto_HDR_total_ratio, SDRRatio, 1);  // Fallback on a value of 1 in case of division by 0
}