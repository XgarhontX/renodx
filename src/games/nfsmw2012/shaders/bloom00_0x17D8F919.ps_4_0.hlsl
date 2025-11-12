// ---- Created with 3Dmigoto v1.3.16 on Tue Nov 11 02:11:20 2025

SamplerState SamplerSource_s : register(s0);
SamplerState HDRToneMapping_s : register(s1);
Texture2D<float4> SamplerSource : register(t0);
Texture2D<float4> HDRToneMapping : register(t1);


// 3Dmigoto declarations
#define cmp -

void S(inout float4 x) { x = max(0, x);}

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = SamplerSource.Sample(SamplerSource_s, v1.xy).xyzw; S(r0);
  r1.xyzw = SamplerSource.Sample(SamplerSource_s, v1.zw).xyzw; S(r1);
  r0.xyz = r1.xyz + r0.xyz;
  r1.xyzw = SamplerSource.Sample(SamplerSource_s, v2.xy).xyzw; S(r1);
  r0.xyz = r1.xyz + r0.xyz;
  r1.xyzw = SamplerSource.Sample(SamplerSource_s, v2.zw).xyzw; S(r1);
  r0.xyz = r1.xyz + r0.xyz;
  r1.xyzw = HDRToneMapping.Sample(HDRToneMapping_s, float2(0.5,0.5)).xyzw;
  r0.xyz = r1.www * r0.xyz;
  r0.xyz = float3(0.0078125,0.0078125,0.0078125) * r0.xyz;
  r0.w = max(r0.x, r0.y);
  r1.x = max(9.99999997e-007, r0.z);
  r0.w = max(r1.x, r0.w);
  r0.w = min(1, r0.w);
  r0.w = 255 * r0.w;
  r0.w = ceil(r0.w);
  r0.w = 0.00392156886 * r0.w;
  // o0.xyz = saturate(r0.xyz / r0.www);
  o0.xyz = max(0, r0.xyz / r0.www);
  o0.w = r0.w;
  return;
}