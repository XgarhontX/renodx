// ---- Created with 3Dmigoto v1.3.16 on Fri Nov 14 01:37:48 2025

cbuffer gObjectCB : register(b1)
{
  float4 GenericVector4_A : packoffset(c0) = {1,1,1,1};
  float4 GenericVector4_B : packoffset(c1) = {1,1,1,1};
  float4 GenericVector4_D : packoffset(c2) = {1,1,1,1};
  float4 MotionBlurPixelConstant : packoffset(c3);
}

SamplerState TonemapSampler_s : register(s0);
SamplerState lightAccumulationBufferSampler_s : register(s1);
SamplerState GenericSamplerA_s : register(s2);
SamplerState deferred_depthBufferSampler_s : register(s3);
Texture2D<float4> deferred_depthBufferSampler : register(t0);
Texture2D<float4> lightAccumulationBufferSampler : register(t1);
Texture2D<float4> GenericSamplerA : register(t2);
Texture2D<float4> TonemapSampler : register(t3);


// 3Dmigoto declarations
#define cmp -
#include "../shared.h"


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = deferred_depthBufferSampler.Sample(deferred_depthBufferSampler_s, v1.xy).xyzw;
  r1.xyzw = lightAccumulationBufferSampler.Sample(lightAccumulationBufferSampler_s, v1.xy).xyzw;
  r0.xyz = MotionBlurPixelConstant.xyz * r0.xxx + v2.xyz;
  r0.xy = v1.xy * r0.zz + r0.xy;
  r0.xy = r0.xy * r1.ww;
  r0.zw = float2(0.0238095243,0.0238095243) * r0.xy;
  r2.x = v3.y * v3.z + v3.x;
  r2.x = frac(r2.x);
  r0.zw = r2.xx * r0.zw + v1.xy;
  r2.xyz = r1.xyz;
  r3.xy = r0.zw;
  r2.w = 1;
  r3.z = 0;
  while (true) {
    r3.w = cmp((int)r3.z >= 6);
    if (r3.w != 0) break;
    r3.xy = r0.xy * float2(0.0238095243,0.0238095243) + r3.xy;
    r4.xyzw = lightAccumulationBufferSampler.Sample(lightAccumulationBufferSampler_s, r3.xy).xyzw;
    r2.xyz = r4.xyz * r4.www + r2.xyz;
    r2.w = r4.w + r2.w;
    r3.z = (int)r3.z + 1;
  }
  r0.xyz = r2.xyz / r2.www;

  //bruh, what is this generic
  r2.xyzw = GenericSamplerA.Sample(GenericSamplerA_s, v1.xy).xyzw;
  r3.xyzw = TonemapSampler.Sample(TonemapSampler_s, float2(0.5,0.5)).xyzw;
  r1.xyz = /* saturate */(r3.www * r2.xyz);
  r2.xyz = GenericVector4_B.xyz * r2.xyz;
  r1.xyz = r2.xyz * r1.xyz;
  r0.xyz = r1.xyz * GenericVector4_B.www + r0.xyz;
  r1.xyz = GenericVector4_A.xyz * r2.www + GenericVector4_D.xyz;
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = r0.xyz * r3.www;

  float3 colorU = r0.xyz;

  //https://www.desmos.com/calculator/qifuhveyfd
  r0.xyz = exp2(-r0.xyz); 
  r0.xyz = float3(1,1,1) + -r0.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r1.xyz = r0.xyz * float3(0.0707062855,0.0707062855,0.0707062855) + float3(-0.317853957,-0.317853957,-0.317853957);
  r1.xyz = r1.xyz * r0.xyz + float3(-0.0227105431,-0.0227105431,-0.0227105431);
  r0.xyz = sqrt(r0.xyz);
  r0.xyz = /* saturate */ (r0.xyz * float3(1.27169645, 1.27169645, 1.27169645) + r1.xyz);
  o0.xyz = max(0, r0.xyz);

  if (RENODX_TONE_MAP_TYPE > 0) {
    colorU = max(0, colorU);

    // float3 colorT = /* renodx::color::srgb::Decode */(o0.xyz);
    // float3 colorT = o0.xyz * o0.xyz;
    // colorU *= (0.18 / 0.38);
    // colorU = renodx::color::correct::Luminance(colorU, colorT, saturate(1-(renodx::color::y::from::BT709(o0.xyz) * 1.25)));
    // colorU /= (0.18 / 0.38);

    //encode intermediate
    colorU = sqrt(colorU / 1.4);

    o0.xyz = colorU; 
  }

  o0.w = r1.w;
  return;
}