// ---- Created with 3Dmigoto v1.3.16 on Tue Nov 25 18:55:04 2025

cbuffer _Globals : register(b0)
{
  bool bDecompressSceneColor : packoffset(c0);
  float4 SceneShadowsAndDesaturation : packoffset(c1);
  float4 SceneInverseHighLights : packoffset(c2);
  float4 SceneMidTones : packoffset(c3);
  float4 SceneScaledLuminanceWeights : packoffset(c4);
  float4 SceneColorize : packoffset(c5);
  float4 GammaColorScaleAndInverse : packoffset(c6);
  float4 GammaOverlayColor : packoffset(c7);
  float4 RenderTargetExtent : packoffset(c8);
  float4 RectanglePosScaleBias : packoffset(c9);
  float4 RectangleUVScaleBias : packoffset(c10);
  float4 RectangleInvTargetSizeAndTextureSize : packoffset(c11);
  float RectangleClipSpaceQuadZ : packoffset(c12);
  float LUTWeights[5] : packoffset(c13);
  float2 RcpBufferDim : packoffset(c17.y);
}



// 3Dmigoto declarations
#define cmp -
#include "../shared.h"

void main(
  float2 v0 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xz = float2(-0.001953125,-0.03125) + v0.xy;
  r1.x = 16 * r0.x;
  r0.y = frac(r1.x);
  r0.w = -r0.y * 0.0625 + r0.x;
  
  r0.xyz = LUTWeights[0] * r0.yzw;
  r0.xyz = saturate(r0.xyz * float3(1.06666672,1.06666672,1.06666672) + -SceneShadowsAndDesaturation.xyz);
  r0.xyz = SceneInverseHighLights.xyz * r0.xyz;
  r0.xyz = max(9.99999994e-009, r0.xyz);

  // r0.xyz = log2(r0.xyz);
  // r0.xyz = SceneMidTones.xyz * r0.xyz;
  // r0.xyz = exp2(r0.xyz);
  r0.xyz = pow(r0.xyz, SceneMidTones.xyz);

  r0.w = dot(r0.xyz, SceneScaledLuminanceWeights.xyz);
  r0.xyz = r0.xyz * SceneShadowsAndDesaturation.www + r0.www;
  r0.xyz = r0.xyz * GammaColorScaleAndInverse.xyz + GammaOverlayColor.xyz;
  r0.xyz = SceneColorize.xyz * r0.xyz;
  r0.xyz = max(9.99999994e-009, r0.xyz);
  r0.w = 9.99999994e-009;

  r1.x = 2.20000005 * GammaColorScaleAndInverse.w;
  // r0.xyzw = log2(r0.xyzw);
  // r0.xyzw = r1.xxxx * r0.xyzw;
  // r0.xyzw = exp2(r0.xyzw);
  r0.xyzw = pow(r0.xyzw, r1.x);
  o0.xyzw = r0.xyzw;
  o0 = max(0, o0);

  return;
}