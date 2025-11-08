// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 06 12:10:41 2025

cbuffer externalConstants : register(b1)
{
  float external_lensFlareCenterDist : packoffset(c0);
  float3 vc_pad0 : packoffset(c0.y);
}

SamplerState sampler0_s : register(s0);
Texture2D<float4> texture_Texture2 : register(t1);


// 3Dmigoto declarations
#define cmp -
#include "./common.hlsl"

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(0.400000006,1.20000005) * external_lensFlareCenterDist;
  sincos(r0.x, r0.x, r1.x);
  sincos(r0.y, r2.x, r3.x);
  r0.yz = float2(-0.5,-0.5) + v1.yx;
  r0.xw = r0.yz * r0.xx;
  r4.x = r0.z * r1.x + -r0.x;
  r4.y = r0.y * r1.x + r0.w;
  r0.xw = float2(0.5,0.5) + r4.xy;
  r1.xyz = texture_Texture2.Sample(sampler0_s, r0.xw).xyz;
  r1.xyz = float3(1,0.27700001,0.0529999994) * r1.xyz;
  r0.xw = r0.yz * r2.xx;
  r2.x = r0.z * r3.x + -r0.x;
  r2.y = r0.y * r3.x + r0.w;
  r0.xy = float2(0.5,0.5) + r2.xy;
  r0.xyz = texture_Texture2.Sample(sampler0_s, r0.xy).xyz;
  r0.xyz = r0.xyz * float3(12,2.04200006,0) + r1.xyz;
  o0.xyz = v1.zzz * r0.xyz;
  o0.w = 0;
  o0.xyz = Lens_Do(o0.xyz);
  return;
}