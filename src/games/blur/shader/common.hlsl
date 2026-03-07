#include "../shared.h"

//(From Luma)
// Returns the mathematical chrominance (it's more like saturation, not necessarily perceptual)
// Note: the result might depend on the color space
float GetChrominance(float3 color)
{
    float maxVal = renodx::math::Max(color);
    float minVal = renodx::math::Min(color);
    float chrominance = (maxVal - minVal) / maxVal;
    return (maxVal == 0.0) ? 0.0 : chrominance;
}
float3 SetChrominance(float3 color, float chrominance)
{
    float maxVal = renodx::math::Max(color);
    float minVal = renodx::math::Min(color);
    float midVal = lerp(minVal, maxVal, 0.5);
    return lerp(midVal, color, chrominance);
}
float GetMidValue(float3 x)
{
    return x.x + x.y + x.z - (renodx::math::Min(x) + renodx::math::Max(x));
}
float InverseLerp(float a, float b, float value) //bruh, where is this in RenoDX? :cry:
{
  return a == b ? 0 : (value - a) / (b - a);
}
float3 CorrectPerChannelTonemapHiglightsDesaturationBo3(float3 color, float peakBrightness, float desaturationExponent = 2.0, float highlightsOnly = 2)
{
  float sourceChrominance = GetChrominance(color);

  float maxBrightness = renodx::math::Max(color);
  float midBrightness = GetMidValue(color);
	float minBrightness = renodx::math::Min(color);
	float brightnessRatio = saturate(maxBrightness / peakBrightness);

  brightnessRatio = lerp(brightnessRatio, sqrt(brightnessRatio), sqrt(saturate(InverseLerp(minBrightness, maxBrightness, midBrightness))));
  brightnessRatio = pow(brightnessRatio, highlightsOnly); // skewed towards highlights only

  float chrominancePow = lerp(1.0, 1.0 / desaturationExponent, brightnessRatio);

  float targetChrominance = sourceChrominance > 1.0 ? pow(sourceChrominance, chrominancePow) : (1.0 - pow(1.0 - sourceChrominance, chrominancePow));
  float chrominanceRatio = renodx::math::DivideSafe(targetChrominance, sourceChrominance, 1);

  float3 o = renodx::color::correct::Luminance(SetChrominance(color, chrominanceRatio), color, 1);
  // o = renodx::color::correct::HueOKLab(o, color, 1); //Not noticable
  return o;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

float T_ChromaticAberrationAndOverlay(inout float4 x, float4 g_vColourSep, sampler2D colourTexture, sampler2D overlayTexture, sampler2D filmGrainTexture, inout float2 texcoord) {
  float multiplier = 1.0;

  // glitch fx
  g_vColourSep.y = abs(g_vColourSep.y);
  if (C_GLITCH > 0 && g_vColourSep.y > 0) {
    const float divX = 52;
    const float divY = 42;
    const float divXFloor = floor(texcoord.x * divX);
    const float divYFloor = floor(texcoord.y * divY);
    const float divXFloorNorm = divXFloor / divX;
    const float divYFloorNorm = divYFloor / divY;

    float2 texcoordChunky = float2(divXFloorNorm, divYFloorNorm);

    float rand = renodx::random::Generate(texcoordChunky + RENODX_SEED);
    rand *= rand;

    g_vColourSep.y *= 3.46;
    g_vColourSep.y = pow(g_vColourSep.y, 4);
    
    if (rand < g_vColourSep.y * 0.75) {
      float dir = divYFloor % 2 == 0 ? -1 : 1;
      texcoord.x = texcoord.x + (dir * (/* sqrt */(/* saturate */(g_vColourSep.y)) * (1/divX) * 4));
    }

    if (rand < g_vColourSep.y * 0.1) {
      texcoord.x = 1 - texcoord.x;
      multiplier = 0.5;
    }
  }

	x = tex2D(colourTexture, texcoord);

  // samples
  if (g_vColourSep.x > 0) {
    //sep
    float sep = g_vColourSep.x * 1.5 * C_CA;
    float s0 = tex2D(colourTexture, sep * -float2(1, 0) + texcoord).x;
    float s1 = tex2D(colourTexture, sep *  float2(1, 0) + texcoord).z;

    //combine
    x.x = s0;
    x.y = x.y;
    x.z = s1;
  }

  // overlay
  if (g_vColourSep.z > 0) {
    float4 overlay = tex2D(overlayTexture, texcoord);
    x.xyz += g_vColourSep.z / EXPOSURE_REVERSAL * overlay.xyz;
    x.xyz = max(x.xyz, 0);
  }

  return multiplier;
}

void T_MotionBlur(inout float4 x, sampler2D motionBlurTexture, float2 texcoord) {
  float4 r1;
  r1 = tex2D(motionBlurTexture, texcoord);
  r1.xyz *= EXPOSURE_REVERSAL;

  float yU = renodx::color::y::from::BT709(x.xyz);
  // float yMb = renodx::color::y::from::BT709(r1.xyz);

  float a = /* r1.w */ /* sqrt(r1.w) */ pow(r1.w, rcp(3.4 * C_MB_LENIENCE)); //distance, close only
  float b = pow(yU, max(0.5, 5.0 - C_MB_LENIENCE)); //luminance
  float c = max(a, b);
  c = saturate(c);
  c *= C_MB_BLEND;
  x.xyz = lerp(x.xyz, r1.xyz, c);
}

void T_Lens(inout float4 x, sampler2D lensEffectsTexture, float2 texcoord) {
  float4 r1 = tex2D(lensEffectsTexture, texcoord);

  // r1.xyz *= 3.46;
  // r1.xyz = renodx::tonemap::Reinhard(r1.xyz, 4);

  // r1.xyz *= EXPOSURE_REVERSAL;
  r1.xyz = renodx::tonemap::ExponentialRollOff(r1.xyz, 1.25, 2.2); //can add up to max and cause errors.
  
  // x.xyz = x.xyz * r1.w + r1.xyz; //orig
  x.xyz += r1.xyz;
}

void T_Bloom(inout float4 x, sampler2D bloomTexture, float2 texcoord) {
  #if 1 
    //highlights
    {
      float y = renodx::color::y::from::BT709(x.xyz);
      if (y > 0) {
        float y1 = y;
        y1 = renodx::color::grade::Highlights(y1, 1.25 * C_CG_HIGHLIGHTS, 0.875 * C_CG_HIGHLIGHTS_MID);
        x.xyz *= y1 / y;
      }
    }

    float4 r1 = tex2D(bloomTexture, texcoord);
    // r1 = max(0, r1);
    
    r1.xyz = /* renodx::color::grade::Saturation */SetChrominance(r1.xyz, C_BLOOM_SAT);
    r1.xyz = max(0, r1.xyz);

    r1.xyz = r1.xyz * r1.xyz; // gamma 2
    // r1.xyz = pow(r1.xyz, 2.2);
    // r1.xyz = renodx::color::srgb::Decode(r1.xyz);

    x.xyz *= x.xyz; // gamma 2
    // x.xyz = pow(x.xyz, 2.2);
    // x.xyz = renodx::color::srgb::Decode(x.xyz);

    x.xyz += r1.xyz;  // add

#else
  x.xyz *= x.xyz;
#endif

    // x.xyz = sqrt(x.xyz); //encode 2
}

//https://github.com/Filoppi/Luma-Framework/blob/main/Shaders/Includes/ColorGradingLUT.hlsl
// Restores the source color hue (and optionally brightness) through Oklab (this works on colors beyond SDR in brightness and gamut too).
// The strength sweet spot for a strong hue restoration seems to be 0.75, while for chrominance, going up to 1 is ok.
float3 RestoreHueAndChrominance(float3 targetColor, float3 sourceColor, float hueStrength = 1.0, float chrominanceStrength = 1.0, float lightnessStrength = 0.0, float saturation = 1.0)
{
  const static float minChrominanceChange = 0;
  const static float maxChrominanceChange = 999999;
  
  // Invalid or black colors fail oklab conversions or ab blending so early out
  if (renodx::color::y::from::BT709(targetColor) <= 0)
    return targetColor; // Optionally we could blend the target towards the source, or towards black, but there's no need until proven otherwise

	const float3 sourceUcsLab = renodx::color::oklab::from::BT709(sourceColor);
	float3 targetUcsLab = renodx::color::oklab::from::BT709(targetColor);
   
  targetUcsLab.x = lerp(targetUcsLab.x, sourceUcsLab.x, lightnessStrength);
  
	float currentChrominance = length(targetUcsLab.yz);

  if (hueStrength != 0.0)
  {
    // First correct both hue and chrominance at the same time (oklab a and b determine both, they are the color xy coordinates basically).
    // As long as we don't restore the hue to a 100% (which should be avoided?), this will always work perfectly even if the source color is pure white (or black, any "hueless" and "chromaless" color).
    // This method also works on white source colors because the center of the oklab ab diagram is a "white hue", thus we'd simply blend towards white (but never flipping beyond it (e.g. from positive to negative coordinates)),
    // and then restore the original chrominance later (white still conserving the original hue direction, so likely spitting out the same color as the original, or one very close to it).
    const float chrominancePre = currentChrominance;
    targetUcsLab.yz = lerp(targetUcsLab.yz, sourceUcsLab.yz, hueStrength);
    const float chrominancePost = length(targetUcsLab.yz);
    // Then restore chrominance to the original one
    float chrominanceRatio = renodx::math::SafeDivision(chrominancePre, chrominancePost, 1);
    targetUcsLab.yz *= chrominanceRatio;
    //currentChrominance = chrominancePre; // Redundant
  }

  if (chrominanceStrength != 0.0)
  {
    const float sourceChrominance = length(sourceUcsLab.yz);
    // Scale original chroma vector from 1.0 to ratio of target to new chroma
    // Note that this might either reduce or increase the chroma.
    float targetChrominanceRatio = renodx::math::SafeDivision(sourceChrominance, currentChrominance, 1);
    // Optional safe boundaries (0.333x to 2x is a decent range)
    targetChrominanceRatio = clamp(targetChrominanceRatio, minChrominanceChange, maxChrominanceChange);
    targetUcsLab.yz *= lerp(1.0, targetChrominanceRatio, chrominanceStrength);
  }

  //Saturation
  targetUcsLab.yz *= saturation;

	return renodx::color::bt709::from::OkLab(targetUcsLab);
}

void T_LutGamma(inout float4 x, sampler3D lookupTexture, float4 g_vSettings1, float4x4 g_mColour, float2 uv = float2(0,0)) {
  float3 colorU = x.xyz;

  colorU = sqrt(colorU); 
  float3 colorBak = colorU;
  // colorU = renodx::color::correct::HueICtCp(colorU, renodx::tonemap::Reinhard(colorU, 1));
  // colorU = renodx::color::correct::HueOKLab(colorU, min(colorU, 0.1));
  // colorU = renodx::color::correct::ChrominanceICtCp(colorU, colorBak);
  // colorU = RestoreHueAndChrominance(colorU, renodx::tonemap::Reinhard(colorU, 1)/* saturate(colorU) */, 1, 0.5, 0, 1.);
  // colorU = max(0, colorU);

  // colorU *= colorU;
  float3 colorN = colorU;
  {
    // float y = renodx::color::y::from::BT709(colorN);
    float y = max(colorN.x, max(colorN.y, colorN.z));
    if (y <= 0) return; //RETURN: black pixel
    float y1 = renodx::tonemap::ReinhardPiecewise(y, 2., 0.36);
    // float y1 = renodx::color::pq::Encode(y / 203);
    // float y1 = renodx::tonemap::Reinhard(y);
    colorN *= y1 / y;
    // colorN = max(0, colorN);

    float m = max(max(colorN.x, colorN.y), colorN.z);
    if (m > 1) colorN /= m;
    colorN = saturate(colorN);

    // colorN = pow(colorN, 1/(2.4 + C_GAMMAOFFSET));
  }
  // colorU *= colorU;
  // colorN *= colorN;

  float3 colorT = colorN;
  {
    colorT = CorrectPerChannelTonemapHiglightsDesaturationBo3(colorT, 1, C_LUT_HIGHLIGHTSAT, 6);
    {
      colorT = max(0, colorT);
      float m = max(max(colorT.x, colorT.y), colorT.z);
      if (m > 1) colorT *= 1 / m;
    }
    
    // float m = max(max(colorT.x, colorT.y), colorT.z);
    // if (m > 1) colorT /= m;

    colorT *= colorT;
    colorT = pow(colorT, 1/2.4 /* g_vSettings1.y */);

    // if (renodx::math::Max(colorT) > 1) colorT = 0;
    colorT = tex3Dlod(lookupTexture, float4(colorT * 0.96875 + 0.015625, 0)).xyz;

    colorU *= colorU;
    colorN *= colorN;
    {
      // if (uv.x < 0.5) {
        // colorU = pow(colorU, 1/(1.65 + C_GAMMAOFFSET));
        // colorU *= 1.36;
      // } else {
        float y = renodx::color::y::from::BT709(colorU); //This helps maintain chroma from inncrease chroma
        float y1 = pow(y, 1 / (1.7 + C_GAMMAOFFSET));
        colorU *= y1 * (1.36 - (C_GAMMAOFFSET * 0.125))/ y;
      // }

      // colorN *= c;
      // colorN = pow(colorN, 1/2.);
      colorN = pow(colorN, 1/2.4);
    }

    // float3 tinted = mul(g_mColour, colorT).xyz;  // bruh. and the decompiler pooped on this.
    // colorT = lerp(colorT, tinted, C_TINT);
  }

  // x.xyz = renodx::color::srgb::Encode(x.xyz);
  // colorU *= 1.46;

  x.xyz = renodx::tonemap::UpgradeToneMap(colorU, colorN, colorT, C_LUT, 0);

  // if (uv.x < 1/4.) x.xyz = colorU;
  // else if (uv.x < 2/4.) x.xyz = colorN;
  // else if (uv.x < 3/4.) x.xyz = colorT;
}

void T_ColorTint(inout float4 x, float4x4 g_mColour) {
  // float3 r1, r2;
  // r1.xyz = x.y * g_mColour[1].xyz;
  // r2.xyz = x.x * g_mColour[0].xyz + r1.xyz;
  // r2.xyz = x.z * g_mColour[2].xyz + r2.xyz;
  // r2.xyz = r2.xyz + g_mColour[3].xyz;
  // x.xyz = r2.xyz;

  float3 tinted = mul(g_mColour, float4(x/* .xyz, 1 */)).xyz;  // bruh. and the decompiler pooped on this.
  tinted = max(0, tinted); //clamp out of bounds
  x.xyz = lerp(x.xyz, tinted, C_TINT);
}

void T_FilmGrain(inout float4 x, sampler2D filmGrainTexture, float4 g_vFilmGrain, float4 g_vSettings2, float2 texcoord) {
  // x.w = dot(x.xyz, g_vFilmGrain.xyz);
  // x.w = -x.w + g_vFilmGrain.w;
  // float4 r1;
  // r1.xyz = x.xyz * x.w + g_vSettings2.z;
  // float4 r2;
  // r2.xy = g_vSettings2.xy;
  // r2.xy = texcoord.xy * r2.xy + g_vFilmGrain.z;
  // r2 = tex2D(filmGrainTexture, r2);
  // r2.xyz = r2.xyz + -0.5;
  // x.xyz = r2.xyz * r1.xyz + x.xyz;

  float s = g_vFilmGrain.z * 2 * C_FILMGRAIN;
  s += (C_FILMGRAIN * 0.005);
  x.xyz = renodx::effects::ApplyFilmGrain(x.xyz, texcoord, RENODX_SEED, s, 2.);
}

void T_Vignette(inout float4 x, float2 texcoord, float4 g_vSpecialFX) {
  float4 r1;

//   r1.xy = -0.5 + texcoord.xy;
//   r1.x = (r1.x * r1.x) + (r1.y * r1.y); r1.x = 1 - r1.x;
//   float score = r1.x;
//   r1.x = saturate(r1.x * g_vSpecialFX.x);
// 
//   // x.w = dot(x.xyz, float3(0.195, 0.3835, 0.0715));
//   // x.w = renodx::tonemap::Reinhard(x.w);
//   // x.w = saturate(x.w);
// 
//   x.w = renodx::math::SafePow(score, 1.5);
// 
//   x.w = -x.w * r1.x + r1.x;
//   x.w = x.w + 1;
// 
  float2 d = texcoord - 0.5;
  float r2 = dot(d, d);
  float vignette = r2 * g_vSpecialFX.x;
  float luminance = dot(x.xyz, float3(0.195, 0.3835, 0.0715));
  luminance = renodx::tonemap::Reinhard(luminance);
  float finalScale = 1.0 + g_vSpecialFX.x * (1.0 - luminance);
  // x.w = finalScale;

  x.w = (d.x * d.x) + (d.y * d.y);
  x.w = pow(x.w, 1.46);
  x.w = 1 - x.w;

  x.w = lerp(1, x.w, C_VIGNETTE); //user
  x.xyz = x.xyz * x.w;
}

float4 T_Output(float4 x, float4 g_vSettings1, sampler2D colourTexture) {
  // x.xyz = renodx::color::srgb::Decode(x.xyz);
  x.xyz = pow(x.xyz, /* 2.4 */ 1 / g_vSettings1.y + 0.1);

  //cg
  {
    float y = renodx::color::y::from::BT709(x.xyz);
    if (y > 0) {
      float y1 = y;
      y1 = renodx::color::grade::Shadows(y1, C_CG_SHADOWS, 0.485 * C_CG_SHADOWS_MID, 3);
      // y1 = renodx::color::grade::Highlights(y1, /* 1.2 * */ C_CG_HIGHLIGHTS, 0.75 * C_CG_HIGHLIGHTS_MID);
      x.xyz *= y1 / y;
    }
  }

  x.xyz *= (RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS);

  x.xyz = renodx::color::srgb::Encode(x.xyz);
  // x.xyz = pow(x.xyz, 1/2.2);

  return float4(x.xyz, 1);
}

// AdvancedAutoHDR pass to generate some HDR brightess out of an SDR signal.
// This is hue conserving and only really affects highlights.
// "SDRColor" is meant to be in "SDR range" (linear), as in, a value of 1 matching SDR white (something between 80, 100, 203, 300 nits, or whatever else)
// This function already knows your Luma peak white nits setting, so actually pass in the max value for paper white 80 (e.g. 400-750, beyond that it looks bad)
// https://github.com/Filoppi/PumboAutoHDR
float3 PumboAutoHDR(float3 SDRColor, float MaxPeakWhiteNits, float _PaperWhiteNits, float ShoulderPow = 2.75f, float SaturationExpansionIntensity = 0.2f) // TODO: default "SaturationExpansionIntensity"?
{
#if 1 // This might disproportionally brighten up pure colors
	float SDRRatio = max(SDRColor.x, max(SDRColor.y, SDRColor.z));
#elif 0
	float SDRRatio = average(SDRColor);
#else // This nearly ignores blue!
	float SDRRatio = max(GetLuminance(SDRColor), 0.f);
#endif
	// Limit AutoHDR brightness, it won't look good beyond a certain level.
	// The paper white multiplier is applied later so we account for that.
	float AutoHDRMaxWhite = max(min(MaxPeakWhiteNits / 80., RENODX_EXPECTED_PEAK_WHITE_NITS / _PaperWhiteNits), 1.f);

	float AutoHDRExtraRatio = pow(saturate(SDRRatio), ShoulderPow) * (AutoHDRMaxWhite - 1.f);
	float AutoHDRTotalRatio = SDRRatio + AutoHDRExtraRatio;
  float SingleColorScale = renodx::math::SafeDivision(AutoHDRTotalRatio, SDRRatio, 1);
  
  // Calculate it again but with "per channel", which would expand gamut (not hue conservative)
  float3 SDRRatio3 = SDRColor;
	float3 AutoHDRExtraRatio3 = pow(saturate(SDRRatio3), ShoulderPow) * (AutoHDRMaxWhite - 1.f);
	float3 AutoHDRTotalRatio3 = SDRRatio3 + AutoHDRExtraRatio3;
  float3 PerChannelColorScale = renodx::math::SafeDivision(AutoHDRTotalRatio3, SDRRatio3, 1);

	return SDRColor * lerp(SingleColorScale, PerChannelColorScale, SaturationExpansionIntensity);
}