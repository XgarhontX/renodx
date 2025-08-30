// ---- Created with 3Dmigoto v1.3.16 on Wed Aug 20 15:44:26 2025
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
  float4 cb2[5];
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

  r0.xy = cb2[0].xy + v1.xy;
  r0.xyz = t0.Sample(s0_s, r0.xy).xyz;
  r1.x = cmp(asint(cb2[4].z) != 3);
  if (r1.x != 0) {
    switch (cb2[4].x) {
      case 1 :      r1.x = dot(float3(0.212599993,0.715200007,0.0722000003), r0.xyz);
      switch (cb2[4].z) {
        case 2 :        r1.y = log2(r1.x);
        r1.y = r1.y * 0.693147182 + 9.2103405;
        r1.y = max(0, r1.y);
        r1.y = 0.0492605828 * r1.y;
        r1.y = min(1, r1.y);
        r1.y = r1.y * 360 + 300;
        r1.y = 0.00278551527 * r1.y;
        r1.y = frac(r1.y);
        r1.z = 5.98333359 * r1.y;
        r1.z = floor(r1.z);
        r1.y = r1.y * 5.98333359 + -r1.z;
        r2.z = 1 + -r1.y;
        r3.y = 1 + -r2.z;
        r4.xyzw = cmp(r1.zzzz == float4(0,1,2,3));
        r1.y = cmp(r1.z == 4.000000);
        r2.xy = float2(1,0);
        r5.xy = r4.ww ? r2.yz : r3.yy;
        r1.y = (int)r1.y | (int)r4.w;
        r3.xz = float2(1,0);
        r5.z = 1;
        r5.xyz = r4.zzz ? r3.zxy : r5.xyz;
        r1.y = (int)r1.y | (int)r4.z;
        r5.xyz = r4.yyy ? r2.zxy : r5.xyz;
        r1.y = (int)r1.y | (int)r4.y;
        r3.xyz = r4.xxx ? r3.xyz : r5.xyz;
        r1.y = (int)r1.y | (int)r4.x;
        r0.xyz = r1.yyy ? r3.xyz : r2.xyz;
        break;
        case 3 :        break;
        default :
        r1.x = cb13[3].x * r1.x;
        r1.x = log2(r1.x);
        r1.xy = float2(5.97393131,7.97393131) + r1.xx;
        r1.x = (int)r1.x;
        r1.x = max(0, (int)r1.x);
        r1.x = min(6, (int)r1.x);
        r1.y = saturate(0.5 * r1.y);
        r1.y = r1.x ? 1 : r1.y;
        r0.xyz = icb[r1.x+0].xyz * r1.yyy;
        break;
      }
      break;
      default :
      r1.xyz = cmp(r0.xyz < cb13[0].xxx);
      r2.xyzw = r1.xxxx ? cb13[2].xyzw : cb13[1].xyzw;
      r1.xw = r2.xy * r0.xx + r2.zw;
      r0.x = saturate(r1.x / r1.w);
      r2.xyzw = r1.yyyy ? cb13[2].xyzw : cb13[1].xyzw;
      r1.xy = r2.xy * r0.yy + r2.zw;
      r0.y = saturate(r1.x / r1.y);
      r1.xyzw = r1.zzzz ? cb13[2].xyzw : cb13[1].xyzw;
      r1.xy = r1.xy * r0.zz + r1.zw;
      r0.z = saturate(r1.x / r1.y);
      break;
    }
    r1.x = saturate(dot(r0.xyz, cb2[1].xyz));
    r1.y = saturate(dot(r0.xyz, cb2[2].xyz));
    r1.z = saturate(dot(r0.xyz, cb2[3].xyz));
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
    r1.xyz = max(float3(0,0,0), r1.xyz);
    r1.w = asint(cb2[4].w) & 1;
    r2.xyz = cmp(float3(0.998039186,0.998039186,0.998039186) < r1.xyz);
    r3.xyz = cmp(r1.xyz < float3(0.00196078443,0.00196078443,0.00196078443));
    r2.w = (int)r2.y | (int)r2.x;
    r2.w = (int)r2.z | (int)r2.w;
    r3.w = (int)r3.y | (int)r3.x;
    r3.w = (int)r3.z | (int)r3.w;
    r2.w = (int)r2.w | (int)r3.w;
    r3.xyz = r3.xyz ? float3(1,1,1) : 0;
    r2.xyz = r2.xyz ? float3(-1,-1,-1) : float3(-0,-0,-0);
    r2.xyz = r3.xyz + r2.xyz;
    r2.xyz = r2.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5);
    r1.w = r1.w ? r2.w : 0;
    r1.xyz = r1.www ? r2.xyz : r1.xyz;
    r1.xyz = r1.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
    r0.xyz = t1.SampleLevel(s1_s, r1.xyz, 0).xyz;
    r0.w = dot(r0.xyz, float3(0.212599993,0.715200007,0.0722000003));
  } else {
    r0.w = 1;
  }
  o0.xyzw = r0.xyzw;
  o1.x = r0.w;
  return;
}