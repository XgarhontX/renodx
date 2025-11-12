// ---- Created with 3Dmigoto v1.3.16 on Tue Nov 11 02:11:22 2025

cbuffer gGlobalCB : register(b0)
{
  float4 GenericVector4_D : packoffset(c0);
  float4 GenericVector4_F : packoffset(c1);
}

SamplerState DiffuseSampler_s : register(s0);
SamplerState GenericSamplerA_s : register(s1);
SamplerState GenericSamplerB_s : register(s2);
SamplerState TonemapSampler_s : register(s3);
Texture2D<float4> GenericSamplerA : register(t0);
Texture2D<float4> TonemapSampler : register(t1);
Texture2D<float4> GenericSamplerB : register(t2);
Texture2D<float4> DiffuseSampler : register(t3);


// 3Dmigoto declarations
#define cmp -
#include "../shared.h"

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD2,
  float3 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = GenericSamplerA.Sample(GenericSamplerA_s, GenericVector4_D.xy).xyzw;
  r0.xyz = v2.xyz * r0.xxx;
  r1.xyzw = TonemapSampler.Sample(TonemapSampler_s, float2(0.5,0.5)).xyzw;
  r0.xyz = r1.www * r0.xyz;
  r0.xyz = exp2(-r0.xyz);
  r0.xyz = float3(1,1,1) + -r0.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r1.xyz = r0.xyz * float3(0.0707062855,0.0707062855,0.0707062855) + float3(-0.317853957,-0.317853957,-0.317853957);
  r1.xyz = r1.xyz * r0.xyz + float3(-0.0227105431,-0.0227105431,-0.0227105431);
  r0.xyz = sqrt(r0.xyz);
  r0.xyz = saturate(r0.xyz * float3(1.27169645,1.27169645,1.27169645) + r1.xyz);
  r2.xyzw = GenericSamplerB.Sample(GenericSamplerB_s, w1.xy).xyzw;
  r1.xyz = r2.xyz * r1.www;
  r1.xyz = GenericVector4_F.xyz * r1.xyz;
  r0.xyz = r1.xyz * float3(0.300000012,0.300000012,0.300000012) + r0.xyz;
  r0.w = dot(r0.xyz, float3(0.298999995, 0.587000012, 0.114));
  r0 *= CUSTOM_LENS;
  r1.xyzw = DiffuseSampler.Sample(DiffuseSampler_s, v1.xy).xyzw;
  o0.xyzw = r1.xyzw * r0.xyzw;
  return;
}