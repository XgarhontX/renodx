sampler2D TextureSampler : register( s0 );
sampler2D TextureSampler2L : register( s1 );
float g_fNegativeFactor : register( c16 );

struct PS_IN
{
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord : TEXCOORD;
};

#include "../shared.h"

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;

	r0 = tex2D(TextureSampler2L, i.texcoord.zw);
	r0 = r0.xxxz * i.texcoord2;
	r0.xyz = r0.w * r0.xyz;
	
	r1 = tex2D(TextureSampler, i.texcoord.xy);
	r2 = r1.xxxz * i.texcoord1;
	r0.w = r1.z * i.texcoord1.w + r0.w;
	r0.xyz = r2.xyz * r2.w + r0.xyz;

	o.xyz = max(r0.xyz, 0) / EXPOSURE_REVERSAL;

	r1.x = (-r0.w >= 0) ? 0 : 1;
	r0.w = (r0.w >= 0) ? -0 : -1;
	r0.w = r0.w + r1.x;
	r0.w = r0.w * 0.003921569;
	r1.x = min(r0.z, r0.y);
	r2.x = min(r1.x, r0.x);
	r0.x = r2.x * g_fNegativeFactor.x;
	r0.x = saturate(-r0.x);
	o.w = max(r0.x, r0.w);

	return o;
}
