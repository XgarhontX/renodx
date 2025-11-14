// ---- Created with 3Dmigoto v1.3.16 on Tue Nov 11 00:50:51 2025

cbuffer _Globals : register(b0)
{
  float2 invPixelSize : packoffset(c0);
  float4 colorScale : packoffset(c1);
  float2 invTexelSize : packoffset(c2);
  float4 ironsightsDofParams : packoffset(c3);
  float4 downsampleQuarterZOffset : packoffset(c4);
  int sampleCount : packoffset(c5);
  float filterWidth : packoffset(c5.y);
  float mipLevelSource : packoffset(c5.z);
  float convolveSpecularPower : packoffset(c5.w);
  float convolveBlurRadius : packoffset(c6);
  int convolveSampleCount : packoffset(c6.y);
  float3 dofDepthScaleFactors : packoffset(c7);
  float4 radialBlurScales : packoffset(c8);
  float2 radialBlurCenter : packoffset(c9);
  float4 poissonRadialBlurConstants : packoffset(c10);
  float blendFactor : packoffset(c11);
}

SamplerState mainTextureSampler_s : register(s0);
Texture2D<float4> mainTexture : register(t0);


// 3Dmigoto declarations
#define cmp -
#include "../shared.h"

void S(inout float4 x) {
  x.xyz = pow(x.xyz, 2.2);
  x.xyz = renodx::tonemap::Reinhard(x.xyz);
  x.xyz = pow(x.xyz, 1/2.2);
}

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float2 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (!CUSTOM_IS_UI) discard;

  r0.zw = invTexelSize.yx + v2.yx;
  r1.xyzw = mainTexture.Sample(mainTextureSampler_s, r0.wz).xyzw; S(r1);
  r0.xy = -invTexelSize.xy + v2.xy;
  r2.xyzw = mainTexture.Sample(mainTextureSampler_s, r0.xz).xyzw; S(r2);
  r3.xyzw = mainTexture.Sample(mainTextureSampler_s, r0.wy).xyzw; S(r3);
  r0.xyzw = mainTexture.Sample(mainTextureSampler_s, r0.xy).xyzw; S(r0);
  r1.xyzw = r2.xyzw + r1.xyzw;
  r1.xyzw = r1.xyzw + r3.xyzw;
  r0.xyzw = r1.xyzw + r0.xyzw;
  r0.xyzw = colorScale.xyzw * r0.xyzw;
  o0.xyzw = float4(0.25,0.25,0.25,0.25) * r0.xyzw;
  return;
}