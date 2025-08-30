// ---- Created with 3Dmigoto v1.3.16 on Wed Aug 20 15:45:17 2025
Texture3D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb13 : register(b13)
{
  float4 cb13[4];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[8];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0,
  out float o1 : SV_TARGET1)
{
  const float4 icb[] = { { 1.000000, 0, 0, 0},
                              { 1.000000, 0.250000, 0, 0},
                              { 1.000000, 1.000000, 0, 0},
                              { 0, 1.000000, 0, 0},
                              { 0, 0.250000, 1.000000, 0},
                              { 0, 1.000000, 1.000000, 0},
                              { 1.000000, 1.000000, 1.000000, 0} };
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb2[1].xy + v1.xy;
  r0.z = 1 + -cb2[2].x;
  r0.w = cmp(0 < cb2[2].w);
  if (r0.w != 0) {
    r1.xy = cb2[3].xy * float2(0.5,0.5) + float2(0.5,0.5);
    r2.xy = cb2[0].xy * cb2[0].wz;
    r2.z = 1;
    r1.zw = r2.zy * r1.xy;
    r3.xy = r0.xy * r2.zy + -r1.zw;
    r0.w = dot(r3.xy, r3.xy);
    r0.w = (uint)r0.w >> 1;
    r0.w = (int)r0.w + 0x1fbd1df5;
    r1.z = -3 * cb2[2].w;
    r3.xy = r3.xy / r0.ww;
    r0.w = r1.z * r0.w;
    r2.w = r0.w * r0.w;
    r2.w = 0.0662999973 * r2.w;
    r2.w = abs(r0.w) * -0.178399995 + -r2.w;
    r2.w = 1.03009999 + r2.w;
    r0.w = r2.w * r0.w;
    r3.xy = r3.xy * r0.ww;
    r3.xy = r3.xy * r1.ww;
    r0.w = r1.z * r1.w;
    r1.z = r0.w * r0.w;
    r1.z = 0.0662999973 * r1.z;
    r1.z = abs(r0.w) * -0.178399995 + -r1.z;
    r1.z = 1.03009999 + r1.z;
    r0.w = r1.z * r0.w;
    r1.zw = r3.xy / r0.ww;
    r1.xy = r1.xy * r2.zy + r1.zw;
    r0.xy = r1.xy * r2.zx;
  }
  r1.xyzw = r0.xyxy * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r1.xyzw = -cb2[3].xyxy + r1.xyzw;
  r0.w = dot(r1.zw, r1.zw);
  r0.w = (uint)r0.w >> 1;
  r0.w = (int)r0.w + 0x1fbd1df5;
  r0.w = max(0, r0.w);
  r2.x = cmp(r0.z < r0.w);
  if (r2.x != 0) {
    r2.xw = float2(1,1) + -cb2[2].zz;
    r3.x = 1 + -r0.z;
    r0.z = r0.w + -r0.z;
    r3.x = 1 / r3.x;
    r0.z = saturate(r3.x * r0.z);
    r3.x = r0.z * -2 + 3;
    r0.z = r0.z * r0.z;
    r0.z = r3.x * r0.z;
    r0.z = cb2[2].y * r0.z;
    r1.xyzw = r0.zzzz * r1.xyzw;
    r0.z = 1 + -cb2[3].z;
    r3.x = 1 + -r0.w;
    r0.w = r3.x / r0.w;
    r0.z = r0.w * cb2[3].z + r0.z;
    r1.xyzw = r1.xyzw * r0.zzzz;
    r0.zw = r0.yx * float2(1024,1024) + float2(-512,-512);
    r3.xy = float2(0.554549694,0.308517009) * r0.wz;
    r3.xy = frac(r3.xy);
    r0.zw = r0.wz * r3.xy + r0.zw;
    r0.z = r0.z * r0.w;
    r0.z = frac(r0.z);
    r0.z = r0.z * 2 + -1;
    r3.xyzw = r0.zzzz * float4(0.100000001,0.100000001,0.100000001,0.100000001) + float4(-1,-0.600000024,-0.199999988,0.200000048);
    r4.xyzw = -r1.zwzw * r3.xxyy + r0.xyxy;
    r5.xyz = t0.SampleLevel(s0_s, r4.xy, 0).xyz;
    r0.z = min(1, -r3.x);
    r0.w = 1 + -r2.x;
    r2.y = r0.z * r0.w + r2.x;
    r6.xyz = r3.xzy * cb2[2].zzz + float3(1,1,1);
    r2.z = r6.x;
    r4.xyz = t0.SampleLevel(s0_s, r4.zw, 0).xyz;
    r7.xy = -r3.yz * r0.ww + r2.xx;
    r7.z = r6.z;
    r7.w = 1 + -cb2[2].z;
    r4.xyz = r7.xzw * r4.xyz;
    r4.xyz = r2.yzw * r5.xyz + r4.xyz;
    r2.yzw = r7.xzw + r2.yzw;
    r1.xyzw = -r1.xyzw * r3.zzww + r0.xyxy;
    r3.xyz = t0.SampleLevel(s0_s, r1.xy, 0).xyz;
    r6.xz = r7.yw;
    r3.xyz = r6.xyz * r3.xyz + r4.xyz;
    r2.yzw = r6.xyz + r2.yzw;
    r1.xyz = t0.SampleLevel(s0_s, r1.zw, 0).xyz;
    r4.y = r3.w * -cb2[2].z + 1;
    r4.z = r3.w * r0.w + r2.x;
    r4.x = 1 + -cb2[2].z;
    r1.xyz = r4.xyz * r1.xyz + r3.xyz;
    r2.xyz = r4.xyz + r2.yzw;
    r1.xyz = r1.xyz / r2.xyz;
  } else {
    r1.xyz = t0.SampleLevel(s0_s, r0.xy, 0).xyz;
  }
  r0.x = cmp(asint(cb2[7].z) != 3);
  if (r0.x != 0) {
    switch (cb2[7].x) {
      case 1 :      r0.x = dot(float3(0.212599993,0.715200007,0.0722000003), r1.xyz);
      switch (cb2[7].z) {
        case 2 :        r0.y = log2(r0.x);
        r0.y = r0.y * 0.693147182 + 9.2103405;
        r0.y = max(0, r0.y);
        r0.y = 0.0492605828 * r0.y;
        r0.y = min(1, r0.y);
        r0.y = r0.y * 360 + 300;
        r0.y = 0.00278551527 * r0.y;
        r0.y = frac(r0.y);
        r0.z = 5.98333359 * r0.y;
        r0.z = floor(r0.z);
        r0.y = r0.y * 5.98333359 + -r0.z;
        r2.z = 1 + -r0.y;
        r3.y = 1 + -r2.z;
        r4.xyzw = cmp(r0.zzzz == float4(0,1,2,3));
        r0.y = cmp(r0.z == 4.000000);
        r2.xy = float2(1,0);
        r5.xy = r4.ww ? r2.yz : r3.yy;
        r0.y = (int)r0.y | (int)r4.w;
        r3.xz = float2(1,0);
        r5.z = 1;
        r5.xyz = r4.zzz ? r3.zxy : r5.xyz;
        r0.y = (int)r0.y | (int)r4.z;
        r5.xyz = r4.yyy ? r2.zxy : r5.xyz;
        r0.y = (int)r0.y | (int)r4.y;
        r3.xyz = r4.xxx ? r3.xyz : r5.xyz;
        r0.y = (int)r0.y | (int)r4.x;
        r1.xyz = r0.yyy ? r3.xyz : r2.xyz;
        break;
        case 3 :        break;
        default :
        r0.x = cb13[3].x * r0.x;
        r0.x = log2(r0.x);
        r0.xy = float2(5.97393131,7.97393131) + r0.xx;
        r0.x = (int)r0.x;
        r0.x = max(0, (int)r0.x);
        r0.x = min(6, (int)r0.x);
        r0.y = saturate(0.5 * r0.y);
        r0.y = r0.x ? 1 : r0.y;
        r1.xyz = icb[r0.x+0].xyz * r0.yyy;
        break;
      }
      break;
      default :
      r0.xyz = cmp(r1.xyz < cb13[0].xxx);
      r2.xyzw = r0.xxxx ? cb13[2].xyzw : cb13[1].xyzw;
      r0.xw = r2.xy * r1.xx + r2.zw;
      r1.x = saturate(r0.x / r0.w);
      r2.xyzw = r0.yyyy ? cb13[2].xyzw : cb13[1].xyzw;
      r0.xy = r2.xy * r1.yy + r2.zw;
      r1.y = saturate(r0.x / r0.y);
      r0.xyzw = r0.zzzz ? cb13[2].xyzw : cb13[1].xyzw;
      r0.xy = r0.xy * r1.zz + r0.zw;
      r1.z = saturate(r0.x / r0.y);
      break;
    }
    r0.x = saturate(dot(r1.xyz, cb2[4].xyz));
    r0.y = saturate(dot(r1.xyz, cb2[5].xyz));
    r0.z = saturate(dot(r1.xyz, cb2[6].xyz));
    r0.xyz = log2(r0.xyz);
    r0.xyz = float3(0.416666657,0.416666657,0.416666657) * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r0.xyz = r0.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
    r0.xyz = max(float3(0,0,0), r0.xyz);
    r0.w = asint(cb2[7].w) & 1;
    r2.xyz = cmp(float3(0.998039186,0.998039186,0.998039186) < r0.xyz);
    r3.xyz = cmp(r0.xyz < float3(0.00196078443,0.00196078443,0.00196078443));
    r2.w = (int)r2.y | (int)r2.x;
    r2.w = (int)r2.z | (int)r2.w;
    r3.w = (int)r3.y | (int)r3.x;
    r3.w = (int)r3.z | (int)r3.w;
    r2.w = (int)r2.w | (int)r3.w;
    r3.xyz = r3.xyz ? float3(1,1,1) : 0;
    r2.xyz = r2.xyz ? float3(-1,-1,-1) : float3(-0,-0,-0);
    r2.xyz = r3.xyz + r2.xyz;
    r2.xyz = r2.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5);
    r0.w = r0.w ? r2.w : 0;
    r0.xyz = r0.www ? r2.xyz : r0.xyz;
    r0.xyz = r0.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
    r1.xyz = t1.SampleLevel(s1_s, r0.xyz, 0).xyz;
    r1.w = dot(r1.xyz, float3(0.212599993,0.715200007,0.0722000003));
  } else {
    r1.w = 1;
  }
  o0.xyzw = r1.xyzw;
  o1.x = r1.w;
  return;
}