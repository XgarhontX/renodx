// ---- Created with 3Dmigoto v1.3.16 on Thu Mar 05 16:52:24 2026

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

cbuffer shader_common_parameters : register(b1)
{
  float4 s_viewport : packoffset(c0);
  float4 s_depth_range : packoffset(c1);
  float4 s_solid_color : packoffset(c2);
  float4 s_ambient_color : packoffset(c3);
}

Texture2DMS<float4,4> s_texture_0 : register(t0);


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

  r0.xy = s_viewport.xy * v1.xy;
  r0.xy = (int2)r0.xy;
  r0.zw = float2(0,0);
  r1.xyz = s_texture_0.Load(r0.xy, 0).xyz;
  r1.w = 1.9921875 * r1.x;
  r1.w = floor(r1.w);
  r1.x = -r1.w * 0.501960814 + r1.x;
  r1.x = dot(r1.xyz, float3(1.9921875,0.00778198242,3.03983688e-005));
  r1.x = 1 + -r1.x;
  r1.x = r1.x * r1.x;
  r1.yzw = s_texture_0.Load(r0.xy, 1).xyz;
  r2.x = 1.9921875 * r1.y;
  r2.x = floor(r2.x);
  r1.y = -r2.x * 0.501960814 + r1.y;
  r1.y = dot(r1.yzw, float3(1.9921875,0.00778198242,3.03983688e-005));
  r1.y = 1 + -r1.y;
  r1.y = r1.y * r1.y;
  r1.z = min(r1.x, r1.y);
  r1.x = max(r1.x, r1.y);
  r2.xyz = s_texture_0.Load(r0.xy, 2).xyz;
  r1.y = 1.9921875 * r2.x;
  r1.y = floor(r1.y);
  r2.x = -r1.y * 0.501960814 + r2.x;
  r1.y = dot(r2.xyz, float3(1.9921875,0.00778198242,3.03983688e-005));
  r1.y = 1 + -r1.y;
  r1.y = r1.y * r1.y;
  r1.z = min(r1.z, r1.y);
  r1.x = max(r1.x, r1.y);
  r0.xyz = s_texture_0.Load(r0.xy, 3).xyz;
  r0.w = 1.9921875 * r0.x;
  r0.w = floor(r0.w);
  r0.x = -r0.w * 0.501960814 + r0.x;
  r0.x = dot(r0.xyz, float3(1.9921875,0.00778198242,3.03983688e-005));
  r0.x = 1 + -r0.x;
  r0.x = r0.x * r0.x;
  r0.y = min(r1.z, r0.x);
  r0.z = max(r1.x, r0.x);
  r0.y = r0.z + -r0.y;
  r0.y = cmp(9.99999997e-007 < r0.y);
  if (r0.y != 0) discard;
  r0.y = dot(v2.xyz, v2.xyz);
  r0.y = rsqrt(r0.y);
  r0.yzw = v2.xyz * r0.yyy;
  r1.x = dot(r0.yzw, up_direction.xyz);
  r1.x = r1.x * r0.x + height_falloff.z;
  r1.xy = height_falloff.xy * r1.xx;
  r1.zw = cmp(float2(9.99999975e-005,9.99999975e-005) < abs(r1.xy));
  r2.xy = exp2(-r1.xy);
  r2.xy = float2(1,1) + -r2.xy;
  r1.xy = r2.xy / r1.xy;
  r1.x = ray_beta.w * r1.x;
  r1.x = r1.z ? r1.x : ray_beta.w;
  r1.y = mie_beta.w * r1.y;
  r1.y = r1.w ? r1.y : mie_beta.w;
  r1.z = log2(r0.x);
  r1.z = power * r1.z;
  r1.z = exp2(r1.z);
  r2.xyz = mie_beta.xyz * r1.yyy;
  r1.xyw = ray_beta.xyz * r1.xxx + r2.xyz;
  r1.xyw = -r1.xyw * r1.zzz;
  r1.xyw = exp2(r1.xyw);
  r0.y = dot(r0.yzw, light_direction.xyz);
  r0.z = r0.y * r0.y;
  r0.z = r0.z * ray_dash.w + 1;
  r0.w = -greenstein.z * r0.y + greenstein.y;
  r0.w = rsqrt(r0.w);
  r0.w = greenstein.x * r0.w;
  r1.z = mie_dash.w * r1.z;
  r0.w = min(r1.z, r0.w);
  r2.xyz = mie_dash.xyz * r0.www;
  r2.xyz = ray_dash.xyz * r0.zzz + r2.xyz;
  r0.y = max(0, r0.y);
  r0.y = log2(r0.y);
  r0.y = sun_angle.x * r0.y;
  r0.y = exp2(r0.y);
  r0.y = /* saturate */(sun_angle.y * r0.y);
  Sun_Boost(r0.y);

  r0.yzw = sun_color.xyz * r0.yyy;
  r3.xyz = float3(1,1,1) + -r1.xyw;
  r0.x = cmp(0.99000001 < r0.x);
  r0.x = r0.x ? 1.000000 : 0;
  r0.xyz = r0.yzw * r0.xxx;
  o0.xyz = r2.xyz * r3.xyz + r0.xyz;
  o1.xyz = r1.xyw;
  return;
}