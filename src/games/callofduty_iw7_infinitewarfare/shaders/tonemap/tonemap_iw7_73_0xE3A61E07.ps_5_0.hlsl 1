// ---- Created with 3Dmigoto v1.3.16 on Wed Aug 20 15:45:32 2025
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
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb2[3].xy + v1.xy;
  r1.xyz = cmp(asint(cb2[4].zzw) == int3(1,3,1));
  r0.w = (int)r1.y | (int)r1.x;
  if (r1.z != 0) {
    r1.x = -cb2[5].y * 2 + r0.y;
    r1.x = saturate(1 + r1.x);
    r1.x = r1.x * r1.x;
    r2.x = cb2[4].x * cb2[0].x;
    r2.z = -cb2[0].w * cb2[4].y + r0.y;
    r0.z = 1;
    r1.zw = r2.xz + r0.xz;
    r2.xy = t1.Sample(s1_s, r1.zw).xy;
    r1.zw = float2(0.5,0.5) * r1.zw;
    r1.zw = t1.Sample(s1_s, r1.zw).xy;
    r2.xy = cb2[0].yy * r2.xy;
    r1.zw = cb2[0].xx * r1.zw;
    r1.zw = float2(0.5,0.5) * r1.zw;
    r1.zw = r2.xy * float2(0.5,0.5) + r1.zw;
    r0.z = cb2[5].x * r1.x;
    r1.xz = saturate(r1.zw * r0.zz + r0.xy);
    r2.xy = r0.ww ? r1.xz : r0.xy;
    r2.xyz = t0.Sample(s0_s, r2.xy).xyz;
    r0.xy = r1.xz;
    r0.z = 0;
    r1.x = 0;
    r3.x = 0;
  } else {
    r1.z = cmp(asint(cb2[4].w) == 2);
    if (r1.z != 0) {
      r1.z = cb2[4].y * cb2[0].z;
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
      r4.yz = t2.Sample(s2_s, r4.yz).zw;
      r3.w = sin(r4.x);
      r3.w = max(0, r3.w);
      r3.w = r4.z * r3.w;
      r4.x = saturate(cb2[4].x + -r4.y);
      r1.zw = t2.Sample(s2_s, r1.zw).xy;
      r1.zw = r1.zw * float2(2,2) + float2(-1,-1);
      r3.w = r4.x * r3.w;
      r4.xz = r4.xx * float2(0.100000001,0.0329999998) + r3.ww;
      r1.zw = r4.xz * r1.zw;
      r3.w = r1.z * 0.5 + cb2[4].x;
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
      r1.z = cmp(asint(cb2[4].w) == 3);
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
        r3.w = cb2[4].y * r3.w;
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
        r4.w = cb2[4].x * r4.w;
        r3.w = 0.00828157365 * r3.w;
        r3.w = r4.w * r1.z + r3.w;
        r4.z = r4.z * 0.333333343 + -0.119999997;
        r4.z = -abs(r4.z) * 20 + 1;
        r4.z = max(0, r4.z);
        r4.z = r4.z * r4.z;
        r4.z = cb2[4].x * r4.z;
        r0.z = r4.z * 0.400000006 + r4.x;
        r5.x = r3.w + r0.x;
        r3.w = floor(r4.y);
        r3.w = cb2[0].w * 0.333333343 + -r3.w;
        r4.xy = float2(-43.2808495,30) * r3.ww;
        r3.w = exp2(r4.x);
        r3.w = saturate(-0.00999999978 + r3.w);
        r4.x = cos(r4.y);
        r3.w = -r4.x * r3.w;
        r3.w = cb2[5].x * r3.w;
        r4.x = 0.600000024 * r3.w;
        r4.y = cmp(0.949999988 < cb2[5].x);
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
        r5.y = cb2[5].z * r1.w + r3.y;
        if (r0.w != 0) {
          r0.w = cmp(cb2[5].y == 0.000000);
          r0.w = r0.w ? 0 : r0.z;
          r4.x = r0.w * 4 + cb2[5].y;
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
  r0.w = cmp(asint(cb2[10].z) != 3);
  if (r0.w != 0) {
    r1.zw = cb2[3].wz + r0.yx;
    r3.yz = cb2[2].xy * r1.wz;
    r4.yz = (uint2)r3.yz;
    r4.x = (uint)r4.y >> 1;
    r4.w = 0;
    r0.w = t5.Load(r4.xzw).x;
    r3.y = (int)r4.y & 1;
    r3.z = (uint)r0.w >> 4;
    r0.w = r3.y ? r3.z : r0.w;
    r3.z = (int)r0.w & 4;
    switch (cb2[10].x) {
      case 1 :      r3.w = dot(float3(0.212599993,0.715200007,0.0722000003), r2.xyz);
      switch (cb2[10].z) {
        case 2 :        r5.x = log2(r3.w);
        r5.x = r5.x * 0.693147182 + 9.2103405;
        r5.x = max(0, r5.x);
        r5.x = 0.0492605828 * r5.x;
        r5.x = min(1, r5.x);
        r5.x = r5.x * 360 + 300;
        r5.x = 0.00278551527 * r5.x;
        r5.x = frac(r5.x);
        r5.y = 5.98333359 * r5.x;
        r5.y = floor(r5.y);
        r5.x = r5.x * 5.98333359 + -r5.y;
        r6.z = 1 + -r5.x;
        r7.y = 1 + -r6.z;
        r8.xyzw = cmp(r5.yyyy == float4(0,1,2,3));
        r5.x = cmp(r5.y == 4.000000);
        r6.xy = float2(1,0);
        r9.xy = r8.ww ? r6.yz : r7.yy;
        r5.x = (int)r5.x | (int)r8.w;
        r7.xz = float2(1,0);
        r9.z = 1;
        r5.yzw = r8.zzz ? r7.zxy : r9.xyz;
        r5.x = (int)r5.x | (int)r8.z;
        r5.yzw = r8.yyy ? r6.zxy : r5.yzw;
        r5.x = (int)r5.x | (int)r8.y;
        r5.yzw = r8.xxx ? r7.xyz : r5.yzw;
        r5.x = (int)r5.x | (int)r8.x;
        r2.xyz = r5.xxx ? r5.yzw : r6.xyz;
        break;
        case 3 :        break;
        default :
        r3.w = cb13[3].x * r3.w;
        r3.w = log2(r3.w);
        r5.xy = float2(5.97393131,7.97393131) + r3.ww;
        r3.w = (int)r5.x;
        r3.w = max(0, (int)r3.w);
        r3.w = min(6, (int)r3.w);
        r5.x = saturate(0.5 * r5.y);
        r5.x = r3.w ? 1 : r5.x;
        r2.xyz = icb[r3.w+0].xyz * r5.xxx;
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
    r3.w = asint(cb2[10].w) & 1;
    r6.xyz = cmp(float3(0.998039186,0.998039186,0.998039186) < r5.xyz);
    r7.xyz = cmp(r5.xyz < float3(0.00196078443,0.00196078443,0.00196078443));
    r5.w = (int)r6.y | (int)r6.x;
    r5.w = (int)r6.z | (int)r5.w;
    r6.w = (int)r7.y | (int)r7.x;
    r6.w = (int)r7.z | (int)r6.w;
    r5.w = (int)r5.w | (int)r6.w;
    r7.xyz = r7.xyz ? float3(1,1,1) : 0;
    r6.xyz = r6.xyz ? float3(-1,-1,-1) : float3(-0,-0,-0);
    r6.xyz = r7.xyz + r6.xyz;
    r6.xyz = r6.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5);
    r3.w = r3.w ? r5.w : 0;
    r5.xyz = r3.www ? r6.xyz : r5.xyz;
    r5.xyz = r5.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
    r5.xyz = t3.SampleLevel(s3_s, r5.xyz, 0).xyz;
    r6.xy = cmp(asint(cb2[4].wz) == int2(3,2));
    r1.y = (int)r1.y | (int)r6.y;
    r1.y = r1.y ? r6.x : 0;
    if (r1.y != 0) {
      r1.y = 8 * r0.x;
      r3.w = r0.y * 483 + r0.x;
      r5.w = 123.779999 * cb2[0].w;
      r5.w = frac(r5.w);
      r5.w = 12345.5996 * r5.w;
      r3.w = r3.w * 234.5 + r5.w;
      r5.w = floor(r3.w);
      r3.w = frac(r3.w);
      r6.x = 0.103100002 * r5.w;
      r6.x = frac(r6.x);
      r6.y = 19.1900005 + r6.x;
      r6.y = dot(r6.xxx, r6.yyy);
      r6.x = r6.x + r6.y;
      r6.y = r6.x + r6.x;
      r6.x = r6.y * r6.x;
      r6.x = frac(r6.x);
      r5.w = 1 + r5.w;
      r5.w = 0.103100002 * r5.w;
      r5.w = frac(r5.w);
      r6.y = 19.1900005 + r5.w;
      r6.y = dot(r5.www, r6.yyy);
      r5.w = r6.y + r5.w;
      r6.y = r5.w + r5.w;
      r5.w = r6.y * r5.w;
      r5.w = frac(r5.w);
      r6.y = 1 + -r3.w;
      r6.x = r6.x * r6.y;
      r3.w = r5.w * r3.w + r6.x;
      r5.w = cb2[5].z * 0.300000012 + 1;
      r6.xyz = r5.xyz * r5.www;
      r5.w = -0.699999988 + r1.x;
      r5.w = 4 * abs(r5.w);
      r5.w = min(1, r5.w);
      r5.w = 1 + -r5.w;
      r6.w = cmp(r1.x >= 0.00100000005);
      r6.w = r6.w ? 1.000000 : 0;
      r5.w = r6.w * r5.w;
      r5.w = r5.w * r3.w;
      r1.x = cmp(0 < r1.x);
      r6.xyz = r1.xxx ? r5.www : r6.xyz;
      r1.x = -0.5 + r3.w;
      r1.x = dot(r1.xx, r0.zz);
      r6.xyz = saturate(r6.xyz + r1.xxx);
      r1.x = r0.y * 2 + r1.y;
      r1.x = cb2[0].w * 0.200000003 + r1.x;
      r1.x = 20 * r1.x;
      r1.x = frac(r1.x);
      r1.x = -r1.x * 2 + 1;
      r1.x = cb2[5].z * abs(r1.x);
      r0.z = 0.25 * r0.z;
      r0.z = saturate(r1.x * 0.5 + r0.z);
      r1.x = dot(r6.xyz, float3(0.298999995,0.587000012,0.114));
      r7.xyz = r1.xxx + -r6.xyz;
      r6.xyz = r0.zzz * r7.xyz + r6.xyz;
      r0.z = frac(r3.x);
      r0.z = -r0.z * 2 + 1;
      r0.z = cb2[5].z * abs(r0.z);
      r0.z = -r0.z * 0.75 + 1;
      r5.xyz = saturate(r6.xyz * r0.zzz);
    }
    if (r3.z != 0) {
      r0.z = (int)r0.w & 8;
      r1.xy = t4.Load(r4.yzw).xy;
      r1.xy = float2(255.5,255.100006) * r1.yx;
      r1.xy = (uint2)r1.xy;
      r0.w = (uint)r1.x << 11;
      bitmask.w = ((~(-1 << 8)) << 3) & 0xffffffff;  r0.w = (((uint)r1.y << 3) & bitmask.w) | ((uint)r0.w & ~bitmask.w);
      r1.xy = (int2)r0.ww + int2(1,2);
      r3.xz = t14.Load(r1.x).yw;
      r1.xy = t14.Load(r1.y).yz;
      r6.xyzw = t14.Load(r0.w).xyzw;
      r1.xy = cmp(float2(0,0) < r1.xy);
      r0.w = r0.z ? 1 : 0;
      r0.w = r1.x ? r0.w : r3.x;
      r1.x = (uint)cb2[11].w;
      if (r0.z != 0) {
        r0.w = r0.w * r3.z;
        r7.xyzw = float4(-1,-1,-1,-1) + r6.xyzw;
        r7.xyzw = cb2[11].xxxx * r7.xyzw + float4(1,1,1,1);
        r7.xyzw = cb2[14].xyzw * r7.xyzw;
        r6.xyzw = r7.xyzw * r3.zzzz;
        r7.xyzw = cb2[16].xyzw;
        r8.xyzw = cb2[15].xyzw;
      } else {
        r7.xyzw = cb2[12].xyzw;
        r8.xyzw = cb2[13].xyzw;
      }
      r3.x = cb2[0].x + cb2[0].x;
      r1.y = r1.y ? r3.x : 1;
      r6.xyzw = r6.xyzw * r1.yyyy;
      if (r1.x == 0) {
        r1.y = 0;
      } else {
        r9.xy = (int2)-r1.xx + (int2)r4.zy;
        r9.zw = r4.xw;
        r3.x = t5.Load(r9.zxw).x;
        r3.z = (uint)r3.x >> 4;
        r3.x = r3.y ? r3.z : r3.x;
        r3.x = (int)r3.x & 4;
        r3.x = cmp((int)r3.x != 0);
        r10.xy = (int2)r1.xx + (int2)r4.zy;
        r10.zw = r9.zw;
        r1.x = t5.Load(r10.zxw).x;
        r3.z = (uint)r1.x >> 4;
        r1.x = r3.y ? r3.z : r1.x;
        r1.x = (int)r1.x & 4;
        r1.x = cmp((int)r1.x != 0);
        r4.y = (uint)r9.y >> 1;
        r3.y = t5.Load(r4.yzw).x;
        r3.z = (int)r9.y & 1;
        r3.w = (uint)r3.y >> 4;
        r3.y = r3.z ? r3.w : r3.y;
        r3.y = (int)r3.y & 4;
        r3.y = cmp((int)r3.y != 0);
        r4.x = (uint)r10.y >> 1;
        r3.z = t5.Load(r4.xzw).x;
        r3.w = (int)r10.y & 1;
        r4.x = (uint)r3.z >> 4;
        r3.z = r3.w ? r4.x : r3.z;
        r3.z = (int)r3.z & 4;
        r3.z = cmp((int)r3.z != 0);
        r1.x = r1.x ? r3.x : 0;
        r1.x = r3.y ? r1.x : 0;
        r1.x = r3.z ? r1.x : 0;
        r1.y = ~(int)r1.x;
      }
      if (r1.y == 0) {
        r1.xy = cb2[1].yx * r1.zw;
        r3.xyzw = float4(12,12,12,12) * r1.yxyx;
        r3.xyzw = cmp(r3.xyzw >= -r3.zwzw);
        r3.xyzw = r3.xyzw ? float4(12,12,0.0833333358,0.0833333358) : float4(-12,-12,-0.0833333358,-0.0833333358);
        r1.yz = r3.wz * r1.xy;
        r1.yz = frac(r1.yz);
        r1.yz = r3.yx * r1.yz;
        r1.xyz = (uint3)r1.xyz;
        r3.xy = cmp((int2)r1.zy == int2(0,0));
        r1.xyz = (int3)r1.xyz & int3(2,14,14);
        r1.xyz = cmp((int3)r1.xyz != int3(0,6,6));
        r1.yz = r1.yz ? r3.xy : 0;
        r1.y = (int)r1.z | (int)r1.y;
        r0.z = r0.z ? r1.y : r1.x;
        r1.xyzw = r0.zzzz ? r8.xyzw : r7.xyzw;
        r1.xyzw = r1.xyzw * r0.wwww;
        r6.xyzw = r1.xyzw * r6.xyzw;
      }
      r1.xyz = r6.xyz + -r5.xyz;
      r5.xyz = r6.www * r1.xyz + r5.xyz;
    }
    r2.w = dot(r5.xyz, float3(0.212599993,0.715200007,0.0722000003));
    r0.z = min(r5.x, r5.y);
    r0.w = max(r5.x, r5.y);
    r0.w = min(r0.w, r5.z);
    r0.z = max(r0.z, r0.w);
    r0.w = -0.100000001 + r0.z;
    r0.w = saturate(-10 * r0.w);
    r1.x = r0.w * -2 + 3;
    r0.w = r0.w * r0.w;
    r0.z = r1.x * r0.w + r0.z;
    r0.xy = cb2[0].ww * r0.yx;
    r0.xy = frac(r0.xy);
    r0.xy = r0.xy * float2(1024,1024) + float2(-512,-512);
    r1.xy = float2(0.554549694,0.308517009) * r0.yx;
    r1.xy = frac(r1.xy);
    r0.xy = r0.yx * r1.xy + r0.xy;
    r0.xz = r0.xz * r0.yz;
    r0.x = frac(r0.x);
    r0.x = r0.x * 2 + -1;
    r0.y = min(1, r0.z);
    r0.x = r0.y * -r0.x + r0.x;
    r0.x = cb2[6].y * r0.x;
    r2.xyz = r5.xyz * r0.xxx + r5.xyz;
  } else {
    r2.w = 1;
  }
  o0.xyzw = r2.xyzw;
  o1.x = r2.w;
  return;
}