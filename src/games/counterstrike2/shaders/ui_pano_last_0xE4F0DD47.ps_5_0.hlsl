// ---- Created with 3Dmigoto v1.3.16 on Thu Oct 02 18:14:21 2025
Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t1.Sample(s1_s, v0.xy).x;
  r0.x = -0.5 + r0.x;
  r0.xy = float2(0.391730011,2.01699996) * r0.xx;
  r0.z = t0.Sample(s0_s, v0.xy).x;
  r0.z = -0.0625 + r0.z;
  r0.x = r0.z * 1.16429996 + -r0.x;
  r0.y = r0.z * 1.16429996 + r0.y;
  r0.y = log2(r0.y);
  r0.y = 2.20000005 * r0.y;
  r0.y = exp2(r0.y);
  r0.w = t2.Sample(s2_s, v0.xy).x;
  r0.w = -0.5 + r0.w;
  r0.x = -r0.w * 0.812900007 + r0.x;
  r0.w = 1.59580004 * r0.w;
  r0.z = r0.z * 1.16429996 + r0.w;
  r0.z = log2(r0.z);
  r0.z = 2.20000005 * r0.z;
  r0.z = exp2(r0.z);
  r0.x = log2(r0.x);
  r0.x = 2.20000005 * r0.x;
  r0.x = exp2(r0.x);
  r1.w = t3.Sample(s3_s, v0.xy).w;
  r1.xyz = r1.www * r0.zxy;
  o0.xyzw = v1.xyzw * r1.xyzw;
  return;
}