// ---- Created with 3Dmigoto v1.3.16 on Tue Nov 11 00:51:02 2025

cbuffer Constants : register(b0)
{
  float2 g_mainTexSize : packoffset(c0);
  float2 g_mainTexInvSize : packoffset(c0.z);
  float2 g_outputTexSize : packoffset(c1);
  float2 g_outputTexInvSize : packoffset(c1.z);
  float4 g_planeWeights : packoffset(c2);
}

SamplerState g_linearSampler_s : register(s1);
Texture2D<float4> g_mainTexture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.z = 1;
  r1.xy = -g_mainTexInvSize.xy * float2(0.5,0.5) + v1.xy;
  r1.zw = g_mainTexSize.xy * r1.xy;
  r1.zw = frac(r1.zw);
  r2.xy = r1.zw * r1.zw;
  r3.xz = r2.xy * r1.zw;
  r2.z = r3.z;
  r0.xy = r2.zy;
  r4.y = dot(r0.xzy, float3(1,1,-2));
  r4.w = dot(r0.xy, float2(1,-1));
  r2.w = r1.w;
  r4.x = dot(r2.zwy, float3(-1,-1,2));
  r4.z = dot(r2.zyw, float3(-1,1,1));
  r3.y = r2.x;
  r0.x = dot(r4.xyzw, float4(1,1,1,1));
  r0.xyzw = r4.xyzw / r0.xxxx;
  r3.w = r1.z;
  r1.zw = float2(-0.5,-0.5) + -r1.zw;
  r1.xw = r1.zw * g_mainTexInvSize.xy + r1.xy;
  r2.x = dot(r3.xwy, float3(-1,-1,2));
  r2.z = dot(r3.xyw, float3(-1,1,1));
  r3.z = 1;
  r2.y = dot(r3.xzy, float3(1,1,-2));
  r2.w = dot(r3.xy, float2(1,-1));
  r3.x = dot(r2.xyzw, float4(1,1,1,1));
  r2.xyzw = r2.xyzw / r3.xxxx;
  r1.yz = g_mainTexInvSize.yx + r1.wx;
  r3.xyz = g_mainTexture.SampleLevel(g_linearSampler_s, r1.zy, 0).xyz;
  r3.xyz = r3.xyz * r2.yyy;
  r4.xyz = g_mainTexture.SampleLevel(g_linearSampler_s, r1.xy, 0).xyz;
  r3.xyz = r2.xxx * r4.xyz + r3.xyz;
  r4.zw = r1.wy;
  r4.xy = g_mainTexInvSize.xy * float2(2,2) + r1.xw;
  r5.xyz = g_mainTexture.SampleLevel(g_linearSampler_s, r4.xw, 0).xyz;
  r3.xyz = r2.zzz * r5.xyz + r3.xyz;
  r5.zw = r4.zw;
  r6.xyz = g_mainTexture.SampleLevel(g_linearSampler_s, r4.xz, 0).xyz;
  r5.xy = g_mainTexInvSize.xy * float2(3,3) + r1.xw;
  r7.xyz = g_mainTexture.SampleLevel(g_linearSampler_s, r5.xw, 0).xyz;
  r8.xyz = g_mainTexture.SampleLevel(g_linearSampler_s, r5.xz, 0).xyz;
  r3.xyz = r2.www * r7.xyz + r3.xyz;
  r3.xyz = r3.xyz * r0.yyy;
  r7.xyz = g_mainTexture.SampleLevel(g_linearSampler_s, r1.xw, 0).xyz;
  r9.xyz = g_mainTexture.SampleLevel(g_linearSampler_s, r1.zw, 0).xyz;
  r9.xyz = r9.xyz * r2.yyy;
  r7.xyz = r2.xxx * r7.xyz + r9.xyz;
  r6.xyz = r2.zzz * r6.xyz + r7.xyz;
  r6.xyz = r2.www * r8.xyz + r6.xyz;
  r3.xyz = r0.xxx * r6.xyz + r3.xyz;
  r1.y = r4.y;
  r6.xyz = g_mainTexture.SampleLevel(g_linearSampler_s, r1.xy, 0).xyz;
  r7.xyz = g_mainTexture.SampleLevel(g_linearSampler_s, r1.zy, 0).xyz;
  r8.xz = r1.xz;
  r7.xyz = r7.xyz * r2.yyy;
  r6.xyz = r2.xxx * r6.xyz + r7.xyz;
  r4.yzw = g_mainTexture.SampleLevel(g_linearSampler_s, r4.xy, 0).xyz;
  r8.w = r4.x;
  r4.xyz = r2.zzz * r4.yzw + r6.xyz;
  r1.w = r5.x;
  r1.xyz = g_mainTexture.SampleLevel(g_linearSampler_s, r1.wy, 0).xyz;
  r1.xyz = r2.www * r1.xyz + r4.xyz;
  r0.xyz = r0.zzz * r1.xyz + r3.xyz;
  r8.y = r5.y;
  r1.xyz = g_mainTexture.SampleLevel(g_linearSampler_s, r5.xy, 0).xyz;
  r3.xyz = g_mainTexture.SampleLevel(g_linearSampler_s, r8.zy, 0).xyz;
  r4.xyz = g_mainTexture.SampleLevel(g_linearSampler_s, r8.xy, 0).xyz;
  r5.xyz = g_mainTexture.SampleLevel(g_linearSampler_s, r8.wy, 0).xyz;
  r3.xyz = r3.xyz * r2.yyy;
  r3.xyz = r2.xxx * r4.xyz + r3.xyz;
  r2.xyz = r2.zzz * r5.xyz + r3.xyz;
  r1.xyz = r2.www * r1.xyz + r2.xyz;
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  r1.xyz = g_planeWeights.xxx * r0.xyz + float3(0.0549999997,0.0549999997,0.0549999997);
  r0.xyz = g_planeWeights.xxx * r0.xyz;

  o0.xyz = r0.xyz;

  // decode srgb
  // r1.xyz = float3(0.947867334,0.947867334,0.947867334) * r1.xyz;
  // r1.xyz = log2(r1.xyz);
  // r1.xyz = float3(2.4000001,2.4000001,2.4000001) * r1.xyz;
  // r1.xyz = exp2(r1.xyz);
  // r2.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r0.xyz;
  // r0.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r0.xyz);
  // r0.xyz = /* saturate */(r0.xyz ? r2.xyz : r1.xyz); //bruh wth. Decode to apply sat. 

  // encode srgb
  // r1.xyz = log2(r0.xyz);
  // r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
  // r1.xyz = exp2(r1.xyz);
  // r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  // r2.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xyz;
  // r0.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r0.xyz);
  // o0.xyz = r0.xyz ? r2.xyz : r1.xyz;

  o0.w = g_planeWeights.x;
  return;
}