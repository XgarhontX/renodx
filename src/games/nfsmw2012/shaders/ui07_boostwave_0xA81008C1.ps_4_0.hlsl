// ---- Created with 3Dmigoto v1.3.16 on Sun Nov 16 00:23:56 2025

cbuffer gGlobalCB : register(b0)
{
  float4 Time : packoffset(c0);
}

cbuffer gMaterialCB : register(b2)
{
  float RibbonAmplitude : packoffset(c0);
  float RibbonFrequency : packoffset(c0.y);
  float RibbonHorizontalAmplitudeIncrease : packoffset(c0.z);
  float RibbonHorizontalFrequencyIncrease : packoffset(c0.w);
  float RibbonSpeed : packoffset(c1);
  float RibbonVerticalOffset : packoffset(c1.y);
  float RibbonWidth : packoffset(c1.z);
}

SamplerState DiffuseSampler_s : register(s0);
Texture2D<float4> DiffuseSampler : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float2 v3 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = RibbonFrequency * v3.x;
  r0.y = r0.x + r0.x;
  r0.y = cos(r0.y);
  r0.z = saturate(v3.x * RibbonFrequency + -0.5);
  r0.w = log2(r0.x);
  r0.w = RibbonHorizontalFrequencyIncrease * r0.w;
  r0.w = exp2(r0.w);
  r1.x = 1 / RibbonWidth;
  r2.x = v3.x;
  r3.xyzw = float4(0,0,0,0);
  r1.y = 0;
  while (true) {
    r1.z = cmp((int)r1.y >= 4);
    if (r1.z != 0) break;
    r1.z = (int)r1.y;
    r1.w = RibbonHorizontalAmplitudeIncrease * r1.z;
    r1.w = r0.x * r1.w + RibbonAmplitude;
    r1.w = r0.y * r0.z + r1.w;
    r1.z = Time.x + r1.z;
    r1.z = r1.z * RibbonSpeed + r0.x;
    r1.z = r1.z * r0.w;
    r1.z = sin(r1.z);
    r1.z = r1.z * r1.w + RibbonVerticalOffset;
    r2.y = v3.y * r1.x + r1.z;
    r4.xyzw = DiffuseSampler.Sample(DiffuseSampler_s, r2.xy).xyzw;
    r3.xyzw = r4.xyzw + r3.xyzw;
    r1.y = (int)r1.y + 1;
  }
  r0.xyzw = r3.xyzw * v2.xyzw + v1.xyzw;
  r1.x = -0.000392156857 + r0.w;
  r1.x = cmp(r1.x < 0);
  if (r1.x != 0) discard;
  r0.xyz *= 0.125;
  o0.xyzw = r0.xyzw;
  return;
}