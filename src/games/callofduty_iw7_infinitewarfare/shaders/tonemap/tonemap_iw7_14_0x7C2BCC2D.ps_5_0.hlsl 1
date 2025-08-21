// ---- Created with 3Dmigoto v1.3.16 on Wed Aug 20 15:44:23 2025
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
  float4 cb13[3];
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
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb2[4].xy + v1.xy;
  r1.xyz = t0.Sample(s0_s, r0.xy).xyz;
  r0.zw = cb2[4].wz + r0.yx;
  r2.xy = cb2[2].xy * r0.wz;
  r2.yz = (uint2)r2.xy;
  r2.x = (uint)r2.y >> 1;
  r2.w = 0;
  r1.w = t5.Load(r2.xzw).x;
  r2.x = (int)r2.y & 1;
  r3.x = (uint)r1.w >> 4;
  r1.w = r2.x ? r3.x : r1.w;
  r3.xy = (int2)r1.ww & int2(4,8);
  r1.w = cmp((int)r3.x != 0);
  r3.xzw = t2.Sample(s2_s, r0.xy).xyz;
  r0.xy = t4.Load(r2.yzw).xy;
  r0.xy = float2(255.5,255.100006) * r0.yx;
  r0.xy = (uint2)r0.xy;
  r0.x = (uint)r0.x << 11;
  bitmask.x = ((~(-1 << 8)) << 3) & 0xffffffff;  r0.x = (((uint)r0.y << 3) & bitmask.x) | ((uint)r0.x & ~bitmask.x);
  r0.y = cmp((int)r3.y == 0);
  r0.y = r0.y ? r1.w : 0;
  r1.w = t14.Load(r0.x).w;
  r1.w = cmp(0 < r1.w);
  r0.y = r0.y ? r1.w : 0;
  if (r0.y != 0) {
    r0.x = (int)r0.x + 2;
    r0.x = t14.Load(r0.x).x;
    r0.x = cmp(0 < r0.x);
    if (r0.x != 0) {
      r2.xyz = cb2[14].xyz;
      r4.xyz = cb2[13].xyz;
    } else {
      r2.xyz = cb2[12].xyz;
      r4.xyz = cb2[11].xyz;
    }
    r0.x = cb2[9].x;
    r0.y = cb2[10].y;
    r5.xyz = t1.Gather(s1_s, r0.wz).xzw;
    r6.xy = abs(r5.zz) + -abs(r5.yx);
    r6.z = abs(r5.z) * 0.000250000012 + 2.32830644e-010;
    r1.w = dot(r6.xyz, r6.xyz);
    r1.w = (uint)r1.w >> 1;
    r1.w = (int)-r1.w + 0x5f3759df;
    r1.w = r6.z * r1.w;
    r1.w = min(1, r1.w);
  } else {
    r2.xyz = cb2[16].xyz;
    r4.xyz = cb2[15].xyz;
    r0.x = cb2[9].y;
    r0.y = cb2[10].z;
    r3.xyz = cb2[8].xxx * r3.xzw;
    r1.xyz = cb2[8].yyy * r1.xyz + r3.xyz;
    r3.xyz = cmp(r1.xyz < cb13[0].xxx);
    r5.xyzw = r3.xxxx ? cb13[2].xyzw : cb13[1].xyzw;
    r3.xw = r5.xy * r1.xx + r5.zw;
    r5.x = saturate(r3.x / r3.w);
    r6.xyzw = r3.yyyy ? cb13[2].xyzw : cb13[1].xyzw;
    r1.xy = r6.xy * r1.yy + r6.zw;
    r5.y = saturate(r1.x / r1.y);
    r3.xyzw = r3.zzzz ? cb13[2].xyzw : cb13[1].xyzw;
    r1.xy = r3.xy * r1.zz + r3.zw;
    r5.z = saturate(r1.x / r1.y);
    r1.x = saturate(dot(r5.xyz, cb2[5].xyz));
    r1.y = saturate(dot(r5.xyz, cb2[6].xyz));
    r1.z = saturate(dot(r5.xyz, cb2[7].xyz));
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
    r1.xyz = max(float3(0,0,0), r1.xyz);
    r1.xyz = r1.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
    r1.xyz = t3.SampleLevel(s3_s, r1.xyz, 0).xyz;
    r1.w = dot(r1.xyz, float3(0.212599993,0.715200007,0.0722000003));
  }
  r1.xy = cb2[0].yx + r0.zw;
  r1.xy = r1.xy * float2(1024,1024) + float2(-512,-512);
  r3.xy = float2(0.554549694,0.308517009) * r1.yx;
  r3.xy = frac(r3.xy);
  r1.xy = r1.yx * r3.xy + r1.xy;
  r1.x = r1.x * r1.y;
  r1.x = frac(r1.x);
  r1.x = r1.x * 2 + -1;
  r1.x = r1.x * r0.y + 1;
  r1.x = saturate(r1.w * r1.x);
  r1.x = (int)r1.x;
  r1.x = -1.06529242e+009 + r1.x;
  r0.x = r0.x * r1.x + 1.06529242e+009;
  r0.x = (int)r0.x;
  r0.x = saturate(r0.x);
  r1.xyz = -r4.xyz + r2.xyz;
  r1.xyz = r0.xxx * r1.xyz + r4.xyz;
  r0.xz = cb2[0].ww * r0.zw;
  r0.xz = frac(r0.xz);
  r0.xz = r0.xz * float2(1024,1024) + float2(-512,-512);
  r2.xy = float2(0.554549694,0.308517009) * r0.zx;
  r2.xy = frac(r2.xy);
  r0.xz = r0.zx * r2.xy + r0.xz;
  r0.x = r0.x * r0.z;
  r0.x = frac(r0.x);
  r0.x = r0.x * 2 + -1;
  r0.x = r0.x * r0.y + 1;
  r0.xyz = saturate(r1.xyz * r0.xxx);
  r0.w = dot(r0.xyz, float3(0.212599993,0.715200007,0.0722000003));
  o0.xyzw = r0.xyzw;
  o1.x = r0.w;
  return;
}