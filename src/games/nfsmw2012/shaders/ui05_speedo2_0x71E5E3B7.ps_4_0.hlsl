// ---- Created with 3Dmigoto v1.3.16 on Tue Nov 11 02:11:24 2025

cbuffer gMaterialCB : register(b2)
{
  float kInnerIntensity : packoffset(c0) = {0.75};
  float kOuterIntensity : packoffset(c0.y) = {0.100000001};
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
  float2 w3 : TEXCOORD3,
  float4 v4 : TEXCOORD4,
  float4 v5 : TEXCOORD5,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

if (!CUSTOM_IS_UI) discard;
  r0.xyzw = w3.xyxy/* zw */ * float4(-1.29999995,1.29999995,1.29999995,-1.29999995) + v3.xyxy;
  r1.xyzw = DiffuseSampler.SampleBias(DiffuseSampler_s, r0.zw, 1).xyzw;
  r2.xyzw = -v4.xyxy + r0.xyzw;
  r0.xyzw = DiffuseSampler.SampleBias(DiffuseSampler_s, r0.xy, 1).xyzw;
  r2.xyzw = -v4.zwzw + abs(r2.xyzw);
  r2.xy = max(r2.xz, r2.yw);
  r2.xy = cmp(r2.xy >= float2(0,0));
  r1.xyzw = r2.yyyy ? float4(0,0,0,0) : r1.xyzw;
  r1.w = kOuterIntensity * r1.w;
  r2.zw = v3.xy + w3.xy;
  r3.xyzw = DiffuseSampler.SampleBias(DiffuseSampler_s, r2.zw, 1).xyzw;
  r2.zw = -v4.xy + r2.zw;
  r2.zw = -v4.zw + abs(r2.zw);
  r2.z = max(r2.z, r2.w);
  r2.z = cmp(r2.z >= 0);
  r3.xyzw = r2.zzzz ? float4(0,0,0,0) : r3.xyzw;
  r3.xyzw = float4(1,1,1,0.125) * r3.xyzw;
  r4.xyzw = kOuterIntensity * r3.xyzw;
  r3.xyzw = kInnerIntensity * r3.xyzw;
  r3.xyzw = r2.zzzz ? float4(0,0,0,0) : r3.xyzw;
  r4.xyzw = r2.zzzz ? float4(0,0,0,0) : r4.xyzw;
  r0.xyzw = r2.xxxx ? float4(0,0,0,0) : r0.xyzw;
  r0.w = kOuterIntensity * r0.w;
  r5.x = kOuterIntensity;
  r5.w = 0.125;
  r0.xyzw = r0.xyzw * r5.xxxw + r4.xyzw;
  r0.xyzw = r2.xxxx ? r4.xyzw : r0.xyzw;
  r1.xyzw = r1.xyzw * r5.xxxw + r0.xyzw;
  r0.xyzw = r2.yyyy ? r0.xyzw : r1.xyzw;
  r1.xw = w3.xy;
  r1.yz = float2(0,0);
  r2.xyzw = r1.xwxz * float4(-1.29999995,-1.29999995,1.29999995,1.29999995) + v3.xyxy;
  r4.xyzw = -v4.xyxy + r2.xyzw;
  r4.xyzw = -v4.zwzw + abs(r4.xyzw);
  r4.xy = max(r4.xz, r4.yw);
  r4.xy = cmp(r4.xy >= float2(0,0));
  r6.xyzw = DiffuseSampler.SampleBias(DiffuseSampler_s, r2.xy, 1).xyzw;
  r2.xyzw = DiffuseSampler.SampleBias(DiffuseSampler_s, r2.zw, 1).xyzw;
  r2.xyzw = r4.yyyy ? float4(0,0,0,0) : r2.xyzw;
  r6.xyzw = r4.xxxx ? float4(0,0,0,0) : r6.xyzw;
  r6.w = kOuterIntensity * r6.w;
  r6.xyzw = r6.xyzw * r5.xxxw + r0.xyzw;
  r0.xyzw = r4.xxxx ? r0.xyzw : r6.xyzw;
  r2.w = kOuterIntensity * r2.w;
  r2.xyzw = r2.xyzw * r5.xxxw + r0.xyzw;
  r0.xyzw = r4.yyyy ? r0.xyzw : r2.xyzw;
  r2.xy = r1.xy * float2(-1.29999995,1.29999995) + v3.xy;
  r1.xyzw = v3.xyxy + r1.xyzw;
  r2.zw = -v4.xy + r2.xy;
  r4.xyzw = DiffuseSampler.SampleBias(DiffuseSampler_s, r2.xy, 1).xyzw;
  r2.xy = -v4.zw + abs(r2.zw);
  r2.x = max(r2.x, r2.y);
  r2.x = cmp(r2.x >= 0);
  r4.xyzw = r2.xxxx ? float4(0,0,0,0) : r4.xyzw;
  r4.w = kOuterIntensity * r4.w;
  r4.xyzw = r4.xyzw * r5.xxxw + r0.xyzw;
  r0.xyzw = r2.xxxx ? r0.xyzw : r4.xyzw;
  r2.w = w3.y;
  r2.xz = float2(0,1.29999995);
  r2.zw = float2(0,1.29999995) * r2.zw + v3.xy;
  r4.xyzw = DiffuseSampler.SampleBias(DiffuseSampler_s, r2.zw, 1).xyzw;
  r2.zw = -v4.xy + r2.zw;
  r2.zw = -v4.zw + abs(r2.zw);
  r2.z = max(r2.z, r2.w);
  r2.z = cmp(r2.z >= 0);
  r4.xyzw = r2.zzzz ? float4(0,0,0,0) : r4.xyzw;
  r4.w = kOuterIntensity * r4.w;
  r6.xyzw = r4.xyzw * r5.xxxw + r0.xyzw;
  r6.xyzw = r2.zzzz ? r0.xyzw : r6.xyzw;
  r4.xyzw = r4.xyzw * r5.xxxw + r6.xyzw;
  r0.xyzw = r2.zzzz ? r0.xyzw : r4.xyzw;
  r4.xyzw = w3.xyxy/* zw */ * float4(-1,1,1,-1) + v3.xyxy;
  r5.xyzw = DiffuseSampler.SampleBias(DiffuseSampler_s, r4.xy, 1).xyzw;
  r6.xyzw = -v4.xyxy + r4.xyzw;
  r4.xyzw = DiffuseSampler.SampleBias(DiffuseSampler_s, r4.zw, 1).xyzw;
  r6.xyzw = -v4.zwzw + abs(r6.xyzw);
  r2.zw = max(r6.xz, r6.yw);
  r2.zw = cmp(r2.zw >= float2(0,0));
  r5.xyzw = r2.zzzz ? float4(0,0,0,0) : r5.xyzw;
  r5.w = kInnerIntensity * r5.w;
  r6.x = kInnerIntensity;
  r6.w = 0.125;
  r5.xyzw = r5.xyzw * r6.xxxw + r3.xyzw;
  r3.xyzw = r2.zzzz ? r3.xyzw : r5.xyzw;
  r4.xyzw = r2.wwww ? float4(0,0,0,0) : r4.xyzw;
  r4.w = kInnerIntensity * r4.w;
  r4.xyzw = r4.xyzw * r6.xxxw + r3.xyzw;
  r3.xyzw = r2.wwww ? r3.xyzw : r4.xyzw;
  r4.xyz = -w3.xxx/* xyz */;
  r4.w = 0;
  r4.xyzw = v3.xyxy + r4.xyzw;
  r5.xyzw = DiffuseSampler.SampleBias(DiffuseSampler_s, r4.xy, 1).xyzw;
  r7.xyzw = -v4.xyxy + r4.xyzw;
  r4.xyzw = DiffuseSampler.SampleBias(DiffuseSampler_s, r4.zw, 1).xyzw;
  r7.xyzw = -v4.zwzw + abs(r7.xyzw);
  r2.zw = max(r7.xz, r7.yw);
  r2.zw = cmp(r2.zw >= float2(0,0));
  r5.xyzw = r2.zzzz ? float4(0,0,0,0) : r5.xyzw;
  r5.w = kInnerIntensity * r5.w;
  r5.xyzw = r5.xyzw * r6.xxxw + r3.xyzw;
  r3.xyzw = r2.zzzz ? r3.xyzw : r5.xyzw;
  r5.xyzw = DiffuseSampler.SampleBias(DiffuseSampler_s, r1.xy, 1).xyzw;
  r7.xyzw = -v4.xyxy + r1.xyzw;
  r1.xyzw = DiffuseSampler.SampleBias(DiffuseSampler_s, r1.zw, 1).xyzw;
  r7.xyzw = -v4.zwzw + abs(r7.xyzw);
  r6.yz = max(r7.xz, r7.yw);
  r6.yz = cmp(r6.yz >= float2(0,0));
  r5.xyzw = r6.yyyy ? float4(0,0,0,0) : r5.xyzw;
  r5.w = kInnerIntensity * r5.w;
  r5.xyzw = r5.xyzw * r6.xxxw + r3.xyzw;
  r3.xyzw = r6.yyyy ? r3.xyzw : r5.xyzw;
  r4.xyzw = r2.wwww ? float4(0,0,0,0) : r4.xyzw;
  r4.w = kInnerIntensity * r4.w;
  r4.xyzw = r4.xyzw * r6.xxxw + r3.xyzw;
  r3.xyzw = r2.wwww ? r3.xyzw : r4.xyzw;
  r1.xyzw = r6.zzzz ? float4(0,0,0,0) : r1.xyzw;
  r1.w = kInnerIntensity * r1.w;
  r1.xyzw = r1.xyzw * r6.xxxw + r3.xyzw;
  r1.xyzw = r6.zzzz ? r3.xyzw : r1.xyzw;
  r2.y = -w3.y;
  r2.xy = v3.xy + r2.xy;
  r3.xyzw = DiffuseSampler.SampleBias(DiffuseSampler_s, r2.xy, 1).xyzw;
  r2.xy = -v4.xy + r2.xy;
  r2.xy = -v4.zw + abs(r2.xy);
  r2.x = max(r2.x, r2.y);
  r2.x = cmp(r2.x >= 0);
  r3.xyzw = r2.xxxx ? float4(0,0,0,0) : r3.xyzw;
  r3.w = kInnerIntensity * r3.w;
  r3.xyzw = r3.xyzw * r6.xxxw + r1.xyzw;
  r1.xyzw = r2.xxxx ? r1.xyzw : r3.xyzw;
  r0.xyzw = r1.xyzw + r0.xyzw;
  r0.xyzw = v5.xyzw * r0.xyzw;
  r1.xy = -v4.xy + v3.xy;
  r1.xy = -v4.zw + abs(r1.xy);
  r1.x = max(r1.x, r1.y);
  r1.x = cmp(r1.x >= 0);
  r2.xyzw = DiffuseSampler.Sample(DiffuseSampler_s, v3.xy).xyzw;
  r1.xyzw = r1.xxxx ? float4(0,0,0,0) : r2.xyzw;
  r2.x = 1 + -r1.w;
  r0.xyzw = r2.xxxx * r0.xyzw;
  r2.x = r1.w;
  r2.yzw = v2.xyz;
  r1.xyzw = r2.yzwx * r1.xyzw;
  r2.w = v2.w;
  o0.xyzw = r1.xyzw * r2.xxxw + r0.xyzw;
  // o0 = renodx::color::srgba::Encode(o0);
  o0.xyz = renodx::color::srgb::Encode(o0.xyz);
  return;
}