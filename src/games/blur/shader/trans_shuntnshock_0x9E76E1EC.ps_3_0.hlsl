sampler2D TextureSampler : register( s0 );
sampler2D UVDistortTextureSampler : register( s1 );
float gUvDistort : register( c80 );
float g_fNegativeFactor : register( c16 );
float g_vScrollTextureX : register( c69 );
float g_vScrollTextureY : register( c70 );

struct PS_IN
{
	float4 texcoord1 : TEXCOORD1;
	float2 texcoord : TEXCOORD;
	float2 texcoord5 : TEXCOORD5;
};

#include "../shared.h"

//TODO: verify, 80% confident
float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float2 r1;
	float2 r2;

	r0 = tex2D(UVDistortTextureSampler, i.texcoord5);
	r0.xy = r0.yw + -0.5;
	r1.y = 2;
	r2.x = r0.x * r1.y + g_vScrollTextureX.x;
	r2.y = r0.y * r1.y + g_vScrollTextureY.x;
	r0.xy = r2.xy * gUvDistort.x + i.texcoord.xy;

	r0 = tex2D(TextureSampler, r0.xy); //x only, w = 1
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
	r0.x = -r0.x;
	o.w = max(r0.x, r0.w);

	return o;
}
