// ---- Created with 3Dmigoto v1.3.16 on Tue Nov 11 00:50:13 2025

SamplerState mainTextureSampler_s : register(s0);
Texture2D<float4> mainTexture : register(t0);


// 3Dmigoto declarations
#define cmp -
#include "../shared.h"

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;
  
  if (!CUSTOM_IS_UI) discard;

  r0.xyz = v2.www + -v2.xyz;
  r1.xyzw = mainTexture.Sample(mainTextureSampler_s, v1.xy).xyzw;
  r0.w = dot(r1.zyx, float3(0.109999999,0.589999974,0.300000012));
  r1.x = -0.5 + r0.w;
  r0.w = r0.w + r0.w;
  r0.w = min(1, r0.w);
  r1.x = r1.x + r1.x;
  r1.x = max(0, r1.x);
  r0.xyz = r1.xxx * r0.xyz;
  r0.xyz = v2.xyz * r0.www + r0.xyz;
  o0.xyz = r0.xyz * r1.www;
  o0.w = v2.w * r1.w;
  return;
}