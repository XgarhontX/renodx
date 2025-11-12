// ---- Created with 3Dmigoto v1.3.16 on Tue Nov 11 02:11:23 2025

cbuffer gGlobalCB : register(b0)
{
  float4 Time : packoffset(c0);
}

cbuffer gObjectCB : register(b1)
{
  float4 gColourScale : packoffset(c0);
  float4 gColourShift : packoffset(c1);
  float4 gIM2DConstants : packoffset(c2) = {0,-1,0,0};
  float4 gvMaskAPositionMinMax : packoffset(c3);
  float4 gvMaskAUVDifference : packoffset(c4);
  float4 gvMaskAUVStartEnd : packoffset(c5);
  float4 gvMaskBPositionMinMax : packoffset(c6);
  float4 gvMaskBUVDifference : packoffset(c7);
  float4 gvMaskBUVStartEnd : packoffset(c8);
  float4 gvMaskUseFlags : packoffset(c9);
}

SamplerState DiffuseSampler_s : register(s0);
SamplerState MaskSampler0_s : register(s1);
SamplerState MaskSampler1_s : register(s2);
Texture2D<float4> DiffuseSampler : register(t0);
Texture2D<float4> MaskSampler0 : register(t1);
Texture2D<float4> MaskSampler1 : register(t2);


// 3Dmigoto declarations
#define cmp -
#include "../shared.h"


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  float w1 : TEXCOORD2,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

if (!CUSTOM_IS_UI) discard;
  r0.x = saturate(gIM2DConstants.x + -w1.x);
  r0.y = saturate(-gIM2DConstants.y + w1.x);
  r0.xy = ceil(r0.xy);
  r0.x = max(r0.x, r0.y);
  r0.x = 1 + -r0.x;
  r1.xyzw = gColourShift.xyzw + -gColourScale.xyzw;
  r0.xyzw = r0.xxxx * r1.xyzw + gColourScale.xyzw;
  r1.x = 9.99999975e-005 * gIM2DConstants.z;
  r1.y = 0.333333343 * Time.x;
  r1.z = cmp(r1.y >= -r1.y);
  r1.y = frac(abs(r1.y));
  r1.y = r1.z ? r1.y : -r1.y;
  r1.y = r1.y * 0.300000012 + gIM2DConstants.x;
  r1.z = -gIM2DConstants.z * 9.99999975e-005 + r1.y;
  r1.w = saturate(-w1.x + r1.z);
  r1.y = saturate(w1.x + -r1.y);
  r1.yw = ceil(r1.yw);
  r1.y = max(r1.w, r1.y);
  r1.y = 1 + -r1.y;
  r1.x = 1 / r1.x;
  r1.z = w1.x + -r1.z;
  r1.w = r1.z * r1.x;
  r1.x = saturate(r1.z * r1.x + -0.75);
  r1.x = 4 * r1.x;
  r1.x = saturate(r1.w * r1.y + -r1.x);
  r1.xyz = r1.xxx * r0.xyz;
  r1.xyz = saturate(r1.xyz * float3(5,5,5) + r0.xyz);
  r0.x = min(0.899999976, gIM2DConstants.x);
  r0.y = w1.x + -r0.x;
  r0.y = max(0, r0.y);
  r0.x = 1 + -r0.x;
  r0.x = r0.y / r0.x;
  r0.x = -0.5 + r0.x;
  r0.x = r0.x + r0.x;
  r0.x = max(0, r0.x);
  r0.x = 1 + -r0.x;
  r0.x = max(0.200000003, r0.x);
  r1.w = saturate(r0.w * r0.x);
  r0.xyzw = DiffuseSampler.Sample(DiffuseSampler_s, v1.xy).xyzw;
  r0.xyzw = r0.xyzw * r1.xyzw;
  r1.xy = v2.xy / v2.ww;
  r1.zw = cmp(float2(0.5,0.5) < gvMaskUseFlags.xy);
  if (r1.z != 0) {
    r2.xy = cmp(r1.xy >= gvMaskAPositionMinMax.xw);
    r2.zw = cmp(gvMaskAPositionMinMax.zy >= r1.xy);
    r2.xy = r2.zw ? r2.xy : 0;
    r1.z = r2.y ? r2.x : 0;
    r2.xy = -gvMaskAPositionMinMax.xy + r1.xy;
    r2.xy = gvMaskAUVDifference.xy * r2.xy;
    r2.zw = gvMaskAUVStartEnd.zw + -gvMaskAUVStartEnd.xy;
    r2.xy = r2.xy * r2.zw + gvMaskAUVStartEnd.xy;
    r2.xyzw = MaskSampler0.Sample(MaskSampler0_s, r2.xy).wxyz;
    if (r1.z == 0) {
      r2.x = 0;
    }
  } else {
    r2.x = 1;
  }
  if (r1.w != 0) {
    r1.zw = cmp(r1.xy >= gvMaskBPositionMinMax.xw);
    r2.yz = cmp(gvMaskBPositionMinMax.zy >= r1.xy);
    r1.zw = r1.zw ? r2.yz : 0;
    r1.z = r1.w ? r1.z : 0;
    r1.xy = -gvMaskBPositionMinMax.xy + r1.xy;
    r1.xy = gvMaskBUVDifference.xy * r1.xy;
    r2.yz = gvMaskBUVStartEnd.zw + -gvMaskBUVStartEnd.xy;
    r1.xy = r1.xy * r2.yz + gvMaskBUVStartEnd.xy;
    r3.xyzw = MaskSampler1.Sample(MaskSampler1_s, r1.xy).xyzw;
    if (r1.z != 0) {
      r2.x = r3.w * r2.x;
    } else {
      r2.x = 0;
    }
  }
  o0.w = r2.x * r0.w;
  o0.xyz = r0.xyz;
  return;
}