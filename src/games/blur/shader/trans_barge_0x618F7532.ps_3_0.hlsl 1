sampler2D DepthBufferSampler : register( s13 );
sampler2D TextureSampler : register( s0 );
float g_fNegativeFactor : register( c16 );
float4 g_vDepthScale : register( c65 );

struct PS_IN
{
	float4 texcoord1 : TEXCOORD1;
	float2 texcoord : TEXCOORD;
	float4 texcoord4 : TEXCOORD4;
};

#include "../shared.h"

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float r2;

	r0.x = 1 / i.texcoord4.w;
	r0.yz = r0.x * i.texcoord4.xy;
	r0.x = saturate(r0.x * i.texcoord4.z);
	r0.x = -r0.x + 1;

	r1 = tex2D(DepthBufferSampler, r0.yz);
	r0.y = abs(r1.x) + -g_vDepthScale.x;
	r0.y = 1 / r0.y;
	r0.y = saturate(g_vDepthScale.y * r0.y + -i.texcoord4.w);
	r0.x = r0.x * r0.y;

	r1 = tex2D(TextureSampler, i.texcoord);
	r1 = r1.xxxz * i.texcoord1;
	r1.xyz = r1.w * r1.xyz;
	r0 = r0.x * r1;
	o.xyz = max(r0.xyz, 0) / EXPOSURE_REVERSAL;

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
