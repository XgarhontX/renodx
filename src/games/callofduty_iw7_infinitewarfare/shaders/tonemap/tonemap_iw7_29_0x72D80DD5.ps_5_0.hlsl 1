// ---- Created with 3Dmigoto v1.3.16 on Wed Aug 20 15:44:17 2025
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
  float4 cb2[7];
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
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb2[1].yx + v1.yx;
  r1.xyz = t0.Sample(s0_s, r0.yx).xyz;
  r0.z = cmp(asint(cb2[6].z) != 3);
  if (r0.z != 0) {
    switch (cb2[6].x) {
      case 1 :      r0.z = dot(float3(0.212599993,0.715200007,0.0722000003), r1.xyz);
      switch (cb2[6].z) {
        case 2 :        r0.w = log2(r0.z);
        r0.w = r0.w * 0.693147182 + 9.2103405;
        r0.w = max(0, r0.w);
        r0.w = 0.0492605828 * r0.w;
        r0.w = min(1, r0.w);
        r0.w = r0.w * 360 + 300;
        r0.w = 0.00278551527 * r0.w;
        r0.w = frac(r0.w);
        r2.x = 5.98333359 * r0.w;
        r2.x = floor(r2.x);
        r0.w = r0.w * 5.98333359 + -r2.x;
        r3.z = 1 + -r0.w;
        r4.y = 1 + -r3.z;
        r5.xyzw = cmp(r2.xxxx == float4(0,1,2,3));
        r0.w = cmp(r2.x == 4.000000);
        r3.xy = float2(1,0);
        r2.xy = r5.ww ? r3.yz : r4.yy;
        r0.w = (int)r0.w | (int)r5.w;
        r4.xz = float2(1,0);
        r2.z = 1;
        r2.xyz = r5.zzz ? r4.zxy : r2.xyz;
        r0.w = (int)r0.w | (int)r5.z;
        r2.xyz = r5.yyy ? r3.zxy : r2.xyz;
        r0.w = (int)r0.w | (int)r5.y;
        r2.xyz = r5.xxx ? r4.xyz : r2.xyz;
        r0.w = (int)r0.w | (int)r5.x;
        r1.xyz = r0.www ? r2.xyz : r3.xyz;
        break;
        case 3 :        break;
        default :
        r0.z = cb13[3].x * r0.z;
        r0.z = log2(r0.z);
        r0.zw = float2(5.97393131,7.97393131) + r0.zz;
        r0.z = (int)r0.z;
        r0.z = max(0, (int)r0.z);
        r0.z = min(6, (int)r0.z);
        r0.w = saturate(0.5 * r0.w);
        r0.w = r0.z ? 1 : r0.w;
        r1.xyz = icb[r0.z+0].xyz * r0.www;
        break;
      }
      break;
      default :
      r2.xyz = cmp(r1.xyz < cb13[0].xxx);
      r3.xyzw = r2.xxxx ? cb13[2].xyzw : cb13[1].xyzw;
      r0.zw = r3.xy * r1.xx + r3.zw;
      r1.x = saturate(r0.z / r0.w);
      r3.xyzw = r2.yyyy ? cb13[2].xyzw : cb13[1].xyzw;
      r0.zw = r3.xy * r1.yy + r3.zw;
      r1.y = saturate(r0.z / r0.w);
      r2.xyzw = r2.zzzz ? cb13[2].xyzw : cb13[1].xyzw;
      r0.zw = r2.xy * r1.zz + r2.zw;
      r1.z = saturate(r0.z / r0.w);
      break;
    }
    r2.x = saturate(dot(r1.xyz, cb2[3].xyz));
    r2.y = saturate(dot(r1.xyz, cb2[4].xyz));
    r2.z = saturate(dot(r1.xyz, cb2[5].xyz));
    r2.xyz = log2(r2.xyz);
    r2.xyz = float3(0.416666657,0.416666657,0.416666657) * r2.xyz;
    r2.xyz = exp2(r2.xyz);
    r2.xyz = r2.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
    r2.xyz = max(float3(0,0,0), r2.xyz);
    r0.z = asint(cb2[6].w) & 1;
    r3.xyz = cmp(float3(0.998039186,0.998039186,0.998039186) < r2.xyz);
    r4.xyz = cmp(r2.xyz < float3(0.00196078443,0.00196078443,0.00196078443));
    r0.w = (int)r3.y | (int)r3.x;
    r0.w = (int)r3.z | (int)r0.w;
    r2.w = (int)r4.y | (int)r4.x;
    r2.w = (int)r4.z | (int)r2.w;
    r0.w = (int)r0.w | (int)r2.w;
    r4.xyz = r4.xyz ? float3(1,1,1) : 0;
    r3.xyz = r3.xyz ? float3(-1,-1,-1) : float3(-0,-0,-0);
    r3.xyz = r4.xyz + r3.xyz;
    r3.xyz = r3.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5);
    r0.z = r0.z ? r0.w : 0;
    r2.xyz = r0.zzz ? r3.xyz : r2.xyz;
    r2.xyz = r2.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
    r2.xyz = t1.SampleLevel(s1_s, r2.xyz, 0).xyz;
    r1.w = dot(r2.xyz, float3(0.212599993,0.715200007,0.0722000003));
    r0.z = min(r2.x, r2.y);
    r0.w = max(r2.x, r2.y);
    r0.w = min(r0.w, r2.z);
    r0.z = max(r0.z, r0.w);
    r0.w = -0.100000001 + r0.z;
    r0.w = saturate(-10 * r0.w);
    r2.w = r0.w * -2 + 3;
    r0.w = r0.w * r0.w;
    r0.z = r2.w * r0.w + r0.z;
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
    r0.x = cb2[2].y * r0.x;
    r1.xyz = r2.xyz * r0.xxx + r2.xyz;
  } else {
    r1.w = 1;
  }
  o0.xyzw = r1.xyzw;
  o1.x = r1.w;
  return;
}