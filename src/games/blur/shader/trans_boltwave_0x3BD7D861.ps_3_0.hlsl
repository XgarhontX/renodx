sampler2D TextureSampler : register( s0 );
float g_fNegativeFactor : register( c16 );

struct PS_IN
{
	float4 texcoord1 : TEXCOORD1;
	float2 texcoord : TEXCOORD;
};

#include "../shared.h"

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float r1;
	float r2;

	r0 = tex2D(TextureSampler, i.texcoord);
	r0 = r0.xxxz * i.texcoord1;
	r0.xyz = r0.w * r0.xyz;
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
