// ---- Created with 3Dmigoto v1.3.16 on Tue Aug 19 15:08:29 2025
#include "./common.hlsl"


Texture2D<float4> t4 : register(t4); //color

Texture2D<float4> t3 : register(t3); //crazy 256x256 normal map looking thing

Texture2D<float4> t2 : register(t2); //bloom

SamplerState s4_s : register(s4);

SamplerState s2_s : register(s2);

SamplerState s0_s : register(s0);

cbuffer cb4 : register(b4)
{
  float4 cb4[68];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[43];
}




// 3Dmigoto declarations
#define cmp -

//Seen when coming out of water, where water rushes down face.
void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  //declare
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  float3 colorUntonemapped, colorTonemapped, colorSDRNeutral;

  //sample crazy 256x256 normal map looking thing. distorts sampling color uv for wavy effect.
  r0.x = cb2[41].x * cb2[20].x;
  r0.z = -cb2[20].w * cb2[41].z + v1.y;
  r1.x = v1.x;
  r1.y = 1;
  r0.xy = r1.xy + r0.xz;
  r0.zw = float2(0.5,0.5) * r0.xy;
  r0.xy = t3.Sample(s2_s, r0.xy).xy;
  r0.xy = cb2[20].yy * r0.xy;
  r0.zw = t3.Sample(s2_s, r0.zw).xy;
  r0.zw = cb2[20].xx * r0.zw;
  r0.zw = float2(0.5,0.5) * r0.zw;
  r0.xy = r0.xy * float2(0.5,0.5) + r0.zw;
  r0.z = -cb2[42].w * 2 + v1.y;
  r0.z = saturate(1 + r0.z);
  r0.z = r0.z * r0.z;
  r0.z = cb2[41].w * r0.z;
  r0.xy = saturate(r0.xy * r0.zz + v1.xy);
  r0.zw = max(cb2[37].xy, r0.xy);

  //sample color
  r1.xyz = t4.Sample(s4_s, r0.xy).xyz;
  
  //sample bloom
  r0.xy = min(cb2[37].zw, r0.zw);
  r0.xyz = t2.Sample(s0_s, r0.xy).xyz;
  r0.xyz = cb2[33].xxx * r0.xyz;
  Tonemap_BloomScale(r0);

  //composite bloom
  r0.xyz = cb2[33].yyy * r1.xyz + r0.xyz;

  //colorUntonemapped
  colorUntonemapped = r0.xyz * Tonemap_CalculatePreExposureMultiplier(cb4[0], cb4[1], cb4[2]);

  //Vanilla Tonemap
  {
    r1.xyz = cmp(cb4[0].xxx >= r0.xyz);
    r2.xyz = r1.xyz ? float3(0,0,0) : float3(1,1,1);
    r1.xyz = r1.xyz ? float3(1,1,1) : 0;
    r3.xyz = cb4[1].xxx * r2.xyz;
    r3.xyz = r1.xyz * cb4[2].xxx + r3.xyz;
    r4.xyz = cb4[1].zzz * r2.xyz;
    r4.xyz = r1.xyz * cb4[2].zzz + r4.xyz;
    r3.xyz = r0.xyz * r3.xyz + r4.xyz;
    r4.xyz = cb4[1].yyy * r2.xyz;
    r2.xyz = cb4[1].www * r2.xyz;
    r2.xyz = r1.xyz * cb4[2].www + r2.xyz;
    r1.xyz = r1.xyz * cb4[2].yyy + r4.xyz;
    r0.xyz = r0.xyz * r1.xyz + r2.xyz;
    r0.xyz = r3.xyz / r0.xyz;
    r0.xyz = saturate(r0.xyz);

    r0.xyz = log2(r0.xyz);
    r0.xyz = cb4[3].zzz * r0.xyz;
    r0.xyz = exp2(r0.xyz);
  }

  //colorSDRNeutral
  colorSDRNeutral = r0.xyz;

  //color correction & saturate
  {
    r1.x = saturate(dot(r0.xyz, cb4[65].xyz));
    r1.y = saturate(dot(r0.xyz, cb4[66].xyz));
    r1.z = saturate(dot(r0.xyz, cb4[67].xyz));
  }
  {
    colorUntonemapped = float3(
      dot(colorUntonemapped, cb4[65].xyz),
      dot(colorUntonemapped, cb4[66].xyz),
      dot(colorUntonemapped, cb4[67].xyz)
    );
  }

  //to sRGB
  r0.xyz = renodx::color::srgb::Encode(r1.xyz);
  // {
  //   r0.xyz = renodx::color::srgb::Encode(r1.xyz);
  //   r0.xyz = log2(r1.xyz);
  //   r0.xyz = float3(0.416666657,0.416666657,0.416666657) * r0.xyz;
  //   r0.xyz = exp2(r0.xyz);
  //   r0.xyz = r0.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  //   r2.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r1.xyz);
  //   r1.xyz = float3(12.9200001,12.9200001,12.9200001) * r1.xyz;
  //   r0.xyz = r2.xyz ? r1.xyz : r0.xyz;
  // }

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

  //harmful encoding to rgb8?
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