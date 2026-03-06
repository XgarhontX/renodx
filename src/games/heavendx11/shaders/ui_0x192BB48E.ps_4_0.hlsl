// ---- Created with 3Dmigoto v1.3.16 on Thu Mar 05 15:02:32 2026

SamplerState s_sampler_0_s : register(s0);
Texture2D<float4> s_texture_0 : register(t0);


// 3Dmigoto declarations
#define cmp -
#include "../shared.h"

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : COLOR0,
  out float4 o0 : SV_TARGET0,
  out float4 o1 : SV_TARGET1)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (SI.ui <= 0.f) discard;

  r0.xyzw = s_texture_0.Sample(s_sampler_0_s, v1.xy).xyzw;
  r0.xyzw = v2.xyzw * r0.xyzw;
  o0.xyzw = r0.xyzw;
  o1.xyzw = r0.xyzw;
  return;
}