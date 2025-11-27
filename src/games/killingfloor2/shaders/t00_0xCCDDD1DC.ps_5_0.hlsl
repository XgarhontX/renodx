// ---- Created with 3Dmigoto v1.3.16 on Tue Nov 25 17:26:37 2025

cbuffer BlendConstantBuffer : register(b10)
{
  float4 BloomTintAndScreenBlendThreshold : packoffset(c0);
  float4 ImageAdjustments1 : packoffset(c1);
  float4 ImageAdjustments2 : packoffset(c2);
  float4 DistanceFogParameters1 : packoffset(c3);
  float4 DistanceFogParameters2 : packoffset(c4);
  float2 FilmGrainTexCoordScale : packoffset(c5);
  float SqrtHalfExposure : packoffset(c5.z);
  float Time : packoffset(c5.w);
  float NoiseIntensity : packoffset(c6);
  float _Padding1 : packoffset(c6.y);
  float _Padding2 : packoffset(c6.z);
  float _Padding3 : packoffset(c6.w);
}

SamplerState ColorGradingLUTSampler_s : register(s0);
SamplerState BloomTextureSampler_s : register(s1);
SamplerState ColorTextureSampler_s : register(s2);
SamplerState NoiseTextureSampler_s : register(s3);
Texture2D<float4> ColorGradingLUT : register(t0); //256x16
Texture2D<float4> BloomTexture : register(t1);
Texture2D<float4> ColorTexture : register(t2);
Texture3D<float4> NoiseTexture : register(t3);


// 3Dmigoto declarations
#define cmp -
#include "./common.hlsl"

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float3 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = ColorTexture.Sample(ColorTextureSampler_s, v1.xy).xyz;
  
  r0.w = dot(r0.xyz, float3(0.300000012,0.589999974,0.109999999));
  r0.w = -3 * r0.w;
  r0.w = exp2(r0.w);
  r0.w = saturate(BloomTintAndScreenBlendThreshold.w * r0.w);
  r1.xyzw = BloomTintAndScreenBlendThreshold.zzxy * r0.wwww;
  r2.xyz = BloomTexture.Sample(BloomTextureSampler_s, v1.xy).xyz; Tonemap_BloomScale(r2.xyz);
  r0.xyzw = r2.zzxy * r1.xyzw + r0.zzxy;
  r1.xyzw = ImageAdjustments1.wwww * r0.xyzw; //exposure

  float3 colorU = r1.zwy; //goofy swizzle (same as batmanak)
  
  //tonemapper
  r1 = pow(r1, 0.416666657); // 1/2.4
  r1.xyzw = r1.xyzw * float4(1.05499995,1.05499995,1.05499995,1.05499995) + float4(-0.0549999997,-0.0549999997,-0.0549999997,-0.0549999997);
  r2.xyzw = ImageAdjustments1.xxxx + r0.yyzw;
  r2.xyzw = r0.yyzw / abs(r2.xyzw);
  r0.xyzw = -ImageAdjustments1.zzzz + r0.yyzw;
  r0.xyzw = saturate(float4(10000,10000,10000,10000) * r0.xyzw);
  r3.xyzw = r2.yyzw * ImageAdjustments1.yyyy + -r1.yyzw;
  r0.xyzw = r0.xyzw * r3.xyzw + r1.xyzw;
  r1.xyzw = r2.xyzw * ImageAdjustments1.yyyy + -r0.yyzw;
  r0.xyzw = saturate(ImageAdjustments2.xxxx * r1.xyzw + r0.xyzw);

  // r0 = max(0, r0);
  // r0.zwy = Tonemap_PerChannelCorrect(r0.zwy, colorU);
  // r0 = min(1, r0);

  //film grain
  r1.xyzw = float4(1,1,1,1) + -r0.xyzw;
  r1.xyzw = r1.xyzw + r1.xyzw;
  r2.xy = FilmGrainTexCoordScale.xy * v1.xy;
  r2.z = Time;
  r0.x = NoiseTexture.SampleLevel(NoiseTextureSampler_s, r2.xyz, 0).x;
  r0.x = -0.5 + r0.x;
  r2.x = NoiseIntensity * SqrtHalfExposure;
  r2.x = -2.36999989 * r2.x;
  r2.x = NoiseIntensity * 3.5 + r2.x;
  r0.x = r2.x * r0.x + 0.5;
  r2.x = 1 + -r0.x;
  r1.xyzw = -r1.xyzw * r2.xxxx + float4(1,1,1,1);
  r2.xyzw = r0.xxxx * r0.yyzw;

  r0.x = pow(abs(r0.x), 2.20000005);
  r0.x = cmp(r0.x < 0.5);
  r2.xyzw = r2.xyzw + r2.xyzw;
  r0.xyzw = r0.xxxx ? r2.xyzw : r1.xyzw;
  
  // float3 colorN = r0.zwy;
  // o0.xyz = colorN; //this matches colorU basically.
  
  // if (RENODX_TONE_MAP_TYPE == 0 || v1.x < 0.5) {    
  r1.xyw = float3(14.9998999,0.9375,0.05859375) * r0.xwz;
  r0.x = floor(r1.x);
  r1.x = r0.x * 0.0625 + r1.w;
  r1.xyzw = float4(0.001953125,0.03125,0.064453125,0.03125) + r1.xyxy;
  r0.x = r0.y * 15 + -r0.x;
  r0.yzw = ColorGradingLUT.SampleLevel(ColorGradingLUTSampler_s, r1.zw, 0.001953125).xyz;
  r1.xyz = ColorGradingLUT.SampleLevel(ColorGradingLUTSampler_s, r1.xy, 0.001953125).xyz;
  // r0.yzw = ColorGradingLUT.Sample(ColorGradingLUTSampler_s, r1.zw).xyz;
  // r1.xyz = ColorGradingLUT.Sample(ColorGradingLUTSampler_s, r1.xy).xyz;
  r0.yzw = -r1.xyz + r0.yzw;
  r0.xyz = r0.xxx * r0.yzw + r1.xyz;

  //exposure from LUT
  {
    float3 a = ColorGradingLUT.SampleLevel(ColorGradingLUTSampler_s, 0.46, 0.001953125).xyz;
    float3 b = a * a;
    float c = renodx::color::y::from::BT709(b);
    colorU *= c / 0.18;
  }
  
  //out
  o0.w = dot(r0.xyz, float3(0.298999995,0.587000012,0.114)); //y for AA
  o0.xyz = r0.xyz;
  o0.xyz = Tonemap_Do(colorU, o0.xyz, v1.xy);
  return;
}