sampler2D DepthBufferSampler : register( s13 );
sampler2D TextureSampler : register( s0 );
sampler2D UVDistortTextureSampler : register( s1 );
float gUvDistort : register( c80 );
float g_fNegativeFactor : register( c16 );
float4 g_vDepthScale : register( c65 );
float g_vScrollTextureX : register( c69 );
float g_vScrollTextureY : register( c70 );

struct PS_IN
{
	float4 texcoord1 : TEXCOORD1;
	float2 texcoord : TEXCOORD;
	float4 texcoord4 : TEXCOORD4;
	float2 texcoord5 : TEXCOORD5;
};

#include "../shared.h"

//TODO: verify, 90% confident
float4 main(PS_IN i) : COLOR
{
  // float b = 100;
	// return float4(b,b,b,1);
	// return tex2D(TextureSampler, i.texcoord.xy);

	float4 o;

	float4 r0;
	float4 r1;
	float2 r2;

	r0.x = 1 / i.texcoord4.w;
	r0.yz = r0.x * i.texcoord4.xy;
	r0.x = saturate(r0.x * i.texcoord4.z);
	r0.x = -r0.x + 1;

	r1 = tex2D(DepthBufferSampler, r0.yz);
	r0.y = abs(r1.x) + -g_vDepthScale.x;
	r0.y = 1 / r0.y;
	r0.y = saturate(g_vDepthScale.y * r0.y + -i.texcoord4.w);
	r0.x = r0.x * r0.y;

	r1 = tex2D(UVDistortTextureSampler, i.texcoord5);
	r0.yz = r1.yw + -0.5; 
	r1.y = 2;
	r2.x = r0.y * r1.y + g_vScrollTextureX;
	r2.y = r0.z * r1.y + g_vScrollTextureY;
	r0.yz = r2.xy * gUvDistort + i.texcoord;

	r1 = tex2D(TextureSampler, r0.yz); //x only, w = 1
	r1 = r1.xxxz * i.texcoord1;
	r1.xyz = r1.w * r1.xyz; //alpha basically
	r0 = r0.x * r1;
	o.xyz = max(r0.xyz, 0) /* z */ / EXPOSURE_REVERSAL;
	
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
      0x00000200:     def c0, -0.5, 2, 1, 0
      0x00000218:     def c1, 0.00392156886, 0, 0, 0
      0x00000230:     dcl_texcoord1 v0
      0x0000023C:     dcl_texcoord v1.xy
      0x00000248:     dcl_texcoord4 v2
      0x00000254:     dcl_texcoord5 v3.xy
      0x00000260:     dcl_2d s0
      0x0000026C:     dcl_2d s1
      0x00000278:     dcl_2d s13
   0  0x00000284:     rcp r0.x, v2.w
   1  0x00000290:     mul r0.yz, r0.x, v2.xxyw
   2  0x000002A0:     mul_sat r0.x, r0.x, v2.z
   3  0x000002B0:     add r0.x, -r0.x, c0.z
   4  0x000002C0:     texld r1, r0.yzzw, s13
   4  0x000002D0:     add r0.y, r1_abs.x, -c65.x
   5  0x000002E0:     rcp r0.y, r0.y
   6  0x000002EC:     mad_sat r0.y, c65.y, r0.y, -v2.w
   7  0x00000300:     mul r0.x, r0.x, r0.y
   8  0x00000310:     texld r1, v3, s1
   8  0x00000320:     add r0.yz, r1.xyww, c0.x
   9  0x00000330:     mov r1.y, c0.y
  10  0x0000033C:     mad r2.x, r0.y, r1.y, c69.x
  11  0x00000350:     mad r2.y, r0.z, r1.y, c70.x
  12  0x00000364:     mad r0.yz, r2.xxyw, c80.x, v1.xxyw
  13  0x00000378:     texld r1, r0.yzzw, s0
  13  0x00000388:     mul r1, r1.xxxz, v0
  14  0x00000398:     mul r1.xyz, r1.w, r1
  15  0x000003A8:     mul r0, r0.x, r1
  16  0x000003B8:     max oC0.xyz, r0, c0.w
  17  0x000003C8:     min r1.x, r0.z, r0.y
  18  0x000003D8:     min r2.x, r1.x, r0.x
  19  0x000003E8:     mul r0.x, r2.x, c16.x
  20  0x000003F8:     mov_sat r0.x, -r0.x
  21  0x00000404:     cmp r0.y, -r0.w, c0.w, c0.z
  22  0x00000418:     cmp r0.z, r0.w, -c0.w, -c0.z
  23  0x0000042C:     add_pp r0.y, r0.z, r0.y
  24  0x0000043C:     mul r0.y, r0.y, c1.x
  25  0x0000044C:     max oC0.w, r0.x, r0.y

*/