#include "./common.hlsl"
sampler2D Texture2D_0 : register(s0);
float4 UniformVector_0 : register(c0);
float4 UniformVector_1 : register(c2);
float4 UniformVector_2 : register(c3);
float4 UniformVector_3 : register(c4);
float4 UniformVector_4 : register(c5);

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
  float2 r1;
  float4 r2;
  r0.xy = -0.5 + i.texcoord.xy;
  r1.y = 0;
  r0.z = dot(UniformVector_1.x, r0.x) + r1.y;
  r0.w = dot(UniformVector_2.x, r0.x) + r1.y;
  r0.zw = r0.xy + 0.5;
  r2 = tex2D(Texture2D_0, r0.zwzw);
  r0.z = dot(UniformVector_3.x, r0.x) + r1.y;
  r0.w = dot(UniformVector_4.x, r0.x) + r1.y;
  r0.xy = r0.zw + 0.5;
  r0 = tex2D(Texture2D_0, r0);
  r0.x = r2.y * r0.y;
  r0.y = max(i.texcoord2.y, 0.1);
  r1.x = min(r0.y, 1000);
  r0.y = -r1.x + 1;
  r0.yzw = r0.y * i.texcoord1.xyz;
  r0.xyz = r0.x * r0.yzw;
  r0.xyz = r0.xyz * i.texcoord3.x;
  r0.xyz = i.texcoord3.y * r0.xyz + UniformVector_0.xyz;
  o.xyz = r0.xyz * i.texcoord4.w;
  o.xyz = SunPass(o.xyz, Texture2D_0, i.texcoord.xy, i.texcoord4.w);
  o.w = 0;

  return o;
}
