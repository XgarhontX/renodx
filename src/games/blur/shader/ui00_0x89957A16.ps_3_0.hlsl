#include "../shared.h"

float4 g_LightColourFrom : register( c23 );
float4 g_LightColourTo : register( c24 );
float3 g_LightDir : register( c22 );
float g_LightFallOff : register( c25 );
float4 g_LightPos : register( c21 );

struct PS_IN
{
	float4 color : COLOR;
	float3 texcoord3 : TEXCOORD3;
};

float4 main(PS_IN i) : COLOR
{
	if (!C_UI) discard;

	float4 o;

	float4 r0;
	float4 r1;
	r0.xyz = -g_LightPos.xyz + i.texcoord3.xyz;
	r0.x = dot(g_LightDir.xyz, r0.xyz);
	r0.y = 1 / g_LightFallOff.x;
	r0.x = saturate(r0.x * r0.y);
	r1 = g_LightColourFrom;
	r1 = -r1 + g_LightColourTo;
	r0 = r0.x * r1 + g_LightColourFrom;
	o.xyz = i.color.xyz * r0.w + r0.xyz;
	o.w = r0.w * i.color.w;

	return o;
}

/*
      0x00000140:     dcl_color v0
      0x0000014C:     dcl_texcoord3 v1.xyz
   0  0x00000158:     add r0.xyz, -c21, v1
   1  0x00000168:     dp3 r0.x, c22, r0
   2  0x00000178:     rcp r0.y, c25.x
   3  0x00000184:     mul_sat r0.x, r0.y, r0.x
   4  0x00000194:     mov r1, c23
   5  0x000001A0:     add r1, -r1, c24
   6  0x000001B0:     mad r0, r0.x, r1, c23
   7  0x000001C4:     mad oC0.xyz, v0, r0.w, r0
   8  0x000001D8:     mul oC0.w, r0.w, v0.w
*/
