// ---- Created with 3Dmigoto v1.3.16 on Mon Aug 18 19:49:06 2025
#include "./common.hlsl"

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t2 : register(t2);

SamplerState s4_s : register(s4);

SamplerState s0_s : register(s0);

cbuffer cb3 : register(b3)
{
  float4 cb3[3];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[18];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (!CUSTOM_IS_UI) discard;

  r0.xyz = cb2[17].xxx / cb3[0].xyz;
  r1.xyz = cmp(r0.xyz >= -r0.xyz);
  r0.xyz = frac(abs(r0.xyz));
  r0.xyz = r1.xyz ? r0.xyz : -r0.xyz;
  r1.xyz = cb3[0].xyz * r0.xyz;
  r0.xyz = -r0.xyz * cb3[0].xyz + cb3[0].xyz;
  r0.xyz = r0.xyz * r1.xyz;
  r0.xyz = r0.xyz / cb3[1].xyz;
  r0.w = cb2[17].x / cb3[1].w;
  r1.x = cmp(r0.w >= -r0.w);
  r0.w = frac(abs(r0.w));
  r0.w = r1.x ? r0.w : -r0.w;
  r0.w = cb3[1].w * r0.w;
  r1.xy = cb3[2].xy * r0.ww + v1.xy;
  r1.xyz = t2.Sample(s0_s, r1.xy).xyz;
  r0.xy = r1.xy * r0.xy;
  r0.x = r0.x + r0.y;
  r0.x = r1.z * r0.z + r0.x;
  r0.x = r0.x * cb3[0].w + 1;
  r1.xyzw = t4.Sample(s4_s, v1.xy).xyzw;
  o0.w = saturate(r1.w * r0.x);
  o0.xyz = r1.xyz;
  return;
}