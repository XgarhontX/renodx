// ---- Created with 3Dmigoto v1.3.16 on Wed Aug 20 15:43:21 2025
Buffer<float4> t14 : register(t14);

Texture2D<uint4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture3D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb13 : register(b13)
{
  float4 cb13[4];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[17];
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
  r0.z = cmp(asint(cb2[8].z) != 3);
  if (r0.z != 0) {
    r0.xy = cb2[4].wz + r0.xy;
    r0.zw = cb2[2].xy * r0.yx;
    r2.yz = (uint2)r0.zw;
    r2.x = (uint)r2.y >> 1;
    r2.w = 0;
    r0.z = t4.Load(r2.xzw).x;
    r0.w = (int)r2.y & 1;
    r2.x = (uint)r0.z >> 4;
    r0.z = r0.w ? r2.x : r0.z;
    r0.zw = (int2)r0.zz & int2(4,8);
    r0.z = cmp((int)r0.z != 0);
    switch (cb2[8].x) {
      case 1 :      r2.x = dot(float3(0.212599993,0.715200007,0.0722000003), r1.xyz);
      switch (cb2[8].z) {
        case 2 :        r3.x = log2(r2.x);
        r3.x = r3.x * 0.693147182 + 9.2103405;
        r3.x = max(0, r3.x);
        r3.x = 0.0492605828 * r3.x;
        r3.x = min(1, r3.x);
        r3.x = r3.x * 360 + 300;
        r3.x = 0.00278551527 * r3.x;
        r3.x = frac(r3.x);
        r3.y = 5.98333359 * r3.x;
        r3.y = floor(r3.y);
        r3.x = r3.x * 5.98333359 + -r3.y;
        r4.z = 1 + -r3.x;
        r5.y = 1 + -r4.z;
        r6.xyzw = cmp(r3.yyyy == float4(0,1,2,3));
        r3.x = cmp(r3.y == 4.000000);
        r4.xy = float2(1,0);
        r7.xy = r6.ww ? r4.yz : r5.yy;
        r3.x = (int)r3.x | (int)r6.w;
        r5.xz = float2(1,0);
        r7.z = 1;
        r3.yzw = r6.zzz ? r5.zxy : r7.xyz;
        r3.x = (int)r3.x | (int)r6.z;
        r3.yzw = r6.yyy ? r4.zxy : r3.yzw;
        r3.x = (int)r3.x | (int)r6.y;
        r3.yzw = r6.xxx ? r5.xyz : r3.yzw;
        r3.x = (int)r3.x | (int)r6.x;
        r1.xyz = r3.xxx ? r3.yzw : r4.xyz;
        break;
        case 3 :        break;
        default :
        r2.x = cb13[3].x * r2.x;
        r2.x = log2(r2.x);
        r3.xy = float2(5.97393131,7.97393131) + r2.xx;
        r2.x = (int)r3.x;
        r2.x = max(0, (int)r2.x);
        r2.x = min(6, (int)r2.x);
        r3.x = saturate(0.5 * r3.y);
        r3.x = r2.x ? 1 : r3.x;
        r1.xyz = icb[r2.x+0].xyz * r3.xxx;
        break;
      }
      break;
      default :
      r3.xyz = cmp(r1.xyz < cb13[0].xxx);
      r4.xyzw = r3.xxxx ? cb13[2].xyzw : cb13[1].xyzw;
      r3.xw = r4.xy * r1.xx + r4.zw;
      r1.x = saturate(r3.x / r3.w);
      r4.xyzw = r3.yyyy ? cb13[2].xyzw : cb13[1].xyzw;
      r3.xy = r4.xy * r1.yy + r4.zw;
      r1.y = saturate(r3.x / r3.y);
      r3.xyzw = r3.zzzz ? cb13[2].xyzw : cb13[1].xyzw;
      r3.xy = r3.xy * r1.zz + r3.zw;
      r1.z = saturate(r3.x / r3.y);
      break;
    }
    r2.xy = t3.Load(r2.yzw).xy;
    r2.xy = float2(255.5,255.100006) * r2.yx;
    r2.xy = (uint2)r2.xy;
    r2.x = (uint)r2.x << 11;
    bitmask.x = ((~(-1 << 8)) << 3) & 0xffffffff;  r2.x = (((uint)r2.y << 3) & bitmask.x) | ((uint)r2.x & ~bitmask.x);
    r0.w = cmp((int)r0.w == 0);
    r0.z = r0.w ? r0.z : 0;
    r0.w = t14.Load(r2.x).w;
    r0.w = cmp(0 < r0.w);
    r0.z = r0.w ? r0.z : 0;
    if (r0.z != 0) {
      r0.z = (int)r2.x + 2;
      r0.z = t14.Load(r0.z).x;
      r0.z = cmp(0 < r0.z);
      if (r0.z != 0) {
        r2.xyz = cb2[14].xyz;
        r3.xyz = cb2[13].xyz;
      } else {
        r2.xyz = cb2[12].xyz;
        r3.xyz = cb2[11].xyz;
      }
      r0.z = cb2[9].x;
      r0.w = cb2[10].y;
      r4.xyz = t1.Gather(s1_s, r0.yx).xzw;
      r5.xy = abs(r4.zz) + -abs(r4.yx);
      r5.z = abs(r4.z) * 0.000250000012 + 2.32830644e-010;
      r2.w = dot(r5.xyz, r5.xyz);
      r2.w = (uint)r2.w >> 1;
      r2.w = (int)-r2.w + 0x5f3759df;
      r2.w = r5.z * r2.w;
      r2.w = min(1, r2.w);
    } else {
      r2.xyz = cb2[16].xyz;
      r3.xyz = cb2[15].xyz;
      r0.z = cb2[9].y;
      r0.w = cb2[10].z;
      r4.x = saturate(dot(r1.xyz, cb2[5].xyz));
      r4.y = saturate(dot(r1.xyz, cb2[6].xyz));
      r4.z = saturate(dot(r1.xyz, cb2[7].xyz));
      r4.xyz = log2(r4.xyz);
      r4.xyz = float3(0.416666657,0.416666657,0.416666657) * r4.xyz;
      r4.xyz = exp2(r4.xyz);
      r4.xyz = r4.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
      r4.xyz = max(float3(0,0,0), r4.xyz);
      r3.w = asint(cb2[8].w) & 1;
      r5.xyz = cmp(float3(0.998039186,0.998039186,0.998039186) < r4.xyz);
      r6.xyz = cmp(r4.xyz < float3(0.00196078443,0.00196078443,0.00196078443));
      r4.w = (int)r5.y | (int)r5.x;
      r4.w = (int)r5.z | (int)r4.w;
      r5.w = (int)r6.y | (int)r6.x;
      r5.w = (int)r6.z | (int)r5.w;
      r4.w = (int)r4.w | (int)r5.w;
      r6.xyz = r6.xyz ? float3(1,1,1) : 0;
      r5.xyz = r5.xyz ? float3(-1,-1,-1) : float3(-0,-0,-0);
      r5.xyz = r6.xyz + r5.xyz;
      r5.xyz = r5.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5);
      r3.w = r3.w ? r4.w : 0;
      r4.xyz = r3.www ? r5.xyz : r4.xyz;
      r4.xyz = r4.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
      r4.xyz = t2.SampleLevel(s2_s, r4.xyz, 0).xyz;
      r2.w = dot(r4.xyz, float3(0.212599993,0.715200007,0.0722000003));
    }
    r4.xy = cb2[0].yx + r0.xy;
    r4.xy = r4.xy * float2(1024,1024) + float2(-512,-512);
    r4.zw = float2(0.554549694,0.308517009) * r4.yx;
    r4.zw = frac(r4.zw);
    r4.xy = r4.yx * r4.zw + r4.xy;
    r3.w = r4.x * r4.y;
    r3.w = frac(r3.w);
    r3.w = r3.w * 2 + -1;
    r3.w = r3.w * r0.w + 1;
    r2.w = saturate(r3.w * r2.w);
    r2.w = (int)r2.w;
    r2.w = -1.06529242e+009 + r2.w;
    r0.z = r0.z * r2.w + 1.06529242e+009;
    r0.z = (int)r0.z;
    r0.z = saturate(r0.z);
    r2.xyz = r2.xyz + -r3.xyz;
    r2.xyz = r0.zzz * r2.xyz + r3.xyz;
    r0.xy = cb2[0].ww * r0.xy;
    r0.xy = frac(r0.xy);
    r0.xy = r0.xy * float2(1024,1024) + float2(-512,-512);
    r3.xy = float2(0.554549694,0.308517009) * r0.yx;
    r3.xy = frac(r3.xy);
    r0.xy = r0.yx * r3.xy + r0.xy;
    r0.x = r0.x * r0.y;
    r0.x = frac(r0.x);
    r0.x = r0.x * 2 + -1;
    r0.x = r0.x * r0.w + 1;
    r1.xyz = saturate(r2.xyz * r0.xxx);
    r1.w = dot(r1.xyz, float3(0.212599993,0.715200007,0.0722000003));
  } else {
    r1.w = 1;
  }
  o0.xyzw = r1.xyzw;
  o1.x = r1.w;
  return;
}