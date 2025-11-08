// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 06 12:10:59 2025

cbuffer externalConstants : register(b1)
{
  float external_lensFlareCenterDist : packoffset(c0);
  float3 vc_pad0 : packoffset(c0.y);
}

SamplerState sampler0_s : register(s0);
Texture2D<float4> texture_Texture4 : register(t1);
Texture2D<float4> texture_Texture3 : register(t2);
Texture2D<float4> texture_Texture : register(t3);


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

  r0.xy = texture_Texture.Sample(sampler0_s, v1.xy).xy;
  r0.z = 1 + external_lensFlareCenterDist;
  r0.xy = r0.xy + r0.zz;
  r0.xyz = texture_Texture3.Sample(sampler0_s, r0.xy).xyz;
  r1.xyz = texture_Texture4.Sample(sampler0_s, v1.xy).xyz;
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = float3(5,4.04799986,2.64700007) * r0.xyz;
  o0.xyz = v1.zzz * r0.xyz;
  o0.w = 0;
  o0.xyz = Lens_Do(o0.xyz);
  return;
}