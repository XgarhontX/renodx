sampler2D DepthBufferSampler : register( s13 );
sampler2D TextureSampler : register( s0 );
sampler2D TextureSampler2L : register( s1 );
float g_fNegativeFactor : register( c16 );
float4 g_vDepthScale : register( c65 );

struct PS_IN
{
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord : TEXCOORD;
	float4 texcoord4 : TEXCOORD4;
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

	r1 = tex2D(TextureSampler2L, i.texcoord.zw);
	r1 = r1.xxxz * i.texcoord2;
	r0.yzw = r1.w * r1.xyz;

	r2 = tex2D(TextureSampler, i.texcoord.xy);
	r3 = r2.xxxz * i.texcoord1;
	r1.w = r2.z * i.texcoord1.w + r1.w;
	r1.xyz = r3.xyz * r3.w + r0.yzw;
	r0 = r0.x * r1;
	o.xyz = max(r0.xyz, 0) / EXPOSURE_REVERSAL; //TODO: verify

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
      0x00000180:     def c0, 1, 0, -0, -1
      0x00000198:     def c1, 0.00392156886, 0, 0, 0
      0x000001B0:     dcl_texcoord1 v0
      0x000001BC:     dcl_texcoord2 v1
      0x000001C8:     dcl_texcoord v2
      0x000001D4:     dcl_texcoord4 v3
      0x000001E0:     dcl_2d s0
      0x000001EC:     dcl_2d s1
      0x000001F8:     dcl_2d s13
   0  0x00000204:     rcp r0.x, v3.w
   1  0x00000210:     mul r0.yz, r0.x, v3.xxyw
   2  0x00000220:     mul_sat r0.x, r0.x, v3.z
   3  0x00000230:     add r0.x, -r0.x, c0.x
   4  0x00000240:     texld r1, r0.yzzw, s13
   4  0x00000250:     add r0.y, r1_abs.x, -c65.x
   5  0x00000260:     rcp r0.y, r0.y
   6  0x0000026C:     mad_sat r0.y, c65.y, r0.y, -v3.w
   7  0x00000280:     mul r0.x, r0.x, r0.y
   8  0x00000290:     texld r1, v2.zwzw, s1
   8  0x000002A0:     mul r1, r1.xxxz, v1
   9  0x000002B0:     mul r0.yzw, r1.w, r1.xxyz
  10  0x000002C0:     texld r2, v2, s0
  10  0x000002D0:     mul r3, r2.xxxz, v0
  11  0x000002E0:     mad r1.w, r2.z, v0.w, r1.w
  12  0x000002F4:     mad r1.xyz, r3, r3.w, r0.yzww
  13  0x00000308:     mul r0, r0.x, r1
  14  0x00000318:     max oC0.xyz, r0, c0.y
  15  0x00000328:     min r1.x, r0.z, r0.y
  16  0x00000338:     min r2.x, r1.x, r0.x
  17  0x00000348:     mul r0.x, r2.x, c16.x
  18  0x00000358:     mov_sat r0.x, -r0.x
  19  0x00000364:     cmp r0.y, -r0.w, c0.y, c0.x
  20  0x00000378:     cmp r0.z, r0.w, c0.z, c0.w
  21  0x0000038C:     add_pp r0.y, r0.z, r0.y
  22  0x0000039C:     mul r0.y, r0.y, c1.x
  23  0x000003AC:     max oC0.w, r0.x, r0.y
*/