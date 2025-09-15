// ---- Created with 3Dmigoto v1.3.16 on Sun Aug 17 23:58:49 2025
#include "./common.hlsl"

Texture2D<float4> t4 : register(t4);

SamplerState s4_s : register(s4);

cbuffer cb3 : register(b3)
{
  float4 cb3[1];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[31];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD11,
  float3 v3 : TEXCOORD12,
  out float4 o0 : SV_TARGET0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t4.Sample(s4_s, v1.xy).xyzw;
  r0.xyz = r0.xyz * r0.xyz;
  o0.w = r0.w;
  r0.xyz = r0.xyz * cb3[0].xxx + cb3[0].yyy;
  r0.xyz = cb2[30].xxx * r0.xyz;
  o0.xyz = r0.xyz * v2.xyz + v3.xyz;

  ADSSights_Scale(o0);

  return;
}