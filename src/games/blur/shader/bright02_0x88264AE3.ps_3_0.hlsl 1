sampler2D TextureSampler : register( s0 );
sampler2D TextureSampler2L : register( s1 );
float g_fAlphaFactor : register( c16 );

struct PS_IN
{
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord : TEXCOORD;
};

#include "../shared.h"

//turn barriers
float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	r0 = tex2D(TextureSampler2L, i.texcoord.zwzw);
	r0 = r0 * i.texcoord2;
	r0.xyz = r0.w * r0.xyz;
	r1 = tex2D(TextureSampler, i.texcoord);
	r2 = r1 * i.texcoord1;
	r0.w = r1.w * i.texcoord1.w + r0.w;
	o.xyz = r2.xyz * r2.w + r0.xyz;
	r0.x = (-r0.w >= 0) ? 0 : 1;
	r0.y = (r0.w >= 0) ? -0 : -1;
	r0.x = r0.y + r0.x;
	r0.y = r0.x * -0.003921569 + r0.w;
	r0.x = r0.x * 0.003921569;
	o.w = g_fAlphaFactor.x * r0.y + r0.x;

	o.xyz *= /* 0.55 * */ EXPOSURE_BRIGHT_GLOBAL;

	return o;
}
