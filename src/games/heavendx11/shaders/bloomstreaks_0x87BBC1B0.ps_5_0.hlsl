// ---- Created with 3Dmigoto v1.3.16 on Thu Mar 05 16:00:31 2026

cbuffer _Globals : register(b0)
{
  float4 color : packoffset(c0);
  float4 direction : packoffset(c1);
  float threshold : packoffset(c2);
}

SamplerState s_sampler_0_s : register(s0);
Texture2D<float4> s_texture_0 : register(t0);


// 3Dmigoto declarations
#define cmp -
#include "../shared.h"

float InverseLerp(float a, float b, float value) {
  if (b - a == 0) return 0; // prevent divide by zero
  return (value - a) / (b - a);
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r1.xy = v1.xy;
  r0.xyzw = float4(0,0,0,0);
  r1.z = 0;
  while (true) {
    r1.w = cmp(r1.z >= direction.z);
    if (r1.w != 0) break;

    // stronger near the center
    float ratio = 1;
    if (SI.bloom_streaksrolloff > 0) {
      ratio = InverseLerp(direction.z, 0, r1.z);
      ratio = saturate(ratio);
      ratio = pow(ratio, SI.bloom_streaksrolloff);
    }

    r2.xyzw = s_texture_0.SampleLevel(s_sampler_0_s, r1.xy, 0).xyzw;
    r3.xy = direction.xy * SI.bloom_streakslength + r1.xy;

    r4.xyzw = s_texture_0.SampleLevel(s_sampler_0_s, r3.xy, 0).xyzw;
    r1.xy = direction.xy * SI.bloom_streakslength + r3.xy;

    r1.w = saturate(-threshold + r2.w);
    r2.xyz = r2.xyz * ratio * r1.www + r0.xyz;

    r1.w = saturate(-threshold + r4.w);
    r0.xyz = r4.xyz * ratio * r1.www + r2.xyz;

    r0.w = 2 + r0.w;
    r1.z = direction.w + r1.z;
  }
  r0.xyz = color.xyz * r0.xyz;
  r0.xyz *= SI.bloom_streakslength;
  o0.xyz = r0.xyz / max(r0.w, 0.000001f);
  o0.xyz *= SI.bloom_streaks;
  o0.w = 1;
  return;
}