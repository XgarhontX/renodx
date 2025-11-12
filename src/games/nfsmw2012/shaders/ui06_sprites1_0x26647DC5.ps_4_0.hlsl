// ---- Created with 3Dmigoto v1.3.16 on Tue Nov 11 02:11:21 2025

cbuffer gObjectCB : register(b1)
{
  float4 gIM2DConstants : packoffset(c0);
}

cbuffer gMaterialCB : register(b2)
{
  float kStretchU : packoffset(c0) = {0.5};
  float kStretchU2 : packoffset(c0.y) = {0.5};
  float kStretchV : packoffset(c0.z) = {0.5};
  float kStretchV2 : packoffset(c0.w) = {0.5};
}

SamplerState DiffuseSampler_s : register(s0);
Texture2D<float4> DiffuseSampler : register(t0);


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
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

if (!CUSTOM_IS_UI) discard;
  r0.xy = float2(-1,-1) + gIM2DConstants.xy;
  r0.zw = kStretchU + -kStretchU2;
  r0.zw = float2(1,1) + r0.zw;
  r1.xy = kStretchU / r0.zw;
  r0.zw = float2(1,1) + -r0.zw;
  r0.xy = r0.xy * r1.xy + kStretchU;
  r1.xy = v3.xy * gIM2DConstants.xy + -r0.xy;
  r1.xy = kStretchU + r1.xy;
  r0.zw = r0.xy + r0.zw;
  r1.zw = gIM2DConstants.xy * v3.xy;
  r0.xyzw = cmp(r1.zwzw < r0.xyzw);
  r0.zw = r0.zw ? r1.xy : kStretchU2;
  r0.xy = r0.xy ? kStretchU : r0.zw;
  r0.zw = cmp(kStretchU == kStretchU2);
  r0.xy = r0.zw ? kStretchU2 : r0.xy;
  r0.zw = -v3.xy * gIM2DConstants.xy + gIM2DConstants.xy;
  r0.zw = float2(1,1) + -r0.zw;
  r1.xy = -kStretchU2 + gIM2DConstants.xy;
  r1.xy = cmp(r1.xy < r1.zw);
  r0.xy = r1.xy ? r0.zw : r0.xy;
  r0.zw = cmp(r1.zw < kStretchU);
  r0.xy = r0.zw ? r1.zw : r0.xy;
  r0.xyzw = DiffuseSampler.Sample(DiffuseSampler_s, r0.xy).xyzw;
  o0.xyzw = r0.xyzw * v2.xyzw + v1.xyzw;
  return;
}