// ---- Created with 3Dmigoto v1.3.16 on Tue Nov 11 02:11:30 2025

cbuffer gGlobalCB : register(b0)
{
  float4 GenericVector4_E : packoffset(c0);
  float4 HDRConstants : packoffset(c1);
  float3 KeyLightColour : packoffset(c2) = {1,0,0};
  float3 KeyLightDirection : packoffset(c3);
  float4 ShadowMap_Constants : packoffset(c4);
  float4 ShadowMap_Constants2 : packoffset(c5);
  float4 ShadowMap_ConstantsArray[5] : packoffset(c6);
  float4 ShadowMap_ScaleOffset[3] : packoffset(c11);
  row_major float4x4 ShadowMap_WorldToLight0 : packoffset(c14);
  float3 ViewPosition : packoffset(c18);
  float3 deferred_cameraDirection : packoffset(c19) = {0,0,1};
}

cbuffer gObjectCB : register(b1)
{
  float4 KeylightProjectedShadowMaskSettings : packoffset(c0) = {0,1,0,0};
}

SamplerState DiffuseSampler_s : register(s0);
SamplerState deferred_normalBufferSampler_s : register(s1);
SamplerState deferred_depthBufferSampler_s : register(s2);
SamplerState AdditiveSampler_s : register(s3);
SamplerState KeylightProjectedShadowMaskSampler_s : register(s4);
SamplerState SpecularSampler_s : register(s5);
SamplerState TonemapSampler_s : register(s6);
SamplerState cubeIrradianceSampler2_s : register(s13);
SamplerState cubeIrradianceSampler_s : register(s14);
SamplerComparisonState shadowMapSamplerHighDetail_s : register(s15);
Texture2D<float4> deferred_depthBufferSampler : register(t0);
Texture2D<float4> deferred_normalBufferSampler : register(t1);
Texture2D<float4> AdditiveSampler : register(t2);
Texture2D<float4> TonemapSampler : register(t3);
Texture2D<float4> SpecularSampler : register(t4);
Texture2D<float4> DiffuseSampler : register(t5);
Texture2D<float4> KeylightProjectedShadowMaskSampler : register(t6);
TextureCube<float4> cubeIrradianceSampler : register(t7);
TextureCube<float4> cubeIrradianceSampler2 : register(t8);
Texture2D<float4> shadowMap0 : register(t15);


// 3Dmigoto declarations
#define cmp -

// void S(inout float3 x) { x = max(0, x); }
// void S(inout float4 x) { x = max(0, x); }
// void S(inout float2 x) { x = max(0, x); }
// void S(inout float x) { x = max(0, x); }
void S(inout float3 x) { x = saturate(x); }
void S(inout float4 x) { x = saturate(x); }
void S(inout float2 x) { x = saturate(x); }
void S(inout float x) { x = saturate(x); }

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = deferred_depthBufferSampler.Sample(deferred_depthBufferSampler_s, v1.xy).xyzw; /* S(r0); */
  r0.x = -v2.w + r0.x;
  r0.xyz = v2.xyz / r0.xxx;
  r1.xyz = ViewPosition.xyz + r0.xyz;
  r0.x = dot(deferred_cameraDirection.xyz, r0.xyz);
  r0.yzw = ShadowMap_WorldToLight0._m10_m11_m12 * r1.yyy;
  r0.yzw = r1.xxx * ShadowMap_WorldToLight0._m00_m01_m02 + r0.yzw;
  r0.yzw = r1.zzz * ShadowMap_WorldToLight0._m20_m21_m22 + r0.yzw;
  r0.yzw = ShadowMap_WorldToLight0._m30_m31_m32 + r0.yzw;
  r2.z = max(abs(r0.y), abs(r0.z));
  r3.xy = r0.yz * ShadowMap_ScaleOffset[0].xy + ShadowMap_ScaleOffset[1].xy;
  r2.y = max(abs(r3.x), abs(r3.y));
  r3.xy = r3.xy * float2(0.5,-0.166666672) + float2(0.5,0.5);
  r4.xy = r0.yz * ShadowMap_ScaleOffset[0].zw + ShadowMap_ScaleOffset[2].xy;
  r2.x = max(abs(r4.x), abs(r4.y));
  r4.xy = r4.xy * float2(0.5,-0.166666672) + float2(0.5,0.833333313);
  r2.xyz = float3(-0.99000001,-0.99000001,-0.99000001) + r2.xyz;
  r2.xyz = cmp(r2.xyz < float3(0,0,0));
  r1.w = ShadowMap_ScaleOffset[2].z + r0.w;
  r4.z = r2.x ? r1.w : 0;
  r3.z = ShadowMap_ScaleOffset[1].z + r0.w;
  r0.yzw = r0.yzw * float3(0.5,-0.166666672,1) + float3(0.5,0.166666657,0);
  r2.xyw = r2.yyy ? r3.xyz : r4.xyz;
  r0.yzw = r2.zzz ? r0.yzw : r2.xyw;
  r1.w = saturate(-r0.x * 0.0250000004 + 1);
  r0.x = saturate(-r0.x * ShadowMap_Constants2.w + ShadowMap_Constants.w);
  r0.x = r0.x * r0.x;
  r2.xy = -ShadowMap_ConstantsArray[4].zw * r1.ww + r0.yz;
  r2.x = shadowMap0.SampleCmpLevelZero(shadowMapSamplerHighDetail_s, r2.xy, r0.w).x;
  r3.xy = ShadowMap_ConstantsArray[4].zw * r1.ww + r0.yz;
  r4.xy = ShadowMap_ConstantsArray[4].zw * r1.ww;
  r2.w = shadowMap0.SampleCmpLevelZero(shadowMapSamplerHighDetail_s, r3.xy, r0.w).x;
  r4.zw = -r4.yx;
  r3.xyzw = r4.xzwy + r0.yzyz;
  r2.y = shadowMap0.SampleCmpLevelZero(shadowMapSamplerHighDetail_s, r3.xy, r0.w).x;
  r2.z = shadowMap0.SampleCmpLevelZero(shadowMapSamplerHighDetail_s, r3.zw, r0.w).x;
  r0.y = shadowMap0.SampleCmpLevelZero(shadowMapSamplerHighDetail_s, r0.yz, r0.w).x;
  r0.z = dot(r2.xyzw, float4(0.200000003,0.200000003,0.200000003,0.200000003));
  r0.y = r0.y * 0.200000003 + r0.z;
  r0.y = -ShadowMap_Constants2.y + r0.y;
  r0.x = r0.x * r0.y + ShadowMap_Constants2.y;
  r0.x = r0.x * r0.x;
  r0.yz = r1.xz * KeylightProjectedShadowMaskSettings.zz + KeylightProjectedShadowMaskSettings.ww;
  r1.xyz = GenericVector4_E.xyz + -r1.xyz;
  r0.w = dot(r1.xyz, r1.xyz);
  r0.w = sqrt(r0.w);
  r0.w = 0.0199999996 * r0.w;
  r0.w = min(1, r0.w);
  r1.xyzw = KeylightProjectedShadowMaskSampler.Sample(KeylightProjectedShadowMaskSampler_s, r0.yz).xyzw; /* S(r1); */
  r0.y = r1.y * KeylightProjectedShadowMaskSettings.x + KeylightProjectedShadowMaskSettings.y;
  r0.x = r0.x * r0.y;
  r1.xyzw = DiffuseSampler.Sample(DiffuseSampler_s, v1.xy).xyzw;/*  S(r1); */
  r0.y = 1 + -r1.w;
  r0.y = saturate(-r0.y * 0.800000012 + 1);
  r0.x = r0.x * r0.y;
  r0.xyz = KeyLightColour.xyz * r0.xxx;
  r1.xyz = r1.xyz * r1.xyz;
  r2.xyzw = deferred_normalBufferSampler.Sample(deferred_normalBufferSampler_s, v1.xy).xyzw; /* S(r2); */
  r2.xyz = r2.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r2.w = r2.w * -11 + 11.0001001;
  r2.w = exp2(r2.w);
  r3.x = dot(r2.xyz, r2.xyz);
  r3.x = rsqrt(r3.x);
  r2.xyz = r3.xxx * r2.xyz;
  r3.x = dot(r2.xyz, -KeyLightDirection.xyz);
  r3.y = saturate(r3.x);
  r4.xyz = r3.yyy * r1.xyz;
  r5.xyzw = SpecularSampler.Sample(SpecularSampler_s, v1.xy).xyzw; /* S(r5); */
  r6.xyz = float3(1,1,1) + -r5.xyz;
  r4.xyz = r6.xyz * r4.xyz;
  r4.xyz = r4.xyz * r0.xyz;
  r4.xyz = float3(0.318309873,0.318309873,0.318309873) * r4.xyz;
  r3.z = dot(v2.xyz, v2.xyz);
  r3.z = rsqrt(r3.z);
  r7.xyz = v2.xyz * r3.zzz;
  r8.xyz = v2.xyz * r3.zzz + -KeyLightDirection.xyz;
  r3.z = saturate(dot(r2.xyz, r7.xyz));
  r3.w = -r3.z * 0.5 + 1;
  r3.z = max(r3.x, r3.z);
  r3.x = -r3.x * 0.5 + 1;
  r4.w = r3.w * r3.w;
  r4.w = r4.w * r4.w;
  r3.w = -r4.w * r3.w + 1;
  r4.w = r3.x * r3.x;
  r4.w = r4.w * r4.w;
  r3.x = -r4.w * r3.x + 1;
  r3.x = r3.x * r3.w;
  r9.xyz = r6.xyz * r1.xyz;
  r9.xyz = r9.xyz * r3.xxx;
  r9.xyz = float3(0.387507677,0.387507677,0.387507677) * r9.xyz;
  r9.xyz = r9.xyz * r3.yyy;
  r9.xyz = r0.xyz * r9.xyz + -r4.xyz;
  
  r10.xyzw = AdditiveSampler.Sample(AdditiveSampler_s, v1.xy).xyzw; S(r10); /* r10 = clamp(r10, 0, 2.0); */ //letting this unclamped over blows car lights.
  r3.x = cmp(0.992156863 < r10.w);
  r10.xyz = r10.xyz * r10.xyz;
  r3.w = r3.x ? 1 : 0;
  o0.w = r3.x ? 0 : 1;
  r4.xyz = r3.www * r9.xyz + r4.xyz;

  r9.xyzw = cubeIrradianceSampler2.Sample(cubeIrradianceSampler2_s, r2.xyz).xyzw;/*  S(r9); */
  r9.xyz = r9.xyz * r9.xyz;
  r9.xyz = float3(4,4,4) * r9.xyz;
  r11.xyzw = cubeIrradianceSampler.Sample(cubeIrradianceSampler_s, r2.xyz).xyzw; /* S(r11); */
  r11.xyz = r11.xyz * r11.xyz;
  r12.xyz = r11.xyz * float3(4,4,4) + -r9.xyz;
  r9.xyz = r0.www * r12.xyz + r9.xyz;
  r9.xyz = -r11.xyz * float3(4,4,4) + r9.xyz;
  r11.xyz = float3(4,4,4) * r11.xyz;
  r9.xyz = r3.www * r9.xyz + r11.xyz;
  r9.xyz = r9.xyz * r1.www;
  r9.xyz = r9.xyz * r6.xyz;
  r6.xyz = r6.xyz * r5.www;
  r1.xyz = r9.xyz * r1.xyz + r4.xyz;
  r0.w = dot(r8.xyz, r8.xyz);
  r0.w = rsqrt(r0.w);
  r4.xyz = r8.xyz * r0.www;
  r0.w = saturate(dot(r2.xyz, r4.xyz));
  r1.w = dot(r7.xyz, r4.xyz);
  r0.w = 9.99999975e-005 + r0.w;
  r0.w = min(1, r0.w);
  r0.w = log2(r0.w);
  r0.w = r2.w * r0.w;
  r2.x = 1 + r2.w;
  r2.x = 0.0397887342 * r2.x;
  r0.w = exp2(r0.w);
  r0.w = r2.x * r0.w;
  r2.x = saturate(r1.w * r3.z);
  r1.w = saturate(1 + -r1.w);
  r2.x = 0.0013 + r2.x;
  r2.x = 1 / r2.x;
  r0.w = r2.x * r0.w;
  r2.x = r1.w * r1.w;
  r2.x = r2.x * r2.x;
  r1.w = r2.x * r1.w;
  r2.xyz = r6.xyz * r1.www + r5.xyz;
  r2.xyz = r2.xyz * r0.www;
  r2.xyz = r2.xyz * r3.yyy;
  r0.xyz = r0.xyz * r2.xyz + r1.xyz;
  r1.xyzw = TonemapSampler.Sample(TonemapSampler_s, float2(0.5,0.5)).xyzw; /* S(r11); */
  r0.w = HDRConstants.y / r1.w;
  o0.xyz = r10.xyz * r0.www + r0.xyz;
  return;
}