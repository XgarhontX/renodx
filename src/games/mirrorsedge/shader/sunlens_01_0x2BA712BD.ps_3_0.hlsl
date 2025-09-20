#include "../shared.h"
sampler2D Texture2D_0 : register(s0);
float UniformScalar_0 : register(c2);
float UniformScalar_1 : register(c3);
float UniformScalar_2 : register(c4);
float UniformScalar_3 : register(c5);
float4 UniformVector_0 : register(c0);

struct PS_IN {
  float2 texcoord : TEXCOORD;
  float3 texcoord1 : TEXCOORD1;
  float2 texcoord2 : TEXCOORD2;
  float2 texcoord3 : TEXCOORD3;
  float4 texcoord4 : TEXCOORD4;
};

float4 main(PS_IN i) : COLOR {
  float4 o;

  float4 r0;
  float3 r1;

  if (CUSTOM_SUNLENS <= 0) discard;

  r0.w = 0.5;
  r0.x = i.texcoord.x * r0.w + UniformScalar_0.x;
  r0.x = (i.texcoord.x >= 0) ? r0.x : UniformScalar_0.x;
  r1.x = min(UniformScalar_1.x, r0.x);
  r0.x = 0.25;
  r0.x = i.texcoord.y * r0.x + UniformScalar_2.x;
  r0.x = (i.texcoord.y >= 0) ? r0.x : UniformScalar_2.x;
  r1.y = min(UniformScalar_3.x, r0.x);
  r0 = tex2D(Texture2D_0, r1);
  r0.w = 1 + -i.texcoord2.y;
  r1.x = max(0.1, r0.w);
  r0.w = min(r1.x, 1000);
  r1.xyz = r0.w * i.texcoord1.xyz;
  r0.xyz = r0.xyz * r1.xyz;
  r0.xyz = r0.xyz * i.texcoord3.x;
  r0.xyz = i.texcoord3.y * r0.xyz + UniformVector_0.xyz;
  o.xyz = r0.xyz * (i.texcoord4.w * CUSTOM_SUNLENS);
  o.w = 0;

  return o;
}
