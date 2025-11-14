// ---- Created with 3Dmigoto v1.3.16 on Tue Nov 11 00:51:01 2025

SamplerState mainTexture0Sampler_s : register(s0);
Texture2D<float4> mainTexture0 : register(t0);


// 3Dmigoto declarations
#define cmp -
#include "../shared.h"


void main(
  float4 v0 : SV_Position0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (!CUSTOM_IS_UI) discard;
  
  r0.xyzw = mainTexture0.Sample(mainTexture0Sampler_s, v2.xy).xyzw;
  o0.xyzw = v1.xyzw * r0.xyzw;
  return;
}