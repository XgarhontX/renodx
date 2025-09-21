#include "../shared.h"
// #define IS_DEBUG_GRAPH
// #define IS_DEBUG_DECODE

#define RHSC_E (50.f / 41.f)
float3 ReinhardScalableCached(float3 x) {
  return (x * RHSC_E) / (x * RHSC_E + 1.f);
}

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
#ifndef IS_DEBUG_DECODE
  colorTonemapped = renodx::color::srgb::Decode(colorTonemapped);  // 1000000000000000000% sure
#else
  if (uv.x < 0.5)
    colorTonemapped = renodx::color::srgb::Decode(colorTonemapped);
  else
    colorTonemapped = renodx::color::gamma::Decode(colorTonemapped);
#endif

  float3 result;
  if (RENODX_TONE_MAP_TYPE > 0) {
    // prep
    colorUntonemapped = renodx::color::srgb::Decode(colorUntonemapped);

    // chroma
    {
      // CUSTOM_GRADE_CHROMA
      colorTonemapped = CUSTOM_GRADE_CHROMA == 1.f ? colorTonemapped : renodx::tonemap::UpgradeToneMap(colorTonemapped, colorUntonemapped, colorUntonemapped, 1 - CUSTOM_GRADE_CHROMA, 0);

      // CUSTOM_WHITECLIP_LERP
      float3 colorSat = saturate(colorTonemapped);
      colorTonemapped = renodx::tonemap::UpgradeToneMap(colorSat, colorTonemapped, colorTonemapped, 1 - CUSTOM_WHITECLIP_LERP, 0);  // way better than Chrominance
    }

    // preexposure
    {
      float e = CUSTOM_PREEXPOSURE * CUSTOM_PREEXPOSURE_RATIO;
      // e = CUSTOM_PREEXPOSURE_NEW > 0 ? (e * rcp(exposure * 64.f) * log2(exposure * 50 + 1) * 2.f) : e;
      colorUntonemapped *= e;
    }

    // CUSTOM_PREEXPOSURE_CONTRAST
    colorUntonemapped = CUSTOM_PREEXPOSURE_CONTRAST != 0 ? renodx::color::grade::Contrast(colorUntonemapped, CUSTOM_PREEXPOSURE_CONTRAST /* , 0.18 */) : colorUntonemapped;

    // sdr neutral
    float3 colorSDRNeutral;
    {
      // CUSTOM_GRADE_LUMA
      colorSDRNeutral = colorUntonemapped;
      colorSDRNeutral = ReinhardScalableCached(colorSDRNeutral);
      colorSDRNeutral = lerp(colorTonemapped, colorSDRNeutral, CUSTOM_GRADE_LUMA);
    }

#ifdef IS_DEBUG_GRAPH
    // graph start
    float w = 2560 * uv.x;
    float h = 1440 * uv.y;
    // tex.GetDimesions(w, h);
    renodx::debug::graph::Config graph_config = renodx::debug::graph::DrawStart(uv, colorUntonemapped, w, h, RENODX_DIFFUSE_WHITE_NITS);
#endif

    // ToneMapPass
    renodx::draw::Config draw_config = renodx::draw::BuildConfig();
    // draw_config.color_grade_strength = CUSTOM_GRADE_CHROMA;
    // draw_config.reno_drt_white_clip = (1 - CUSTOM_GRADE_LUMA) * 100;
    result = renodx::draw::ToneMapPass(colorUntonemapped, colorTonemapped, colorSDRNeutral, draw_config);

#ifdef IS_DEBUG_GRAPH
    // graph end
    result = renodx::debug::graph::DrawEnd(result, graph_config);
#endif
  } else {
    result = saturate(colorTonemapped);
  }

  // RenderIntermediatePass
  result = renodx::draw::RenderIntermediatePass(result);

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
        // color = renodx::color::correct::Luminance(colorCenter, yCenter, 64, 1);
        color = colorCenter * 64;
      }
    }
  }

  return color;
}
