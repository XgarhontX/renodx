// ---- Created with 3Dmigoto v1.3.16 on Tue Nov 11 02:11:26 2025

SamplerState DiffuseSampler_s : register(s0);
Texture2D<float4> DiffuseSampler : register(t0);


// 3Dmigoto declarations
#define cmp -
#include "../shared.h"

bool C0(float4 v) {
  return 
    v.x > 0 && v.x < v.y &&
    v.y > 0 && v.y < v.z &&
    v.z > 0
  ;
}

bool C1(float4 v) {
  return 
    v.x < 0.1 && v.x < v.y &&
    v.y > 0 && v.y < v.z &&
    v.z > 0
  ;
}

bool C2(float4 v) {
  return 
    v.x > 0 && v.x < v.y &&
    v.y > 0.5 && abs(v.y - v.z) < 0.05 &&
    v.z > 0.5
  ;
}


float3 DiffuseSamplerMultiplier(float3 x) {
  //size
  float w;
  float h;
  DiffuseSampler.GetDimensions(w, h);
  
  [branch]
  // nos lens hor
  if (
    w == 128.f && h == 256.f &&
    // DiffuseSampler.Sample(DiffuseSampler_s, float2(0, 0)).x == 0 &&
    C1(DiffuseSampler.Sample(DiffuseSampler_s, float2(0, 0.5))) 
    &&
    C2(DiffuseSampler.Sample(DiffuseSampler_s, float2(0.5078, 0.5)))
  ) return 0.8 * min(x, 0.5);

  // nos lens hor stacked 
  else if (
    w == 256.f && h == 64.f &&
    // DiffuseSampler.Sample(DiffuseSampler_s, float2(0,0)).x == 0 
    // &&
    // DiffuseSampler.Sample(DiffuseSampler_s, float2(0.4766,0)).x == 0 
    // && 
    DiffuseSampler.Sample(DiffuseSampler_s, float2(0,0.6406)).x == 0 
    && 
    C0(DiffuseSampler.Sample(DiffuseSampler_s, float2(0.414,0.6406))) 
    && 
    DiffuseSampler.Sample(DiffuseSampler_s, float2(0.4766,0.6406)).z > 0.5
  ) return 0.8 * min(x, 0.125);

  return x;
}

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float2 v3 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (!CUSTOM_IS_UI) discard;
  r0.xyzw = DiffuseSampler.Sample(DiffuseSampler_s, v3.xy).xyzw;
  r0.xyz = DiffuseSamplerMultiplier(r0.xyz);
  o0.xyzw = r0.xyzw * v2.xyzw + v1.xyzw;
  return;
}