// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 06 12:10:46 2025

cbuffer externalConstants : register(b1)
{
  float external_lensFlareCenterDist : packoffset(c0);
  float3 vc_pad0 : packoffset(c0.y);
}

SamplerState sampler0_s : register(s0);
Texture2D<float4> texture_Texture5 : register(t1);


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

  r0.xy = float2(0.550000012,-0.550000012) * external_lensFlareCenterDist;
  sincos(r0.y, r1.x, r2.x);
  sincos(r0.x, r0.x, r3.x);
  r0.yz = v1.yx * float2(2,2) + float2(-1,-1);
  r1.xy = r0.yz * r1.xx;
  r4.x = r0.z * r2.x + -r1.x;
  r4.y = r0.y * r2.x + r1.y;
  r1.xyz = texture_Texture5.Sample(sampler0_s, r4.xy).xyz;
  r0.xw = r0.yz * r0.xx;
  r2.x = r0.z * r3.x + -r0.x;
  r2.y = r0.y * r3.x + r0.w;
  r0.xyz = texture_Texture5.Sample(sampler0_s, r2.xy).xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r0.xyz = float3(3,2.54999995,1.977) * r0.xyz;
  o0.xyz = v1.zzz * r0.xyz;
  o0.w = 0;
  o0.xyz = Lens_Do(o0.xyz);
  return;
}