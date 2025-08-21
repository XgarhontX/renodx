// ---- Created with 3Dmigoto v1.3.16 on Wed Aug 20 15:45:11 2025
Buffer<float4> t14 : register(t14);

Texture2D<uint4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture3D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb13 : register(b13)
{
  float4 cb13[3];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[21];
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
  r0.xy = cb2[3].wz + r0.xy;
  r0.zw = cb2[2].xy * r0.yx;
  r2.yz = (uint2)r0.zw;
  r2.x = (uint)r2.y >> 1;
  r2.w = 0;
  r0.z = t3.Load(r2.xzw).x;
  r0.w = (int)r2.y & 1;
  r1.w = (uint)r0.z >> 4;
  r0.z = r0.w ? r1.w : r0.z;
  r1.w = (int)r0.z & 4;
  r3.xyz = cmp(r1.xyz < cb13[0].xxx);
  r4.xyzw = r3.xxxx ? cb13[2].xyzw : cb13[1].xyzw;
  r3.xw = r4.xy * r1.xx + r4.zw;
  r4.x = saturate(r3.x / r3.w);
  r5.xyzw = r3.yyyy ? cb13[2].xyzw : cb13[1].xyzw;
  r1.xy = r5.xy * r1.yy + r5.zw;
  r4.y = saturate(r1.x / r1.y);
  r3.xyzw = r3.zzzz ? cb13[2].xyzw : cb13[1].xyzw;
  r1.xy = r3.xy * r1.zz + r3.zw;
  r4.z = saturate(r1.x / r1.y);
  r1.x = saturate(dot(r4.xyz, cb2[4].xyz));
  r1.y = saturate(dot(r4.xyz, cb2[5].xyz));
  r1.z = saturate(dot(r4.xyz, cb2[6].xyz));
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r1.xyz = max(float3(0,0,0), r1.xyz);
  r1.xyz = r1.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
  r3.xyz = t1.SampleLevel(s1_s, r1.xyz, 0).xyz;
  if (r1.w != 0) {
    r1.xy = (int2)r0.zz & int2(2,8);
    r0.z = cmp((int)r1.x != 0);
    r1.zw = t2.Load(r2.yzw).xy;
    r1.zw = float2(255.5,255.100006) * r1.wz;
    r1.zw = (uint2)r1.zw;
    r1.z = (uint)r1.z << 11;
    bitmask.z = ((~(-1 << 8)) << 3) & 0xffffffff;  r1.z = (((uint)r1.w << 3) & bitmask.z) | ((uint)r1.z & ~bitmask.z);
    r4.xy = (int2)r1.zz + int2(1,2);
    r5.xyzw = t14.Load(r4.x).xyzw;
    r4.xyz = t14.Load(r4.y).xyz;
    r6.xyzw = t14.Load(r1.z).xyzw;
    r4.xyz = cmp(float3(0,0,0) < r4.xyz);
    r1.z = cmp(0 < r5.z);
    r0.z = r0.z ? r1.z : 0;
    if (r0.z != 0) {
      r0.z = (uint)cb2[10].w;
      r1.z = cb2[7].z * r5.z;
      r7.xyzw = r4.xxxx ? cb2[8].xyzw : cb2[9].xyzw;
      r7.xyzw = r7.xyzw * r5.zzzz;
      if (r1.y != 0) {
        r8.xyzw = cb2[13].xyzw * cb2[7].yyyy;
        r7.xyzw = r8.xyzw * r7.xyzw;
        r1.z = cb2[7].y * r1.z;
        r8.xyzw = cb2[15].xyzw;
        r9.xyzw = cb2[14].xyzw;
      } else {
        r8.xyzw = cb2[11].xyzw;
        r9.xyzw = cb2[12].xyzw;
      }
    } else {
      r1.x = r1.x ? 1 : r5.x;
      r1.w = r5.y * r1.x;
      r10.xyzw = r6.xyzw * r1.xxxx;
      r4.x = r1.y ? 1 : 0;
      r1.z = r4.y ? r4.x : r1.w;
      r0.z = (uint)cb2[7].w;
      if (r1.y != 0) {
        r1.z = r1.z * r5.w;
        r6.xyzw = r6.xyzw * r1.xxxx + -r1.xxxx;
        r6.xyzw = cb2[7].xxxx * r6.xyzw + r1.xxxx;
        r6.xyzw = cb2[18].xyzw * r6.xyzw;
        r10.xyzw = r6.xyzw * r5.wwww;
        r8.xyzw = cb2[20].xyzw;
        r9.xyzw = cb2[19].xyzw;
      } else {
        r8.xyzw = cb2[16].xyzw;
        r9.xyzw = cb2[17].xyzw;
      }
      r1.x = cb2[0].x + cb2[0].x;
      r1.x = r4.z ? r1.x : 1;
      r7.xyzw = r10.xyzw * r1.xxxx;
    }
    if (r0.z == 0) {
      r1.x = 0;
    } else {
      r4.xy = (int2)-r0.zz + (int2)r2.zy;
      r4.zw = r2.xw;
      r1.w = t3.Load(r4.zxw).x;
      r4.x = (uint)r1.w >> 4;
      r1.w = r0.w ? r4.x : r1.w;
      r1.w = (int)r1.w & 4;
      r1.w = cmp((int)r1.w != 0);
      r5.xy = (int2)r0.zz + (int2)r2.zy;
      r5.zw = r4.zw;
      r0.z = t3.Load(r5.zxw).x;
      r4.x = (uint)r0.z >> 4;
      r0.z = r0.w ? r4.x : r0.z;
      r0.z = (int)r0.z & 4;
      r0.z = cmp((int)r0.z != 0);
      r2.y = (uint)r4.y >> 1;
      r0.w = t3.Load(r2.yzw).x;
      r2.y = (int)r4.y & 1;
      r4.x = (uint)r0.w >> 4;
      r0.w = r2.y ? r4.x : r0.w;
      r0.w = (int)r0.w & 4;
      r0.w = cmp((int)r0.w != 0);
      r2.x = (uint)r5.y >> 1;
      r2.x = t3.Load(r2.xzw).x;
      r2.y = (int)r5.y & 1;
      r2.z = (uint)r2.x >> 4;
      r2.x = r2.y ? r2.z : r2.x;
      r2.x = (int)r2.x & 4;
      r2.x = cmp((int)r2.x != 0);
      r0.z = r0.z ? r1.w : 0;
      r0.z = r0.w ? r0.z : 0;
      r0.z = r2.x ? r0.z : 0;
      r1.x = ~(int)r0.z;
    }
    if (r1.x == 0) {
      r0.xy = cb2[1].yx * r0.xy;
      r2.xyzw = float4(12,12,12,12) * r0.yxyx;
      r2.xyzw = cmp(r2.xyzw >= -r2.zwzw);
      r2.xyzw = r2.xyzw ? float4(12,12,0.0833333358,0.0833333358) : float4(-12,-12,-0.0833333358,-0.0833333358);
      r0.yz = r2.wz * r0.xy;
      r0.yz = frac(r0.yz);
      r0.yz = r2.yx * r0.yz;
      r0.xyz = (uint3)r0.xyz;
      r1.xw = cmp((int2)r0.zy == int2(0,0));
      r0.xyz = (int3)r0.xyz & int3(2,14,14);
      r0.xyz = cmp((int3)r0.xyz != int3(0,6,6));
      r0.yz = r0.yz ? r1.xw : 0;
      r0.y = (int)r0.z | (int)r0.y;
      r0.x = r1.y ? r0.y : r0.x;
      r0.xyzw = r0.xxxx ? r9.xyzw : r8.xyzw;
      r0.xyzw = r1.zzzz * r0.xyzw;
      r7.xyzw = r0.xyzw * r7.xyzw;
    }
    r0.xyz = r7.xyz + -r3.xyz;
    r3.xyz = r7.www * r0.xyz + r3.xyz;
  }
  r3.w = dot(r3.xyz, float3(0.212599993,0.715200007,0.0722000003));
  o0.xyzw = r3.xyzw;
  o1.x = r3.w;
  return;
}