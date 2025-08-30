// ---- Created with 3Dmigoto v1.3.16 on Wed Aug 20 15:43:45 2025
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
  const float4 icb[] = { { 1.000000, 0, 0, 0},
                              { 1.000000, 0.250000, 0, 0},
                              { 1.000000, 1.000000, 0, 0},
                              { 0, 1.000000, 0, 0},
                              { 0, 0.250000, 1.000000, 0},
                              { 0, 1.000000, 1.000000, 0},
                              { 1.000000, 1.000000, 1.000000, 0} };
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11;
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
    r2.zw = float2(1,1) + -cb2[7].xz;
    r0.z = cmp(0 < cb2[7].w);
    if (r0.z != 0) {
      r3.xy = cb2[8].xy * float2(0.5,0.5) + float2(0.5,0.5);
      r4.xy = cb2[1].xy * cb2[1].wz;
      r4.z = 1;
      r3.zw = r4.zy * r3.xy;
      r5.xy = r2.xy * r4.zy + -r3.zw;
      r0.z = dot(r5.xy, r5.xy);
      r0.z = (uint)r0.z >> 1;
      r0.z = (int)r0.z + 0x1fbd1df5;
      r1.w = -3 * cb2[7].w;
      r5.xy = r5.xy / r0.zz;
      r0.z = r1.w * r0.z;
      r3.z = r0.z * r0.z;
      r3.z = 0.0662999973 * r3.z;
      r3.z = abs(r0.z) * -0.178399995 + -r3.z;
      r3.z = 1.03009999 + r3.z;
      r0.z = r3.z * r0.z;
      r5.xy = r5.xy * r0.zz;
      r5.xy = r5.xy * r3.ww;
      r0.z = r1.w * r3.w;
      r1.w = r0.z * r0.z;
      r1.w = 0.0662999973 * r1.w;
      r1.w = abs(r0.z) * -0.178399995 + -r1.w;
      r1.w = 1.03009999 + r1.w;
      r0.z = r1.w * r0.z;
      r3.zw = r5.xy / r0.zz;
      r3.xy = r3.xy * r4.zy + r3.zw;
      r2.xy = r3.xy * r4.zx;
    }
    r3.xyzw = r2.xyxy * float4(2,2,2,2) + float4(-1,-1,-1,-1);
    r3.xyzw = -cb2[8].xyxy + r3.xyzw;
    r0.z = dot(r3.zw, r3.zw);
    r0.z = (uint)r0.z >> 1;
    r0.z = (int)r0.z + 0x1fbd1df5;
    r0.z = max(0, r0.z);
    r1.w = cmp(r2.z < r0.z);
    if (r1.w != 0) {
      r4.xy = float2(1,1) + -r2.zw;
      r1.w = r0.z + -r2.z;
      r2.z = 1 / r4.x;
      r1.w = saturate(r2.z * r1.w);
      r2.z = r1.w * -2 + 3;
      r1.w = r1.w * r1.w;
      r1.w = r2.z * r1.w;
      r1.w = cb2[7].y * r1.w;
      r3.xyzw = r1.wwww * r3.xyzw;
      r1.w = 1 + -cb2[8].z;
      r2.z = 1 + -r0.z;
      r0.z = r2.z / r0.z;
      r0.z = r0.z * cb2[8].z + r1.w;
      r3.xyzw = r3.xyzw * r0.zzzz;
      r4.xz = r2.yx * float2(1024,1024) + float2(-512,-512);
      r5.xy = float2(0.554549694,0.308517009) * r4.zx;
      r5.xy = frac(r5.xy);
      r4.xz = r4.zx * r5.xy + r4.xz;
      r0.z = r4.x * r4.z;
      r0.z = frac(r0.z);
      r0.z = r0.z * 2 + -1;
      r5.xyzw = r0.zzzz * float4(0.100000001,0.100000001,0.100000001,0.100000001) + float4(-1,-0.600000024,-0.199999988,0.200000048);
      r6.xyzw = -r3.zwzw * r5.xxyy + r2.xyxy;
      r4.xzw = t0.SampleLevel(s0_s, r6.xy, 0).xyz;
      r0.z = min(1, -r5.x);
      r7.x = r0.z * r4.y + r2.w;
      r8.xyz = r5.xzy * cb2[7].zzz + float3(1,1,1);
      r7.y = r8.x;
      r7.z = 1 + -cb2[7].z;
      r6.xyz = t0.SampleLevel(s0_s, r6.zw, 0).xyz;
      r9.xy = -r5.yz * r4.yy + r2.ww;
      r9.z = r8.z;
      r9.w = 1 + -cb2[7].z;
      r6.xyz = r9.xzw * r6.xyz;
      r4.xzw = r7.xyz * r4.xzw + r6.xyz;
      r6.xyz = r9.xzw + r7.xyz;
      r3.xyzw = -r3.xyzw * r5.zzww + r2.xyxy;
      r5.xyz = t0.SampleLevel(s0_s, r3.xy, 0).xyz;
      r8.xz = r9.yw;
      r4.xzw = r8.xyz * r5.xyz + r4.xzw;
      r5.xyz = r8.xyz + r6.xyz;
      r3.xyz = t0.SampleLevel(s0_s, r3.zw, 0).xyz;
      r6.y = r5.w * -cb2[7].z + 1;
      r6.z = r5.w * r4.y + r2.w;
      r6.x = 1 + -cb2[7].z;
      r3.xyz = r6.xyz * r3.xyz + r4.xzw;
      r4.xyz = r6.xyz + r5.xyz;
      r3.xyz = r3.xyz / r4.xyz;
    } else {
      r3.xyz = t0.SampleLevel(s0_s, r2.xy, 0).xyz;
    }
    r0.xy = r1.xz;
    r0.z = 0;
    r1.x = 0;
    r2.x = 0;
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
      r2.w = floor(r4.w);
      r5.x = 0.0166002642 * r2.w;
      r5.y = 0;
      r4.yz = r0.xy * float2(0.25,1) + r5.xy;
      r4.yz = t3.Sample(s3_s, r4.yz).zw;
      r2.w = sin(r4.x);
      r2.w = max(0, r2.w);
      r2.w = r4.z * r2.w;
      r4.x = saturate(cb2[5].x + -r4.y);
      r1.zw = t3.Sample(s3_s, r1.zw).xy;
      r1.zw = r1.zw * float2(2,2) + float2(-1,-1);
      r2.w = r4.x * r2.w;
      r4.xz = r4.xx * float2(0.100000001,0.0329999998) + r2.ww;
      r1.zw = r4.xz * r1.zw;
      r2.w = r1.z * 0.5 + cb2[5].x;
      r2.w = cmp(r4.y < r2.w);
      r1.zw = r2.ww ? r1.zw : 0;
      r1.zw = r1.zw + r0.xy;
      r4.xy = r0.ww ? r1.zw : r0.xy;
      r2.w = 1 + -cb2[7].x;
      r4.z = cmp(0 < cb2[7].w);
      if (r4.z != 0) {
        r4.zw = cb2[8].xy * float2(0.5,0.5) + float2(0.5,0.5);
        r5.xy = cb2[1].xy * cb2[1].wz;
        r5.z = 1;
        r6.xy = r5.zy * r4.zw;
        r6.xz = r4.xy * r5.zy + -r6.xy;
        r5.w = dot(r6.xz, r6.xz);
        r5.w = (uint)r5.w >> 1;
        r5.w = (int)r5.w + 0x1fbd1df5;
        r6.w = -3 * cb2[7].w;
        r6.xz = r6.xz / r5.ww;
        r5.w = r6.w * r5.w;
        r7.x = r5.w * r5.w;
        r7.x = 0.0662999973 * r7.x;
        r7.x = abs(r5.w) * -0.178399995 + -r7.x;
        r7.x = 1.03009999 + r7.x;
        r5.w = r7.x * r5.w;
        r6.xz = r6.xz * r5.ww;
        r6.xz = r6.xz * r6.yy;
        r5.w = r6.w * r6.y;
        r6.y = r5.w * r5.w;
        r6.y = 0.0662999973 * r6.y;
        r6.y = abs(r5.w) * -0.178399995 + -r6.y;
        r6.y = 1.03009999 + r6.y;
        r5.w = r6.y * r5.w;
        r6.xy = r6.xz / r5.ww;
        r4.zw = r4.zw * r5.zy + r6.xy;
        r4.xy = r4.zw * r5.zx;
      }
      r5.xyzw = r4.xyxy * float4(2,2,2,2) + float4(-1,-1,-1,-1);
      r5.xyzw = -cb2[8].xyxy + r5.xyzw;
      r4.z = dot(r5.zw, r5.zw);
      r4.z = (uint)r4.z >> 1;
      r4.z = (int)r4.z + 0x1fbd1df5;
      r4.z = max(0, r4.z);
      r4.w = cmp(r2.w < r4.z);
      if (r4.w != 0) {
        r6.xw = float2(1,1) + -cb2[7].zz;
        r4.w = 1 + -r2.w;
        r2.w = r4.z + -r2.w;
        r4.w = 1 / r4.w;
        r2.w = saturate(r4.w * r2.w);
        r4.w = r2.w * -2 + 3;
        r2.w = r2.w * r2.w;
        r2.w = r4.w * r2.w;
        r2.w = cb2[7].y * r2.w;
        r5.xyzw = r2.wwww * r5.xyzw;
        r2.w = 1 + -cb2[8].z;
        r4.w = 1 + -r4.z;
        r4.z = r4.w / r4.z;
        r2.w = r4.z * cb2[8].z + r2.w;
        r5.xyzw = r5.xyzw * r2.wwww;
        r4.zw = r4.yx * float2(1024,1024) + float2(-512,-512);
        r7.xy = float2(0.554549694,0.308517009) * r4.wz;
        r7.xy = frac(r7.xy);
        r4.zw = r4.wz * r7.xy + r4.zw;
        r2.w = r4.z * r4.w;
        r2.w = frac(r2.w);
        r2.w = r2.w * 2 + -1;
        r7.xyzw = r2.wwww * float4(0.100000001,0.100000001,0.100000001,0.100000001) + float4(-1,-0.600000024,-0.199999988,0.200000048);
        r8.xyzw = -r5.zwzw * r7.xxyy + r4.xyxy;
        r9.xyz = t0.SampleLevel(s0_s, r8.xy, 0).xyz;
        r2.w = min(1, -r7.x);
        r4.z = 1 + -r6.x;
        r6.y = r2.w * r4.z + r6.x;
        r10.xyz = r7.xzy * cb2[7].zzz + float3(1,1,1);
        r6.z = r10.x;
        r8.xyz = t0.SampleLevel(s0_s, r8.zw, 0).xyz;
        r11.xy = -r7.yz * r4.zz + r6.xx;
        r11.z = r10.z;
        r11.w = 1 + -cb2[7].z;
        r8.xyz = r11.xzw * r8.xyz;
        r8.xyz = r6.yzw * r9.xyz + r8.xyz;
        r6.yzw = r11.xzw + r6.yzw;
        r5.xyzw = -r5.xyzw * r7.zzww + r4.xyxy;
        r7.xyz = t0.SampleLevel(s0_s, r5.xy, 0).xyz;
        r10.xz = r11.yw;
        r7.xyz = r10.xyz * r7.xyz + r8.xyz;
        r6.yzw = r10.xyz + r6.yzw;
        r5.xyz = t0.SampleLevel(s0_s, r5.zw, 0).xyz;
        r8.y = r7.w * -cb2[7].z + 1;
        r8.z = r7.w * r4.z + r6.x;
        r8.x = 1 + -cb2[7].z;
        r5.xyz = r8.xyz * r5.xyz + r7.xyz;
        r6.xyz = r8.xyz + r6.yzw;
        r3.xyz = r5.xyz / r6.xyz;
      } else {
        r3.xyz = t0.SampleLevel(s0_s, r4.xy, 0).xyz;
      }
      r0.xy = r1.zw;
      r0.z = 0;
      r1.x = 0;
      r2.x = 0;
    } else {
      r1.z = cmp(asint(cb2[5].w) == 3);
      if (r1.z != 0) {
        r4.xyz = float3(1234,0.333333343,0.200000003) * cb2[0].www;
        r1.zw = frac(r4.xz);
        r1.z = 12345 * r1.z;
        r1.z = r0.y * 100 + r1.z;
        r1.z = 0.103100002 * r1.z;
        r1.z = frac(r1.z);
        r2.w = 19.1900005 + r1.z;
        r2.w = dot(r1.zzz, r2.www);
        r1.z = r2.w + r1.z;
        r2.w = r1.z + r1.z;
        r1.z = r2.w * r1.z;
        r1.z = frac(r1.z);
        r2.w = 123.449997 * r1.z;
        r2.w = frac(r2.w);
        r2.w = cb2[5].y * r2.w;
        r4.x = r2.w + r2.w;
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
        r2.w = 0.00828157365 * r2.w;
        r2.w = r4.w * r1.z + r2.w;
        r4.z = r4.z * 0.333333343 + -0.119999997;
        r4.z = -abs(r4.z) * 20 + 1;
        r4.z = max(0, r4.z);
        r4.z = r4.z * r4.z;
        r4.z = cb2[5].x * r4.z;
        r0.z = r4.z * 0.400000006 + r4.x;
        r5.x = r2.w + r0.x;
        r2.w = floor(r4.y);
        r2.w = cb2[0].w * 0.333333343 + -r2.w;
        r4.xy = float2(-43.2808495,30) * r2.ww;
        r2.w = exp2(r4.x);
        r2.w = saturate(-0.00999999978 + r2.w);
        r4.x = cos(r4.y);
        r2.w = -r4.x * r2.w;
        r2.w = cb2[6].x * r2.w;
        r4.x = 0.600000024 * r2.w;
        r4.y = cmp(0.949999988 < cb2[6].x);
        r1.w = r2.w * 0.600000024 + r1.w;
        r1.w = -0.5 + r1.w;
        r1.w = r4.y ? r1.w : r4.x;
        r1.w = r1.w * 1.0869565 + r0.y;
        r1.w = 0.920000017 * r1.w;
        r1.w = frac(r1.w);
        r2.xyz = float3(262.5,1.0869565,525) * r1.www;
        r2.w = cmp(0.920000017 < r1.w);
        r1.w = r1.w * 1.0869565 + -1;
        r1.w = 12.5 * r1.w;
        r1.x = r2.w ? r1.w : 0;
        r1.w = floor(r2.z);
        r1.w = r1.w * 0.00207039341 + -r2.y;
        r5.y = cb2[6].z * r1.w + r2.y;
        if (r0.w != 0) {
          r0.w = cmp(cb2[6].y == 0.000000);
          r0.w = r0.w ? 0 : r0.z;
          r4.x = r0.w * 4 + cb2[6].y;
          r4.y = 1 + r0.z;
          r4.xyzw = float4(0.00207039341,-0.000517598353,0.00207039341,0.000517598353) * r4.xyxy;
          r1.w = 1 + r1.z;
          r2.yz = -r4.xy * r1.ww + r5.xy;
          r2.yzw = t0.Sample(s0_s, r2.yz).xyz;
          r5.z = 0.289000005 * r2.z;
          r5.z = r2.y * -0.147 + -r5.z;
          r6.yw = r2.ww * float2(0.43599999,0.43599999) + r5.zz;
          r2.z = 0.514999986 * r2.z;
          r2.y = r2.y * 0.61500001 + -r2.z;
          r6.xz = -r2.ww * float2(0.100000001,0.100000001) + r2.yy;
          r2.yz = -r4.zw * r1.zz + r5.xy;
          r2.yzw = t0.Sample(s0_s, r2.yz).xyz;
          r5.z = 0.289000005 * r2.z;
          r5.z = r2.y * -0.147 + -r5.z;
          r7.yw = r2.ww * float2(0.43599999,0.43599999) + r5.zz;
          r2.z = 0.514999986 * r2.z;
          r2.y = r2.y * 0.61500001 + -r2.z;
          r7.xz = -r2.ww * float2(0.100000001,0.100000001) + r2.yy;
          r2.yzw = t0.Sample(s0_s, r5.xy).xyz;
          r5.z = dot(r2.yzw, float3(0.298999995,0.587000012,0.114));
          r5.w = 0.289000005 * r2.z;
          r5.w = r2.y * -0.147 + -r5.w;
          r8.yw = r2.ww * float2(0.43599999,0.43599999) + r5.ww;
          r2.z = 0.514999986 * r2.z;
          r2.y = r2.y * 0.61500001 + -r2.z;
          r8.xz = -r2.ww * float2(0.100000001,0.100000001) + r2.yy;
          r2.yz = r4.xy * r1.zz + r5.xy;
          r2.yzw = t0.Sample(s0_s, r2.yz).xyz;
          r1.z = 0.289000005 * r2.z;
          r1.z = r2.y * -0.147 + -r1.z;
          r9.yw = r2.ww * float2(0.43599999,0.43599999) + r1.zz;
          r1.z = 0.514999986 * r2.z;
          r1.z = r2.y * 0.61500001 + -r1.z;
          r9.xz = -r2.ww * float2(0.100000001,0.100000001) + r1.zz;
          r1.zw = r4.zw * r1.ww + r5.xy;
          r2.yzw = t0.Sample(s0_s, r1.zw).xyz;
          r1.z = 0.289000005 * r2.z;
          r1.z = r2.y * -0.147 + -r1.z;
          r4.yw = r2.ww * float2(0.43599999,0.43599999) + r1.zz;
          r1.z = 0.514999986 * r2.z;
          r1.z = r2.y * 0.61500001 + -r1.z;
          r4.xz = -r2.ww * float2(0.100000001,0.100000001) + r1.zz;
          r0.w = r0.w * 0.200000003 + 0.200000003;
          r6.xyzw = r7.xyzw + r6.xyzw;
          r6.xyzw = r6.xyzw + r8.xyzw;
          r6.xyzw = r6.xyzw + r9.xyzw;
          r4.xyzw = r6.xyzw + r4.xyzw;
          r4.xyzw = r4.xyzw * r0.wwww;
          r0.w = -r4.y * 0.395000011 + r5.z;
          r3.y = -r4.z * 0.58099997 + r0.w;
          r3.xz = r4.xw * float2(1.13999999,2.03200006) + r5.zz;
        } else {
          r1.zw = float2(1,1) + -cb2[7].xz;
          r0.w = cmp(0 < cb2[7].w);
          if (r0.w != 0) {
            r2.yz = cb2[8].xy * float2(0.5,0.5) + float2(0.5,0.5);
            r4.xy = cb2[1].xy * cb2[1].wz;
            r4.z = 1;
            r5.zw = r4.zy * r2.yz;
            r6.xy = r0.xy * r4.zy + -r5.zw;
            r0.w = dot(r6.xy, r6.xy);
            r0.w = (uint)r0.w >> 1;
            r0.w = (int)r0.w + 0x1fbd1df5;
            r2.w = -3 * cb2[7].w;
            r6.xy = r6.xy / r0.ww;
            r0.w = r2.w * r0.w;
            r4.w = r0.w * r0.w;
            r4.w = 0.0662999973 * r4.w;
            r4.w = abs(r0.w) * -0.178399995 + -r4.w;
            r4.w = 1.03009999 + r4.w;
            r0.w = r4.w * r0.w;
            r6.xy = r6.xy * r0.ww;
            r6.xy = r6.xy * r5.ww;
            r0.w = r2.w * r5.w;
            r2.w = r0.w * r0.w;
            r2.w = 0.0662999973 * r2.w;
            r2.w = abs(r0.w) * -0.178399995 + -r2.w;
            r2.w = 1.03009999 + r2.w;
            r0.w = r2.w * r0.w;
            r5.zw = r6.xy / r0.ww;
            r2.yz = r2.yz * r4.zy + r5.zw;
            r0.xy = r2.yz * r4.zx;
          }
          r4.xyzw = r0.xyxy * float4(2,2,2,2) + float4(-1,-1,-1,-1);
          r4.xyzw = -cb2[8].xyxy + r4.xyzw;
          r0.w = dot(r4.zw, r4.zw);
          r0.w = (uint)r0.w >> 1;
          r0.w = (int)r0.w + 0x1fbd1df5;
          r0.w = max(0, r0.w);
          r2.y = cmp(r1.z < r0.w);
          if (r2.y != 0) {
            r2.yz = float2(1,1) + -r1.zw;
            r1.z = r0.w + -r1.z;
            r2.y = 1 / r2.y;
            r1.z = saturate(r2.y * r1.z);
            r2.y = r1.z * -2 + 3;
            r1.z = r1.z * r1.z;
            r1.z = r2.y * r1.z;
            r1.z = cb2[7].y * r1.z;
            r4.xyzw = r1.zzzz * r4.xyzw;
            r1.z = 1 + -cb2[8].z;
            r2.y = 1 + -r0.w;
            r0.w = r2.y / r0.w;
            r0.w = r0.w * cb2[8].z + r1.z;
            r4.xyzw = r4.xyzw * r0.wwww;
            r2.yw = r0.yx * float2(1024,1024) + float2(-512,-512);
            r5.zw = float2(0.554549694,0.308517009) * r2.wy;
            r5.zw = frac(r5.zw);
            r2.yw = r2.wy * r5.zw + r2.yw;
            r0.w = r2.y * r2.w;
            r0.w = frac(r0.w);
            r0.w = r0.w * 2 + -1;
            r6.xyzw = r0.wwww * float4(0.100000001,0.100000001,0.100000001,0.100000001) + float4(-1,-0.600000024,-0.199999988,0.200000048);
            r7.xyzw = -r4.zwzw * r6.xxyy + r0.xyxy;
            r8.xyz = t0.SampleLevel(s0_s, r7.xy, 0).xyz;
            r0.w = min(1, -r6.x);
            r9.x = r0.w * r2.z + r1.w;
            r10.xyz = r6.xzy * cb2[7].zzz + float3(1,1,1);
            r9.y = r10.x;
            r9.z = 1 + -cb2[7].z;
            r7.xyz = t0.SampleLevel(s0_s, r7.zw, 0).xyz;
            r11.xy = -r6.yz * r2.zz + r1.ww;
            r11.z = r10.z;
            r11.w = 1 + -cb2[7].z;
            r7.xyz = r11.xzw * r7.xyz;
            r7.xyz = r9.xyz * r8.xyz + r7.xyz;
            r8.xyz = r11.xzw + r9.xyz;
            r4.xyzw = -r4.xyzw * r6.zzww + r0.xyxy;
            r6.xyz = t0.SampleLevel(s0_s, r4.xy, 0).xyz;
            r10.xz = r11.yw;
            r6.xyz = r10.xyz * r6.xyz + r7.xyz;
            r7.xyz = r10.xyz + r8.xyz;
            r4.xyz = t0.SampleLevel(s0_s, r4.zw, 0).xyz;
            r8.y = r6.w * -cb2[7].z + 1;
            r8.z = r6.w * r2.z + r1.w;
            r8.x = 1 + -cb2[7].z;
            r2.yzw = r8.xyz * r4.xyz + r6.xyz;
            r4.xyz = r8.xyz + r7.xyz;
            r3.xyz = r2.yzw / r4.xyz;
          } else {
            r3.xyz = t0.SampleLevel(s0_s, r0.xy, 0).xyz;
          }
        }
        r0.xy = r5.xy;
      } else {
        r3.xyz = float3(0,0,0);
        r0.z = 0;
        r1.x = 0;
        r2.x = 0;
      }
    }
  }
  r0.w = cmp(asint(cb2[14].z) != 3);
  if (r0.w != 0) {
    r1.zw = cb2[4].wz + r0.yx;
    r2.yz = cb2[2].xy * r1.wz;
    r4.yz = (uint2)r2.yz;
    r4.x = (uint)r4.y >> 1;
    r4.w = 0;
    r0.w = t7.Load(r4.xzw).x;
    r2.y = (int)r4.y & 1;
    r2.z = (uint)r0.w >> 4;
    r0.w = r2.y ? r2.z : r0.w;
    r2.yz = (int2)r0.ww & int2(4,8);
    r0.w = cmp((int)r2.y != 0);
    r2.yw = asint(cb2[14].yw) & int2(1,1);
    if (r2.y != 0) {
      r5.xyz = t4.Sample(s4_s, r0.xy).xyz;
      r5.xyz = cb2[13].xxx * r5.xyz;
      r3.xyz = cb2[13].yyy * r3.xyz + r5.xyz;
    }
    switch (cb2[14].x) {
      case 1 :      r2.y = dot(float3(0.212599993,0.715200007,0.0722000003), r3.xyz);
      switch (cb2[14].z) {
        case 2 :        r4.x = log2(r2.y);
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
        r3.xyz = r4.xxx ? r5.xyz : r6.xyz;
        break;
        case 3 :        break;
        default :
        r2.y = cb13[3].x * r2.y;
        r2.y = log2(r2.y);
        r5.xy = float2(5.97393131,7.97393131) + r2.yy;
        r2.y = (int)r5.x;
        r2.y = max(0, (int)r2.y);
        r2.y = min(6, (int)r2.y);
        r4.x = saturate(0.5 * r5.y);
        r4.x = r2.y ? 1 : r4.x;
        r3.xyz = icb[r2.y+0].xyz * r4.xxx;
        break;
      }
      break;
      default :
      r5.xyz = cmp(r3.xyz < cb13[0].xxx);
      r6.xyzw = r5.xxxx ? cb13[2].xyzw : cb13[1].xyzw;
      r5.xw = r6.xy * r3.xx + r6.zw;
      r3.x = saturate(r5.x / r5.w);
      r6.xyzw = r5.yyyy ? cb13[2].xyzw : cb13[1].xyzw;
      r5.xy = r6.xy * r3.yy + r6.zw;
      r3.y = saturate(r5.x / r5.y);
      r5.xyzw = r5.zzzz ? cb13[2].xyzw : cb13[1].xyzw;
      r5.xy = r5.xy * r3.zz + r5.zw;
      r3.z = saturate(r5.x / r5.y);
      break;
    }
    r5.x = saturate(dot(r3.xyz, cb2[10].xyz));
    r5.y = saturate(dot(r3.xyz, cb2[11].xyz));
    r5.z = saturate(dot(r3.xyz, cb2[12].xyz));
    r5.xyz = log2(r5.xyz);
    r5.xyz = float3(0.416666657,0.416666657,0.416666657) * r5.xyz;
    r5.xyz = exp2(r5.xyz);
    r5.xyz = r5.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
    r5.xyz = max(float3(0,0,0), r5.xyz);
    r6.xyz = cmp(float3(0.998039186,0.998039186,0.998039186) < r5.xyz);
    r7.xyz = cmp(r5.xyz < float3(0.00196078443,0.00196078443,0.00196078443));
    r2.y = (int)r6.y | (int)r6.x;
    r2.y = (int)r6.z | (int)r2.y;
    r4.x = (int)r7.y | (int)r7.x;
    r4.x = (int)r7.z | (int)r4.x;
    r2.y = (int)r2.y | (int)r4.x;
    r7.xyz = r7.xyz ? float3(1,1,1) : 0;
    r6.xyz = r6.xyz ? float3(-1,-1,-1) : float3(-0,-0,-0);
    r6.xyz = r7.xyz + r6.xyz;
    r6.xyz = r6.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5);
    r2.y = r2.w ? r2.y : 0;
    r5.xyz = r2.yyy ? r6.xyz : r5.xyz;
    r5.xyz = r5.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
    r5.xyz = t5.SampleLevel(s5_s, r5.xyz, 0).xyz;
    r2.yw = cmp(asint(cb2[5].wz) == int2(3,2));
    r1.y = (int)r1.y | (int)r2.w;
    r1.y = r1.y ? r2.y : 0;
    if (r1.y != 0) {
      r1.y = 8 * r0.x;
      r2.y = r0.y * 483 + r0.x;
      r2.w = 123.779999 * cb2[0].w;
      r2.w = frac(r2.w);
      r2.w = 12345.5996 * r2.w;
      r2.y = r2.y * 234.5 + r2.w;
      r2.w = floor(r2.y);
      r4.x = 0.103100002 * r2.w;
      r4.x = frac(r4.x);
      r5.w = 19.1900005 + r4.x;
      r5.w = dot(r4.xxx, r5.www);
      r4.x = r5.w + r4.x;
      r5.w = r4.x + r4.x;
      r4.x = r5.w * r4.x;
      r4.x = frac(r4.x);
      r2.w = 1 + r2.w;
      r2.w = 0.103100002 * r2.w;
      r2.yw = frac(r2.yw);
      r5.w = 19.1900005 + r2.w;
      r5.w = dot(r2.www, r5.www);
      r2.w = r5.w + r2.w;
      r5.w = r2.w + r2.w;
      r2.w = r5.w * r2.w;
      r2.w = frac(r2.w);
      r5.w = 1 + -r2.y;
      r4.x = r5.w * r4.x;
      r2.y = r2.w * r2.y + r4.x;
      r2.w = cb2[6].z * 0.300000012 + 1;
      r6.xyz = r5.xyz * r2.www;
      r2.w = -0.699999988 + r1.x;
      r2.w = 4 * abs(r2.w);
      r2.w = min(1, r2.w);
      r2.w = 1 + -r2.w;
      r4.x = cmp(r1.x >= 0.00100000005);
      r4.x = r4.x ? 1.000000 : 0;
      r2.w = r4.x * r2.w;
      r2.w = r2.w * r2.y;
      r1.x = cmp(0 < r1.x);
      r6.xyz = r1.xxx ? r2.www : r6.xyz;
      r1.x = -0.5 + r2.y;
      r1.x = dot(r1.xx, r0.zz);
      r6.xyz = saturate(r6.xyz + r1.xxx);
      r1.x = r0.y * 2 + r1.y;
      r1.x = cb2[0].w * 0.200000003 + r1.x;
      r1.x = 20 * r1.x;
      r1.x = frac(r1.x);
      r1.x = -r1.x * 2 + 1;
      r1.x = cb2[6].z * abs(r1.x);
      r0.z = 0.25 * r0.z;
      r0.z = saturate(r1.x * 0.5 + r0.z);
      r1.x = dot(r6.xyz, float3(0.298999995,0.587000012,0.114));
      r7.xyz = r1.xxx + -r6.xyz;
      r6.xyz = r0.zzz * r7.xyz + r6.xyz;
      r0.z = frac(r2.x);
      r0.z = -r0.z * 2 + 1;
      r0.z = cb2[6].z * abs(r0.z);
      r0.z = -r0.z * 0.75 + 1;
      r5.xyz = saturate(r6.xyz * r0.zzz);
    }
    r1.xy = t6.Load(r4.yzw).xy;
    r1.xy = float2(255.5,255.100006) * r1.yx;
    r1.xy = (uint2)r1.xy;
    r0.z = (uint)r1.x << 11;
    bitmask.z = ((~(-1 << 8)) << 3) & 0xffffffff;  r0.z = (((uint)r1.y << 3) & bitmask.z) | ((uint)r0.z & ~bitmask.z);
    r1.x = cmp((int)r2.z == 0);
    r0.w = r0.w ? r1.x : 0;
    r1.x = t14.Load(r0.z).w;
    r1.x = cmp(0 < r1.x);
    r0.w = r0.w ? r1.x : 0;
    if (r0.w != 0) {
      r0.z = (int)r0.z + 2;
      r0.z = t14.Load(r0.z).x;
      r0.z = cmp(0 < r0.z);
      if (r0.z != 0) {
        r2.xyz = cb2[20].xyz;
        r4.xyz = cb2[19].xyz;
      } else {
        r2.xyz = cb2[18].xyz;
        r4.xyz = cb2[17].xyz;
      }
      r0.z = cb2[15].x;
      r0.w = cb2[16].y;
      r6.xyz = t1.Gather(s1_s, r1.wz).xzw;
      r7.xy = abs(r6.zz) + -abs(r6.yx);
      r7.z = abs(r6.z) * 0.000250000012 + 2.32830644e-010;
      r1.x = dot(r7.xyz, r7.xyz);
      r1.x = (uint)r1.x >> 1;
      r1.x = (int)-r1.x + 0x5f3759df;
      r1.x = r7.z * r1.x;
      r1.x = min(1, r1.x);
    } else {
      r2.xyz = cb2[22].xyz;
      r4.xyz = cb2[21].xyz;
      r0.z = cb2[15].y;
      r0.w = cb2[16].z;
      r1.x = dot(r5.xyz, float3(0.212599993,0.715200007,0.0722000003));
    }
    r5.xy = cb2[0].yx + r1.zw;
    r5.xy = r5.xy * float2(1024,1024) + float2(-512,-512);
    r5.zw = float2(0.554549694,0.308517009) * r5.yx;
    r5.zw = frac(r5.zw);
    r5.xy = r5.yx * r5.zw + r5.xy;
    r1.y = r5.x * r5.y;
    r1.y = frac(r1.y);
    r1.y = r1.y * 2 + -1;
    r1.y = r1.y * r0.w + 1;
    r1.x = saturate(r1.x * r1.y);
    r1.x = (int)r1.x;
    r1.x = -1.06529242e+009 + r1.x;
    r0.z = r0.z * r1.x + 1.06529242e+009;
    r0.z = (int)r0.z;
    r0.z = saturate(r0.z);
    r2.xyz = -r4.xyz + r2.xyz;
    r2.xyz = r0.zzz * r2.xyz + r4.xyz;
    r1.xy = cb2[0].ww * r1.zw;
    r1.xy = frac(r1.xy);
    r1.xy = r1.xy * float2(1024,1024) + float2(-512,-512);
    r1.zw = float2(0.554549694,0.308517009) * r1.yx;
    r1.zw = frac(r1.zw);
    r1.xy = r1.yx * r1.zw + r1.xy;
    r0.z = r1.x * r1.y;
    r0.z = frac(r0.z);
    r0.z = r0.z * 2 + -1;
    r0.z = r0.z * r0.w + 1;
    r1.xyz = saturate(r2.xyz * r0.zzz);
    r3.w = dot(r1.xyz, float3(0.212599993,0.715200007,0.0722000003));
    r0.z = min(r1.x, r1.y);
    r0.w = max(r1.x, r1.y);
    r0.w = min(r0.w, r1.z);
    r0.z = max(r0.z, r0.w);
    r0.w = -0.100000001 + r0.z;
    r0.w = -10 * r0.w;
    r0.w = max(0, r0.w);
    r1.w = r0.w * -2 + 3;
    r0.w = r0.w * r0.w;
    r0.z = r1.w * r0.w + r0.z;
    r0.xy = cb2[0].ww * r0.yx;
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
    r0.x = cb2[9].y * r0.x;
    r3.xyz = r1.xyz * r0.xxx + r1.xyz;
  } else {
    r3.w = 1;
  }
  o0.xyzw = r3.xyzw;
  o1.x = r3.w;
  return;
}