#include "../shared.h"
#include "./drawbinary.hlsl"

#define SDR_NORMALIZATION_MAX 32768.0 //1 / 3.05175781e-005
#define RENODX_TONE_MAP_TYPE_IS_ON RENODX_TONE_MAP_TYPE > 0
#define TONEMAP_START_FLAT 5

// void Tonemap_Compressor(inout color) {
//   //y
//   float y = renodx::color::
// }

// void F(inout float4 color) {
//   saturate(color);
// }

// void F(inout float3 color) {
//   saturate(color);
// }

// void F(inout float2 color) {
//   saturate(color);
// }

// void F(inout float color) {
//   saturate(color);
// }

#define RHSC_E (50.f/41.f)
float3 ReinhardScalableCached(float3 x) {
  return (x * RHSC_E) / (x * RHSC_E + 1.f);
}

// float3 ReinhardScalableFaster(float3 x, in float exp = RHSC_E) {
//   return (x * exp) / (x * exp + 1.f);
// }

float Sum3(in float3 v) {
  return (v.x + v.y + v.z);
}


#define MINIMUM_Y 0.000001f
float3 Tonemap_Do(in float3 colorUntonemapped, /* in float3 colorSDRNeutral, */ in float3 colorTonemapped, in float2 uv, in Texture2D<float4> texColor) {
  //decode
  colorTonemapped = max((float3)0, colorTonemapped);
  colorTonemapped = renodx::color::srgb::Decode(colorTonemapped);

  if (RENODX_TONE_MAP_TYPE_IS_ON) {
    //sum of colorTonemapped (save blacks)
    // const float sumTonemapped = Sum3(colorTonemapped);

    //decode
    colorUntonemapped = max((float3)0, colorUntonemapped);
    
    // colorSDRNeutral = max((float3)0, colorSDRNeutral);
    // colorSDRNeutral = renodx::color::gamma::Decode(colorSDRNeutral);

    //colorSDRNeutral prepare
    float3 colorSDRNeutral; 
    {
        //use colorUntonemapped
        colorSDRNeutral = colorUntonemapped;

        //apply preexposure
        colorSDRNeutral *= CUSTOM_PREEXPOSURE;

        //apply min (save blacks)
        // if (sumTonemapped >= MINIMUM_Y) colorSDRNeutral = max(colorSDRNeutral, (float3)MINIMUM_Y);

        //contrast
        colorSDRNeutral = CUSTOM_PREEXPOSURE_CONTRAST == 0 ? colorSDRNeutral : renodx::color::grade::Contrast(colorSDRNeutral, CUSTOM_PREEXPOSURE_CONTRAST, CUSTOM_PREEXPOSURE_CONTRAST_MID);

        //Reinhard
        colorSDRNeutral = ReinhardScalableCached(colorSDRNeutral);

        // CUSTOM_GRADE_LUMA
         colorSDRNeutral = lerp(colorTonemapped, colorSDRNeutral, CUSTOM_GRADE_LUMA);
        // colorSDRNeutral = CUSTOM_GRADE_LUMA < 0 ? renodx::color::correct::Luminance(colorSDRNeutral, colorTonemapped, 1 - CUSTOM_GRADE_LUMA) : colorSDRNeutral;

    }

    //colorTonemapped prepare
    {
      //map chroma of colorSDRNeutral to colorTonemapped
      if (CUSTOM_GRADE_CHROMA < 1) colorTonemapped = renodx::tonemap::UpgradeToneMap(colorTonemapped, colorUntonemapped, colorUntonemapped, 1-CUSTOM_GRADE_CHROMA, 0); //a bit inverted, but its ok
    }

    //colorUntonemapped prepare
    {
      //apply preexposure
      colorUntonemapped *= CUSTOM_PREEXPOSURE * CUSTOM_PREEXPOSURE_RATIO;

      // contrast
      colorUntonemapped = CUSTOM_PREEXPOSURE_CONTRAST == 0 ? colorUntonemapped : renodx::color::grade::Contrast(colorUntonemapped, CUSTOM_PREEXPOSURE_CONTRAST, CUSTOM_PREEXPOSURE_CONTRAST_MID);

      //dice
      // colorUntonemapped = renodx::tonemap::dice::BT709(colorUntonemapped, 100000);

      //apply min (save blacks)
      // if (sumTonemapped >= MINIMUM_Y) colorUntonemapped = max(colorUntonemapped, (float3)MINIMUM_Y);
    }
    
    //ToneMapPass()
    {
      // [branch]
      // if (CUSTOM_TONEMAP_DEBUG <= 1.f) {
        renodx::draw::Config config = renodx::draw::BuildConfig();
        colorTonemapped = renodx::draw::ToneMapPass(colorUntonemapped, colorTonemapped, colorSDRNeutral, config);
      // }
      // else if (CUSTOM_TONEMAP_DEBUG == 2.f) {
      //   [flatten]
      //   if (uv.x < 1/3.f) {
      //     colorTonemapped = colorUntonemapped;
      //   } else if (uv.x < 2/3.f) {
      //     colorTonemapped = colorSDRNeutral;
      //   } else {
      //     colorTonemapped = colorTonemapped;
      //   }
      // }
    }

    //film grain
    {
      colorTonemapped = CUSTOM_FILMGRAIN_RENO > 0 ? renodx::effects::ApplyFilmGrainColored(colorTonemapped, uv, SEED, CUSTOM_FILMGRAIN_RENO) : colorTonemapped;
    }
  }

  //RenderIntermediatePass
  colorTonemapped = renodx::draw::RenderIntermediatePass(colorTonemapped);

  return colorTonemapped;
}

// static renodx::debug::graph::Config graph_config; //no warning of unused var if out here
float3 Final_Do(in float3 color, in float2 uv, in Texture2D<float4> texColor) {
  //decode
  color = max((float3)0, color);
  color = renodx::color::srgb::Decode(color); //100000% srgb

  if (RENODX_TONE_MAP_TYPE_IS_ON)
  {    
    //graph start
    // if (CUSTOM_TONEMAP_DEBUG == 1.f) graph_config = renodx::debug::graph::DrawStart(uv, color, texColor, RENODX_PEAK_WHITE_NITS, RENODX_DIFFUSE_WHITE_NITS);

    renodx::draw::Config draw_config = renodx::draw::BuildConfig();
    renodx::tonemap::Config tone_map_config = renodx::tonemap::config::Create();
    {
      tone_map_config.peak_nits = draw_config.peak_white_nits;
      tone_map_config.game_nits = draw_config.diffuse_white_nits;
      tone_map_config.type = min(draw_config.tone_map_type, 3);
      tone_map_config.gamma_correction = draw_config.gamma_correction;
      tone_map_config.exposure = draw_config.tone_map_exposure;
      tone_map_config.highlights = draw_config.tone_map_highlights;
      tone_map_config.shadows = draw_config.tone_map_shadows;
      tone_map_config.contrast = draw_config.tone_map_contrast;
      tone_map_config.saturation = draw_config.tone_map_saturation;

      tone_map_config.reno_drt_highlights = 1.0f;
      tone_map_config.reno_drt_shadows = 1.0f;
      tone_map_config.reno_drt_contrast = 1.0f;
      tone_map_config.reno_drt_saturation = 1.0f;
      tone_map_config.reno_drt_blowout = -1.f * (draw_config.tone_map_highlight_saturation - 1.f);
      tone_map_config.reno_drt_dechroma = draw_config.tone_map_blowout;
      tone_map_config.reno_drt_flare = 0.10f * pow(draw_config.tone_map_flare, 10.f);
      tone_map_config.reno_drt_working_color_space = draw_config.tone_map_working_color_space;
      tone_map_config.reno_drt_per_channel = draw_config.tone_map_per_channel == 1.f;
      tone_map_config.reno_drt_hue_correction_method = draw_config.tone_map_hue_processor;
      tone_map_config.reno_drt_clamp_color_space = draw_config.tone_map_clamp_color_space;
      tone_map_config.reno_drt_clamp_peak = draw_config.tone_map_clamp_peak;
      tone_map_config.reno_drt_tone_map_method = draw_config.reno_drt_tone_map_method;
      tone_map_config.reno_drt_white_clip = draw_config.reno_drt_white_clip;
    }
    color = renodx::tonemap::config::Apply(color, tone_map_config);

    //graph end
    // if (CUSTOM_TONEMAP_DEBUG == 1.f) color = renodx::debug::graph::DrawEnd(color, graph_config);
  }

  color = renodx::draw::RenderIntermediatePass(color);

  return color;
}