// ---- Created with 3Dmigoto v1.3.16 on Sun Aug 17 23:50:08 2025
#include "./common.hlsl"

Texture2D<float4> t4 : register(t4);

SamplerState s4_s : register(s4);

cbuffer cb2 : register(b2)
{
  float4 cb2[22];
}




// 3Dmigoto declarations
#define cmp -


//Seen in infrared sight. 
void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  //declare
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  float3 colorUntonemapped, colorTonemapped, colorSDRNeutral;

  //NO BLOOM
  
  //sample color
  r0.xyz = t4.Sample(s4_s, v1.xy).xyz;

  //colorUntonemapped
  colorUntonemapped = r0.xyz;

  //NO TONEMAP

  //NO COLOR CORRECTION

  //colorSDRNeutral
  colorSDRNeutral = r0.xyz;

  //saturate
  r0.xyz = saturate(r0.xyz);

  //to sRGB 
  r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  // {
  //   r1.xyz = log2(r0.xyz);
  //   r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
  //   r1.xyz = exp2(r1.xyz);
  //   r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  //   r2.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r0.xyz);
  //   r0.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xyz;
  //   r0.xyz = r2.xyz ? r0.xyz : r1.xyz;
  // }

  //NO LUT

  //r0.w
  r0.w = saturate(dot(r0.xyz, float3(0.298999995,0.587000012,0.114)));

  //Saturation
  {
    r1.xyz = r0.www + -r0.xyz;
    r1.w = cb2[1].w * r0.w + cb2[0].w;
    r0.xyz = r1.www * r1.xyz + r0.xyz;
  }

  //Tint + Game Brightness
  {
    r1.xyz = cb2[2].xyz * r0.www + cb2[1].xyz;
    r1.xyz = r1.xyz * r0.www + cb2[0].xyz;
    r0.xyz = r0.xyz * r1.xyz + cb2[3].xyz;
  }

  // //harmful encoding, to rgb8?
  // {
  //   r1.xy = cb2[21].yz + v1.xy;
  //   r0.w = dot(r1.xy, float2(353632,4234));
  //   r0.w = (uint)r0.w;
  //   r1.x = (int)r0.w ^ 61;
  //   r0.w = (uint)r0.w >> 16;
  //   r0.w = (int)r0.w ^ (int)r1.x;
  //   r0.w = (int)r0.w * 7;
  //   r1.x = (uint)r0.w >> 4;
  //   r0.w = (int)r0.w ^ (int)r1.x;
  //   r1.xyz = (int3)r0.www * int3(356,2543,0x424df4);
  //   r1.xyz = (int3)r1.xyz & int3(0x3fffc,0x3ffff,0x7fffc);
  //   r0.xyz = (int3)r0.xyz + (int3)r1.xyz;
  // }

  //colorTonemapped
  colorTonemapped = r0.xyz;

  //upgrade 
  Tonemap_UpgradeTonemap0(colorTonemapped, r0);
  
  //do tonemap
  Tonemap_Do(r0, colorUntonemapped, colorTonemapped/* , colorSDRNeutral */, v1, t4);
  
  //out
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}