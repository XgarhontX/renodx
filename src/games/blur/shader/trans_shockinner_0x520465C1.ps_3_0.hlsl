sampler2D TextureSampler : register( s0 );
sampler2D TextureSampler2L : register( s2 );
sampler2D UVDistortTextureSampler : register( s1 );
sampler2D UVDistortTextureSampler2L : register( s3 );
float gUvDistort : register( c80 );
float g_2L_UvDistort : register( c90 );
float g_2L_vScrollTextureX : register( c84 );
float g_2L_vScrollTextureY : register( c85 );
float g_fNegativeFactor : register( c16 );
float g_vScrollTextureX : register( c69 );
float g_vScrollTextureY : register( c70 );

struct PS_IN
{
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord : TEXCOORD;
	float4 texcoord5 : TEXCOORD5;
};

#include "../shared.h"

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;

	r0 = tex2D(UVDistortTextureSampler2L, i.texcoord5.zw);
	r0.xy = r0.yw + -0.5;
	r1.y = 2;
	r2.x = r0.x * r1.y + g_2L_vScrollTextureX.x;
	r2.y = r0.y * r1.y + g_2L_vScrollTextureY.x;
	r0.xy = r2.xy * g_2L_UvDistort.x + i.texcoord.zw;
	
	r0 = tex2D(TextureSampler2L, r0);
	r0 = r0.xxxz * i.texcoord2;
	r0.xyz = r0.w * r0.xyz;

	r2 = tex2D(UVDistortTextureSampler, i.texcoord5);
	r1.xz = r2.yw + -0.5;
	r2.x = r1.x * r1.y + g_vScrollTextureX.x;
	r2.y = r1.z * r1.y + g_vScrollTextureY.x;
	r1.xy = r2.xy * gUvDistort.x + i.texcoord.xy;

	r1 = tex2D(TextureSampler, r1);
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
