// ---- Created with 3Dmigoto v1.3.16 on Tue Sep 30 09:40:05 2025
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
}

SamplerState mainTexture_s : register(s0);
Texture2D<float4> mainTexture : register(t0);


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
  float3 colorU;

  r0.xyzw = invPixelSize.xyxy * float4(-0.5,-0.5,-0.5,0.5) + v2.xyxy;
  r1.xyzw = mainTexture.Sample(mainTexture_s, r0.xy).xyzw;
  r0.xyzw = mainTexture.Sample(mainTexture_s, r0.zw).xyzw;
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xyzw = invPixelSize.xyxy * float4(0.5,0.5,0.5,-0.5) + v2.xyxy;
  r2.xyzw = mainTexture.Sample(mainTexture_s, r1.xy).xyzw;
  r1.xyzw = mainTexture.Sample(mainTexture_s, r1.zw).xyzw;
  r0.xyzw = r2.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;

  r0.xyzw = colorScale.xyzw * r0.xyzw;
  colorU = r0.xyz; //idk if this is right

  o0.xyzw = float4(0.25,0.25,0.25,0.25) * r0.xyzw;
  o0.xyz = Tonemap_Do(colorU, /*colorN, */o0.xyz, v2.xy, mainTexture);
  return;
}