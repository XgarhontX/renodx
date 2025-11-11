// ---- Created with 3Dmigoto v1.3.16 on Sun Nov 09 21:38:45 2025

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
  float4 gParams : packoffset(c30);
  float4 gTextureUV : packoffset(c31);
  float4 gGradientUV : packoffset(c32);
}

SamplerState gTextureSampler_s : register(s0);
SamplerState gGradientTextureSampler_s : register(s1);
Texture2D<float4> gTexture : register(t0);
Texture2D<float4> gGradientTexture : register(t1);


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

  r0.xy = -gTextureUV.xy + v1.xy;
  r0.zw = gTextureUV.zw + -gTextureUV.xy;
  r0.xy = r0.xy / r0.zw;
  r0.zw = gGradientUV.zw + -gGradientUV.xy;
  r1.xy = cmp(float2(0,0) < gParams.yz);
  if (r1.x != 0) {
    r2.x = -r0.x * r0.z + gGradientUV.z;
  } else {
    r2.x = r0.x * r0.z + gGradientUV.x;
  }
  if (r1.y != 0) {
    r2.y = -r0.y * r0.w + gGradientUV.w;
  } else {
    r2.y = r0.y * r0.w + gGradientUV.y;
  }
  r0.xyzw = gGradientTexture.Sample(gGradientTextureSampler_s, r2.xy).xyzw;
  r0.x = r0.w + r0.x;
  r0.x = r0.x + r0.y;
  r0.x = r0.x + r0.z;
  r1.xyzw = gTexture.Sample(gTextureSampler_s, v1.xy).xyzw;
  r1.xyzw = v2.xyzw * r1.xyzw;
  r0.x = r0.x * 0.25 + -gParams.x;
  r0.x = saturate(200 * r0.x);
  r0.x = 1 + -r0.x;
  o0.w = r1.w * r0.x;
  o0.xyz = r1.xyz;
  return;
}