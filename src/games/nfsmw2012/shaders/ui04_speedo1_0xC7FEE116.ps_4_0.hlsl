// ---- Created with 3Dmigoto v1.3.16 on Tue Nov 11 02:11:28 2025

SamplerState DiffuseSampler_s : register(s0);
Texture2D<float4> DiffuseSampler : register(t0);


// 3Dmigoto declarations
#define cmp -
#include "../shared.h"


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float2 v3 : TEXCOORD2,
  float2 w3 : TEXCOORD3,
  float4 v4 : TEXCOORD4,
  float4 v5 : TEXCOORD5,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

if (!CUSTOM_IS_UI) discard;
  r0.xy = -v4.xy + v3.xy;
  r0.xy = -v4.zw + abs(r0.xy);
  r0.x = max(r0.x, r0.y);
  r0.x = cmp(r0.x >= 0);
  r1.xyzw = DiffuseSampler.Sample(DiffuseSampler_s, v3.xy).xyzw;
  r1.xyzw = v2.xyzw * r1.xyzw;
  r0.xyzw = r0.xxxx ? float4(0,0,0,0) : r1.xyzw;
  o0.xyzw = v1.xyzw + r0.xyzw;
  return;
}