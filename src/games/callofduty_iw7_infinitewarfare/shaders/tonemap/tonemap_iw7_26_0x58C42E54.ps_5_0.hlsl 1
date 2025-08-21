// ---- Created with 3Dmigoto v1.3.16 on Wed Aug 20 15:43:59 2025
Buffer<float4> t14 : register(t14);

Texture2D<uint4> t7 : register(t7);

Texture2D<float4> t6 : register(t6);

Texture3D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s5_s : register(s5);

SamplerState s4_s : register(s4);

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
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb2[4].xy + v1.xy;
  r1.xyz = cmp(asint(cb2[5].zzw) == int3(1,3,1));
  r0.w = (int)r1.y | (int)r1.x;
  if (r1.z != 0) {
    r1.x = -cb2[6].y * 2 + r0.y;
    r1.x = saturate(1 + r1.x);
    r1.x = r1.x * r1.x;
    r2.x = cb2[5].x * cb2[0].x;
    r2.z = -cb2[0].w * cb2[5].y + r0.y;
    r0.z = 1;
    r1.zw = r2.xz + r0.xz;
    r2.xy = t2.Sample(s2_s, r1.zw).xy;
    r1.zw = float2(0.5,0.5) * r1.zw;
    r1.zw = t2.Sample(s2_s, r1.zw).xy;
    r2.xy = cb2[0].yy * r2.xy;
    r1.zw = cb2[0].xx * r1.zw;
    r1.zw = float2(0.5,0.5) * r1.zw;
    r1.zw = r2.xy * float2(0.5,0.5) + r1.zw;
    r0.z = cb2[6].x * r1.x;
    r1.xz = saturate(r1.zw * r0.zz + r0.xy);
    r2.xy = r0.ww ? r1.xz : r0.xy;
    r2.xyz = t0.Sample(s0_s, r2.xy).xyz;
    r0.xy = r1.xz;
    r0.z = 0;
    r1.x = 0;
    r3.x = 0;
  } else {
    r1.z = cmp(asint(cb2[5].w) == 2);
    if (r1.z != 0) {
      r1.z = cb2[5].y * cb2[0].z;
      r1.z = 15 * r1.z;
      r1.z = floor(r1.z);
      r4.xyz = float3(0.0666666701,5.39166689,1.82500005) * r1.zzz;
      r5.xyz = cmp(r4.yzy >= -r4.yzy);
      r4.yzw = frac(abs(r4.yzy));
      r4.yzw = r5.xyz ? r4.yzw : -r4.wzw;
      r4.yzw = float3(8,8,60.2400017) * r4.yzw;
      r1.zw = r0.xy * float2(0.600000024,0.400000006) + r4.yz;
      r3.w = floor(r4.w);
      r5.x = 0.0166002642 * r3.w;
      r5.y = 0;
      r4.yz = r0.xy * float2(0.25,1) + r5.xy;
      r4.yz = t3.Sample(s3_s, r4.yz).zw;
      r3.w = sin(r4.x);
      r3.w = max(0, r3.w);
      r3.w = r4.z * r3.w;
      r4.x = saturate(cb2[5].x + -r4.y);
      r1.zw = t3.Sample(s3_s, r1.zw).xy;
      r1.zw = r1.zw * float2(2,2) + float2(-1,-1);
      r3.w = r4.x * r3.w;
      r4.xz = r4.xx * float2(0.100000001,0.0329999998) + r3.ww;
      r1.zw = r4.xz * r1.zw;
      r3.w = r1.z * 0.5 + cb2[5].x;
      r3.w = cmp(r4.y < r3.w);
      r1.zw = r3.ww ? r1.zw : 0;
      r1.zw = r1.zw + r0.xy;
      r4.xy = r0.ww ? r1.zw : r0.xy;
      r2.xyz = t0.Sample(s0_s, r4.xy).xyz;
      r0.xy = r1.zw;
      r0.z = 0;
      r1.x = 0;
      r3.x = 0;
    } else {
      r1.z = cmp(asint(cb2[5].w) == 3);
      if (r1.z != 0) {
        r4.xyz = float3(1234,0.333333343,0.200000003) * cb2[0].www;
        r1.zw = frac(r4.xz);
        r1.z = 12345 * r1.z;
        r1.z = r0.y * 100 + r1.z;
        r1.z = 0.103100002 * r1.z;
        r1.z = frac(r1.z);
        r3.w = 19.1900005 + r1.z;
        r3.w = dot(r1.zzz, r3.www);
        r1.z = r3.w + r1.z;
        r3.w = r1.z + r1.z;
        r1.z = r3.w * r1.z;
        r1.z = frac(r1.z);
        r3.w = 123.449997 * r1.z;
        r3.w = frac(r3.w);
        r3.w = cb2[5].y * r3.w;
        r4.x = r3.w + r3.w;
        r4.z = 0.300000012 + -r0.y;
        r4.z = 3 * r4.z;
        r4.z = frac(r4.z);
        r4.w = 2.66666675 * r4.z;
        r4.w = min(1, r4.w);
        r4.w = 1 + -r4.w;
        r5.xy = float2(5,-14.4269505) * r4.ww;
        r4.w = exp2(r5.y);
        r4.w = r5.x * r4.w;
        r4.w = cb2[5].x * r4.w;
        r3.w = 0.00828157365 * r3.w;
        r3.w = r4.w * r1.z + r3.w;
        r4.z = r4.z * 0.333333343 + -0.119999997;
        r4.z = -abs(r4.z) * 20 + 1;
        r4.z = max(0, r4.z);
        r4.z = r4.z * r4.z;
        r4.z = cb2[5].x * r4.z;
        r0.z = r4.z * 0.400000006 + r4.x;
        r5.x = r3.w + r0.x;
        r3.w = floor(r4.y);
        r3.w = cb2[0].w * 0.333333343 + -r3.w;
        r4.xy = float2(-43.2808495,30) * r3.ww;
        r3.w = exp2(r4.x);
        r3.w = saturate(-0.00999999978 + r3.w);
        r4.x = cos(r4.y);
        r3.w = -r4.x * r3.w;
        r3.w = cb2[6].x * r3.w;
        r4.x = 0.600000024 * r3.w;
        r4.y = cmp(0.949999988 < cb2[6].x);
        r1.w = r3.w * 0.600000024 + r1.w;
        r1.w = -0.5 + r1.w;
        r1.w = r4.y ? r1.w : r4.x;
        r1.w = r1.w * 1.0869565 + r0.y;
        r1.w = 0.920000017 * r1.w;
        r1.w = frac(r1.w);
        r3.xyz = float3(262.5,1.0869565,525) * r1.www;
        r3.w = cmp(0.920000017 < r1.w);
        r1.w = r1.w * 1.0869565 + -1;
        r1.w = 12.5 * r1.w;
        r1.x = r3.w ? r1.w : 0;
        r1.w = floor(r3.z);
        r1.w = r1.w * 0.00207039341 + -r3.y;
        r5.y = cb2[6].z * r1.w + r3.y;
        if (r0.w != 0) {
          r0.w = cmp(cb2[6].y == 0.000000);
          r0.w = r0.w ? 0 : r0.z;
          r4.x = r0.w * 4 + cb2[6].y;
          r4.y = 1 + r0.z;
          r4.xyzw = float4(0.00207039341,-0.000517598353,0.00207039341,0.000517598353) * r4.xyxy;
          r1.w = 1 + r1.z;
          r3.yz = -r4.xy * r1.ww + r5.xy;
          r3.yzw = t0.Sample(s0_s, r3.yz).xyz;
          r5.z = 0.289000005 * r3.z;
          r5.z = r3.y * -0.147 + -r5.z;
          r6.yw = r3.ww * float2(0.43599999,0.43599999) + r5.zz;
          r3.z = 0.514999986 * r3.z;
          r3.y = r3.y * 0.61500001 + -r3.z;
          r6.xz = -r3.ww * float2(0.100000001,0.100000001) + r3.yy;
          r3.yz = -r4.zw * r1.zz + r5.xy;
          r3.yzw = t0.Sample(s0_s, r3.yz).xyz;
          r5.z = 0.289000005 * r3.z;
          r5.z = r3.y * -0.147 + -r5.z;
          r7.yw = r3.ww * float2(0.43599999,0.43599999) + r5.zz;
          r3.z = 0.514999986 * r3.z;
          r3.y = r3.y * 0.61500001 + -r3.z;
          r7.xz = -r3.ww * float2(0.100000001,0.100000001) + r3.yy;
          r3.yzw = t0.Sample(s0_s, r5.xy).xyz;
          r5.z = dot(r3.yzw, float3(0.298999995,0.587000012,0.114));
          r5.w = 0.289000005 * r3.z;
          r5.w = r3.y * -0.147 + -r5.w;
          r8.yw = r3.ww * float2(0.43599999,0.43599999) + r5.ww;
          r3.z = 0.514999986 * r3.z;
          r3.y = r3.y * 0.61500001 + -r3.z;
          r8.xz = -r3.ww * float2(0.100000001,0.100000001) + r3.yy;
          r3.yz = r4.xy * r1.zz + r5.xy;
          r3.yzw = t0.Sample(s0_s, r3.yz).xyz;
          r1.z = 0.289000005 * r3.z;
          r1.z = r3.y * -0.147 + -r1.z;
          r9.yw = r3.ww * float2(0.43599999,0.43599999) + r1.zz;
          r1.z = 0.514999986 * r3.z;
          r1.z = r3.y * 0.61500001 + -r1.z;
          r9.xz = -r3.ww * float2(0.100000001,0.100000001) + r1.zz;
          r1.zw = r4.zw * r1.ww + r5.xy;
          r3.yzw = t0.Sample(s0_s, r1.zw).xyz;
          r1.z = 0.289000005 * r3.z;
          r1.z = r3.y * -0.147 + -r1.z;
          r4.yw = r3.ww * float2(0.43599999,0.43599999) + r1.zz;
          r1.z = 0.514999986 * r3.z;
          r1.z = r3.y * 0.61500001 + -r1.z;
          r4.xz = -r3.ww * float2(0.100000001,0.100000001) + r1.zz;
          r0.w = r0.w * 0.200000003 + 0.200000003;
          r6.xyzw = r7.xyzw + r6.xyzw;
          r6.xyzw = r6.xyzw + r8.xyzw;
          r6.xyzw = r6.xyzw + r9.xyzw;
          r4.xyzw = r6.xyzw + r4.xyzw;
          r4.xyzw = r4.xyzw * r0.wwww;
          r0.w = -r4.y * 0.395000011 + r5.z;
          r2.y = -r4.z * 0.58099997 + r0.w;
          r2.xz = r4.xw * float2(1.13999999,2.03200006) + r5.zz;
        } else {
          r2.xyz = t0.Sample(s0_s, r0.xy).xyz;
        }
        r0.xy = r5.xy;
      } else {
        r2.xyz = float3(0,0,0);
        r0.z = 0;
        r1.x = 0;
        r3.x = 0;
      }
    }
  }
  r0.w = cmp(asint(cb2[11].z) != 3);
  if (r0.w != 0) {
    r1.zw = cb2[4].wz + r0.yx;
    r3.yz = cb2[2].xy * r1.wz;
    r4.yz = (uint2)r3.yz;
    r4.x = (uint)r4.y >> 1;
    r4.w = 0;
    r0.w = t7.Load(r4.xzw).x;
    r3.y = (int)r4.y & 1;
    r3.z = (uint)r0.w >> 4;
    r0.w = r3.y ? r3.z : r0.w;
    r3.y = (int)r0.w & 2;
    r3.zw = asint(cb2[11].yw) & int2(1,1);
    if (r3.z != 0) {
      r5.xyz = t4.Sample(s4_s, r0.xy).xyz;
      r5.xyz = cb2[10].xxx * r5.xyz;
      r2.xyz = cb2[10].yyy * r2.xyz + r5.xyz;
    }
    switch (cb2[11].x) {
      case 1 :      r3.z = dot(float3(0.212599993,0.715200007,0.0722000003), r2.xyz);
      switch (cb2[11].z) {
        case 2 :        r4.x = log2(r3.z);
        r4.x = r4.x * 0.693147182 + 9.2103405;
        r4.x = max(0, r4.x);
        r4.x = 0.0492605828 * r4.x;
        r4.x = min(1, r4.x);
        r4.x = r4.x * 360 + 300;
        r4.x = 0.00278551527 * r4.x;
        r4.x = frac(r4.x);
        r5.x = 5.98333359 * r4.x;
        r5.x = floor(r5.x);
        r4.x = r4.x * 5.98333359 + -r5.x;
        r6.z = 1 + -r4.x;
        r7.y = 1 + -r6.z;
        r8.xyzw = cmp(r5.xxxx == float4(0,1,2,3));
        r4.x = cmp(r5.x == 4.000000);
        r6.xy = float2(1,0);
        r5.xy = r8.ww ? r6.yz : r7.yy;
        r4.x = (int)r4.x | (int)r8.w;
        r7.xz = float2(1,0);
        r5.z = 1;
        r5.xyz = r8.zzz ? r7.zxy : r5.xyz;
        r4.x = (int)r4.x | (int)r8.z;
        r5.xyz = r8.yyy ? r6.zxy : r5.xyz;
        r4.x = (int)r4.x | (int)r8.y;
        r5.xyz = r8.xxx ? r7.xyz : r5.xyz;
        r4.x = (int)r4.x | (int)r8.x;
        r2.xyz = r4.xxx ? r5.xyz : r6.xyz;
        break;
        case 3 :        break;
        default :
        r3.z = cb13[3].x * r3.z;
        r3.z = log2(r3.z);
        r5.xy = float2(5.97393131,7.97393131) + r3.zz;
        r3.z = (int)r5.x;
        r3.z = max(0, (int)r3.z);
        r3.z = min(6, (int)r3.z);
        r4.x = saturate(0.5 * r5.y);
        r4.x = r3.z ? 1 : r4.x;
        r2.xyz = icb[r3.z+0].xyz * r4.xxx;
        break;
      }
      break;
      default :
      r5.xyz = cmp(r2.xyz < cb13[0].xxx);
      r6.xyzw = r5.xxxx ? cb13[2].xyzw : cb13[1].xyzw;
      r5.xw = r6.xy * r2.xx + r6.zw;
      r2.x = saturate(r5.x / r5.w);
      r6.xyzw = r5.yyyy ? cb13[2].xyzw : cb13[1].xyzw;
      r5.xy = r6.xy * r2.yy + r6.zw;
      r2.y = saturate(r5.x / r5.y);
      r5.xyzw = r5.zzzz ? cb13[2].xyzw : cb13[1].xyzw;
      r5.xy = r5.xy * r2.zz + r5.zw;
      r2.z = saturate(r5.x / r5.y);
      break;
    }
    r5.x = saturate(dot(r2.xyz, cb2[7].xyz));
    r5.y = saturate(dot(r2.xyz, cb2[8].xyz));
    r5.z = saturate(dot(r2.xyz, cb2[9].xyz));
    r5.xyz = log2(r5.xyz);
    r5.xyz = float3(0.416666657,0.416666657,0.416666657) * r5.xyz;
    r5.xyz = exp2(r5.xyz);
    r5.xyz = r5.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
    r5.xyz = max(float3(0,0,0), r5.xyz);
    r6.xyz = cmp(float3(0.998039186,0.998039186,0.998039186) < r5.xyz);
    r7.xyz = cmp(r5.xyz < float3(0.00196078443,0.00196078443,0.00196078443));
    r3.z = (int)r6.y | (int)r6.x;
    r3.z = (int)r6.z | (int)r3.z;
    r4.x = (int)r7.y | (int)r7.x;
    r4.x = (int)r7.z | (int)r4.x;
    r3.z = (int)r3.z | (int)r4.x;
    r7.xyz = r7.xyz ? float3(1,1,1) : 0;
    r6.xyz = r6.xyz ? float3(-1,-1,-1) : float3(-0,-0,-0);
    r6.xyz = r7.xyz + r6.xyz;
    r6.xyz = r6.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5);
    r3.z = r3.w ? r3.z : 0;
    r5.xyz = r3.zzz ? r6.xyz : r5.xyz;
    r5.xyz = r5.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
    r2.xyz = t5.SampleLevel(s5_s, r5.xyz, 0).xyz;
    r3.zw = cmp(asint(cb2[5].wz) == int2(3,2));
    r1.y = (int)r1.y | (int)r3.w;
    r1.y = r1.y ? r3.z : 0;
    if (r1.y != 0) {
      r1.y = 8 * r0.x;
      r0.x = r0.y * 483 + r0.x;
      r3.z = 123.779999 * cb2[0].w;
      r3.z = frac(r3.z);
      r3.z = 12345.5996 * r3.z;
      r0.x = r0.x * 234.5 + r3.z;
      r3.z = floor(r0.x);
      r0.x = frac(r0.x);
      r3.w = 0.103100002 * r3.z;
      r3.w = frac(r3.w);
      r4.x = 19.1900005 + r3.w;
      r4.x = dot(r3.www, r4.xxx);
      r3.w = r4.x + r3.w;
      r4.x = r3.w + r3.w;
      r3.w = r4.x * r3.w;
      r3.z = 1 + r3.z;
      r3.z = 0.103100002 * r3.z;
      r3.zw = frac(r3.zw);
      r4.x = 19.1900005 + r3.z;
      r4.x = dot(r3.zzz, r4.xxx);
      r3.z = r4.x + r3.z;
      r4.x = r3.z + r3.z;
      r3.z = r4.x * r3.z;
      r3.z = frac(r3.z);
      r4.x = 1 + -r0.x;
      r3.w = r4.x * r3.w;
      r0.x = r3.z * r0.x + r3.w;
      r3.z = cb2[6].z * 0.300000012 + 1;
      r5.xyz = r3.zzz * r2.xyz;
      r3.z = -0.699999988 + r1.x;
      r3.z = 4 * abs(r3.z);
      r3.z = min(1, r3.z);
      r3.z = 1 + -r3.z;
      r3.w = cmp(r1.x >= 0.00100000005);
      r3.w = r3.w ? 1.000000 : 0;
      r3.z = r3.z * r3.w;
      r3.z = r3.z * r0.x;
      r1.x = cmp(0 < r1.x);
      r5.xyz = r1.xxx ? r3.zzz : r5.xyz;
      r0.x = -0.5 + r0.x;
      r0.x = dot(r0.xx, r0.zz);
      r5.xyz = saturate(r5.xyz + r0.xxx);
      r0.x = r0.y * 2 + r1.y;
      r0.x = cb2[0].w * 0.200000003 + r0.x;
      r0.x = 20 * r0.x;
      r0.x = frac(r0.x);
      r0.x = -r0.x * 2 + 1;
      r0.x = cb2[6].z * abs(r0.x);
      r0.y = 0.25 * r0.z;
      r0.x = saturate(r0.x * 0.5 + r0.y);
      r0.y = dot(r5.xyz, float3(0.298999995,0.587000012,0.114));
      r6.xyz = r0.yyy + -r5.xyz;
      r0.xyz = r0.xxx * r6.xyz + r5.xyz;
      r1.x = frac(r3.x);
      r1.x = -r1.x * 2 + 1;
      r1.x = cb2[6].z * abs(r1.x);
      r1.x = -r1.x * 0.75 + 1;
      r2.xyz = saturate(r1.xxx * r0.xyz);
    }
    if (r3.y != 0) {
      r0.xy = (int2)r0.ww & int2(4,8);
      r0.x = cmp((int)r0.x != 0);
      r0.zw = t6.Load(r4.yzw).xy;
      r0.zw = float2(255.5,255.100006) * r0.wz;
      r0.zw = (uint2)r0.zw;
      r0.z = (uint)r0.z << 11;
      bitmask.z = ((~(-1 << 8)) << 3) & 0xffffffff;  r0.z = (((uint)r0.w << 3) & bitmask.z) | ((uint)r0.z & ~bitmask.z);
      r0.w = (int)r0.z + 2;
      r0.w = t14.Load(r0.w).x;
      r0.w = cmp(0 < r0.w);
      r0.y = cmp((int)r0.y == 0);
      r0.x = r0.y ? r0.x : 0;
      r0.y = t14.Load(r0.z).w;
      r0.y = cmp(0 < r0.y);
      r0.x = r0.y ? r0.x : 0;
      if (r0.x != 0) {
        if (r0.w != 0) {
          r0.xyz = cb2[17].xyz;
          r3.xyz = cb2[16].xyz;
        } else {
          r0.xyz = cb2[15].xyz;
          r3.xyz = cb2[14].xyz;
        }
        r0.w = cb2[12].x;
        r1.x = cb2[13].y;
        r4.xyz = t1.Gather(s1_s, r1.wz).xzw;
        r5.xy = abs(r4.zz) + -abs(r4.yx);
        r5.z = abs(r4.z) * 0.000250000012 + 2.32830644e-010;
        r1.y = dot(r5.xyz, r5.xyz);
        r1.y = (uint)r1.y >> 1;
        r1.y = (int)-r1.y + 0x5f3759df;
        r1.y = r5.z * r1.y;
        r1.y = min(1, r1.y);
      } else {
        r0.xyz = cb2[19].xyz;
        r3.xyz = cb2[18].xyz;
        r0.w = cb2[12].y;
        r1.x = cb2[13].z;
        r1.y = dot(r2.xyz, float3(0.212599993,0.715200007,0.0722000003));
      }
      r4.xy = cb2[0].yx + r1.zw;
      r4.xy = r4.xy * float2(1024,1024) + float2(-512,-512);
      r4.zw = float2(0.554549694,0.308517009) * r4.yx;
      r4.zw = frac(r4.zw);
      r4.xy = r4.yx * r4.zw + r4.xy;
      r3.w = r4.x * r4.y;
      r3.w = frac(r3.w);
      r3.w = r3.w * 2 + -1;
      r3.w = r3.w * r1.x + 1;
      r1.y = saturate(r3.w * r1.y);
      r1.y = (int)r1.y;
      r1.y = -1.06529242e+009 + r1.y;
      r0.w = r0.w * r1.y + 1.06529242e+009;
      r0.w = (int)r0.w;
      r0.w = saturate(r0.w);
      r0.xyz = r0.xyz + -r3.xyz;
      r0.xyz = r0.www * r0.xyz + r3.xyz;
      r1.yz = cb2[0].ww * r1.zw;
      r1.yz = frac(r1.yz);
      r1.yz = r1.yz * float2(1024,1024) + float2(-512,-512);
      r3.xy = float2(0.554549694,0.308517009) * r1.zy;
      r3.xy = frac(r3.xy);
      r1.yz = r1.zy * r3.xy + r1.yz;
      r0.w = r1.y * r1.z;
      r0.w = frac(r0.w);
      r0.w = r0.w * 2 + -1;
      r0.w = r0.w * r1.x + 1;
      r2.xyz = saturate(r0.xyz * r0.www);
    }
    r2.w = dot(r2.xyz, float3(0.212599993,0.715200007,0.0722000003));
  } else {
    r2.w = 1;
  }
  o0.xyzw = r2.xyzw;
  o1.x = r2.w;
  return;
}