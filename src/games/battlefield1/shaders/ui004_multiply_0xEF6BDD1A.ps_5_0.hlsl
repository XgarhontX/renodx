// ---- Created with 3Dmigoto v1.3.16 on Tue Nov 11 00:51:32 2025

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
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (!CUSTOM_IS_UI) discard;

  r0.xyzw = mainTexture.Sample(mainTextureSampler_s, v1.xy).xyzw;
  r0.xyz = r0.xyz * r0.www;
  o0.xyzw = saturate(float4(renodx::math::SignPow(v2.xyz, 4.4), v2.w)) * r0.xyzw;
  return;
}