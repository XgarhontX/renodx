// ---- Created with 3Dmigoto v1.3.16 on Wed Aug 20 15:43:34 2025
Buffer<float4> t14 : register(t14);

Texture2D<uint4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

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
  float4 cb2[15];
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
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb2[3].yx + v1.yx;
  r1.xyz = t0.Sample(s0_s, r0.yx).xyz;
  r0.z = cmp(asint(cb2[8].z) != 3);
  if (r0.z != 0) {
    r0.zw = cb2[3].wz + r0.xy;
    r2.xy = cb2[2].xy * r0.wz;
    r2.yz = (uint2)r2.xy;
    r2.x = (uint)r2.y >> 1;
    r2.w = 0;
    r3.x = t3.Load(r2.xzw).x;
    r3.y = (int)r2.y & 1;
    r3.z = (uint)r3.x >> 4;
    r3.x = r3.y ? r3.z : r3.x;
    r3.z = (int)r3.x & 4;
    switch (cb2[8].x) {
      case 1 :      r3.w = dot(float3(0.212599993,0.715200007,0.0722000003), r1.xyz);
      switch (cb2[8].z) {
        case 2 :        r4.x = log2(r3.w);
        r4.x = r4.x * 0.693147182 + 9.2103405;
        r4.x = max(0, r4.x);
        r4.x = 0.0492605828 * r4.x;
        r4.x = min(1, r4.x);
        r4.x = r4.x * 360 + 300;
        r4.x = 0.00278551527 * r4.x;
        r4.x = frac(r4.x);
        r4.y = 5.98333359 * r4.x;
        r4.y = floor(r4.y);
        r4.x = r4.x * 5.98333359 + -r4.y;
        r5.z = 1 + -r4.x;
        r6.y = 1 + -r5.z;
        r7.xyzw = cmp(r4.yyyy == float4(0,1,2,3));
        r4.x = cmp(r4.y == 4.000000);
        r5.xy = float2(1,0);
        r8.xy = r7.ww ? r5.yz : r6.yy;
        r4.x = (int)r4.x | (int)r7.w;
        r6.xz = float2(1,0);
        r8.z = 1;
        r4.yzw = r7.zzz ? r6.zxy : r8.xyz;
        r4.x = (int)r4.x | (int)r7.z;
        r4.yzw = r7.yyy ? r5.zxy : r4.yzw;
        r4.x = (int)r4.x | (int)r7.y;
        r4.yzw = r7.xxx ? r6.xyz : r4.yzw;
        r4.x = (int)r4.x | (int)r7.x;
        r1.xyz = r4.xxx ? r4.yzw : r5.xyz;
        break;
        case 3 :        break;
        default :
        r3.w = cb13[3].x * r3.w;
        r3.w = log2(r3.w);
        r4.xy = float2(5.97393131,7.97393131) + r3.ww;
        r3.w = (int)r4.x;
        r3.w = max(0, (int)r3.w);
        r3.w = min(6, (int)r3.w);
        r4.x = saturate(0.5 * r4.y);
        r4.x = r3.w ? 1 : r4.x;
        r1.xyz = icb[r3.w+0].xyz * r4.xxx;
        break;
      }
      break;
      default :
      r4.xyz = cmp(r1.xyz < cb13[0].xxx);
      r5.xyzw = r4.xxxx ? cb13[2].xyzw : cb13[1].xyzw;
      r4.xw = r5.xy * r1.xx + r5.zw;
      r1.x = saturate(r4.x / r4.w);
      r5.xyzw = r4.yyyy ? cb13[2].xyzw : cb13[1].xyzw;
      r4.xy = r5.xy * r1.yy + r5.zw;
      r1.y = saturate(r4.x / r4.y);
      r4.xyzw = r4.zzzz ? cb13[2].xyzw : cb13[1].xyzw;
      r4.xy = r4.xy * r1.zz + r4.zw;
      r1.z = saturate(r4.x / r4.y);
      break;
    }
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
    r4.xyz = t1.SampleLevel(s1_s, r4.xyz, 0).xyz;
    if (r3.z != 0) {
      r3.x = (int)r3.x & 8;
      r3.zw = t2.Load(r2.yzw).xy;
      r3.zw = float2(255.5,255.100006) * r3.wz;
      r3.zw = (uint2)r3.zw;
      r3.z = (uint)r3.z << 11;
      bitmask.z = ((~(-1 << 8)) << 3) & 0xffffffff;  r3.z = (((uint)r3.w << 3) & bitmask.z) | ((uint)r3.z & ~bitmask.z);
      r5.xy = (int2)r3.zz + int2(1,2);
      r5.xz = t14.Load(r5.x).yw;
      r5.yw = t14.Load(r5.y).yz;
      r6.xyzw = t14.Load(r3.z).xyzw;
      r3.zw = cmp(float2(0,0) < r5.yw);
      r4.w = r3.x ? 1 : 0;
      r3.z = r3.z ? r4.w : r5.x;
      r4.w = (uint)cb2[9].w;
      if (r3.x != 0) {
        r3.z = r3.z * r5.z;
        r7.xyzw = float4(-1,-1,-1,-1) + r6.xyzw;
        r7.xyzw = cb2[9].xxxx * r7.xyzw + float4(1,1,1,1);
        r7.xyzw = cb2[12].xyzw * r7.xyzw;
        r6.xyzw = r7.xyzw * r5.zzzz;
        r5.xyzw = cb2[14].xyzw;
        r7.xyzw = cb2[13].xyzw;
      } else {
        r5.xyzw = cb2[10].xyzw;
        r7.xyzw = cb2[11].xyzw;
      }
      r8.x = cb2[0].x + cb2[0].x;
      r3.w = r3.w ? r8.x : 1;
      r6.xyzw = r6.xyzw * r3.wwww;
      if (r4.w == 0) {
        r3.w = 0;
      } else {
        r8.xy = (int2)r2.zy + (int2)-r4.ww;
        r8.zw = r2.xw;
        r8.x = t3.Load(r8.zxw).x;
        r9.x = (uint)r8.x >> 4;
        r8.x = r3.y ? r9.x : r8.x;
        r8.x = (int)r8.x & 4;
        r8.x = cmp((int)r8.x != 0);
        r9.xy = (int2)r2.zy + (int2)r4.ww;
        r9.zw = r8.zw;
        r4.w = t3.Load(r9.zxw).x;
        r8.z = (uint)r4.w >> 4;
        r3.y = r3.y ? r8.z : r4.w;
        r3.y = (int)r3.y & 4;
        r3.y = cmp((int)r3.y != 0);
        r2.y = (uint)r8.y >> 1;
        r2.y = t3.Load(r2.yzw).x;
        r4.w = (int)r8.y & 1;
        r8.y = (uint)r2.y >> 4;
        r2.y = r4.w ? r8.y : r2.y;
        r2.y = (int)r2.y & 4;
        r2.y = cmp((int)r2.y != 0);
        r2.x = (uint)r9.y >> 1;
        r2.x = t3.Load(r2.xzw).x;
        r2.z = (int)r9.y & 1;
        r2.w = (uint)r2.x >> 4;
        r2.x = r2.z ? r2.w : r2.x;
        r2.x = (int)r2.x & 4;
        r2.x = cmp((int)r2.x != 0);
        r2.z = r3.y ? r8.x : 0;
        r2.y = r2.y ? r2.z : 0;
        r2.x = r2.x ? r2.y : 0;
        r3.w = ~(int)r2.x;
      }
      if (r3.w == 0) {
        r0.zw = cb2[1].yx * r0.zw;
        r2.xyzw = float4(12,12,12,12) * r0.wzwz;
        r2.xyzw = cmp(r2.xyzw >= -r2.zwzw);
        r2.xyzw = r2.xyzw ? float4(12,12,0.0833333358,0.0833333358) : float4(-12,-12,-0.0833333358,-0.0833333358);
        r2.zw = r2.wz * r0.zw;
        r2.zw = frac(r2.zw);
        r2.xy = r2.yx * r2.zw;
        r2.xy = (uint2)r2.xy;
        r2.zw = cmp((int2)r2.yx == int2(0,0));
        r2.xy = (int2)r2.xy & int2(14,14);
        r0.z = (uint)r0.z;
        r2.xy = cmp((int2)r2.xy != int2(6,6));
        r2.xy = r2.xy ? r2.zw : 0;
        r0.w = (int)r2.y | (int)r2.x;
        r0.z = (int)r0.z & 2;
        r0.z = cmp((int)r0.z != 0);
        r0.z = r3.x ? r0.w : r0.z;
        r2.xyzw = r0.zzzz ? r7.xyzw : r5.xyzw;
        r2.xyzw = r3.zzzz * r2.xyzw;
        r6.xyzw = r2.xyzw * r6.xyzw;
      }
      r2.xyz = r6.xyz + -r4.xyz;
      r4.xyz = r6.www * r2.xyz + r4.xyz;
    }
    r1.w = dot(r4.xyz, float3(0.212599993,0.715200007,0.0722000003));
    r0.z = min(r4.x, r4.y);
    r0.w = max(r4.x, r4.y);
    r0.w = min(r0.w, r4.z);
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
    r0.x = cb2[4].y * r0.x;
    r1.xyz = r4.xyz * r0.xxx + r4.xyz;
  } else {
    r1.w = 1;
  }
  o0.xyzw = r1.xyzw;
  o1.x = r1.w;
  return;
}