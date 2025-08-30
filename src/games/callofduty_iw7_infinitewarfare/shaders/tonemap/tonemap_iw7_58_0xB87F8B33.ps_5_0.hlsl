// ---- Created with 3Dmigoto v1.3.16 on Wed Aug 20 15:45:04 2025
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
  float4 cb2[11];
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

  r0.xy = cb2[2].yx + v1.yx;
  r0.z = 1 + -cb2[3].x;
  r0.w = cmp(0 < cb2[3].w);
  if (r0.w != 0) {
    r1.xy = cb2[4].xy * float2(0.5,0.5) + float2(0.5,0.5);
    r2.xy = cb2[1].xy * cb2[1].wz;
    r2.z = 1;
    r1.zw = r2.zy * r1.xy;
    r3.xy = r0.yx * r2.zy + -r1.zw;
    r0.w = dot(r3.xy, r3.xy);
    r0.w = (uint)r0.w >> 1;
    r0.w = (int)r0.w + 0x1fbd1df5;
    r1.z = -3 * cb2[3].w;
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
    r1.xy = r0.yx;
  }
  r2.xyzw = r1.xyxy * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r2.xyzw = -cb2[4].xyxy + r2.xyzw;
  r0.w = dot(r2.zw, r2.zw);
  r0.w = (uint)r0.w >> 1;
  r0.w = (int)r0.w + 0x1fbd1df5;
  r0.w = max(0, r0.w);
  r1.z = cmp(r0.z < r0.w);
  if (r1.z != 0) {
    r3.xw = float2(1,1) + -cb2[3].zz;
    r1.z = 1 + -r0.z;
    r0.z = r0.w + -r0.z;
    r1.z = 1 / r1.z;
    r0.z = saturate(r1.z * r0.z);
    r1.z = r0.z * -2 + 3;
    r0.z = r0.z * r0.z;
    r0.z = r1.z * r0.z;
    r0.z = cb2[3].y * r0.z;
    r2.xyzw = r0.zzzz * r2.xyzw;
    r0.z = 1 + -cb2[4].z;
    r1.z = 1 + -r0.w;
    r0.w = r1.z / r0.w;
    r0.z = r0.w * cb2[4].z + r0.z;
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
    r7.xyz = r4.xzy * cb2[3].zzz + float3(1,1,1);
    r3.z = r7.x;
    r5.xyz = t0.SampleLevel(s0_s, r5.zw, 0).xyz;
    r8.xy = -r4.yz * r0.ww + r3.xx;
    r8.z = r7.z;
    r8.w = 1 + -cb2[3].z;
    r5.xyz = r8.xzw * r5.xyz;
    r5.xyz = r3.yzw * r6.xyz + r5.xyz;
    r3.yzw = r8.xzw + r3.yzw;
    r2.xyzw = -r2.xyzw * r4.zzww + r1.xyxy;
    r4.xyz = t0.SampleLevel(s0_s, r2.xy, 0).xyz;
    r7.xz = r8.yw;
    r4.xyz = r7.xyz * r4.xyz + r5.xyz;
    r3.yzw = r7.xyz + r3.yzw;
    r2.xyz = t0.SampleLevel(s0_s, r2.zw, 0).xyz;
    r5.y = r4.w * -cb2[3].z + 1;
    r5.z = r4.w * r0.w + r3.x;
    r5.x = 1 + -cb2[3].z;
    r2.xyz = r5.xyz * r2.xyz + r4.xyz;
    r3.xyz = r5.xyz + r3.yzw;
    r2.xyz = r2.xyz / r3.xyz;
  } else {
    r2.xyz = t0.SampleLevel(s0_s, r1.xy, 0).xyz;
  }
  r0.z = cmp(asint(cb2[10].z) != 3);
  if (r0.z != 0) {
    r0.zw = asint(cb2[10].yw) & int2(1,1);
    if (r0.z != 0) {
      r1.xyz = t1.Sample(s1_s, r0.yx).xyz;
      r1.xyz = cb2[9].xxx * r1.xyz;
      r2.xyz = cb2[9].yyy * r2.xyz + r1.xyz;
    }
    switch (cb2[10].x) {
      case 1 :      r0.z = dot(float3(0.212599993,0.715200007,0.0722000003), r2.xyz);
      switch (cb2[10].z) {
        case 2 :        r1.x = log2(r0.z);
        r1.x = r1.x * 0.693147182 + 9.2103405;
        r1.x = max(0, r1.x);
        r1.x = 0.0492605828 * r1.x;
        r1.x = min(1, r1.x);
        r1.x = r1.x * 360 + 300;
        r1.x = 0.00278551527 * r1.x;
        r1.x = frac(r1.x);
        r1.y = 5.98333359 * r1.x;
        r1.y = floor(r1.y);
        r1.x = r1.x * 5.98333359 + -r1.y;
        r3.z = 1 + -r1.x;
        r4.y = 1 + -r3.z;
        r5.xyzw = cmp(r1.yyyy == float4(0,1,2,3));
        r1.x = cmp(r1.y == 4.000000);
        r3.xy = float2(1,0);
        r6.xy = r5.ww ? r3.yz : r4.yy;
        r1.x = (int)r1.x | (int)r5.w;
        r4.xz = float2(1,0);
        r6.z = 1;
        r1.yzw = r5.zzz ? r4.zxy : r6.xyz;
        r1.x = (int)r1.x | (int)r5.z;
        r1.yzw = r5.yyy ? r3.zxy : r1.yzw;
        r1.x = (int)r1.x | (int)r5.y;
        r1.yzw = r5.xxx ? r4.xyz : r1.yzw;
        r1.x = (int)r1.x | (int)r5.x;
        r2.xyz = r1.xxx ? r1.yzw : r3.xyz;
        break;
        case 3 :        break;
        default :
        r0.z = cb13[3].x * r0.z;
        r0.z = log2(r0.z);
        r1.xy = float2(5.97393131,7.97393131) + r0.zz;
        r0.z = (int)r1.x;
        r0.z = max(0, (int)r0.z);
        r0.z = min(6, (int)r0.z);
        r1.x = saturate(0.5 * r1.y);
        r1.x = r0.z ? 1 : r1.x;
        r2.xyz = icb[r0.z+0].xyz * r1.xxx;
        break;
      }
      break;
      default :
      r1.xyz = cmp(r2.xyz < cb13[0].xxx);
      r3.xyzw = r1.xxxx ? cb13[2].xyzw : cb13[1].xyzw;
      r1.xw = r3.xy * r2.xx + r3.zw;
      r2.x = saturate(r1.x / r1.w);
      r3.xyzw = r1.yyyy ? cb13[2].xyzw : cb13[1].xyzw;
      r1.xy = r3.xy * r2.yy + r3.zw;
      r2.y = saturate(r1.x / r1.y);
      r1.xyzw = r1.zzzz ? cb13[2].xyzw : cb13[1].xyzw;
      r1.xy = r1.xy * r2.zz + r1.zw;
      r2.z = saturate(r1.x / r1.y);
      break;
    }
    r1.x = saturate(dot(r2.xyz, cb2[6].xyz));
    r1.y = saturate(dot(r2.xyz, cb2[7].xyz));
    r1.z = saturate(dot(r2.xyz, cb2[8].xyz));
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
    r1.xyz = max(float3(0,0,0), r1.xyz);
    r3.xyz = cmp(float3(0.998039186,0.998039186,0.998039186) < r1.xyz);
    r4.xyz = cmp(r1.xyz < float3(0.00196078443,0.00196078443,0.00196078443));
    r0.z = (int)r3.y | (int)r3.x;
    r0.z = (int)r3.z | (int)r0.z;
    r1.w = (int)r4.y | (int)r4.x;
    r1.w = (int)r4.z | (int)r1.w;
    r0.z = (int)r0.z | (int)r1.w;
    r4.xyz = r4.xyz ? float3(1,1,1) : 0;
    r3.xyz = r3.xyz ? float3(-1,-1,-1) : float3(-0,-0,-0);
    r3.xyz = r4.xyz + r3.xyz;
    r3.xyz = r3.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5);
    r0.z = r0.w ? r0.z : 0;
    r1.xyz = r0.zzz ? r3.xyz : r1.xyz;
    r1.xyz = r1.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
    r1.xyz = t2.SampleLevel(s2_s, r1.xyz, 0).xyz;
    r2.w = dot(r1.xyz, float3(0.212599993,0.715200007,0.0722000003));
    r0.z = min(r1.x, r1.y);
    r0.w = max(r1.x, r1.y);
    r0.w = min(r0.w, r1.z);
    r0.z = max(r0.z, r0.w);
    r0.w = -0.100000001 + r0.z;
    r0.w = saturate(-10 * r0.w);
    r1.w = r0.w * -2 + 3;
    r0.w = r0.w * r0.w;
    r0.z = r1.w * r0.w + r0.z;
    r0.xy = cb2[0].ww * r0.xy;
    r0.xy = frac(r0.xy);
    r0.xy = r0.xy * float2(1024,1024) + float2(-512,-512);
    r3.xy = float2(0.554549694,0.308517009) * r0.yx;
    r3.xy = frac(r3.xy);
    r0.xy = r0.yx * r3.xy + r0.xy;
    r0.xz = r0.xz * r0.yz;
    r0.x = frac(r0.x);
    r0.x = r0.x * 2 + -1;
    r0.y = min(1, r0.z);
    r0.x = r0.y * -r0.x + r0.x;
    r0.x = cb2[5].y * r0.x;
    r2.xyz = r1.xyz * r0.xxx + r1.xyz;
  } else {
    r2.w = 1;
  }
  o0.xyzw = r2.xyzw;
  o1.x = r2.w;
  return;
}