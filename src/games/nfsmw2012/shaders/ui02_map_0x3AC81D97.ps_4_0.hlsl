// ---- Created with 3Dmigoto v1.3.16 on Tue Nov 11 02:11:22 2025

SamplerState DiffuseSampler_s : register(s0);
SamplerState MaskSampler0_s : register(s1);
SamplerState MaskSampler1_s : register(s2);
Texture2D<float4> DiffuseSampler : register(t0);
Texture2D<float4> MaskSampler0 : register(t1);
Texture2D<float4> MaskSampler1 : register(t2);


// 3Dmigoto declarations
#define cmp -
#include "../shared.h"

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float2 v3 : TEXCOORD2,
  float2 w3 : TEXCOORD6,
  float4 v4 : TEXCOORD3,
  float4 v5 : TEXCOORD4,
  float4 v6 : TEXCOORD5,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

if (!CUSTOM_IS_UI) discard;
  r0.xy = max(abs(v6.xz), abs(v6.yw));
  r0.xy = cmp(float2(1,1) >= r0.xy);
  r0.xy = r0.xy ? float2(1,1) : 0;
  r1.xyzw = MaskSampler0.Sample(MaskSampler0_s, v5.xy).wxyz;
  r2.xyzw = MaskSampler1.Sample(MaskSampler1_s, v5.zw).xyzw;
  r1.y = r2.w;
  r0.xy = r1.xy * r0.xy;
  r0.xy = max(w3.xy, r0.xy);
  r0.x = r0.x * r0.y;
  r1.xyzw = DiffuseSampler.Sample(DiffuseSampler_s, v3.xy).xyzw;
  r1.xyzw = r1.xyzw * v2.xyzw + v1.xyzw;
  o0.w = r1.w * r0.x;
  o0.xyz = r1.xyz;
  return;
}