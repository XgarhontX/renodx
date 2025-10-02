// ---- Created with 3Dmigoto v1.3.16 on Tue Sep 30 09:40:12 2025
#include "./common.hlsl"

cbuffer _Globals : register(b0)
{
  float2 invPixelSize : packoffset(c0);
  float3 ghostStrengths : packoffset(c1);
  float2 ghost0Displacement : packoffset(c2);
  float2 ghost1Displacement : packoffset(c2.z);
  float2 ghost2Displacement : packoffset(c3);
  float3 ghostSubValues : packoffset(c4);
  float4 color : packoffset(c5);
  float4 colorMatrix0 : packoffset(c6);
  float4 colorMatrix1 : packoffset(c7);
  float4 colorMatrix2 : packoffset(c8);
  float4 aberrationColor0 : packoffset(c9);
  float4 aberrationColor1 : packoffset(c10);
  float4 aberrationColor2 : packoffset(c11);
  float2 aberrationDisplacement1 : packoffset(c12);
  float2 aberrationDisplacement2 : packoffset(c12.z);
  float2 radialBlendDistanceCoefficients : packoffset(c13);
  float2 radialBlendCenter : packoffset(c13.z);
  float2 radialBlendScale : packoffset(c14);
  float4 colorScale : packoffset(c15);
}

SamplerState mainTexture_s : register(s0);
Texture2D<float4> mainTexture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;
  float3 colorU /*, colorN*/;

  r0.x = dot(w1.xy, w1.xy);
  r0.x = sqrt(r0.x);
  r0.x = saturate(r0.x * radialBlendDistanceCoefficients.x + radialBlendDistanceCoefficients.y);
  r0.y = cmp(0 < r0.x);

  // r1.xyzw = aberrationDisplacement1.xyzw + v1.xyxy;  
  r1.xyzw = aberrationDisplacement1.xyxy + v1.xyxy;

  r2.xyz = mainTexture.Sample(mainTexture_s, r1.xy).xyz;
  r1.xyz = mainTexture.Sample(mainTexture_s, r1.zw).xyz;
  if (r0.y != 0) {
    r0.yzw = mainTexture.Sample(mainTexture_s, v1.xy).xyz;
    r0.yzw = colorScale.xyz * r0.yzw;
    r2.xyz = colorScale.xyz * r2.xyz;
    r2.xyz = aberrationColor1.xyz * r2.xyz;
    r1.xyz = colorScale.xyz * r1.xyz;
    r0.yzw = r0.yzw * aberrationColor0.xyz + r2.xyz;
    r1.xyz = r1.xyz * aberrationColor2.xyz + r0.yzw;
  } else {
    r1.xyz = float3(0,0,0);
  }

  colorU = r1.xyz;

  r1.w = 1;

  o0.x = dot(r1.xyzw, colorMatrix0.xyzw);
  o0.y = dot(r1.xyzw, colorMatrix1.xyzw);
  o0.z = dot(r1.xyzw, colorMatrix2.xyzw);
  o0.xyz = Tonemap_Do(colorU, /*colorN, */o0.xyz, v1.xy, mainTexture);

  o0.w = r0.x;
  return;
}