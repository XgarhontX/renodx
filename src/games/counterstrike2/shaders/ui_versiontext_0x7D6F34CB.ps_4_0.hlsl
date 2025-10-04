// ---- Created with 3Dmigoto v1.3.16 on Thu Oct 02 18:13:42 2025
#include "../shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[1];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : COLOR0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (CUSTOM_UI_SHOWVERSIONTEXT == 0) discard;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xyz = cb0[0].xxx * r0.xyz;
  o0.xyzw = v0.xyzw * r0.xyzw;
  return;
}