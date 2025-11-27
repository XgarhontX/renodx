// ---- Created with 3Dmigoto v1.3.16 on Tue Nov 25 17:26:35 2025

cbuffer _Globals : register(b0)
{
  bool bDecompressSceneColor : packoffset(c0);
  float InverseGamma : packoffset(c0.y);
}

SamplerState texSampler_s : register(s0);
Texture2D<float4> tex : register(t0);


// 3Dmigoto declarations
#define cmp -
#include "../shared.h"


void main(
  float4 v0 : COLOR0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  if (!CUSTOM_IS_UI) discard;
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = tex.Sample(texSampler_s, v1.xy).xyzw;
  r0.xyz = saturate(r0.xyz);
  o0.w = v0.w * r0.w;
  r0.xyz = log2(r0.xyz);
  r0.xyz = InverseGamma * r0.xyz;
  o0.xyz = exp2(r0.xyz);
  return;
}