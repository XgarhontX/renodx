#include "../shared.h"

#define SDR_NORMALIZATION_MAX 32768.0 //1 / 3.05175781e-005

#define RHSC_E (50.f/41.f)
float3 ReinhardScalableCached(float3 x) {
  return (x * RHSC_E) / (x * RHSC_E + 1.f);
}

// //https://github.com/ronja-tutorials/ShaderTutorials/blob/master/Assets/047_InverseInterpolationAndRemap/Interpolation.cginc
// float invLerp(float from, float to, float value) {
//   return (value - from) / (to - from);
// }
// float3 invLerp(float3 from, float3 to, float3 value) {
//   return (value - from) / (to - from);
// }
// float remap(float origFrom, float origTo, float targetFrom, float targetTo, float value){
//   float rel = invLerp(origFrom, origTo, value);
//   return lerp(targetFrom, targetTo, rel);
// }
// float3 remap(float3 origFrom, float3 origTo, float3 targetFrom, float3 targetTo, float3 value){
//   float3 rel = invLerp(origFrom, origTo, value);
//   return lerp(targetFrom, targetTo, rel);
// }


float Sum3(in float3 v) {
  return (v.x + v.y + v.z);
}

float Avg3(in float3 v) {
  return Sum3(v) / 3.f;
}

float3 Bloom_Composite(float3 colorU, float3 bloomMask) {

}


#define MINIMUM_Y 0.000001f
// static renodx::debug::graph::Config graph_config; //no warning of unused var if out here
/*
* in: linear untonemapped & tonemapped
* out: scaled tradeoff color space normalized up to SDR_NORMALIZATION_MAX
*/
float3 Tonemap_Do(float3 colorUntonemapped, float3 colorTonemapped, float2 uv, Texture2D<float4> texColor) {
  float3 result;

  //colorTonemapped clean
  // colorTonemapped = max(colorTonemapped, float3(0,0,0));
  colorTonemapped = saturate(colorTonemapped);  

  //ToneMapPass
  if (RENODX_TONE_MAP_TYPE != 0) {
    // //colorUntonemapped clean
    colorUntonemapped = max(colorUntonemapped, float3(0,0,0));
    
    //CUSTOM_GRADE_LUMA, colorSDRNeutral prepare (The actual before-lut color is so messed up that it is way better to do this.)
    float3 colorSDRNeutral;
    if (CUSTOM_GRADE_LUMA > 0)
    {
      colorSDRNeutral = colorUntonemapped;
      colorSDRNeutral *= CUSTOM_PREEXPOSURE;

      //This helps preserve extreme highlights for UpgradeToneMap() that would be crushed if just doing saturate(colorSDRNeutral).
      colorSDRNeutral = ReinhardScalableCached(colorSDRNeutral);

      //CUSTOM_GRADE_LUMA
      colorSDRNeutral = lerp(colorTonemapped, colorSDRNeutral, CUSTOM_GRADE_LUMA);
    } else colorSDRNeutral = colorTonemapped;

    //CUSTOM_GRADE_CHROMA
    {
      //map chroma of colorSDRNeutral to colorTonemapped
      colorTonemapped = CUSTOM_GRADE_CHROMA < 1 ? 
        renodx::tonemap::UpgradeToneMap(colorTonemapped, colorUntonemapped, colorUntonemapped, 1-CUSTOM_GRADE_CHROMA, 0) :
        // renodx::color::correct::Hue(colorTonemapped, colorUntonemapped, 1-CUSTOM_GRADE_CHROMA) :
        colorTonemapped; 
    }

    //colorUntonemapped prepare
    {
      //apply preexposure
      colorUntonemapped *= CUSTOM_PREEXPOSURE * CUSTOM_PREEXPOSURE_RATIO;
    }
    
    //graph start
    // if (CUSTOM_TONEMAP_DEBUG == 1.f) graph_config = renodx::debug::graph::DrawStart(uv, colorUntonemapped, texColor, RENODX_PEAK_WHITE_NITS, RENODX_DIFFUSE_WHITE_NITS);
    
    //ToneMapPass
    {
      // if (CUSTOM_TONEMAP_DEBUG <= 1.f) {
        //config
        renodx::draw::Config config = renodx::draw::BuildConfig();
        // config.tone_map_highlight_saturation += 0.5f * 0.02f; 
        // config.tone_map_pass_autocorrection = 0;
        // config.per_channel_chrominance_correction = 1;

        //do
        result = renodx::draw::ToneMapPass(colorUntonemapped, colorTonemapped, colorSDRNeutral, config);

      // }
      // else if (CUSTOM_TONEMAP_DEBUG == 2.f) {
      //   if (uv.x < 1/3.f) {
      //     result = colorUntonemapped;
      //   } else if (uv.x < 2/3.f) {
      //     result = colorSDRNeutral;
      //   } else {
      //     result = colorTonemapped;
      //   }
      // }
    }

    // graph end
    //  if (CUSTOM_TONEMAP_DEBUG == 1.f) colorTonemapped = renodx::debug::graph::DrawEnd(colorTonemapped, graph_config);
  } else {
    result = saturate(colorTonemapped);
  }

  result = renodx::draw::RenderIntermediatePass(result);

  return result;
}