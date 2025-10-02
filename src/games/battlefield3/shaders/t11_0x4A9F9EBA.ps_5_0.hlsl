// ---- Created with 3Dmigoto v1.3.16 on Tue Sep 30 09:40:17 2025
#include "./common.hlsl"

cbuffer _Globals : register(b0)
{
  float2 invPixelSize : packoffset(c0);
  float4 depthFactors : packoffset(c1);
  float2 fadeParams : packoffset(c2);
  float4 color : packoffset(c3);
  float4 colorMatrix0 : packoffset(c4);
  float4 colorMatrix1 : packoffset(c5);
  float4 colorMatrix2 : packoffset(c6);
  float exponent : packoffset(c7);
  float4 combineTextureWeights[2] : packoffset(c8);
  float4 colorScale : packoffset(c10);
  float2 invTexelSize : packoffset(c11);
  float4 downsampleQuarterZOffset : packoffset(c12);
  int sampleCount : packoffset(c13);
  float filterWidth : packoffset(c13.y);
  float mipLevelSource : packoffset(c13.z);
  float4 radialBlurScales : packoffset(c14);
  float2 radialBlurCenter : packoffset(c15);
  float4 poissonRadialBlurConstants : packoffset(c16);
  float blendFactor : packoffset(c17);
  float3 filmGrainColorScale : packoffset(c17.y);
  float4 filmGrainTextureScaleAndOffset : packoffset(c18);
  float3 depthScaleFactors : packoffset(c19);
  float4 dofParams : packoffset(c20);
  float3 bloomScale : packoffset(c21);
  float3 invGamma : packoffset(c22);
  float3 luminanceVector : packoffset(c23);
  float3 vignetteParams : packoffset(c24);
  float4 vignetteColor : packoffset(c25);
  float4 chromostereopsisParams : packoffset(c26);
}

SamplerState mainTexture_s : register(s0);
SamplerState tonemapBloomTexture_s : register(s1);
SamplerState filmGrainTexture_s : register(s2);
SamplerState colorGradingTexture_s : register(s3);
Texture2D<float4> mainTexture : register(t0);
Texture2D<float4> tonemapBloomTexture : register(t1);
Texture3D<float4> colorGradingTexture : register(t2);
Texture2D<float4> filmGrainTexture : register(t3);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float2 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;
  float3 colorU /*, colorN*/;

  r0.xyz = mainTexture.Sample(mainTexture_s, v2.xy).xyz;
  r1.xyz = tonemapBloomTexture.Sample(tonemapBloomTexture_s, v2.xy).xyz;
  r0.xyz = r1.xyz * bloomScale.xyz * CUSTOM_BLOOM + r0.xyz;

  r0.xyz = r0.xyz * colorScale.xyz + float3(-0.00400000019,-0.00400000019,-0.00400000019);
  r0.xyz = max(float3(0, 0, 0), r0.xyz);
  colorU = r0.xyz;

  r1.xyz = r0.xyz * float3(6.19999981,6.19999981,6.19999981) + float3(0.5,0.5,0.5);
  r1.xyz = r1.xyz * r0.xyz;
  r2.xyz = r0.xyz * float3(6.19999981,6.19999981,6.19999981) + float3(1.70000005,1.70000005,1.70000005);
  r0.xyz = r0.xyz * r2.xyz + float3(0.0599999987,0.0599999987,0.0599999987);
  r0.xyz = r1.xyz / r0.xyz;

  r0.xyz = r0.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
  r0.xyz = colorGradingTexture.Sample(colorGradingTexture_s, r0.xyz).xyz;

  r1.xy = float2(-0.5,-0.5) + v2.xy;
  r1.xy = vignetteParams.xy * r1.xy;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = log2(r0.w);
  r0.w = vignetteParams.z * r0.w;
  r0.w = exp2(r0.w);
  r0.w = vignetteColor.w * r0.w;
  r1.xyz = float3(-1,-1,-1) + vignetteColor.xyz;
  r1.xyz = (r0.w * CUSTOM_VIGNETTE) * r1.xyz + float3(1,1,1);

  r2.xy = v2.xy * filmGrainTextureScaleAndOffset.xy + filmGrainTextureScaleAndOffset.zw;
  r0.w = filmGrainTexture.Sample(filmGrainTexture_s, r2.xy).x;
  r0.w = -0.5 + r0.w;
  r2.xyz = filmGrainColorScale.xyz * (r0.w * CUSTOM_FILMGRAIN);

  r0.xyz = r0.xyz * r1.xyz + r2.xyz;
  colorU = colorU * r1.xyz + r2.xyz;  

  o0.w = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
  
  o0.xyz = r0.xyz;
  o0.xyz = Tonemap_Do(colorU, /*colorN, */o0.xyz, v2.xy, mainTexture);
  return;
}