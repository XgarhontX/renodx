// ---- Created with 3Dmigoto v1.3.16 on Wed Nov 26 17:31:03 2025

cbuffer _Globals : register(b0)
{
  float4 RectanglePosScaleBias : packoffset(c0);
  float4 RectangleUVScaleBias : packoffset(c1);
  float4 RectangleInvTargetSizeAndTextureSize : packoffset(c2);
  float RectangleClipSpaceQuadZ : packoffset(c3);
  float2 fxaaQualityRcpFrame : packoffset(c3.y);
  float4 fxaaConstDir : packoffset(c4) = {1,-1,0.25,-0.25};
  float4 fxaaConsoleRcpFrameOpt : packoffset(c5);
  float4 fxaaConsoleRcpFrameOpt2 : packoffset(c6);
  float4 fxaaConsole360RcpFrameOpt2 : packoffset(c7);
  float fxaaQualitySubpix : packoffset(c8);
  float fxaaQualityEdgeThreshold : packoffset(c8.y);
  float fxaaQualityEdgeThresholdMin : packoffset(c8.z);
  float fxaaConsoleEdgeSharpness : packoffset(c8.w);
  float fxaaConsoleEdgeThreshold : packoffset(c9);
  float fxaaConsoleEdgeThresholdMin : packoffset(c9.y);
  float4 fxaaConsole360ConstDir : packoffset(c10);
}

SamplerState SceneColorTextureSampler_s : register(s0);
Texture2D<float4> SceneColorTexture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = SceneColorTexture.SampleLevel(SceneColorTextureSampler_s, v0.xy, 0).xyz;
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}