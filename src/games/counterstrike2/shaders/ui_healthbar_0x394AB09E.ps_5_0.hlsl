// ---- Created with 3Dmigoto v1.3.16 on Thu Oct 02 18:13:15 2025
#include "../shared.h"

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[10];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float4 v3 : TEXCOORD3,
  float4 v4 : TEXCOORD4,
  float4 v5 : TEXCOORD5,
  float4 v6 : TEXCOORD6,
  float4 v7 : TEXCOORD7,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = ddx_coarse(v0.xy);
  r0.zw = ddy_coarse(v0.xy);
  r1.xyz = cmp(int3(1,2,2) == asint(cb0[7].wwy));
  r1.x = (int)r1.y | (int)r1.x;
  if (r1.x != 0) {
    r2.xyzw = t0.SampleGrad(s0_s, v0.xy, r0.xyxx, r0.zwzz).xyzw;
  } else {
    r1.x = cmp(3 == asint(cb0[7].w));
    if (r1.x != 0) {
      r2.w = t0.SampleGrad(s0_s, v0.xy, r0.x, r0.z).w;
      r2.xyz = r2.www;
    } else {
      r1.x = cmp(4 == asint(cb0[7].w));
      if (r1.x != 0) {
        r0.xyzw = t4.SampleGrad(s0_s, v0.xy, r0.xyxx, r0.zwzz).xyzw;
        r0.z = r0.z * 31.875 + 1;
        r0.xy = float2(-0.501960814,-0.501960814) + r0.yx;
        r0.xy = r0.xy / r0.zz;
        r3.yz = r0.ww + r0.yx;
        r3.x = r3.y + -r0.x;
        r0.y = r0.w + -r0.y;
        r3.w = r0.y + -r0.x;
        r0.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r3.xzw;
        r4.xyz = r3.xzw * float3(0.947867334,0.947867334,0.947867334) + float3(0.0521326996,0.0521326996,0.0521326996);
        r4.xyz = log2(r4.xyz);
        r4.xyz = float3(2.4000001,2.4000001,2.4000001) * r4.xyz;
        r4.xyz = exp2(r4.xyz);
        r3.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r3.xzw);
        r2.xyz = r3.xyz ? r0.xyz : r4.xyz;
      } else {
        r2.xyz = float3(1,1,1);
      }
      r2.w = 1;
    }
  }
  r0.x = min(r2.y, r2.z);
  r0.x = min(r2.x, r0.x);
  r0.y = max(r2.y, r2.z);
  r0.y = max(r2.x, r0.y);
  r0.x = r0.y + -r0.x;
  r0.z = cmp(r0.x != 0.000000);
  r3.y = r0.x / r0.y;
  r4.xyz = r0.yyy + -r2.xyz;
  r4.xyz = r4.xyz / r0.xxx;
  r4.xyz = r4.xyz + -r4.zxy;
  r0.xw = float2(2,4) + r4.xy;
  r1.xw = cmp(r2.xy >= r0.yy);
  r0.x = r1.w ? r0.x : r0.w;
  r0.x = r1.x ? r4.z : r0.x;
  r0.x = 0.166666672 * r0.x;
  r3.x = frac(r0.x);
  r0.xz = r0.zz ? r3.xy : 0;
  r0.x = cb0[5].x + r0.x;
  r0.x = frac(r0.x);
  r0.w = cb0[5].y * r0.z;
  r1.x = cb0[5].z * r0.y;
  r1.w = cmp(0 < r2.w);
  r3.x = cmp(1 < cb0[5].w);
  r1.w = (int)r1.w | (int)r3.x;
  r0.y = r0.y * cb0[5].z + -0.5;
  r0.y = cb0[5].w * r0.y + 0.5;
  r3.z = r1.w ? r0.y : r1.x;
  r0.y = cmp(r0.w != 0.000000);
  r1.x = 6 * r0.x;
  r1.x = floor(r1.x);
  r0.z = -r0.z * cb0[5].y + 1;
  r3.x = r3.z * r0.z;
  r0.x = r0.x * 6 + -r1.x;
  r0.z = -r0.w * r0.x + 1;
  r0.x = 1 + -r0.x;
  r0.x = -r0.w * r0.x + 1;
  r3.yw = r3.zz * r0.xz;
  r4.xyzw = cmp(r1.xxxx == float4(0,1,2,3));
  r0.x = cmp(r1.x == 4.000000);
  r5.xz = r0.xx ? r3.yz : r3.zw;
  r5.y = r3.x;
  r0.xzw = r4.www ? r3.xwz : r5.xyz;
  r0.xzw = r4.zzz ? r3.xzy : r0.xzw;
  r0.xzw = r4.yyy ? r3.wzx : r0.xzw;
  r0.xzw = r4.xxx ? r3.zyx : r0.xzw;
  r0.xyz = r0.yyy ? r0.xzw : r3.zzz;
  r3.xyz = r0.xyz * r2.www;
  r2.xyz = r1.yyy ? r3.xyz : r0.xyz;
  if (r1.z != 0) {
    r0.x = saturate(v0.z);
    r0.x = r0.x * 0.999023438 + 0.00048828125;
    r0.y = 0;
    r0.xyzw = t3.SampleLevel(s0_s, r0.xy, 0).xyzw;
    r0.xyzw = r2.xyzw * r0.xyzw;
  } else {
    r1.x = cmp(1 == asint(cb0[7].y));
    r1.y = saturate(v0.z);
    r3.xyzw = v4.xyzw + -v3.xyzw;
    r3.xyzw = r1.yyyy * r3.xyzw + v3.xyzw;
    r3.xyzw = r3.xyzw * r2.xyzw;
    r2.xyzw = v3.xyzw * r2.xyzw;
    r0.xyzw = r1.xxxx ? r3.xyzw : r2.xyzw;
  }
  if (cb0[7].z != 0) {
    r1.xyzw = t1.Sample(s0_s, v7.xy).wxyz;
    if (cb0[9].y != 0) {
      r1.y = dot(r1.yzw, float3(0.212500006,0.715399981,0.0720999986));
      r1.x = r1.x * r1.y;
    }
    r1.y = cmp(0 < cb0[6].z);
    r1.z = 1 + -r1.x;
    r1.x = r1.y ? r1.x : r1.z;
    r1.y = -abs(cb0[6].z) + 1;
    r1.x = r1.x * abs(cb0[6].z) + r1.y;
    o0.xyzw = r1.xxxx * r0.xyzw;
  } else {
    o0.xyzw = r0.xyzw;
  }

  o0.xyz *= CUSTOM_UI_HEALTHBARMUTLIPLIER;
  return;
}