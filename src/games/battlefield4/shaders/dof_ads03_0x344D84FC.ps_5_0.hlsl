// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 06 12:10:33 2025

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
}

SamplerState sharpDOFTextureSampler_s : register(s0);
SamplerState blurredDOFTextureSampler_s : register(s1);
Texture2D<float4> sharpDOFTexture : register(t0);
Texture2D<float4> blurredDOFTexture : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float2 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = blurredDOFTexture.Sample(blurredDOFTextureSampler_s, v2.xy).xyzw;
  r0 = max(1e-6, r0);
  
  r1.x = sharpDOFTexture.Sample(sharpDOFTextureSampler_s, v2.xy).w;
  r1.x = max(1e-6, r1.x);

  r0.w = max(r1.x, r0.w);
  
  o0.xyz = r0.xyz;
  o0.w = ironsightsDofParams.z * r0.w + -r1.x;
  // o0 = max(1e-6, o0);
  o0 = saturate(o0);
  return;
}