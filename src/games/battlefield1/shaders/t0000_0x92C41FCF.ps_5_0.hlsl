// ---- Created with 3Dmigoto v1.3.16 on Tue Nov 11 00:51:02 2025

cbuffer _Globals : register(b0)
{
  float2 invPixelSize : packoffset(c0);
  float preBlendAmount : packoffset(c0.z);
  float postAddAmount : packoffset(c0.w);
  float4 parametricTonemapParams : packoffset(c1);
  float4 parametricTonemapToeCoeffs : packoffset(c2);
  float4 parametricTonemapMidCoeffs : packoffset(c3);
  float4 parametricTonemapShoulderCoeffs : packoffset(c4);
  float3 filmGrainColorScale : packoffset(c5);
  float4 filmGrainTextureScaleAndOffset : packoffset(c6);
  float4 color : packoffset(c7);
  float4 colorMatrix0 : packoffset(c8);
  float4 colorMatrix1 : packoffset(c9);
  float4 colorMatrix2 : packoffset(c10);
  float4 ironsightsDofParams : packoffset(c11);
  float4 filmicLensDistortParams : packoffset(c12);
  float4 colorScale : packoffset(c13);
  float4 runnersVisionColor : packoffset(c14);
  float3 depthScaleFactors : packoffset(c15);
  float4 dofParams : packoffset(c16);
  float4 dofParams2 : packoffset(c17);
  float4 dofDebugParams : packoffset(c18);
  float3 bloomScale : packoffset(c19);
  float3 lensDirtExponent : packoffset(c20);
  float3 lensDirtFactor : packoffset(c21);
  float3 lensDirtBias : packoffset(c22);
  float3 luminanceVector : packoffset(c23);
  float3 vignetteParams : packoffset(c24);
  float4 vignetteColor : packoffset(c25);
  float4 chromostereopsisParams : packoffset(c26);
  float4 distortionScaleOffset : packoffset(c27);
  float3 maxClampColor : packoffset(c28);
  float fftBloomSpikeDampingScale : packoffset(c28.w);
  float4 fftKernelSampleScales : packoffset(c29);
}

SamplerState mainTextureSampler_s : register(s0);
SamplerState colorGradingTextureSampler_s : register(s1);
SamplerState distortionTextureSampler_s : register(s2);
SamplerState tonemapBloomTextureSampler_s : register(s3);
Texture2D<float4> mainTexture : register(t0);
Texture3D<float4> colorGradingTexture : register(t1);
Texture2D<float4> distortionTexture : register(t2);
Texture2D<float4> tonemapBloomTexture : register(t3);


// 3Dmigoto declarations
#define cmp -
#include "./common.hlsl"


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float2 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = distortionTexture.Sample(distortionTextureSampler_s, v2.xy).xyz;
  r0.xy = r0.xy * distortionScaleOffset.xy + distortionScaleOffset.zw;
  r0.xy = v2.xy + r0.xy;
  r1.xyz = mainTexture.Sample(mainTextureSampler_s, r0.xy).xyz;
  r0.xyw = tonemapBloomTexture.Sample(tonemapBloomTextureSampler_s, r0.xy).xyz;
Tonemap_BloomScale(r0.xyz);
  r2.xyz = r0.xyw + -r1.xyz;
  r1.xyz = r0.zzz * r2.xyz + r1.xyz;
  r0.xyz = r0.xyw * bloomScale.xyz + r1.xyz;
  r0.xyz = colorScale.xyz * r0.xyz;

  // r1.xy = float2(-0.5,-0.5) + v2.xy;
  // r1.xy = vignetteParams.xy * r1.xy;
  // r0.w = dot(r1.xy, r1.xy);
  // r0.w = saturate(-r0.w * vignetteColor.w + 1);
  // r0.w = log2(r0.w);
  // r0.w = vignetteParams.z * r0.w;
  // r0.w = exp2(r0.w);
  // r0.xyz = r0.xyz * r0.www;
r0.xyz = Tonemap_Vignette(r0.xyz, vignetteParams, vignetteColor, v2);

  // r1.xyz = float3(0.985521019,0.985521019,0.985521019) * r0.xyz;
  // r2.xyz = r0.xyz * float3(0.985521019,0.985521019,0.985521019) + float3(0.058662001,0.058662001,0.058662001);
  // r1.xyz = r2.xyz * r1.xyz;
  // r2.xyz = r0.xyz * float3(0.774596989,0.774596989,0.774596989) + float3(0.0482814983,0.0482814983,0.0482814983);
  // r0.xyz = r0.xyz * float3(0.774596989,0.774596989,0.774596989) + float3(1.24270999,1.24270999,1.24270999);
  // r0.xyz = r2.xyz * r0.xyz;
  // r0.xyz = r1.xyz / r0.xyz;
float3 colorU = r0.xyz; Tonemap_Vanilla(colorU, r0.xyz);

  r1.xyz = log2(abs(r0.xyz));
  r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r2.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xyz;
  r0.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r0.xyz);
  r0.xyz = r0.xyz ? r2.xyz : r1.xyz;
// r0.xyz = renodx::color::srgb::Encode(r0.xyz);

  // r0.xyz = r0.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
  // r0.xyz = colorGradingTexture.Sample(colorGradingTextureSampler_s, r0.xyz).xyz;
Tonemap_Lut(colorU, r0.xyz, colorGradingTextureSampler_s, colorGradingTexture);

  o0.w = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
  o0.xyz = r0.xyz;
o0.xyz = Tonemap_Do(colorU, o0.xyz, v2.xy, mainTexture);
  return;
}