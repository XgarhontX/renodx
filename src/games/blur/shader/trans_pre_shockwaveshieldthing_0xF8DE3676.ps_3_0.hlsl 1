sampler2D ColourBufferSampler : register( s12 );
sampler2D DepthBufferSampler : register( s13 );
sampler2D TextureSampler : register( s0 );
float g_pRefractionIntensity : register( c74 );
float4 g_vDepthScale : register( c65 );

struct PS_IN
{
	float4 texcoord1 : TEXCOORD1;
	float2 texcoord : TEXCOORD;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord6 : TEXCOORD6;
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
	r0.xyz = r0.x * i.texcoord4.xyz/* zxy */; //TODO: swizzle?
  r1 = tex2D(TextureSampler, i.texcoord);
	// return r1 * 0.1;

	r2 = r1.xxyy * 2 + -1; //TODO: swizzle?
	r2 = r2 * i.texcoord3;
	r1.yw = r2.xy + r2.zw;
	r1.yw = r1.yw * g_pRefractionIntensity.x;
	r1.yw = r1.yw * i.texcoord6.w;
	r0.yz = r1.yw * r1.z + r0.xy;
	r0.x = saturate(r0.x);
	r0.x = -r0.x + 1;

	r2 = tex2D(ColourBufferSampler, r0.yz);
	// return r2;

	r3 = tex2D(DepthBufferSampler, r0.yz); /* r3 = saturate(r3); */
	// return r3;
	
	//TODO: brightness from depth is not 100% similar.
	r0.y = abs(r3.x) + -g_vDepthScale.x;
	r0.y = 1 / r0.y;
	r0.y = saturate(g_vDepthScale.y * r0.y + -i.texcoord4.w);
	r0.x = r0.x * r0.y;
	
	r0.yzw = -1 + i.texcoord6.xyz/* xxy */;
	r0.yzw = r1.z * r0.yzw + 1;
	r0.yzw = r0.yzw * r2.xyz/* xxy */;
	r1.xyw = r1.x * i.texcoord1.xyz;
	r1.xyz = r1.z * r1.xyw;
	r0.yzw = r1.xyz/* xxy */ * i.texcoord1.w + r0.yzw;
	r1.xyz = lerp(r2.xyz, r0.yzw, r0.x);

	o.xyz = max(r1.xyz, 0) ;
	o.w = 1;
	return o;
}
/*
ps_3_0
      0x00000174:     def c0, 2, -1, 1, 0
      0x0000018C:     dcl_texcoord1 v0
      0x00000198:     dcl_texcoord v1.xy
      0x000001A4:     dcl_texcoord3 v2
      0x000001B0:     dcl_texcoord6 v3
      0x000001BC:     dcl_texcoord4 v4
      0x000001C8:     dcl_2d s0
      0x000001D4:     dcl_2d s12
      0x000001E0:     dcl_2d s13

   0  0x000001EC:     rcp r0.x, v4.w
   1  0x000001F8:     mul r0.xyz, r0.x, v4.zxyw
   2  0x00000208:     texld r1, v1, s0
   2  0x00000218:     mad r2, r1.xxyy, c0.x, c0.y

   3  0x0000022C:     mul r2, r2, v2
   4  0x0000023C:     add r1.yw, r2.xzzw, r2.xxzy
   5  0x0000024C:     mul r1.yw, r1, c74.x
   6  0x0000025C:     mul r1.yw, r1, v3.w
   7  0x0000026C:     mad r0.yz, r1.xyww, r1.z, r0
   8  0x00000280:     mov_sat r0.x, r0.x
   9  0x0000028C:     add r0.x, -r0.x, c0.z

  10  0x0000029C:     texld r2, r0.yzzw, s12
  10  0x000002AC:     texld r3, r0.yzzw, s13
  10  0x000002BC:     add r0.y, r3_abs.x, -c65.x
  11  0x000002CC:     rcp r0.y, r0.y
  12  0x000002D8:     mad_sat r0.y, c65.y, r0.y, -v4.w
  13  0x000002EC:     mul r0.x, r0.x, r0.y

  14  0x000002FC:     add r0.yzw, c0.y, v3.xxyz
  15  0x0000030C:     mad r0.yzw, r1.z, r0, c0.z
  16  0x00000320:     mul r0.yzw, r0, r2.xxyz
  17  0x00000330:     mul r1.xyw, r1.x, v0.xyzz
  18  0x00000340:     mul r1.xyz, r1.z, r1.xyww
  19  0x00000350:     mad r0.yzw, r1.xxyz, v0.w, r0
  20  0x00000364:     lrp r1.xyz, r0.x, r0.yzww, r2

  21  0x00000378:     max oC0.xyz, r1, c0.w
  22  0x00000388:     mov_pp oC0.w, c0.z
*/