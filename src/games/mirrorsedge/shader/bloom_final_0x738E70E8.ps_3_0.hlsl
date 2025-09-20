#include "../shared.h"
sampler2D BlurredImage : register(s1);
float2 MinMaxBlurClamp : register(c2);
float4 PackedParameters : register(c0);
sampler2D SceneColorTexture : register(s0);

struct PS_IN {
  float2 texcoord : TEXCOORD;
  float2 texcoord1 : TEXCOORD1;
};

float4 main(PS_IN i) : COLOR {
  float4 o;

  float4 r0;
  float4 r1;
  float4 r2;

  r0 = tex2D(SceneColorTexture, i.texcoord1);
  float3 colorTex = r0.xyz;
  if (CUSTOM_BLOOM <= 0) return r0;

  // depth replace?
  r1.x = r0.w + -PackedParameters.x;
  r1.y = abs(r1.x) * PackedParameters.y;
  r1.x = (r1.x >= 0) ? MinMaxBlurClamp.y : MinMaxBlurClamp.x;
  r2.x = max(r1.y, 0.0001);
  r1.y = pow(r2.x, PackedParameters.z);
  r2.x = min(r1.y, r1.x);
  r1.x = saturate(-r2.x + 1);

  r2 = tex2D(BlurredImage, i.texcoord);
  r1.yzw = r2.xyz * 4;
  r2.x = r2.w * 4 + r1.x;
  r0.xyz = r0.xyz * r1.x + r1.yzw;
  o.w = r0.w;

  r0.w = r2.x;
  r0.w = max(r0.w, 0.001);
  r0.w = 1 / r0.w;
  o.xyz = r0.xyz * r0.w;

  return o;
}

//   ps_3_0
//     0x00000128:     def c1, 9.99999975e-005, 1, 4, 0.00100000005
//     0x00000140:     dcl_texcoord v0.xy
//     0x0000014C:     dcl_texcoord1 v1.xy
//     0x00000158:     dcl_2d s0
//     0x00000164:     dcl_2d s1

//  0  0x00000170:     texld_pp r0, v1, s0
//  0  0x00000180:     add_pp r1.x, r0.w, -c0.x
//  1  0x00000190:     mul_sat r1.y, r1_abs.x, c0.y
//  2  0x000001A0:     cmp_pp r1.x, r1.x, c2.y, c2.x
//  3  0x000001B4:     max r2.x, r1.y, c1.x
//  4  0x000001C4:     pow_pp r1.y, r2.x, c0.z
//  7  0x000001D4:     min_pp r2.x, r1.y, r1.x
//  8  0x000001E4:     add_sat_pp r1.x, -r2.x, c1.y

//  9  0x000001F4:     texld r2, v0, s1
//  9  0x00000204:     mul_pp r1.yzw, r2.xxyz, c1.z
// 10  0x00000214:     mad_pp r2.x, r2.w, c1.z, r1.x
// 11  0x00000228:     mad_pp r0.xyz, r0, r1.x, r1.yzww
// 12  0x0000023C:     mov_pp oC0.w, r0.w

// 13  0x00000248:     max_pp r0.w, r2.x, c1.w
// 14  0x00000258:     rcp r0.w, r0.w
// 15  0x00000264:     mul_pp oC0.xyz, r0, r0.w