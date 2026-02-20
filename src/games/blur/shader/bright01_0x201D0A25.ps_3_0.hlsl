sampler2D TextureSampler : register( s0 );
float g_fAlphaFactor : register( c16 );

struct PS_IN
{
	float4 texcoord1 : TEXCOORD1;
	float2 texcoord : TEXCOORD;
};

#include "../shared.h"

//ground decals like road white edge
float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	r0 = tex2D(TextureSampler, i.texcoord);
	r1 = r0 * i.texcoord1;
	o.xyz = r1.w * r1.xyz;

	r0.x = (-r1.w >= 0) ? 0 : 1;
	r0.y = (r1.w >= 0) ? -0 : -1;
	r0.x = r0.y + r0.x;
	r0.x = r0.x * 0.003921569;
	r0.y = r0.w * i.texcoord1.w + -r0.x;
	o.w = g_fAlphaFactor.x * r0.y + r0.x;

  o.xyz *=/*  0.65 * */ EXPOSURE_BRIGHT_GLOBAL;

	return o;
}
