#include "./common.hlsl"

float4 ScreenPositionScaleBias : register(c1);
sampler2D Texture2D_0 : register(s0);
float4 UniformVector_0 : register(c0);

struct PS_IN {
  float2 texcoord : TEXCOORD;
  float4 texcoord4 : TEXCOORD4;
  float4 texcoord5 : TEXCOORD5;
};

float4 main(PS_IN i) : COLOR {
  float4 o;

  float4 r0;
  float3 r1;
  float4 r2;
  r0.x = 1 / i.texcoord5.x;
  r0.xy = r0.x * i.texcoord5.w;
  r0.xy = r0.xy * ScreenPositionScaleBias.xy + ScreenPositionScaleBias.wz;
  r0.xy = r0.xy * 0.5 + 0.5;
  r0.xy = frac(r0.xy);
  r0.xy = r0.xy * 6.2831855 + -3.1415927;
  sincos(r0.x, r1.y, r1.y);
  sincos(r0.y, r2.y, r2.y);
  r0.x = r1.y + r2.y;
  r0.x = r0.x * 0.5 + 0.59999996;
  r0.y = r0.x * 0.5 + 0.5;
  r0.xy = r0.x * -i.texcoord.xy + r0.y;
  r0 = tex2D(Texture2D_0, r0);
  r0.xyz = r0.xyz * r0.xyz;
  r1.xyz = float3(1.5, 1.25, 1);
  r0.xyz = r0.xyz * r1.xyz + UniformVector_0.xyz;
  o.xyz = r0.xyz * i.texcoord4.w;
  o.xyz = SunPass(o.xyz, Texture2D_0, i.texcoord.xy, i.texcoord4.w);
  o.w = 0;

  return o;
}

// ps_3_0
//       0x000000F0 : def c2, 0.5, 6.28318548, -3.14159274, 0.599999964
//       0x00000108 : def c3, 1.5, 1.25, 1, 0
//       0x00000120 : dcl_texcoord v0.xy
//       0x0000012C : dcl_texcoord4_pp v1.w
//       0x00000138 : dcl_texcoord5 v2.xyw
//       0x00000144 : dcl_2d s0
//    0 0x00000150 : rcp r0.x, v2.w
//    1 0x0000015C : mul r0.xy, r0.x, v2
//    2 0x0000016C : mad r0.xy, r0, c1, c1.wzzw
//    3 0x00000180 : mad r0.xy, r0, c2.x, c2.x
//    4 0x00000194 : frc r0.xy, r0
//    5 0x000001A0 : mad r0.xy, r0, c2.y, c2.z
//    6 0x000001B4 : sincos r1.y, r0.x
//   14 0x000001C0 : sincos r2.y, r0.y
//   22 0x000001CC : add r0.x, r1.y, r2.y
//   23 0x000001DC : mad r0.x, r0.x, c2.x, c2.w
//   24 0x000001F0 : mad r0.y, r0.x, c2.x, c2.x
//   25 0x00000204 : mad r0.xy, r0.x, -v0, r0.y
//   26 0x00000218 : texld r0, r0, s0
//   26 0x00000228 : mul r0.xyz, r0, r0
//   27 0x00000238 : mov r1.xyz, c3
//   28 0x00000244 : mad_pp r0.xyz, r0, r1, c0
//   29 0x00000258 : mul_pp oC0.xyz, r0, v1.w
//   30 0x00000268 : mov_pp oC0.w, c3.w