struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
};

#include "../shared.h"

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float2 r0;
	float r1;
	
	r0.xy = saturate(abs(i.texcoord.xy));
	r0.x = dot(r0.xy, -r0.xy) + 1;
	r1.x = max(r0.x, 0);
	r0.x = r1.x * r1.x;
	r0.y = r0.x * r0.x;
	r0.x = r0.y * r0.x;
	o.xyz = r0.x * i.texcoord1.xyz;
	o.w = 0;

	return o / EXPOSURE_REVERSAL /* * 0.85 */;
}

/*
   ps_3_0
      0x00000060:     def c0, 1, 0, 0, 0
      0x00000078:     dcl_texcoord v0.xy
      0x00000084:     dcl_texcoord1 v1.xyz
   0  0x00000090:     abs_sat r0.xy, v0
   1  0x0000009C:     dp2add r0.x, r0, -r0, c0.x
   3  0x000000B0:     max r1.x, r0.x, c0.y
   4  0x000000C0:     mul r0.x, r1.x, r1.x
   5  0x000000D0:     mul r0.y, r0.x, r0.x
   6  0x000000E0:     mul r0.x, r0.y, r0.x
   7  0x000000F0:     mul oC0.xyz, r0.x, v1
   8  0x00000100:     mov oC0.w, c0.y
*/