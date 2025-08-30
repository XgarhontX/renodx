// ---- Created with 3Dmigoto v1.3.16 on Wed Aug 20 15:43:56 2025
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
  float4 cb2[23];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0,
  out float o1 : SV_TARGET1)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10;
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
    r3.yz = (int2)r1.ww & int2(2,8);
    r1.w = cmp((int)r3.y != 0);
    r4.xy = t3.Load(r2.yzw).xy;
    r4.xy = float2(255.5,255.100006) * r4.yx;
    r4.xy = (uint2)r4.xy;
    r3.w = (uint)r4.x << 11;
    bitmask.w = ((~(-1 << 8)) << 3) & 0xffffffff;  r3.w = (((uint)r4.y << 3) & bitmask.w) | ((uint)r3.w & ~bitmask.w);
    r4.xy = (int2)r3.ww + int2(1,2);
    r5.xyzw = t14.Load(r4.x).xyzw;
    r4.xyz = t14.Load(r4.y).xyz;
    r6.xyzw = t14.Load(r3.w).xyzw;
    r4.xyz = cmp(float3(0,0,0) < r4.xyz);
    r3.w = cmp(0 < r5.z);
    r1.w = r1.w ? r3.w : 0;
    if (r1.w != 0) {
      r1.w = (uint)cb2[12].w;
      r3.w = cb2[9].z * r5.z;
      r7.xyzw = r4.xxxx ? cb2[10].xyzw : cb2[11].xyzw;
      r7.xyzw = r7.xyzw * r5.zzzz;
      if (r3.z != 0) {
        r8.xyzw = cb2[15].xyzw * cb2[9].yyyy;
        r7.xyzw = r8.xyzw * r7.xyzw;
        r3.w = cb2[9].y * r3.w;
        r8.xyzw = cb2[17].xyzw;
        r9.xyzw = cb2[16].xyzw;
      } else {
        r8.xyzw = cb2[13].xyzw;
        r9.xyzw = cb2[14].xyzw;
      }
    } else {
      r3.y = r3.y ? 1 : r5.x;
      r4.x = r5.y * r3.y;
      r10.xyzw = r6.xyzw * r3.yyyy;
      r4.w = r3.z ? 1 : 0;
      r3.w = r4.y ? r4.w : r4.x;
      r1.w = (uint)cb2[9].w;
      if (r3.z != 0) {
        r3.w = r3.w * r5.w;
        r6.xyzw = r6.xyzw * r3.yyyy + -r3.yyyy;
        r6.xyzw = cb2[9].xxxx * r6.xyzw + r3.yyyy;
        r6.xyzw = cb2[20].xyzw * r6.xyzw;
        r10.xyzw = r6.xyzw * r5.wwww;
        r8.xyzw = cb2[22].xyzw;
        r9.xyzw = cb2[21].xyzw;
      } else {
        r8.xyzw = cb2[18].xyzw;
        r9.xyzw = cb2[19].xyzw;
      }
      r3.y = cb2[0].x + cb2[0].x;
      r3.y = r4.z ? r3.y : 1;
      r7.xyzw = r10.xyzw * r3.yyyy;
    }
    if (r1.w == 0) {
      r3.y = 0;
    } else {
      r4.xy = (int2)-r1.ww + (int2)r2.zy;
      r4.zw = r2.xw;
      r4.x = t4.Load(r4.zxw).x;
      r5.x = (uint)r4.x >> 4;
      r4.x = r3.x ? r5.x : r4.x;
      r4.x = (int)r4.x & 4;
      r4.x = cmp((int)r4.x != 0);
      r5.xy = (int2)r1.ww + (int2)r2.zy;
      r5.zw = r4.zw;
      r1.w = t4.Load(r5.zxw).x;
      r4.z = (uint)r1.w >> 4;
      r1.w = r3.x ? r4.z : r1.w;
      r1.w = (int)r1.w & 4;
      r1.w = cmp((int)r1.w != 0);
      r2.y = (uint)r4.y >> 1;
      r2.y = t4.Load(r2.yzw).x;
      r3.x = (int)r4.y & 1;
      r4.y = (uint)r2.y >> 4;
      r2.y = r3.x ? r4.y : r2.y;
      r2.y = (int)r2.y & 4;
      r2.y = cmp((int)r2.y != 0);
      r2.x = (uint)r5.y >> 1;
      r2.x = t4.Load(r2.xzw).x;
      r2.z = (int)r5.y & 1;
      r2.w = (uint)r2.x >> 4;
      r2.x = r2.z ? r2.w : r2.x;
      r2.x = (int)r2.x & 4;
      r2.x = cmp((int)r2.x != 0);
      r1.w = r1.w ? r4.x : 0;
      r1.w = r2.y ? r1.w : 0;
      r1.w = r2.x ? r1.w : 0;
      r3.y = ~(int)r1.w;
    }
    if (r3.y == 0) {
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
      r0.z = r3.z ? r0.w : r0.z;
      r2.xyzw = r0.zzzz ? r9.xyzw : r8.xyzw;
      r2.xyzw = r3.wwww * r2.xyzw;
      r7.xyzw = r2.xyzw * r7.xyzw;
    }
    r2.xyz = r7.xyz + -r1.xyz;
    r1.xyz = r7.www * r2.xyz + r1.xyz;
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