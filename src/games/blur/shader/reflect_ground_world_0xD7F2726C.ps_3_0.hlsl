sampler2D g_tColour : register( s0 );
float4 g_vSettings : register( c0 );
float4 g_vWeights0 : register( c1 );

#include "../shared.h"

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	r0.xy = g_vSettings.xy + texcoord.xy;
	r0 = tex2D(g_tColour, r0);
	r1.xy = -g_vSettings.xy + texcoord.xy;
	r1 = tex2D(g_tColour, r1);
	r0 = r0 + r1;
	r0 = r0 * g_vWeights0.y;
	r1 = tex2D(g_tColour, texcoord);
	r0 = g_vWeights0.x * r1 + r0;
	r1.xy = g_vSettings.xy;
	r1.zw = r1.xy * 2 + texcoord.xy;
	r2 = tex2D(g_tColour, r1.zwzw);
	r1.zw = r1.xy * -2 + texcoord.xy;
	r3 = tex2D(g_tColour, r1.zwzw);
	r2 = r2 + r3;
	r0 = g_vWeights0.z * r2 + r0;
	r1.zw = r1.xy * 3 + texcoord.xy;
	r2 = tex2D(g_tColour, r1.zwzw);
	r1.xy = r1.xy * -3 + texcoord.xy;
	r1 = tex2D(g_tColour, r1);
	r1 = r1 + r2;
	o = g_vWeights0.w * r1 + r0;

	o.xyz = pow(o.xyz, 1.2);
	o.xyz *= 0.85/* 0.67 */; //strength
	return o;
}
