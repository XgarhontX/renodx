// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 06 12:10:33 2025

cbuffer externalConstants : register(b1)
{
  float4 external_FLIRData : packoffset(c0);
  float external_FLIRScale : packoffset(c1);
  float3 vc_pad1 : packoffset(c1.y);
  float external_lensFlareCenterDist : packoffset(c2);
  float3 vc_pad2 : packoffset(c2.y);
}

SamplerState sampler0_s : register(s0);
Texture2D<float4> texture_Texture3 : register(t1);


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
  r1.xyz = texture_Texture3.Sample(sampler0_s, r0.xw).xyz;
  r0.x = external_FLIRScale * external_FLIRData.x;
  r2.yzw = r0.xxx * float3(990,-10,990) + float3(10,10,10);
  r1.xyz = r2.yzw * r1.xyz;
  r0.xw = r0.yz * r2.xx;
  r2.x = r0.z * r3.x + -r0.x;
  r2.y = r0.y * r3.x + r0.w;
  r0.xy = float2(0.5,0.5) + r2.xy;
  r0.xyz = texture_Texture3.Sample(sampler0_s, r0.xy).xyz;
  r0.xyz = r2.wzw * r0.xyz + r1.xyz;
  o0.xyz = v1.zzz * r0.xyz;
  o0.w = 0;
  o0.xyz = Lens_Do(o0.xyz);
  return;
}