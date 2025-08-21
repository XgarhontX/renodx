// ---- Created with 3Dmigoto v1.3.16 on Wed Aug 20 15:45:37 2025
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
  float4 cb2[19];
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

  r0.xy = cb2[4].yx + v1.yx;
  r1.xyz = t0.Sample(s0_s, r0.yx).xyz;
  r0.z = cmp(asint(cb2[10].z) != 3);
  if (r0.z != 0) {
    r0.zw = cb2[4].wz + r0.xy;
    r2.xy = cb2[2].xy * r0.wz;
    r2.yz = (uint2)r2.xy;
    r2.x = (uint)r2.y >> 1;
    r2.w = 0;
    r2.x = t5.Load(r2.xzw).x;
    r3.x = (int)r2.y & 1;
    r3.y = (uint)r2.x >> 4;
    r2.x = r3.x ? r3.y : r2.x;
    r3.x = (int)r2.x & 2;
    r3.yz = asint(cb2[10].yw) & int2(1,1);
    if (r3.y != 0) {
      r4.xyz = t2.Sample(s2_s, r0.yx).xyz;
      r4.xyz = cb2[9].xxx * r4.xyz;
      r1.xyz = cb2[9].yyy * r1.xyz + r4.xyz;
    }
    switch (cb2[10].x) {
      case 1 :      r3.y = dot(float3(0.212599993,0.715200007,0.0722000003), r1.xyz);
      switch (cb2[10].z) {
        case 2 :        r3.w = log2(r3.y);
        r3.w = r3.w * 0.693147182 + 9.2103405;
        r3.w = max(0, r3.w);
        r3.w = 0.0492605828 * r3.w;
        r3.w = min(1, r3.w);
        r3.w = r3.w * 360 + 300;
        r3.w = 0.00278551527 * r3.w;
        r3.w = frac(r3.w);
        r4.x = 5.98333359 * r3.w;
        r4.x = floor(r4.x);
        r3.w = r3.w * 5.98333359 + -r4.x;
        r5.z = 1 + -r3.w;
        r6.y = 1 + -r5.z;
        r7.xyzw = cmp(r4.xxxx == float4(0,1,2,3));
        r3.w = cmp(r4.x == 4.000000);
        r5.xy = float2(1,0);
        r4.xy = r7.ww ? r5.yz : r6.yy;
        r3.w = (int)r3.w | (int)r7.w;
        r6.xz = float2(1,0);
        r4.z = 1;
        r4.xyz = r7.zzz ? r6.zxy : r4.xyz;
        r3.w = (int)r3.w | (int)r7.z;
        r4.xyz = r7.yyy ? r5.zxy : r4.xyz;
        r3.w = (int)r3.w | (int)r7.y;
        r4.xyz = r7.xxx ? r6.xyz : r4.xyz;
        r3.w = (int)r3.w | (int)r7.x;
        r1.xyz = r3.www ? r4.xyz : r5.xyz;
        break;
        case 3 :        break;
        default :
        r3.y = cb13[3].x * r3.y;
        r3.y = log2(r3.y);
        r3.yw = float2(5.97393131,7.97393131) + r3.yy;
        r3.y = (int)r3.y;
        r3.y = max(0, (int)r3.y);
        r3.y = min(6, (int)r3.y);
        r3.w = saturate(0.5 * r3.w);
        r3.w = r3.y ? 1 : r3.w;
        r1.xyz = icb[r3.y+0].xyz * r3.www;
        break;
      }
      break;
      default :
      r4.xyz = cmp(r1.xyz < cb13[0].xxx);
      r5.xyzw = r4.xxxx ? cb13[2].xyzw : cb13[1].xyzw;
      r3.yw = r5.xy * r1.xx + r5.zw;
      r1.x = saturate(r3.y / r3.w);
      r5.xyzw = r4.yyyy ? cb13[2].xyzw : cb13[1].xyzw;
      r3.yw = r5.xy * r1.yy + r5.zw;
      r1.y = saturate(r3.y / r3.w);
      r4.xyzw = r4.zzzz ? cb13[2].xyzw : cb13[1].xyzw;
      r3.yw = r4.xy * r1.zz + r4.zw;
      r1.z = saturate(r3.y / r3.w);
      break;
    }
    r4.x = saturate(dot(r1.xyz, cb2[6].xyz));
    r4.y = saturate(dot(r1.xyz, cb2[7].xyz));
    r4.z = saturate(dot(r1.xyz, cb2[8].xyz));
    r4.xyz = log2(r4.xyz);
    r4.xyz = float3(0.416666657,0.416666657,0.416666657) * r4.xyz;
    r4.xyz = exp2(r4.xyz);
    r4.xyz = r4.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
    r4.xyz = max(float3(0,0,0), r4.xyz);
    r5.xyz = cmp(float3(0.998039186,0.998039186,0.998039186) < r4.xyz);
    r6.xyz = cmp(r4.xyz < float3(0.00196078443,0.00196078443,0.00196078443));
    r3.y = (int)r5.y | (int)r5.x;
    r3.y = (int)r5.z | (int)r3.y;
    r3.w = (int)r6.y | (int)r6.x;
    r3.w = (int)r6.z | (int)r3.w;
    r3.y = (int)r3.w | (int)r3.y;
    r6.xyz = r6.xyz ? float3(1,1,1) : 0;
    r5.xyz = r5.xyz ? float3(-1,-1,-1) : float3(-0,-0,-0);
    r5.xyz = r6.xyz + r5.xyz;
    r5.xyz = r5.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5);
    r3.y = r3.z ? r3.y : 0;
    r3.yzw = r3.yyy ? r5.xyz : r4.xyz;
    r3.yzw = r3.yzw * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
    r3.yzw = t3.SampleLevel(s3_s, r3.yzw, 0).xyz;
    if (r3.x != 0) {
      r4.xy = (int2)r2.xx & int2(4,8);
      r2.x = cmp((int)r4.x != 0);
      r2.yz = t4.Load(r2.yzw).xy;
      r2.yz = float2(255.5,255.100006) * r2.zy;
      r2.yz = (uint2)r2.yz;
      r2.y = (uint)r2.y << 11;
      bitmask.y = ((~(-1 << 8)) << 3) & 0xffffffff;  r2.y = (((uint)r2.z << 3) & bitmask.y) | ((uint)r2.y & ~bitmask.y);
      r2.z = (int)r2.y + 2;
      r2.z = t14.Load(r2.z).x;
      r2.z = cmp(0 < r2.z);
      r2.w = cmp((int)r4.y == 0);
      r2.x = r2.w ? r2.x : 0;
      r2.y = t14.Load(r2.y).w;
      r2.y = cmp(0 < r2.y);
      r2.x = r2.y ? r2.x : 0;
      if (r2.x != 0) {
        if (r2.z != 0) {
          r2.xyz = cb2[16].xyz;
          r4.xyz = cb2[15].xyz;
        } else {
          r2.xyz = cb2[14].xyz;
          r4.xyz = cb2[13].xyz;
        }
        r2.w = cb2[11].x;
        r3.x = cb2[12].y;
        r5.xyz = t1.Gather(s1_s, r0.wz).xzw;
        r6.xy = abs(r5.zz) + -abs(r5.yx);
        r6.z = abs(r5.z) * 0.000250000012 + 2.32830644e-010;
        r4.w = dot(r6.xyz, r6.xyz);
        r4.w = (uint)r4.w >> 1;
        r4.w = (int)-r4.w + 0x5f3759df;
        r4.w = r6.z * r4.w;
        r4.w = min(1, r4.w);
      } else {
        r2.xyz = cb2[18].xyz;
        r4.xyz = cb2[17].xyz;
        r2.w = cb2[11].y;
        r3.x = cb2[12].z;
        r4.w = dot(r3.yzw, float3(0.212599993,0.715200007,0.0722000003));
      }
      r5.xy = cb2[0].yx + r0.zw;
      r5.xy = r5.xy * float2(1024,1024) + float2(-512,-512);
      r5.zw = float2(0.554549694,0.308517009) * r5.yx;
      r5.zw = frac(r5.zw);
      r5.xy = r5.yx * r5.zw + r5.xy;
      r5.x = r5.x * r5.y;
      r5.x = frac(r5.x);
      r5.x = r5.x * 2 + -1;
      r5.x = r5.x * r3.x + 1;
      r4.w = saturate(r5.x * r4.w);
      r4.w = (int)r4.w;
      r4.w = -1.06529242e+009 + r4.w;
      r2.w = r2.w * r4.w + 1.06529242e+009;
      r2.w = (int)r2.w;
      r2.w = saturate(r2.w);
      r2.xyz = -r4.xyz + r2.xyz;
      r2.xyz = r2.www * r2.xyz + r4.xyz;
      r0.zw = cb2[0].ww * r0.zw;
      r0.zw = frac(r0.zw);
      r0.zw = r0.zw * float2(1024,1024) + float2(-512,-512);
      r4.xy = float2(0.554549694,0.308517009) * r0.wz;
      r4.xy = frac(r4.xy);
      r0.zw = r0.wz * r4.xy + r0.zw;
      r0.z = r0.z * r0.w;
      r0.z = frac(r0.z);
      r0.z = r0.z * 2 + -1;
      r0.z = r0.z * r3.x + 1;
      r3.yzw = saturate(r2.xyz * r0.zzz);
    }
    r1.w = dot(r3.yzw, float3(0.212599993,0.715200007,0.0722000003));
    r0.z = min(r3.y, r3.z);
    r0.w = max(r3.y, r3.z);
    r0.w = min(r0.w, r3.w);
    r0.z = max(r0.z, r0.w);
    r0.w = -0.100000001 + r0.z;
    r0.w = saturate(-10 * r0.w);
    r2.x = r0.w * -2 + 3;
    r0.w = r0.w * r0.w;
    r0.z = r2.x * r0.w + r0.z;
    r0.xy = cb2[0].ww * r0.xy;
    r0.xy = frac(r0.xy);
    r0.xy = r0.xy * float2(1024,1024) + float2(-512,-512);
    r2.xy = float2(0.554549694,0.308517009) * r0.yx;
    r2.xy = frac(r2.xy);
    r0.xy = r0.yx * r2.xy + r0.xy;
    r0.xz = r0.xz * r0.yz;
    r0.x = frac(r0.x);
    r0.x = r0.x * 2 + -1;
    r0.y = min(1, r0.z);
    r0.x = r0.y * -r0.x + r0.x;
    r0.x = cb2[5].y * r0.x;
    r1.xyz = r3.yzw * r0.xxx + r3.yzw;
  } else {
    r1.w = 1;
  }
  o0.xyzw = r1.xyzw;
  o1.x = r1.w;
  return;
}