// ---- Created with 3Dmigoto v1.3.16 on Sun Nov 09 21:39:26 2025

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
  float4 ironsightsDofParams : packoffset(c8);
  uint4 mainTextureDimensions : packoffset(c9);
  float4 combineTextureWeights[2] : packoffset(c10);
  float4 colorScale : packoffset(c12);
  float2 invTexelSize : packoffset(c13);
  float4 downsampleQuarterZOffset : packoffset(c14);
  int sampleCount : packoffset(c15);
  float filterWidth : packoffset(c15.y);
  float mipLevelSource : packoffset(c15.z);
  float convolveSpecularPower : packoffset(c15.w);
  float convolveBlurRadius : packoffset(c16);
  int convolveSampleCount : packoffset(c16.y);
  float3 dofDepthScaleFactors : packoffset(c17);
  float4 radialBlurScales : packoffset(c18);
  float2 radialBlurCenter : packoffset(c19);
  float4 poissonRadialBlurConstants : packoffset(c20);
  float blendFactor : packoffset(c21);
  float3 filmGrainColorScale : packoffset(c21.y);
  float4 filmGrainTextureScaleAndOffset : packoffset(c22);
  float3 depthScaleFactors : packoffset(c23);
  float4 dofParams : packoffset(c24);
  float4 dofParams2 : packoffset(c25);
  float4 dofDebugParams : packoffset(c26);
  float3 bloomScale : packoffset(c27);
  float3 invGamma : packoffset(c28);
  float3 luminanceVector : packoffset(c29);
  float3 vignetteParams : packoffset(c30);
  float4 vignetteScaleAndOffset : packoffset(c31);
  float4 vignetteColor : packoffset(c32);
  float4 chromostereopsisParams : packoffset(c33);
  float4 distortionScaleOffset : packoffset(c34);
}

SamplerState mainTextureSampler_s : register(s0);
SamplerState tonemapBloomTextureSampler_s : register(s1);
Texture2D<float4> mainTexture : register(t0);
Texture2D<float4> tonemapBloomTexture : register(t1);


// 3Dmigoto declarations
#define cmp -
#include "./common.hlsl"


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float2 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = tonemapBloomTexture.Sample(tonemapBloomTextureSampler_s, v2.xy).xyz;
Tonemap_BloomScale(r0.xyz);
  r1.xy = float2(-0.5,-0.5) + v2.xy;
  r1.zw = r1.xy * chromostereopsisParams.yy + v2.xy;
  r1.xy = -r1.xy * chromostereopsisParams.yy + v2.xy;
  r0.w = mainTexture.Sample(mainTextureSampler_s, r1.xy).z;
  r1.x = mainTexture.Sample(mainTextureSampler_s, r1.zw).y;
  r1.yzw = mainTexture.Sample(mainTextureSampler_s, v2.xy).xyz;
  r1.x = r1.x + -r1.z;
  r1.z = chromostereopsisParams.x * r1.x + r1.z;
  r0.w = -r1.w + r0.w;
  r1.w = chromostereopsisParams.x * r0.w + r1.w;
  r0.xyz = r0.xyz * bloomScale.xyz + r1.yzw;
  r0.xyz = colorScale.xyz * r0.xyz;
  // r1.xy = v2.xy * vignetteScaleAndOffset.xy + vignetteScaleAndOffset.zw;
  // r0.w = dot(r1.xy, r1.xy);
  // r0.w = 1 + -r0.w;
  // r0.w = max(0, r0.w);
  // r0.w = log2(r0.w);
  // r0.w = vignetteParams.z * r0.w;
  // r0.w = exp2(r0.w);
  // r0.xyz = r0.xyz * r0.www 
r0.xyz = Tonemap_Vignette(r0.xyz, vignetteScaleAndOffset, vignetteParams, v2);
  // + float3(-0.00400000019,-0.00400000019,-0.00400000019);
  // r0.xyz = max(float3(0,0,0), r0.xyz);
  // r1.xyz = r0.xyz * float3(6.19999981,6.19999981,6.19999981) + float3(0.5,0.5,0.5);
  // r1.xyz = r1.xyz * r0.xyz;
  // r2.xyz = r0.xyz * float3(6.19999981,6.19999981,6.19999981) + float3(1.70000005,1.70000005,1.70000005);
  // r0.xyz = r0.xyz * r2.xyz + float3(0.0599999987,0.0599999987,0.0599999987);
  // r0.xyz = r1.xyz / r0.xyz;
float3 colorU = r0.xyz; Tonemap_Vanilla1(colorU, r0.xyz);
  o0.w = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
  o0.xyz = r0.xyz;
o0.xyz = Tonemap_Do(colorU, o0.xyz, v2.xy, mainTexture);
  return;
}