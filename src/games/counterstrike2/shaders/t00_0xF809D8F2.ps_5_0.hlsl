// ---- Created with 3Dmigoto v1.3.16 on Thu Oct 02 18:12:23 2025
#include "./common.hlsl"

Texture3D<float4> t14 : register(t14); //lut

Texture2D<float4> t13 : register(t13); //bloom

Texture2D<float4> t12 : register(t12); //color

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb3 : register(b3)
{
  float4 cb3[3];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[24];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[8];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;
  float3 colorU;

  r0.xy = cb1[23].zw * v1.xy;
  r0.zw = cb0[0].zw * r0.xy;
  r0.xy = min(cb0[1].zw, r0.xy);
  r0.xy = cb0[1].xy * r0.xy;
  r1.xyz = t13.SampleLevel(s1_s, r0.xy, 0).xyz; //bloom
  r0.xyzw = t12.SampleLevel(s0_s, r0.zw, 0).xyzw; //color
  r1.w = max(r0.y, r0.z);
  r1.w = max(r1.w, r0.x);
  r1.w = 1 + -r1.w;
  r1.w = rcp(r1.w);
  r0.xyz = r1.www * r0.xyz;

  o0.w = r0.w;

  //exposure? idk
  r0.w = 1 + -cb0[5].z;
  r2.xyz = cb0[4].www * r1.xyz;
  r0.xyz = r0.www * r0.xyz + r2.xyz;
  r0.xyz = cb0[4].yyy * r1.xyz + r0.xyz;

  colorU = r0.xyz;
  
  //tonemapper (HABLE)
  r0.xyz = float3(2.79999995,2.79999995,2.79999995) * r0.xyz;
  r0.xyz = min(cb3[1].www, r0.xyz); //white clip
  r2.xyz = cb3[0].yyy * r0.xyz; //a * x
  r2.xyz = cb3[0].www * cb3[0].zzz + r2.xyz; //c * b +
  r3.xy = cb3[1].xx * cb3[1].yz; 
  r2.xyz = r0.xyz * r2.xyz + r3.xxx;

  r3.xzw = cb3[0].yyy * r0.xyz + cb3[0].zzz; // x * a + b
  r0.xyz = r0.xyz * r3.xzw + r3.yyy;

  r0.xyz = r2.xyz / r0.xyz;

  r0.w = cb3[1].y / cb3[1].z; //e - f
  r0.xyz = r0.xyz + -r0.www;

  r0.xyz = cb3[2].xxx * r0.xyz;

  // srgb encode
  r0.xyz = renodx::color::srgb::Encode(r0.xyz);
  colorU.xyz = renodx::color::srgb::Encode(colorU.xyz);
  // r2.xyz = log2(r0.xyz);
  // r2.xyz = float3(0.416666657,0.416666657,0.416666657) * r2.xyz;
  // r2.xyz = exp2(r2.xyz);
  // r2.xyz = r2.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  // r3.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xyz;
  // r0.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r0.xyz);
  // r0.xyz = r0.xyz ? r3.xyz : r2.xyz;

  // bloom composite (sdr dependant)
  r1.xyz *= CUSTOM_BLOOM;

  r0.w = cb3[0].x * cb1[18].x;
  r2.xyz = r1.xyz * r0.www;
  r1.xyz = r1.xyz * r0.www + float3(0.187000006,0.187000006,0.187000006);
  r1.xyz = r2.xyz / r1.xyz;
  
  colorU += max((float3)0, r1.xyz * cb0[4].z);
  
  r1.xyz = saturate(float3(1.03499997,1.03499997,1.03499997) * r1.xyz);
  r2.xyz = r1.xyz * cb0[4].zzz + r0.xyz;
  r1.xyz = cb0[4].zzz * r1.xyz;
  r0.xyz = -r0.xyz * r1.xyz + r2.xyz;
  
  //lut
  r1.xyz = saturate(r0.xyz);
  r1.xyz = r1.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
  r1.xyz = t14.Sample(s2_s, r1.xyz).xyz;
  
  //color grade?
  r0.xyz = -r1.xyz + r0.xyz;
  r0.xyz = cb0[4].xxx * r0.xyz + r1.xyz;
  r1.xyz = cb0[6].xyz * r0.xyz + -cb0[6].xyz;
  r1.xyz = cb0[7].xxx * r1.xyz + cb0[6].xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[6].www * r1.xyz + r0.xyz;
  
  // Brightness slider
  //  r0.xyz = log2(r0.xyz);
  //  r0.w = 0.454545438 * cb0[7].y;
  //  r0.xyz = r0.www * r0.xyz;
  //  r0.xyz = exp2(r0.xyz);
  float brightness = 0.454545438 * cb0[7].y;
  r0.xyz = pow(r0.xyz, brightness);
  colorU = pow(colorU, brightness * CUSTOM_BRIGHTNESSOFFSET);

  o0.xyz = r0.xyz;
  
  colorU.xyz = renodx::color::srgb::Decode(colorU.xyz);
  o0.xyz = renodx::color::srgb::Decode(o0.xyz);
  o0.xyz = Tonemap_Do(colorU, o0.xyz, v0, t12);

  return;
}