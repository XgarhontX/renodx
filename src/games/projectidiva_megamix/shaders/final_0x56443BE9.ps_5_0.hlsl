// ---- Created with 3Dmigoto v1.3.16 on Sat Aug 09 22:01:31 2025

#include "../shared.h"


SamplerState g_sampler_s : register(s0);
Texture2D<float4> g_texture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  o0.xyzw = g_texture.Sample(g_sampler_s, v1.xy).xyzw;
  
  if (RENODX_TONE_MAP_TYPE > 0) {
    o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz); //100% srgb
    o0.xyz = renodx::draw::RenderIntermediatePass(o0.xyz);
  }
  return;
}