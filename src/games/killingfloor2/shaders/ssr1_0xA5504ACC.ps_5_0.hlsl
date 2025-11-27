// ---- Created with 3Dmigoto v1.3.16 on Tue Nov 25 18:55:07 2025

cbuffer _Globals : register(b0)
{
  bool bDecompressSceneColor : packoffset(c0);
  float4 SceneShadowsAndDesaturation : packoffset(c1);
  float4 SceneInverseHighLights : packoffset(c2);
  float4 SceneMidTones : packoffset(c3);
  float4 SceneScaledLuminanceWeights : packoffset(c4);
  float4 SceneColorize : packoffset(c5);
  float4 GammaColorScaleAndInverse : packoffset(c6);
  float4 GammaOverlayColor : packoffset(c7);
  float4 RenderTargetExtent : packoffset(c8);
  float4 TextureDimensions : packoffset(c9);
}

SamplerState SceneColorTextureSampler_s : register(s0);
SamplerState ScreenSpaceReflectionsTextureSampler_s : register(s1);
Texture2D<float4> SceneColorTexture : register(t0);
Texture2D<float4> ScreenSpaceReflectionsTexture : register(t1);


// 3Dmigoto declarations
#define cmp -
#include "./M.hlsl"
#include "../shared.h"

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  //thres
  r0.xyz = ScreenSpaceReflectionsTexture.Sample(ScreenSpaceReflectionsTextureSampler_s, v1.xy).xyz;
  r0.w = cmp(0 >= r0.z);
  if (r0.w != 0) {
    if (-1 != 0) discard;
  }
  
  r1.xy = float2(1.5,1.5) / TextureDimensions.zw;
  r2.xyz = SceneColorTexture.Sample(SceneColorTextureSampler_s, r0.xy).xyz; /* M(r2.xyz); */
  r3.xy = r1.xy + r0.xy;
  r3.xyz = SceneColorTexture.Sample(SceneColorTextureSampler_s, r3.xy).xyz; /* M(r3.xyz); */
  r3.xyz = float3(0.125,0.125,0.125) * r3.xyz;
  r2.xyz = r2.xyz * float3(0.5,0.5,0.5) + r3.xyz;
  r3.xy = -r1.xy + r0.xy;
  r3.xyz = SceneColorTexture.Sample(SceneColorTextureSampler_s, r3.xy).xyz; /* M(r3.xyz); */
  r2.xyz = r3.xyz * float3(0.125,0.125,0.125) + r2.xyz;
  r1.zw = -r1.yx;
  r1.xyzw = r1.xzwy + r0.xyxy;
  r0.xyw = SceneColorTexture.Sample(SceneColorTextureSampler_s, r1.xy).xyz; /* M(r0.xyw); */
  r0.xyw = r0.xyw * float3(0.125,0.125,0.125) + r2.xyz;
  r1.xyz = SceneColorTexture.Sample(SceneColorTextureSampler_s, r1.zw).xyz; /* M(r1.xyz); */
  r0.xyw = r1.xyz * float3(0.125,0.125,0.125) + r0.xyw;
  // r0.xyw = max(0, r0.xyw); //just in case nans
  o0.xyz = r0.xyw ;

  //alpha
  r1.x = length(r0.xyw); // r1.x = dot(r0.xyw, r0.xyw); r1.x = sqrt(r1.x);
  o0.w = r1.x * r0.z * CUSTOM_SSR_MULTIPLIER;
  return;
}