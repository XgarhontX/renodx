// ---- Created with 3Dmigoto v1.3.16 on Mon Aug 18 00:03:41 2025
#include "./common.hlsl"

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t2 : register(t2);

SamplerState s4_s : register(s4);

SamplerState s0_s : register(s0);

cbuffer cb4 : register(b4)
{
  float4 cb4[4];
}

cbuffer cb3 : register(b3)
{
  float4 cb3[2];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[32];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t4.Sample(s4_s, v1.xy).x;
  r0.y = t2.Sample(s0_s, w1.xy).x;
  r0.z = r0.x * r0.y + -0.200000003;
  r1.xw = r0.xx * r0.yy;
  r1.yz = saturate(r0.zz);
  r0.xyzw = float4(2,1.20000005,1.20000005,1.20000005) * r1.xyzw;
  r2.xyz = cb2[1].xyz * float3(2,2,2) + r0.zyz;
  r1.xyz = r2.xyz * r1.www;
  r2.x = cmp(cb2[1].w == 0.000000);
  r0.xyzw = saturate(r2.xxxx ? r0.xyzw : r1.xyzw);
  r0.xyz = cb2[31].xxx * r0.xyz;
  o0.w = r0.w;
  r1.xyz = r0.xyz * cb4[3].yyy + -r0.xyz;
  o0.xyz = cb3[1].xxx * r1.xyz + r0.xyz;

  ADSSights_Scale(o0);

  return;
}