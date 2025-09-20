#include "../shared.h"
// #define IS_DEBUG_GRAPH

// #define RHSC_E (50.f / 41.f)
// float3 ReinhardScalableCached(float3 x) {
//   return (x * RHSC_E) / (x * RHSC_E + 1.f);
// }

// float max3(float x, float y, float z) {
//   return max(x, max(y, z));
// }

// float3 InverseTonemap(float3 x, float curve, float xmax) {
//   x = (curve * x * xmax) / max(0.000000000001, xmax - x);
//   return x;
// }

// uint ParseHueProcessing(float x) {
//   if (x == renodx::tonemap::renodrt::config::hue_correction_method::OKLAB) {
//     return 0u;
//   } else if (x == renodx::tonemap::renodrt::config::hue_correction_method::ICTCP) {
//     return 1u;
//   } else /* if (x == renodx::tonemap::renodrt::config::hue_correction_method::DARKTABLE_UCS) */ {
//     return 2u;
//   }
// }

float3 Tonemap_Do(in float3 colorUntonemapped, in float3 colorTonemapped, in float exposure, in sampler2D tex, in float2 uv) {
  // prep colorTonemapped
  // colorTonemapped = max(0, colorTonemapped);
  colorTonemapped = renodx::color::srgb::Decode(colorTonemapped);  // 100000% srgb

  float3 result;
  if (RENODX_TONE_MAP_TYPE > 0) {
    // prep colorUntonemapped
    // colorUntonemapped = max(0, colorUntonemapped);

    // chroma
    float3 color_sdr_graded;
    {
      float3 colorWorkingChroma = lerp(colorUntonemapped, colorTonemapped, CUSTOM_GRADE_CHROMA);

      float3 colorWorkingChromaSat = saturate(colorWorkingChroma);
      color_sdr_graded = renodx::tonemap::UpgradeToneMap(colorWorkingChroma, colorWorkingChromaSat, colorWorkingChromaSat, CUSTOM_WHITECLIP_LERP, 0);  // way better than Chrominance
      // color_sdr_graded = renodx::color::correct::Chrominance(colorWorkingChroma, colorWorkingChromaSat, CUSTOM_WHITECLIP_LERP, 0, ParseHueProcessing(0)); //THIS SUCKS
    }

    // luma
    float3 color_untonemapped = lerp(colorUntonemapped, colorTonemapped, CUSTOM_GRADE_LUMA);
    float3 color_sdr_neutral = color_untonemapped;
    float e = CUSTOM_INV_EXPOSURE;
    e = (CUSTOM_NEWEXPOSURE) ? e * rcp(exposure * 64.f) * log2(exposure * 50 + 1) * 2.f : e;
    color_untonemapped *= e;

    // InverseTonemap
    // color_untonemapped = (CUSTOM_INV_MAX > 0) ? InverseTonemap(color_untonemapped, CUSTOM_INV_CURVE, CUSTOM_INV_MAX) : color_untonemapped;

// #ifdef IS_DEBUG_GRAPH
//     // graph start
//     float w = 2560 * uv.x;
//     float h = 1440 * uv.y;
//     // tex.GetDimesions(w, h);
//     renodx::debug::graph::Config graph_config = renodx::debug::graph::DrawStart(uv, color_untonemapped, w, h, RENODX_DIFFUSE_WHITE_NITS);
// #endif

    // ToneMapPass
    result = renodx::draw::ToneMapPass(color_untonemapped, color_sdr_graded, color_sdr_neutral);

// #ifdef IS_DEBUG_GRAPH
//     // graph end
//     result = renodx::debug::graph::DrawEnd(result, graph_config);
// #endif

  } else {
    result = saturate(colorTonemapped);
  }

  // result = renodx::color::srgb::Decode(result);  // 100000% srgb

  result = renodx::draw::RenderIntermediatePass(result);
  // result = renodx::color::gamma::Encode(result);
  return result;
}

float3 SunPass(in float3 color, in sampler2D tex, in float2 uv, in float strength) {
  if (RENODX_TONE_MAP_TYPE == 0) return color;

  // boost
  float3 colorO = color;
  // color = renodx::color::grade::Contrast(color, 1.9, .5);
  color *= CUSTOM_SUNGLARE;
  // color = renodx::color::grade::Saturation(color, 1.5);

  // sun
  if (CUSTOM_SUNSIZE > 0) {
    float3 colorCenter = tex2D(tex, (float2)0.5f);
    float dist = distance((float2)0.5f, uv);
    if (dist < CUSTOM_SUNSIZE && strength > 0.75f) {
      float y = renodx::color::y::from::BT709(colorO);
      if (y > 0.8) {
        float yCenter = renodx::color::y::from::BT709(colorCenter);
        color = renodx::color::correct::Luminance(colorCenter * 2, yCenter, y * 2, 1);
      }
    }
  }

  return color;
}
