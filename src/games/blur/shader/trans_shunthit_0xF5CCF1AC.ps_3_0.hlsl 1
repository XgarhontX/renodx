sampler2D DepthBufferSampler : register( s13 );
sampler2D TextureSampler : register( s0 );
sampler2D TextureSampler2L : register( s2 );
sampler2D UVDistortTextureSampler : register( s1 );
sampler2D UVDistortTextureSampler2L : register( s3 );
float gUvDistort : register( c80 );
float g_2L_UvDistort : register( c90 );
float g_2L_vScrollTextureX : register( c84 );
float g_2L_vScrollTextureY : register( c85 );
float g_fNegativeFactor : register( c16 );
float4 g_vDepthScale : register( c65 );
float g_vScrollTextureX : register( c69 );
float g_vScrollTextureY : register( c70 );

struct PS_IN
{
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord : TEXCOORD;
	float4 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
};

#include "../shared.h"

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;

	r0.x = 1 / i.texcoord4.w;
	r0.yz = r0.x * i.texcoord4.xy;
	r0.x = saturate(r0.x * i.texcoord4.z);
	r0.x = -r0.x + 1;
	
	r1 = tex2D(DepthBufferSampler, r0.yz);
	r0.y = abs(r1.x) + -g_vDepthScale.x;
	r0.y = 1 / r0.y;
	r0.y = saturate(g_vDepthScale.y * r0.y + -i.texcoord4.w);
	r0.x = r0.x * r0.y;

	r1 = tex2D(UVDistortTextureSampler2L, i.texcoord5.zw);
	r0.yz = r1.yw + -0.5;
	r1.y = 2;
	r2.x = r0.y * r1.y + g_2L_vScrollTextureX.x;
	r2.y = r0.z * r1.y + g_2L_vScrollTextureY.x;
	r0.yz = r2.xy * g_2L_UvDistort.x + i.texcoord.zw;

	r2 = tex2D(TextureSampler2L, r0.yz);
	r2 = r2.xxxz * i.texcoord2;
	r0.yzw = r2.w * r2.xyz;

	r3 = tex2D(UVDistortTextureSampler, i.texcoord5.xy);
	r1.xz = r3.yw + -0.5;
	r2.x = r1.xz * r1.y + g_vScrollTextureX.x;
	r2.y = r1.z * r1.y + g_vScrollTextureY.x;
	r1.xy = r2.xy * gUvDistort.x + i.texcoord.xy;

	r1 = tex2D(TextureSampler, r1.xy);
	r3 = r1.xxxz * i.texcoord1;
	r1.w = r1.z * i.texcoord1.w + r2.w;
	r1.xyz = r3.xyz * r3.w + r0.yzw;
	r0 = r0.x * r1;
	o.xyz = max(r0.xyz, 0) / EXPOSURE_REVERSAL; //TODO: verify, 80% confidence

	r1.x = min(r0.z, r0.y);
	r2.x = min(r1.x, r0.x);
	r0.x = r2.x * g_fNegativeFactor.x;
	r0.x = saturate(-r0.x);
	r0.y = (-r0.w >= 0) ? 0 : 1;
	r0.z = (r0.w >= 0) ? -0 : -1;
	r0.y = r0.z + r0.y;
	r0.y = r0.y * 0.003921569;
	o.w = max(r0.x, r0.y);

	return o;
}



/*
    ps_3_0
      0x000002EC:     def c0, -0.5, 2, 1, 0
      0x00000304:     def c1, 0.00392156886, 0, 0, 0
      0x0000031C:     dcl_texcoord1 v0
      0x00000328:     dcl_texcoord2 v1
      0x00000334:     dcl_texcoord v2
      0x00000340:     dcl_texcoord4 v3
      0x0000034C:     dcl_texcoord5 v4
      0x00000358:     dcl_2d s0
      0x00000364:     dcl_2d s1
      0x00000370:     dcl_2d s2
      0x0000037C:     dcl_2d s3
      0x00000388:     dcl_2d s13

   0  0x00000394:     rcp r0.x, v3.w
   1  0x000003A0:     mul r0.yz, r0.x, v3.xxyw
   2  0x000003B0:     mul_sat r0.x, r0.x, v3.z
   3  0x000003C0:     add r0.x, -r0.x, c0.z

   4  0x000003D0:     texld r1, r0.yzzw, s13
   4  0x000003E0:     add r0.y, r1_abs.x, -c65.x
   5  0x000003F0:     rcp r0.y, r0.y
   6  0x000003FC:     mad_sat r0.y, c65.y, r0.y, -v3.w
   7  0x00000410:     mul r0.x, r0.x, r0.y

   8  0x00000420:     texld r1, v4.zwzw, s3
   8  0x00000430:     add r0.yz, r1.xyww, c0.x
   9  0x00000440:     mov r1.y, c0.y
  10  0x0000044C:     mad r2.x, r0.y, r1.y, c84.x
  11  0x00000460:     mad r2.y, r0.z, r1.y, c85.x
  12  0x00000474:     mad r0.yz, r2.xxyw, c90.x, v2.xzww

  13  0x00000488:     texld r2, r0.yzzw, s2
  13  0x00000498:     mul r2, r2.xxxz, v1
  14  0x000004A8:     mul r0.yzw, r2.w, r2.xxyz
  15  0x000004B8:     texld r3, v4, s1
  15  0x000004C8:     add r1.xz, r3.yyww, c0.x
  16  0x000004D8:     mad r2.x, r1.x, r1.y, c69.x
  17  0x000004EC:     mad r2.y, r1.z, r1.y, c70.x
  18  0x00000500:     mad r1.xy, r2, c80.x, v2

  19  0x00000514:     texld r1, r1, s0
  19  0x00000524:     mul r3, r1.xxxz, v0
  20  0x00000534:     mad r1.w, r1.z, v0.w, r2.w
  21  0x00000548:     mad r1.xyz, r3, r3.w, r0.yzww
  22  0x0000055C:     mul r0, r0.x, r1
  23  0x0000056C:     max oC0.xyz, r0, c0.w
  24  0x0000057C:     min r1.x, r0.z, r0.y
  25  0x0000058C:     min r2.x, r1.x, r0.x
  26  0x0000059C:     mul r0.x, r2.x, c16.x

  27  0x000005AC:     mov_sat r0.x, -r0.x
  28  0x000005B8:     cmp r0.y, -r0.w, c0.w, c0.z
  29  0x000005CC:     cmp r0.z, r0.w, -c0.w, -c0.z
  30  0x000005E0:     add_pp r0.y, r0.z, r0.y
  31  0x000005F0:     mul r0.y, r0.y, c1.x
  32  0x00000600:     max oC0.w, r0.x, r0.y
*/