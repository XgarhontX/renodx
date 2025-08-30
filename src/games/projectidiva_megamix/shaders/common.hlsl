#include "../shared.h"

// void Tonemap_Compressor(inout color) {
//   //y
//   float y = renodx::color::
// }

void F(inout float4 color) {
  saturate(color);
}

void F(inout float3 color) {
  saturate(color);
}

void F(inout float2 color) {
  saturate(color);
}


void F(inout float color) {
  saturate(color);
}

void ApplyPerChannelCorrection(float3 untonemapped,
                               inout float vanilla_red,
                               inout float vanilla_green,
                               inout float vanilla_blue) {
  // if (RENODX_TONE_MAP_TYPE == 0.f) return;
  // if (CUSTOM_COLOR_GRADE_BLOWOUT_RESTORATION == 0.f
  //     && CUSTOM_COLOR_GRADE_HUE_CORRECTION == 0.f
  //     && CUSTOM_COLOR_GRADE_SATURATION_CORRECTION == 0.f) {
  //   return;
  // }
  float3 vanilla_color = float3(vanilla_red, vanilla_green, vanilla_blue);
  float3 new_vanilla_color = renodx::draw::ApplyPerChannelCorrection(
      untonemapped,
      vanilla_color,
      0, //blowout
      1, //hue correct
      1); //sat correct
  vanilla_red = new_vanilla_color.r;
  vanilla_green = new_vanilla_color.g;
  vanilla_blue = new_vanilla_color.b;
}

void Tonemap_BloomMultiplier(inout float4 color) {
  if (RENODX_TONE_MAP_TYPE > 0) color *= 0.5;
}

void Tonemap_Do(float3 colorUntonemapped, inout float3 r0, Texture2D<float4> t0) {
  if (RENODX_TONE_MAP_TYPE > 0) {
    // uint2 texture_size;
    // t0.GetDimensions(texture_size.x, texture_size.y);
    // renodx::debug::graph::Start(colorUntonemapped, texture_size, float2(0,0));

    //colorUntonemapped
    colorUntonemapped.xyz = renodx::color::srgb::DecodeSafe(colorUntonemapped.xyz);
    
    // colorUntonemapped.xyz = renodx::color::gamma::DecodeSafe(colorUntonemapped.xyz); //100%
    // colorUntonemapped.xyz *= 0.5;
    
    //r0 (ronemapped)
    r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz); //100% srgb
    r0.xyz = renodx::color::correct::GammaSafe(r0.xyz, true); //reverse 2.2

    // ApplyPerChannelCorrection(colorUntonemapped.xyz, r0.x, r0.y, r0.z); //works really well, but breaks filters like sepia

    //mov fix
    // if ()

    //ToneMapPass()
    if (RENODX_TONE_MAP_TYPE > 0) r0.xyz = renodx::draw::ToneMapPass(colorUntonemapped, r0.xyz);
    else {
      r0.xyz = colorUntonemapped.xyz; //skip
    }

    //encode for rest of shaders until RenderIntermediatePass
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz); //100% srgb

    // renodx::debug::graph::Finish(outputColor);
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