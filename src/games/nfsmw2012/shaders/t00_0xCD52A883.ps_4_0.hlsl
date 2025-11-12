// ---- Created with 3Dmigoto v1.3.16 on Tue Nov 11 02:11:29 2025

cbuffer _Globals : register(b0)
{
  float4 g_DOF_True_K4K5K6 : packoffset(c0);
  float4 DofParamsA : packoffset(c1);
  float4 DofParamsB : packoffset(c2);
  float4 BloomColour : packoffset(c3);
  float4 MotionBlurAmounts : packoffset(c4);
  float4 BlurMatrixZZZ : packoffset(c5);
  float4 ColourCubeScalesOffsets : packoffset(c6);
  float4 ScreenSize : packoffset(c7);
}

SamplerState SamplerSource_s : register(s0);
SamplerState SamplerDof_s : register(s2);
SamplerState Sampler3dTint_s : register(s3);
SamplerState SamplerDepth_s : register(s4);
SamplerState SamplerDistort_s : register(s6);
SamplerState SamplerSplatter_s : register(s7);
Texture2D<float4> SamplerDistort : register(t0);
Texture2D<float4> SamplerDepth : register(t1);
Texture2D<float4> SamplerSource : register(t2);
Texture2D<float4> SamplerDof : register(t3);
Texture2D<float4> SamplerSplatter : register(t4);
Texture3D<float4> Sampler3dTint : register(t5);


// 3Dmigoto declarations
#define cmp -
#include "./common.hlsl"


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = SamplerDistort.Sample(SamplerDistort_s, v1.xy).xyzw;
  r0.xy = saturate(v1.xy + r0.xy);
  r1.xyzw = SamplerDepth.Sample(SamplerDepth_s, r0.xy).xyzw;
  r0.z = g_DOF_True_K4K5K6.x * r1.x + g_DOF_True_K4K5K6.y;
  r0.z = max(g_DOF_True_K4K5K6.z, r0.z);
  r0.z = 15 * abs(r0.z);
  r0.z = min(1, r0.z);
  r1.xyzw = SamplerDof.Sample(SamplerDof_s, r0.xy).xyzw;
  r2.xyzw = SamplerSource.Sample(SamplerSource_s, r0.xy).xyzw;
  r0.xyw = -r2.xyz + r1.xyz;
  r0.xyz = r0.zzz * r0.xyw + r2.xyz;
  r1.xyzw = SamplerSplatter.Sample(SamplerSplatter_s, v1.xy).xyzw;
  r0.w = 1 + -r1.w;
  r0.xyz = r0.xyz * r0.www + r1.xyz;
  r0.xyz = r0.xyz * ColourCubeScalesOffsets.xyz + ColourCubeScalesOffsets.www;
  float3 colorU = r0.xyz;
  // r0 = Sampler3dTint.Sample(Sampler3dTint_s, r0.xyz);  // LUT
  Tonemap_Lut(colorU, r0, Sampler3dTint_s, Sampler3dTint);
  r0.xyz = Tonemap_Do(colorU, r0.xyz, v1);
  o0 = r0;
  return;
}