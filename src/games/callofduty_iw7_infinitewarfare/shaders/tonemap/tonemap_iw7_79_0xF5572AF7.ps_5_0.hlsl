// ---- Created with 3Dmigoto v1.3.16 on Wed Aug 20 15:45:44 2025
Buffer<float4> t14 : register(t14);

Texture2D<uint4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture3D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb13 : register(b13)
{
  float4 cb13[4];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[20];
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
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb2[4].xy + v1.xy;
  r0.z = 1 + -cb2[5].x;
  r0.w = cmp(0 < cb2[5].w);
  if (r0.w != 0) {
    r1.xy = cb2[6].xy * float2(0.5,0.5) + float2(0.5,0.5);
    r2.xy = cb2[1].xy * cb2[1].wz;
    r2.z = 1;
    r1.zw = r2.zy * r1.xy;
    r3.xy = r0.xy * r2.zy + -r1.zw;
    r0.w = dot(r3.xy, r3.xy);
    r0.w = (uint)r0.w >> 1;
    r0.w = (int)r0.w + 0x1fbd1df5;
    r1.z = -3 * cb2[5].w;
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
    r1.xy = r1.xy * r2.zx;
  } else {
    r1.xy = r0.xy;
  }
  r2.xyzw = r1.xyxy * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r2.xyzw = -cb2[6].xyxy + r2.xyzw;
  r0.w = dot(r2.zw, r2.zw);
  r0.w = (uint)r0.w >> 1;
  r0.w = (int)r0.w + 0x1fbd1df5;
  r0.w = max(0, r0.w);
  r1.z = cmp(r0.z < r0.w);
  if (r1.z != 0) {
    r3.xw = float2(1,1) + -cb2[5].zz;
    r1.z = 1 + -r0.z;
    r0.z = r0.w + -r0.z;
    r1.z = 1 / r1.z;
    r0.z = saturate(r1.z * r0.z);
    r1.z = r0.z * -2 + 3;
    r0.z = r0.z * r0.z;
    r0.z = r1.z * r0.z;
    r0.z = cb2[5].y * r0.z;
    r2.xyzw = r0.zzzz * r2.xyzw;
    r0.z = 1 + -cb2[6].z;
    r1.z = 1 + -r0.w;
    r0.w = r1.z / r0.w;
    r0.z = r0.w * cb2[6].z + r0.z;
    r2.xyzw = r2.xyzw * r0.zzzz;
    r0.zw = r1.yx * float2(1024,1024) + float2(-512,-512);
    r1.zw = float2(0.554549694,0.308517009) * r0.wz;
    r1.zw = frac(r1.zw);
    r0.zw = r0.wz * r1.zw + r0.zw;
    r0.z = r0.z * r0.w;
    r0.z = frac(r0.z);
    r0.z = r0.z * 2 + -1;
    r4.xyzw = r0.zzzz * float4(0.100000001,0.100000001,0.100000001,0.100000001) + float4(-1,-0.600000024,-0.199999988,0.200000048);
    r5.xyzw = -r2.zwzw * r4.xxyy + r1.xyxy;
    r6.xyz = t0.SampleLevel(s0_s, r5.xy, 0).xyz;
    r0.z = min(1, -r4.x);
    r0.w = 1 + -r3.x;
    r3.y = r0.z * r0.w + r3.x;
    r7.xyz = r4.xzy * cb2[5].zzz + float3(1,1,1);
    r3.z = r7.x;
    r5.xyz = t0.SampleLevel(s0_s, r5.zw, 0).xyz;
    r8.xy = -r4.yz * r0.ww + r3.xx;
    r8.z = r7.z;
    r8.w = 1 + -cb2[5].z;
    r5.xyz = r8.xzw * r5.xyz;
    r5.xyz = r3.yzw * r6.xyz + r5.xyz;
    r3.yzw = r8.xzw + r3.yzw;
    r2.xyzw = -r2.xyzw * r4.zzww + r1.xyxy;
    r4.xyz = t0.SampleLevel(s0_s, r2.xy, 0).xyz;
    r7.xz = r8.yw;
    r4.xyz = r7.xyz * r4.xyz + r5.xyz;
    r3.yzw = r7.xyz + r3.yzw;
    r2.xyz = t0.SampleLevel(s0_s, r2.zw, 0).xyz;
    r5.y = r4.w * -cb2[5].z + 1;
    r5.z = r4.w * r0.w + r3.x;
    r5.x = 1 + -cb2[5].z;
    r2.xyz = r5.xyz * r2.xyz + r4.xyz;
    r3.xyz = r5.xyz + r3.yzw;
    r2.xyz = r2.xyz / r3.xyz;
  } else {
    r2.xyz = t0.SampleLevel(s0_s, r1.xy, 0).xyz;
  }
  r0.z = cmp(asint(cb2[11].z) != 3);
  if (r0.z != 0) {
    r0.zw = cb2[4].wz + r0.yx;
    r1.xy = cb2[2].xy * r0.wz;
    r1.yz = (uint2)r1.xy;
    r1.x = (uint)r1.y >> 1;
    r1.w = 0;
    r1.x = t5.Load(r1.xzw).x;
    r3.x = (int)r1.y & 1;
    r3.y = (uint)r1.x >> 4;
    r1.x = r3.x ? r3.y : r1.x;
    r3.x = (int)r1.x & 2;
    r3.yz = asint(cb2[11].yw) & int2(1,1);
    if (r3.y != 0) {
      r4.xyz = t2.Sample(s2_s, r0.xy).xyz;
      r4.xyz = cb2[10].xxx * r4.xyz;
      r2.xyz = cb2[10].yyy * r2.xyz + r4.xyz;
    }
    switch (cb2[11].x) {
      case 1 :      r0.x = dot(float3(0.212599993,0.715200007,0.0722000003), r2.xyz);
      switch (cb2[11].z) {
        case 2 :        r0.y = log2(r0.x);
        r0.y = r0.y * 0.693147182 + 9.2103405;
        r0.y = max(0, r0.y);
        r0.y = 0.0492605828 * r0.y;
        r0.y = min(1, r0.y);
        r0.y = r0.y * 360 + 300;
        r0.y = 0.00278551527 * r0.y;
        r0.y = frac(r0.y);
        r3.y = 5.98333359 * r0.y;
        r3.y = floor(r3.y);
        r0.y = r0.y * 5.98333359 + -r3.y;
        r4.z = 1 + -r0.y;
        r5.y = 1 + -r4.z;
        r6.xyzw = cmp(r3.yyyy == float4(0,1,2,3));
        r0.y = cmp(r3.y == 4.000000);
        r4.xy = float2(1,0);
        r7.xy = r6.ww ? r4.yz : r5.yy;
        r0.y = (int)r0.y | (int)r6.w;
        r5.xz = float2(1,0);
        r7.z = 1;
        r7.xyz = r6.zzz ? r5.zxy : r7.xyz;
        r0.y = (int)r0.y | (int)r6.z;
        r7.xyz = r6.yyy ? r4.zxy : r7.xyz;
        r0.y = (int)r0.y | (int)r6.y;
        r5.xyz = r6.xxx ? r5.xyz : r7.xyz;
        r0.y = (int)r0.y | (int)r6.x;
        r2.xyz = r0.yyy ? r5.xyz : r4.xyz;
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
        r2.xyz = icb[r0.x+0].xyz * r0.yyy;
        break;
      }
      break;
      default :
      r4.xyz = cmp(r2.xyz < cb13[0].xxx);
      r5.xyzw = r4.xxxx ? cb13[2].xyzw : cb13[1].xyzw;
      r0.xy = r5.xy * r2.xx + r5.zw;
      r2.x = saturate(r0.x / r0.y);
      r5.xyzw = r4.yyyy ? cb13[2].xyzw : cb13[1].xyzw;
      r0.xy = r5.xy * r2.yy + r5.zw;
      r2.y = saturate(r0.x / r0.y);
      r4.xyzw = r4.zzzz ? cb13[2].xyzw : cb13[1].xyzw;
      r0.xy = r4.xy * r2.zz + r4.zw;
      r2.z = saturate(r0.x / r0.y);
      break;
    }
    r4.x = saturate(dot(r2.xyz, cb2[7].xyz));
    r4.y = saturate(dot(r2.xyz, cb2[8].xyz));
    r4.z = saturate(dot(r2.xyz, cb2[9].xyz));
    r4.xyz = log2(r4.xyz);
    r4.xyz = float3(0.416666657,0.416666657,0.416666657) * r4.xyz;
    r4.xyz = exp2(r4.xyz);
    r4.xyz = r4.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
    r4.xyz = max(float3(0,0,0), r4.xyz);
    r5.xyz = cmp(float3(0.998039186,0.998039186,0.998039186) < r4.xyz);
    r6.xyz = cmp(r4.xyz < float3(0.00196078443,0.00196078443,0.00196078443));
    r0.x = (int)r5.y | (int)r5.x;
    r0.x = (int)r5.z | (int)r0.x;
    r0.y = (int)r6.y | (int)r6.x;
    r0.y = (int)r6.z | (int)r0.y;
    r0.x = (int)r0.y | (int)r0.x;
    r6.xyz = r6.xyz ? float3(1,1,1) : 0;
    r5.xyz = r5.xyz ? float3(-1,-1,-1) : float3(-0,-0,-0);
    r5.xyz = r6.xyz + r5.xyz;
    r5.xyz = r5.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5);
    r0.x = r3.z ? r0.x : 0;
    r3.yzw = r0.xxx ? r5.xyz : r4.xyz;
    r3.yzw = r3.yzw * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
    r2.xyz = t3.SampleLevel(s3_s, r3.yzw, 0).xyz;
    if (r3.x != 0) {
      r0.xy = (int2)r1.xx & int2(4,8);
      r0.x = cmp((int)r0.x != 0);
      r1.xy = t4.Load(r1.yzw).xy;
      r1.xy = float2(255.5,255.100006) * r1.yx;
      r1.xy = (uint2)r1.xy;
      r1.x = (uint)r1.x << 11;
      bitmask.x = ((~(-1 << 8)) << 3) & 0xffffffff;  r1.x = (((uint)r1.y << 3) & bitmask.x) | ((uint)r1.x & ~bitmask.x);
      r1.y = (int)r1.x + 2;
      r1.y = t14.Load(r1.y).x;
      r1.y = cmp(0 < r1.y);
      r0.y = cmp((int)r0.y == 0);
      r0.x = r0.y ? r0.x : 0;
      r0.y = t14.Load(r1.x).w;
      r0.y = cmp(0 < r0.y);
      r0.x = r0.y ? r0.x : 0;
      if (r0.x != 0) {
        if (r1.y != 0) {
          r1.xyz = cb2[17].xyz;
          r3.xyz = cb2[16].xyz;
        } else {
          r1.xyz = cb2[15].xyz;
          r3.xyz = cb2[14].xyz;
        }
        r0.x = cb2[12].x;
        r0.y = cb2[13].y;
        r4.xyz = t1.Gather(s1_s, r0.wz).xzw;
        r5.xy = abs(r4.zz) + -abs(r4.yx);
        r5.z = abs(r4.z) * 0.000250000012 + 2.32830644e-010;
        r1.w = dot(r5.xyz, r5.xyz);
        r1.w = (uint)r1.w >> 1;
        r1.w = (int)-r1.w + 0x5f3759df;
        r1.w = r5.z * r1.w;
        r1.w = min(1, r1.w);
      } else {
        r1.xyz = cb2[19].xyz;
        r3.xyz = cb2[18].xyz;
        r0.x = cb2[12].y;
        r0.y = cb2[13].z;
        r1.w = dot(r2.xyz, float3(0.212599993,0.715200007,0.0722000003));
      }
      r4.xy = cb2[0].yx + r0.zw;
      r4.xy = r4.xy * float2(1024,1024) + float2(-512,-512);
      r4.zw = float2(0.554549694,0.308517009) * r4.yx;
      r4.zw = frac(r4.zw);
      r4.xy = r4.yx * r4.zw + r4.xy;
      r3.w = r4.x * r4.y;
      r3.w = frac(r3.w);
      r3.w = r3.w * 2 + -1;
      r3.w = r3.w * r0.y + 1;
      r1.w = saturate(r3.w * r1.w);
      r1.w = (int)r1.w;
      r1.w = -1.06529242e+009 + r1.w;
      r0.x = r0.x * r1.w + 1.06529242e+009;
      r0.x = (int)r0.x;
      r0.x = saturate(r0.x);
      r1.xyz = r1.xyz + -r3.xyz;
      r1.xyz = r0.xxx * r1.xyz + r3.xyz;
      r0.xz = cb2[0].ww * r0.zw;
      r0.xz = frac(r0.xz);
      r0.xz = r0.xz * float2(1024,1024) + float2(-512,-512);
      r3.xy = float2(0.554549694,0.308517009) * r0.zx;
      r3.xy = frac(r3.xy);
      r0.xz = r0.zx * r3.xy + r0.xz;
      r0.x = r0.x * r0.z;
      r0.x = frac(r0.x);
      r0.x = r0.x * 2 + -1;
      r0.x = r0.x * r0.y + 1;
      r2.xyz = saturate(r1.xyz * r0.xxx);
    }
    r2.w = dot(r2.xyz, float3(0.212599993,0.715200007,0.0722000003));
  } else {
    r2.w = 1;
  }
  o0.xyzw = r2.xyzw;
  o1.x = r2.w;
  return;
}