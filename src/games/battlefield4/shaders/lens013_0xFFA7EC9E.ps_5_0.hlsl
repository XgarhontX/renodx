// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 06 12:12:07 2025

cbuffer externalConstants : register(b1)
{
  float external_lensFlareCenterDist : packoffset(c0);
  float3 vc_pad0 : packoffset(c0.y);
}

SamplerState sampler0_s : register(s0);
Texture2D<float4> texture_Texture6 : register(t1);
Texture2D<float4> texture_Texture5 : register(t2);
Texture2D<float4> texture_Texture7 : register(t3);


// 3Dmigoto declarations
#define cmp -
#include "./common.hlsl"

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = texture_Texture7.Sample(sampler0_s, v1.xy).xy;
  r0.x = external_lensFlareCenterDist + r0.x;
  r0.xyz = texture_Texture5.Sample(sampler0_s, r0.xy).xyz;
  r1.xyz = texture_Texture6.Sample(sampler0_s, v1.xy).xyz;
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = float3(10,3.09599996,0.916000009) * r0.xyz;
  o0.xyz = v1.zzz * r0.xyz;
  o0.w = 0;
  o0.xyz = Lens_Do(o0.xyz);
  return;
}