// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 06 12:10:45 2025

cbuffer externalConstants : register(b1)
{
  float external_lensFlareCenterDist : packoffset(c0);
  float3 vc_pad0 : packoffset(c0.y);
}

SamplerState sampler0_s : register(s0);
SamplerState sampler1_s : register(s1);
SamplerState sampler2_s : register(s2);
Texture2D<float4> texture_Texture4 : register(t1);
Texture2D<float4> texture_Texture : register(t2);
Texture2D<float4> texture_Texture2 : register(t3);


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

  r0.x = 2 * external_lensFlareCenterDist;
  r0.y = 0;
  r0.xy = float2(1,1) + r0.xy;
  r0.zw = texture_Texture2.Sample(sampler2_s, v1.xy).xy;
  r0.xy = r0.zw * r0.xy;
  r0.xyz = texture_Texture.Sample(sampler1_s, r0.xy).xyz;
  r1.xyz = texture_Texture4.Sample(sampler0_s, v1.xy).xyz;
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = float3(5,3.03500009,0.834999979) * r0.xyz;
  o0.xyz = v1.zzz * r0.xyz;
  o0.w = 0;
  o0.xyz = Lens_Do(o0.xyz);
  return;
}