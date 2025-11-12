// ---- Created with 3Dmigoto v1.3.16 on Tue Nov 11 02:11:30 2025

cbuffer gObjectCB : register(b1)
{
  float4 WindowSize : packoffset(c0);
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
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  [branch]
  if (!CUSTOM_FXAA) {
    o0 = DiffuseSampler.SampleLevel(DiffuseSampler_s, v1.xy, 0).xyzw;
    return;
  }

  const float interScale = renodx::color::srgb::Encode(RENODX_INTERMEDIATE_SCALING);
  r0.xyzw = DiffuseSampler.SampleLevel(DiffuseSampler_s, v1.xy, 0).xyzw * interScale;
  r1.xyzw = WindowSize.zwzw * float4(0,1,1,0) + v1.xyxy;
  r2.xyzw = DiffuseSampler.SampleLevel(DiffuseSampler_s, r1.xy, 0).xyzw * interScale;
  r1.xyzw = DiffuseSampler.SampleLevel(DiffuseSampler_s, r1.zw, 0).xyzw * interScale;
  r3.xyzw = WindowSize.zwzw * float4(0,-1,-1,0) + v1.xyxy;
  r4.xyzw = DiffuseSampler.SampleLevel(DiffuseSampler_s, r3.xy, 0).xyzw * interScale;
  r3.xyzw = DiffuseSampler.SampleLevel(DiffuseSampler_s, r3.zw, 0).xyzw * interScale;
  r1.x = max(r2.w, r0.w);
  r1.y = min(r2.w, r0.w);
  r1.x = max(r1.w, r1.x);
  r1.y = min(r1.w, r1.y);
  r1.z = max(r4.w, r3.w);
  r2.x = min(r4.w, r3.w);
  r1.x = max(r1.z, r1.x);
  r1.y = min(r2.x, r1.y);
  r1.z = 0.165999994 * r1.x;
  r1.x = r1.x + -r1.y;
  r1.y = max(0.0833000019, r1.z);
  r1.y = cmp(r1.x >= r1.y);
  if (r1.y != 0) {
    r1.yz = -WindowSize.zw + v1.xy;
    r5.xyzw = DiffuseSampler.SampleLevel(DiffuseSampler_s, r1.yz, 0).xyzw * interScale;
    r1.yz = WindowSize.zw + v1.xy;
    r6.xyzw = DiffuseSampler.SampleLevel(DiffuseSampler_s, r1.yz, 0).xyzw * interScale;
    r7.xyzw = WindowSize.zwzw * float4(1,-1,-1,1) + v1.xyxy;
    r8.xyzw = DiffuseSampler.SampleLevel(DiffuseSampler_s, r7.xy, 0).xyzw * interScale;
    r7.xyzw = DiffuseSampler.SampleLevel(DiffuseSampler_s, r7.zw, 0).xyzw * interScale;
    r1.y = r4.w + r2.w;
    r1.z = r3.w + r1.w;
    r1.x = 1 / r1.x;
    r2.x = r1.y + r1.z;
    r1.y = r0.w * -2 + r1.y;
    r1.z = r0.w * -2 + r1.z;
    r2.y = r8.w + r6.w;
    r2.z = r8.w + r5.w;
    r3.x = r1.w * -2 + r2.y;
    r2.z = r4.w * -2 + r2.z;
    r3.y = r7.w + r5.w;
    r3.z = r7.w + r6.w;
    r1.y = abs(r1.y) * 2 + abs(r3.x);
    r1.z = abs(r1.z) * 2 + abs(r2.z);
    r2.z = r3.w * -2 + r3.y;
    r3.x = r2.w * -2 + r3.z;
    r1.y = abs(r2.z) + r1.y;
    r1.z = abs(r3.x) + r1.z;
    r2.y = r3.y + r2.y;
    r1.y = cmp(r1.y >= r1.z);
    r1.z = r2.x * 2 + r2.y;
    r2.x = r1.y ? r4.w : r3.w;
    r1.w = r1.y ? r2.w : r1.w;
    r2.y = r1.y ? WindowSize.w : WindowSize.z;
    r1.z = r1.z * 0.0833333358 + -r0.w;
    r2.z = r2.x + -r0.w;
    r2.w = r1.w + -r0.w;
    r2.x = r2.x + r0.w;
    r1.w = r1.w + r0.w;
    r3.x = cmp(abs(r2.z) >= abs(r2.w));
    r2.z = max(abs(r2.z), abs(r2.w));
    r2.y = r3.x ? -r2.y : r2.y;
    r1.x = saturate(abs(r1.z) * r1.x);
    r1.z = r1.y ? WindowSize.z : 0;
    r2.w = r1.y ? 0 : WindowSize.w;
    r3.yz = r2.yy * float2(0.5,0.5) + v1.xy;
    r3.y = r1.y ? v1.x : r3.y;
    r3.z = r1.y ? r3.z : v1.y;
    r4.x = r3.y + -r1.z;
    r4.y = r3.z + -r2.w;
    r5.x = r3.y + r1.z;
    r5.y = r3.z + r2.w;
    r3.y = r1.x * -2 + 3;
    r6.xyzw = DiffuseSampler.SampleLevel(DiffuseSampler_s, r4.xy, 0).xyzw * interScale;
    r1.x = r1.x * r1.x;
    r7.xyzw = DiffuseSampler.SampleLevel(DiffuseSampler_s, r5.xy, 0).xyzw * interScale;
    r1.w = r3.x ? r2.x : r1.w;
    r2.x = 0.25 * r2.z;
    r2.z = -r1.w * 0.5 + r0.w;
    r1.x = r3.y * r1.x;
    r2.z = cmp(r2.z < 0);
    r3.y = -r1.w * 0.5 + r6.w;
    r3.x = -r1.w * 0.5 + r7.w;
    r4.zw = cmp(abs(r3.yx) >= r2.xx);
    r5.z = -r1.z * 1.5 + r4.x;
    r5.z = r4.z ? r4.x : r5.z;
    r4.x = -r2.w * 1.5 + r4.y;
    r5.w = r4.z ? r4.y : r4.x;
    r4.xy = ~(int2)r4.zw;
    r4.x = (int)r4.y | (int)r4.x;
    r4.y = r1.z * 1.5 + r5.x;
    r6.x = r4.w ? r5.x : r4.y;
    r4.y = r2.w * 1.5 + r5.y;
    r6.y = r4.w ? r5.y : r4.y;
    if (r4.x != 0) {
      if (r4.z == 0) {
        r7.xyzw = DiffuseSampler.SampleLevel(DiffuseSampler_s, r5.zw, 0).wxyz * interScale;
      } else {
        r7.x = r3.y;
      }
      if (r4.w == 0) {
        r3.xyzw = DiffuseSampler.SampleLevel(DiffuseSampler_s, r6.xy, 0).wxyz * interScale;
      }
      r4.x = -r1.w * 0.5 + r7.x;
      r3.y = r4.z ? r7.x : r4.x;
      r4.x = -r1.w * 0.5 + r3.x;
      r3.x = r4.w ? r3.x : r4.x;
      r4.xy = cmp(abs(r3.yx) >= r2.xx);
      r4.z = -r1.z * 2 + r5.z;
      r5.z = r4.x ? r5.z : r4.z;
      r4.z = -r2.w * 2 + r5.w;
      r5.w = r4.x ? r5.w : r4.z;
      r4.zw = ~(int2)r4.xy;
      r4.z = (int)r4.w | (int)r4.z;
      r4.w = r1.z * 2 + r6.x;
      r6.x = r4.y ? r6.x : r4.w;
      r4.w = r2.w * 2 + r6.y;
      r6.y = r4.y ? r6.y : r4.w;
      if (r4.z != 0) {
        if (r4.x == 0) {
          r7.xyzw = DiffuseSampler.SampleLevel(DiffuseSampler_s, r5.zw, 0).wxyz * interScale;
        } else {
          r7.x = r3.y;
        }
        if (r4.y == 0) {
          r3.xyzw = DiffuseSampler.SampleLevel(DiffuseSampler_s, r6.xy, 0).wxyz * interScale;
        }
        r4.z = -r1.w * 0.5 + r7.x;
        r3.y = r4.x ? r7.x : r4.z;
        r4.x = -r1.w * 0.5 + r3.x;
        r3.x = r4.y ? r3.x : r4.x;
        r4.xy = cmp(abs(r3.yx) >= r2.xx);
        r4.z = -r1.z * 4 + r5.z;
        r5.z = r4.x ? r5.z : r4.z;
        r4.z = -r2.w * 4 + r5.w;
        r5.w = r4.x ? r5.w : r4.z;
        r4.zw = ~(int2)r4.xy;
        r4.z = (int)r4.w | (int)r4.z;
        r4.w = r1.z * 4 + r6.x;
        r6.x = r4.y ? r6.x : r4.w;
        r4.w = r2.w * 4 + r6.y;
        r6.y = r4.y ? r6.y : r4.w;
        if (r4.z != 0) {
          if (r4.x == 0) {
            r7.xyzw = DiffuseSampler.SampleLevel(DiffuseSampler_s, r5.zw, 0).wxyz * interScale;
          } else {
            r7.x = r3.y;
          }
          if (r4.y == 0) {
            r3.xyzw = DiffuseSampler.SampleLevel(DiffuseSampler_s, r6.xy, 0).wxyz * interScale;
          }
          r3.z = -r1.w * 0.5 + r7.x;
          r3.y = r4.x ? r7.x : r3.z;
          r1.w = -r1.w * 0.5 + r3.x;
          r3.x = r4.y ? r3.x : r1.w;
          r3.zw = cmp(abs(r3.yx) >= r2.xx);
          r1.w = -r1.z * 12 + r5.z;
          r5.z = r3.z ? r5.z : r1.w;
          r1.w = -r2.w * 12 + r5.w;
          r5.w = r3.z ? r5.w : r1.w;
          r1.z = r1.z * 12 + r6.x;
          r6.x = r3.w ? r6.x : r1.z;
          r1.z = r2.w * 12 + r6.y;
          r6.y = r3.w ? r6.y : r1.z;
        }
      }
    }
    r1.z = v1.x + -r5.z;
    r1.w = -v1.x + r6.x;
    r2.x = v1.y + -r5.w;
    r1.z = r1.y ? r1.z : r2.x;
    r2.x = -v1.y + r6.y;
    r1.w = r1.y ? r1.w : r2.x;
    r2.xw = cmp(r3.yx < float2(0,0));
    r3.x = r1.w + r1.z;
    r2.xz = cmp((int2)r2.xw != (int2)r2.zz);
    r2.w = 1 / r3.x;
    r3.x = cmp(r1.z < r1.w);
    r1.z = min(r1.z, r1.w);
    r1.w = r3.x ? r2.x : r2.z;
    r1.x = r1.x * r1.x;
    r1.z = r1.z * -r2.w + 0.5;
    r1.x = 0.75 * r1.x;
    r1.z = (int)r1.z & (int)r1.w;
    r1.x = max(r1.z, r1.x);
    r1.xz = r1.xx * r2.yy + v1.xy;
    r2.x = r1.y ? v1.x : r1.x;
    r2.y = r1.y ? r1.z : v1.y;
    r1.xyzw = DiffuseSampler.SampleLevel(DiffuseSampler_s, r2.xy, 0).xyzw * interScale;
    r0.xyz = r1.xyz;
  }
  o0.xyzw = r0.xyzw / interScale;
  return;
}