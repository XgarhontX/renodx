// ---- Created with 3Dmigoto v1.3.16 on Sun Nov 09 21:38:11 2025

cbuffer _Globals : register(b0)
{
  float2 invPixelSize : packoffset(c0);
  float4x4 mvp : packoffset(c1);
  float4 texgen0 : packoffset(c5);
  float4 texgen1 : packoffset(c6);
  float4 texgen2 : packoffset(c7);
  float4 texgen3 : packoffset(c8);
  float4 g_color : packoffset(c9);
  float4 cxmul : packoffset(c10);
  float4 cxadd : packoffset(c11);
  float4 filterTexScale : packoffset(c12);
  float4 filterOffset : packoffset(c13);
  float4 filterShadowColor : packoffset(c14);
  float4 filterShadowTexScale : packoffset(c15);
  float4 aaCircleData : packoffset(c16);
  float4 aaLinePlane0 : packoffset(c17);
  float4 aaLinePlane1 : packoffset(c18);
  float4 aaLinePlane2 : packoffset(c19);
  float4 aaLinePlane3 : packoffset(c20);
  float4 distanceFieldParams0 : packoffset(c21);
  float4 distanceFieldParams1 : packoffset(c22);
  float4 distanceFieldParams2 : packoffset(c23);
  float4 cctvDistortParams0 : packoffset(c24);
  float4 cctvDistortParams1 : packoffset(c25);
  float4 kinectTrackingParams : packoffset(c26);
  float4 postProcessDistortParams0 : packoffset(c27);
  float4 postProcessDistortParams1 : packoffset(c28);
  float4 postProcessDistortParams2 : packoffset(c29);
  float4 screenSizeVector : packoffset(c30);
  float4 distortionVector : packoffset(c31);
  float4 empTestVar : packoffset(c32);
  float4 jammerTestVar : packoffset(c33);
  float4 effectMask : packoffset(c34);
}

SamplerState mainTextureSampler_s : register(s0);
Texture2D<float4> mainTexture : register(t0);


// 3Dmigoto declarations
#define cmp -
#include "../shared.h"

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  if (!CUSTOM_IS_UI) discard;

  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = (int)effectMask.x;
  if (r0.x != 0) {
    r0.xyz = (int3)r0.xxx & int3(1,2,4);
    if (r0.x != 0) {
      r0.x = 1 + distortionVector.x;
      r0.x = max(1, r0.x);
      r0.x = min(3, r0.x);
      r0.xw = screenSizeVector.xy / r0.xx;
      r0.xw = float2(1,1) / r0.xw;
      r1.xy = v1.xy / r0.xw;
      r1.xy = floor(r1.xy);
      r1.zw = float2(0.5,0.5) * r0.xw;
      r1.xw = r1.xy * r0.xw + r1.zw;
      r0.x = distortionVector.x + r1.w;
      r0.x = 1000 * r0.x;
      r0.x = sin(r0.x);
      r0.x = distortionVector.x * r0.x;
      r1.xyz = r0.xxx * float3(0.0149999997,0.00749999983,0.00999999978) + r1.xxx;
      r2.x = mainTexture.Sample(mainTextureSampler_s, r1.xw).x;
      r2.y = mainTexture.Sample(mainTextureSampler_s, r1.yw).y;
      r2.zw = mainTexture.Sample(mainTextureSampler_s, r1.zw).zw;
    } else {
      r2.xyzw = float4(0,0,0,0);
    }
    if (r0.y != 0) {
      r1.xyzw = mainTexture.Sample(mainTextureSampler_s, v1.xy).xyzw;
      r2.xyzw = r1.xyzw * empTestVar.xyzw + r2.xyzw;
    }
    if (r0.z != 0) {
      r0.xyzw = mainTexture.Sample(mainTextureSampler_s, v1.xy).xyzw;
      r2.xyzw = r0.xyzw * jammerTestVar.xyzw + r2.xyzw;
    }
    o0.xyzw = v2.xyzw * r2.xyzw;
    return;
  }
  r0.xyzw = mainTexture.Sample(mainTextureSampler_s, v1.xy).xyzw;
  o0.xyzw = v2.xyzw * r0.xyzw;
  return;
}