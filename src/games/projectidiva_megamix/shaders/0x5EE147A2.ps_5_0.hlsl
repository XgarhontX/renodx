// ---- Created with 3Dmigoto v1.3.16 on Mon Aug 11 22:54:38 2025
#include "../shared.h"
#include "./common.hlsl"

SamplerState g_sampler_s : register(s0);
Texture2D<float4> g_texture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = g_texture.Sample(g_sampler_s, v2.xy).xyzw;
  F(r0.xyzw);
  F(v1.xyzw);
  r0.xyzw = v1.xyzw * r0.xyzw;
  F(r0.xyzw);
  o0.xyzw = r0.xyzw;
  return;
}