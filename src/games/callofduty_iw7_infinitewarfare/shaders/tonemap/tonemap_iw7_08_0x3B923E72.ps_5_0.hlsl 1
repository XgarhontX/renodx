// ---- Created with 3Dmigoto v1.3.16 on Wed Aug 20 15:43:41 2025
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
  float4 cb13[3];
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
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb2[3].yx + v1.yx;
  r1.xyz = t0.Sample(s0_s, r0.yx).xyz;
  r0.zw = cb2[3].wz + r0.xy;
  r2.xy = cb2[2].xy * r0.wz;
  r2.yz = (uint2)r2.xy;
  r2.x = (uint)r2.y >> 1;
  r2.w = 0;
  r1.w = t4.Load(r2.xzw).x;
  r3.x = (int)r2.y & 1;
  r3.y = (uint)r1.w >> 4;
  r1.w = r3.x ? r3.y : r1.w;
  r3.y = (int)r1.w & 4;
  r4.xyz = t1.Sample(s1_s, r0.yx).xyz;
  r4.xyz = cb2[8].xxx * r4.xyz;
  r1.xyz = cb2[8].yyy * r1.xyz + r4.xyz;
  r4.xyz = cmp(r1.xyz < cb13[0].xxx);
  r5.xyzw = r4.xxxx ? cb13[2].xyzw : cb13[1].xyzw;
  r3.zw = r5.xy * r1.xx + r5.zw;
  r5.x = saturate(r3.z / r3.w);
  r6.xyzw = r4.yyyy ? cb13[2].xyzw : cb13[1].xyzw;
  r1.xy = r6.xy * r1.yy + r6.zw;
  r5.y = saturate(r1.x / r1.y);
  r4.xyzw = r4.zzzz ? cb13[2].xyzw : cb13[1].xyzw;
  r1.xy = r4.xy * r1.zz + r4.zw;
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
  r1.xyz = t2.SampleLevel(s2_s, r1.xyz, 0).xyz;
  if (r3.y != 0) {
    r1.w = (int)r1.w & 8;
    r3.yz = t3.Load(r2.yzw).xy;
    r3.yz = float2(255.5,255.100006) * r3.zy;
    r3.yz = (uint2)r3.yz;
    r3.y = (uint)r3.y << 11;
    bitmask.y = ((~(-1 << 8)) << 3) & 0xffffffff;  r3.y = (((uint)r3.z << 3) & bitmask.y) | ((uint)r3.y & ~bitmask.y);
    r3.zw = (int2)r3.yy + int2(1,2);
    r4.xy = t14.Load(r3.z).yw;
    r3.zw = t14.Load(r3.w).yz;
    r5.xyzw = t14.Load(r3.y).xyzw;
    r3.yz = cmp(float2(0,0) < r3.zw);
    r3.w = r1.w ? 1 : 0;
    r3.y = r3.y ? r3.w : r4.x;
    r3.w = (uint)cb2[9].w;
    if (r1.w != 0) {
      r3.y = r3.y * r4.y;
      r6.xyzw = float4(-1,-1,-1,-1) + r5.xyzw;
      r6.xyzw = cb2[9].xxxx * r6.xyzw + float4(1,1,1,1);
      r6.xyzw = cb2[12].xyzw * r6.xyzw;
      r5.xyzw = r6.xyzw * r4.yyyy;
      r4.xyzw = cb2[14].xyzw;
      r6.xyzw = cb2[13].xyzw;
    } else {
      r4.xyzw = cb2[10].xyzw;
      r6.xyzw = cb2[11].xyzw;
    }
    r7.x = cb2[0].x + cb2[0].x;
    r3.z = r3.z ? r7.x : 1;
    r5.xyzw = r5.xyzw * r3.zzzz;
    if (r3.w == 0) {
      r3.z = 0;
    } else {
      r7.xy = (int2)r2.zy + (int2)-r3.ww;
      r7.zw = r2.xw;
      r7.x = t4.Load(r7.zxw).x;
      r8.x = (uint)r7.x >> 4;
      r7.x = r3.x ? r8.x : r7.x;
      r7.x = (int)r7.x & 4;
      r7.x = cmp((int)r7.x != 0);
      r8.xy = (int2)r2.zy + (int2)r3.ww;
      r8.zw = r7.zw;
      r3.w = t4.Load(r8.zxw).x;
      r7.z = (uint)r3.w >> 4;
      r3.x = r3.x ? r7.z : r3.w;
      r3.x = (int)r3.x & 4;
      r3.x = cmp((int)r3.x != 0);
      r2.y = (uint)r7.y >> 1;
      r2.y = t4.Load(r2.yzw).x;
      r3.w = (int)r7.y & 1;
      r7.y = (uint)r2.y >> 4;
      r2.y = r3.w ? r7.y : r2.y;
      r2.y = (int)r2.y & 4;
      r2.y = cmp((int)r2.y != 0);
      r2.x = (uint)r8.y >> 1;
      r2.x = t4.Load(r2.xzw).x;
      r2.z = (int)r8.y & 1;
      r2.w = (uint)r2.x >> 4;
      r2.x = r2.z ? r2.w : r2.x;
      r2.x = (int)r2.x & 4;
      r2.x = cmp((int)r2.x != 0);
      r2.z = r3.x ? r7.x : 0;
      r2.y = r2.y ? r2.z : 0;
      r2.x = r2.x ? r2.y : 0;
      r3.z = ~(int)r2.x;
    }
    if (r3.z == 0) {
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
      r0.z = r1.w ? r0.w : r0.z;
      r2.xyzw = r0.zzzz ? r6.xyzw : r4.xyzw;
      r2.xyzw = r3.yyyy * r2.xyzw;
      r5.xyzw = r2.xyzw * r5.xyzw;
    }
    r2.xyz = r5.xyz + -r1.xyz;
    r1.xyz = r5.www * r2.xyz + r1.xyz;
  }
  r0.z = dot(r1.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r0.w = min(r1.x, r1.y);
  r1.w = max(r1.x, r1.y);
  r1.w = min(r1.w, r1.z);
  r0.w = max(r1.w, r0.w);
  r1.w = -0.100000001 + r0.w;
  r1.w = saturate(-10 * r1.w);
  r2.x = r1.w * -2 + 3;
  r1.w = r1.w * r1.w;
  r0.w = r2.x * r1.w + r0.w;
  r0.xy = cb2[0].ww * r0.xy;
  r0.xy = frac(r0.xy);
  r0.xy = r0.xy * float2(1024,1024) + float2(-512,-512);
  r2.xy = float2(0.554549694,0.308517009) * r0.yx;
  r2.xy = frac(r2.xy);
  r0.xy = r0.yx * r2.xy + r0.xy;
  r0.xw = r0.xw * r0.yw;
  r0.x = frac(r0.x);
  r0.x = r0.x * 2 + -1;
  r0.y = min(1, r0.w);
  r0.x = r0.y * -r0.x + r0.x;
  r0.x = cb2[4].y * r0.x;
  o0.xyz = r1.xyz * r0.xxx + r1.xyz;
  o0.w = r0.z;
  o1.x = r0.z;
  return;
}