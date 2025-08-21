// ---- Created with 3Dmigoto v1.3.16 on Wed Aug 20 15:44:05 2025
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
  float4 cb2[24];
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

  r0.xy = cb2[3].xy + v1.xy;
  r0.z = 1 + -cb2[4].x;
  r0.w = cmp(0 < cb2[4].w);
  if (r0.w != 0) {
    r1.xy = cb2[5].xy * float2(0.5,0.5) + float2(0.5,0.5);
    r2.xy = cb2[1].xy * cb2[1].wz;
    r2.z = 1;
    r1.zw = r2.zy * r1.xy;
    r3.xy = r0.xy * r2.zy + -r1.zw;
    r0.w = dot(r3.xy, r3.xy);
    r0.w = (uint)r0.w >> 1;
    r0.w = (int)r0.w + 0x1fbd1df5;
    r1.z = -3 * cb2[4].w;
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
  r2.xyzw = -cb2[5].xyxy + r2.xyzw;
  r0.w = dot(r2.zw, r2.zw);
  r0.w = (uint)r0.w >> 1;
  r0.w = (int)r0.w + 0x1fbd1df5;
  r0.w = max(0, r0.w);
  r1.z = cmp(r0.z < r0.w);
  if (r1.z != 0) {
    r3.xw = float2(1,1) + -cb2[4].zz;
    r1.z = 1 + -r0.z;
    r0.z = r0.w + -r0.z;
    r1.z = 1 / r1.z;
    r0.z = saturate(r1.z * r0.z);
    r1.z = r0.z * -2 + 3;
    r0.z = r0.z * r0.z;
    r0.z = r1.z * r0.z;
    r0.z = cb2[4].y * r0.z;
    r2.xyzw = r0.zzzz * r2.xyzw;
    r0.z = 1 + -cb2[5].z;
    r1.z = 1 + -r0.w;
    r0.w = r1.z / r0.w;
    r0.z = r0.w * cb2[5].z + r0.z;
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
    r7.xyz = r4.xzy * cb2[4].zzz + float3(1,1,1);
    r3.z = r7.x;
    r5.xyz = t0.SampleLevel(s0_s, r5.zw, 0).xyz;
    r8.xy = -r4.yz * r0.ww + r3.xx;
    r8.z = r7.z;
    r8.w = 1 + -cb2[4].z;
    r5.xyz = r8.xzw * r5.xyz;
    r5.xyz = r3.yzw * r6.xyz + r5.xyz;
    r3.yzw = r8.xzw + r3.yzw;
    r2.xyzw = -r2.xyzw * r4.zzww + r1.xyxy;
    r4.xyz = t0.SampleLevel(s0_s, r2.xy, 0).xyz;
    r7.xz = r8.yw;
    r4.xyz = r7.xyz * r4.xyz + r5.xyz;
    r3.yzw = r7.xyz + r3.yzw;
    r2.xyz = t0.SampleLevel(s0_s, r2.zw, 0).xyz;
    r5.y = r4.w * -cb2[4].z + 1;
    r5.z = r4.w * r0.w + r3.x;
    r5.x = 1 + -cb2[4].z;
    r2.xyz = r5.xyz * r2.xyz + r4.xyz;
    r3.xyz = r5.xyz + r3.yzw;
    r2.xyz = r2.xyz / r3.xyz;
  } else {
    r2.xyz = t0.SampleLevel(s0_s, r1.xy, 0).xyz;
  }
  r0.zw = cb2[3].wz + r0.yx;
  r1.xy = cb2[2].xy * r0.wz;
  r1.yz = (uint2)r1.xy;
  r1.x = (uint)r1.y >> 1;
  r1.w = 0;
  r2.w = t4.Load(r1.xzw).x;
  r3.x = (int)r1.y & 1;
  r3.y = (uint)r2.w >> 4;
  r2.w = r3.x ? r3.y : r2.w;
  r3.y = (int)r2.w & 4;
  r4.xyz = t1.Sample(s1_s, r0.xy).xyz;
  r4.xyz = cb2[9].xxx * r4.xyz;
  r2.xyz = cb2[9].yyy * r2.xyz + r4.xyz;
  r4.xyz = cmp(r2.xyz < cb13[0].xxx);
  r5.xyzw = r4.xxxx ? cb13[2].xyzw : cb13[1].xyzw;
  r0.xy = r5.xy * r2.xx + r5.zw;
  r5.x = saturate(r0.x / r0.y);
  r6.xyzw = r4.yyyy ? cb13[2].xyzw : cb13[1].xyzw;
  r0.xy = r6.xy * r2.yy + r6.zw;
  r5.y = saturate(r0.x / r0.y);
  r4.xyzw = r4.zzzz ? cb13[2].xyzw : cb13[1].xyzw;
  r0.xy = r4.xy * r2.zz + r4.zw;
  r5.z = saturate(r0.x / r0.y);
  r2.x = saturate(dot(r5.xyz, cb2[6].xyz));
  r2.y = saturate(dot(r5.xyz, cb2[7].xyz));
  r2.z = saturate(dot(r5.xyz, cb2[8].xyz));
  r2.xyz = log2(r2.xyz);
  r2.xyz = float3(0.416666657,0.416666657,0.416666657) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r2.xyz = r2.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r2.xyz = max(float3(0,0,0), r2.xyz);
  r2.xyz = r2.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
  r4.xyz = t2.SampleLevel(s2_s, r2.xyz, 0).xyz;
  if (r3.y != 0) {
    r0.xy = (int2)r2.ww & int2(2,8);
    r2.x = cmp((int)r0.x != 0);
    r2.yz = t3.Load(r1.yzw).xy;
    r2.yz = float2(255.5,255.100006) * r2.zy;
    r2.yz = (uint2)r2.yz;
    r2.y = (uint)r2.y << 11;
    bitmask.y = ((~(-1 << 8)) << 3) & 0xffffffff;  r2.y = (((uint)r2.z << 3) & bitmask.y) | ((uint)r2.y & ~bitmask.y);
    r2.zw = (int2)r2.yy + int2(1,2);
    r5.xyzw = t14.Load(r2.z).xyzw;
    r3.yzw = t14.Load(r2.w).xyz;
    r6.xyzw = t14.Load(r2.y).xyzw;
    r2.yzw = cmp(float3(0,0,0) < r3.yzw);
    r3.y = cmp(0 < r5.z);
    r2.x = r2.x ? r3.y : 0;
    if (r2.x != 0) {
      r2.x = (uint)cb2[13].w;
      r3.y = cb2[10].z * r5.z;
      r7.xyzw = r2.yyyy ? cb2[11].xyzw : cb2[12].xyzw;
      r7.xyzw = r7.xyzw * r5.zzzz;
      if (r0.y != 0) {
        r8.xyzw = cb2[16].xyzw * cb2[10].yyyy;
        r7.xyzw = r8.xyzw * r7.xyzw;
        r3.y = cb2[10].y * r3.y;
        r8.xyzw = cb2[18].xyzw;
        r9.xyzw = cb2[17].xyzw;
      } else {
        r8.xyzw = cb2[14].xyzw;
        r9.xyzw = cb2[15].xyzw;
      }
    } else {
      r0.x = r0.x ? 1 : r5.x;
      r2.y = r5.y * r0.x;
      r10.xyzw = r6.xyzw * r0.xxxx;
      r3.z = r0.y ? 1 : 0;
      r3.y = r2.z ? r3.z : r2.y;
      r2.x = (uint)cb2[10].w;
      if (r0.y != 0) {
        r3.y = r3.y * r5.w;
        r6.xyzw = r6.xyzw * r0.xxxx + -r0.xxxx;
        r6.xyzw = cb2[10].xxxx * r6.xyzw + r0.xxxx;
        r6.xyzw = cb2[21].xyzw * r6.xyzw;
        r10.xyzw = r6.xyzw * r5.wwww;
        r8.xyzw = cb2[23].xyzw;
        r9.xyzw = cb2[22].xyzw;
      } else {
        r8.xyzw = cb2[19].xyzw;
        r9.xyzw = cb2[20].xyzw;
      }
      r0.x = cb2[0].x + cb2[0].x;
      r0.x = r2.w ? r0.x : 1;
      r7.xyzw = r10.xyzw * r0.xxxx;
    }
    if (r2.x == 0) {
      r0.x = 0;
    } else {
      r5.xy = (int2)r1.zy + (int2)-r2.xx;
      r5.zw = r1.xw;
      r2.y = t4.Load(r5.zxw).x;
      r2.z = (uint)r2.y >> 4;
      r2.y = r3.x ? r2.z : r2.y;
      r2.y = (int)r2.y & 4;
      r2.y = cmp((int)r2.y != 0);
      r6.xy = (int2)r1.zy + (int2)r2.xx;
      r6.zw = r5.zw;
      r2.x = t4.Load(r6.zxw).x;
      r2.z = (uint)r2.x >> 4;
      r2.x = r3.x ? r2.z : r2.x;
      r2.x = (int)r2.x & 4;
      r2.x = cmp((int)r2.x != 0);
      r1.y = (uint)r5.y >> 1;
      r1.y = t4.Load(r1.yzw).x;
      r2.z = (int)r5.y & 1;
      r2.w = (uint)r1.y >> 4;
      r1.y = r2.z ? r2.w : r1.y;
      r1.y = (int)r1.y & 4;
      r1.y = cmp((int)r1.y != 0);
      r1.x = (uint)r6.y >> 1;
      r1.x = t4.Load(r1.xzw).x;
      r1.z = (int)r6.y & 1;
      r1.w = (uint)r1.x >> 4;
      r1.x = r1.z ? r1.w : r1.x;
      r1.x = (int)r1.x & 4;
      r1.x = cmp((int)r1.x != 0);
      r1.z = r2.x ? r2.y : 0;
      r1.y = r1.y ? r1.z : 0;
      r1.x = r1.x ? r1.y : 0;
      r0.x = ~(int)r1.x;
    }
    if (r0.x == 0) {
      r0.xz = cb2[1].yx * r0.zw;
      r1.xyzw = float4(12,12,12,12) * r0.zxzx;
      r1.xyzw = cmp(r1.xyzw >= -r1.zwzw);
      r1.xyzw = r1.xyzw ? float4(12,12,0.0833333358,0.0833333358) : float4(-12,-12,-0.0833333358,-0.0833333358);
      r0.zw = r1.wz * r0.xz;
      r0.zw = frac(r0.zw);
      r0.zw = r1.yx * r0.zw;
      r0.xzw = (uint3)r0.xzw;
      r1.xy = cmp((int2)r0.wz == int2(0,0));
      r0.xzw = (int3)r0.xzw & int3(2,14,14);
      r0.xzw = cmp((int3)r0.xzw != int3(0,6,6));
      r0.zw = r0.zw ? r1.xy : 0;
      r0.z = (int)r0.w | (int)r0.z;
      r0.x = r0.y ? r0.z : r0.x;
      r0.xyzw = r0.xxxx ? r9.xyzw : r8.xyzw;
      r0.xyzw = r3.yyyy * r0.xyzw;
      r7.xyzw = r0.xyzw * r7.xyzw;
    }
    r0.xyz = r7.xyz + -r4.xyz;
    r4.xyz = r7.www * r0.xyz + r4.xyz;
  }
  r4.w = dot(r4.xyz, float3(0.212599993,0.715200007,0.0722000003));
  o0.xyzw = r4.xyzw;
  o1.x = r4.w;
  return;
}