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
  r0.w = dot(UniformVector_2.y, r0.y) + r1.y;
  r0.zw = r0.xy + 0.5;
  r2 = tex2D(Texture2D_0, r0.zw);

  r0.z = dot(UniformVector_3.x, r0.x) + r1.y;
  r0.w = dot(UniformVector_4.y, r0.y) + r1.y;
  r0.xy = r0.zw + 0.5;
  r0 = tex2D(Texture2D_0, r0.xy);

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

// ps_3_0
//       0x00000154 : def c1, -0.5, 0, 0.5, 0.100000001
//       0x0000016C : def c6, 1000, 1, 0, 0
//       0x00000184 : dcl_texcoord v0.xy
//       0x00000190 : dcl_texcoord1 v1.xyz
//       0x0000019C : dcl_texcoord2 v2.y
//       0x000001A8 : dcl_texcoord3 v3.xy
//       0x000001B4 : dcl_texcoord4_pp v4.w
//       0x000001C0 : dcl_2d s0
//    0 0x000001CC : add r0.xy, c1.x, v0
//    1 0x000001DC : mov r1.y, c1.y
//    2 0x000001E8 : dp2add r0.z, c2, r0, r1.y
//    4 0x000001FC : dp2add r0.w, c3, r0, r1.y
//    6 0x00000210 : add r0.zw, r0, c1.z
//    7 0x00000220 : texld r2, r0.zwzw, s0
//    7 0x00000230 : dp2add r0.z, c4, r0, r1.y
//    9 0x00000244 : dp2add r0.w, c5, r0, r1.y
//   11 0x00000258 : add r0.xy, r0.zwzw, c1.z
//   12 0x00000268 : texld r0, r0, s0
//   12 0x00000278 : mul r0.x, r2.y, r0.y
//   13 0x00000288 : max r0.y, v2.y, c1.w
//   14 0x00000298 : min r1.x, r0.y, c6.x
//   15 0x000002A8 : add_sat r0.y, -r1.x, c6.y
//   16 0x000002B8 : mul r0.yzw, r0.y, v1.xxyz
//   17 0x000002C8 : mul r0.xyz, r0.x, r0.yzww
//   18 0x000002D8 : mul r0.xyz, r0, v3.x
//   19 0x000002E8 : mad_pp r0.xyz, v3.y, r0, c0
//   20 0x000002FC : mul_pp oC0.xyz, r0, v4.w
//   21 0x0000030C : mov_pp oC0.w, c1.y
