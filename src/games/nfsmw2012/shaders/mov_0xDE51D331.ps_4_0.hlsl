// ---- Created with 3Dmigoto v1.3.16 on Tue Nov 11 02:11:30 2025

SamplerState DiffuseSampler_s : register(s0);
SamplerState MovieUSampler_s : register(s3);
SamplerState MovieVSampler_s : register(s4);
Texture2D<float4> DiffuseSampler : register(t0);
Texture2D<float4> MovieUSampler : register(t1);
Texture2D<float4> MovieVSampler : register(t2);


// 3Dmigoto declarations
#define cmp -
#include "../shared.h"


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float2 v3 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v3.xy * float2(1,-1) + float2(0,1);
  r1.xyzw = MovieUSampler.Sample(MovieUSampler_s, r0.xy).xyzw;
  r0.z = -0.5 + r1.x;
  r0.zw = float2(0.393297911,2.02514172) * r0.zz;
  r1.xyzw = DiffuseSampler.Sample(DiffuseSampler_s, r0.xy).xyzw;
  r2.xyzw = MovieVSampler.Sample(MovieVSampler_s, r0.xy).xyzw;
  r0.x = -0.5 + r2.x;
  r0.y = -0.0625 + r1.x;
  r0.z = r0.y * 1.16894972 + -r0.z;
  r1.z = r0.y * 1.16894972 + r0.w;
  r1.y = -r0.x * 0.816156149 + r0.z;
  r0.x = 1.6022861 * r0.x;
  r1.x = r0.y * 1.16894972 + r0.x;
  r1.w = 1;
  o0.xyzw = r1.xyzw * v2.xyzw + v1.xyzw;
  o0.xyz = renodx::draw::UpscaleVideoPass(o0.xyz);
  return;
}