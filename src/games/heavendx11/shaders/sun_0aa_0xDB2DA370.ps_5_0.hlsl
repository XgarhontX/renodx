// ---- Created with 3Dmigoto v1.3.16 on Thu Mar 05 16:58:19 2026

cbuffer _Globals : register(b0)
{
  float power : packoffset(c0);
  float4 sun_color : packoffset(c1);
  float4 sun_angle : packoffset(c2);
  float4 up_direction : packoffset(c3);
  float4 light_direction : packoffset(c4);
  float4 height_falloff : packoffset(c5);
  float4 greenstein : packoffset(c6);
  float4 ray_beta : packoffset(c7);
  float4 mie_beta : packoffset(c8);
  float4 ray_dash : packoffset(c9);
  float4 mie_dash : packoffset(c10);
}

SamplerState s_sampler_0_s : register(s0);
Texture2D<float4> s_texture_0 : register(t0);


// 3Dmigoto declarations
#define cmp -
#include "./common.hlsl"

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float3 v2 : TEXCOORD1,
  out float3 o0 : SV_TARGET0,
  out float3 o1 : SV_TARGET1)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = dot(v2.xyz, v2.xyz);
  r0.x = rsqrt(r0.x);
  r0.xyz = v2.xyz * r0.xxx;
  r0.w = dot(r0.xyz, up_direction.xyz);
  r0.x = dot(r0.xyz, light_direction.xyz);
  r1.xyz = s_texture_0.Sample(s_sampler_0_s, v1.xy).xyz;
  r0.y = dot(r1.xyz, float3(1.9921875,0.00778198242,3.03983688e-005));
  r0.y = 1 + -r0.y;
  r0.y = r0.y * r0.y;
  r0.z = r0.w * r0.y + height_falloff.z;
  r0.zw = height_falloff.xy * r0.zz;
  r1.xy = exp2(-r0.zw);
  r1.xy = float2(1,1) + -r1.xy;
  r1.xy = r1.xy / r0.zw;
  r0.zw = cmp(float2(9.99999975e-005,9.99999975e-005) < abs(r0.zw));
  r1.y = mie_beta.w * r1.y;
  r1.x = ray_beta.w * r1.x;
  r0.z = r0.z ? r1.x : ray_beta.w;
  r0.w = r0.w ? r1.y : mie_beta.w;
  r1.xyz = mie_beta.xyz * r0.www;
  r1.xyz = ray_beta.xyz * r0.zzz + r1.xyz;
  r0.z = log2(r0.y);
  r0.y = cmp(0.99000001 < r0.y);
  r0.y = r0.y ? 1.000000 : 0;
  r0.z = power * r0.z;
  r0.z = exp2(r0.z);
  r1.xyz = -r1.xyz * r0.zzz;
  r0.z = mie_dash.w * r0.z;
  r1.xyz = exp2(r1.xyz);
  r2.xyz = float3(1,1,1) + -r1.xyz;
  o1.xyz = r1.xyz;
  r0.w = -greenstein.z * r0.x + greenstein.y;
  r0.w = rsqrt(r0.w);
  r0.w = greenstein.x * r0.w;
  r0.z = min(r0.w, r0.z);
  r1.xyz = mie_dash.xyz * r0.zzz;
  r0.z = r0.x * r0.x;
  r0.x = max(0, r0.x);
  r0.x = log2(r0.x);
  r0.x = sun_angle.x * r0.x;
  r0.x = exp2(r0.x);
  r0.x = /* saturate */(sun_angle.y * r0.x);
  Sun_Boost(r0.y);

  r3.xyz = sun_color.xyz * r0.xxx;
  r0.xyw = r3.xyz * r0.yyy;
  r0.z = r0.z * ray_dash.w + 1;
  r1.xyz = ray_dash.xyz * r0.zzz + r1.xyz;
  o0.xyz = r1.xyz * r2.xyz + r0.xyw;
  return;
}