float4 g_RefractionParams : register( c0 );
sampler2D g_tDistorsionTexture : register( s2 );
sampler2D g_tScreenTexture : register( s1 );
sampler2D g_tSplashTexture : register( s0 );

struct PS_IN
{
	float3 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
};

#include "../shared.h"

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	r0 = tex2D(g_tDistorsionTexture, i.texcoord);
	r0.xy = r0.xy + -0.5;
	r0.xy = r0.xy * g_RefractionParams.y;
	r0.z = 1 / i.texcoord1.w;
	r0.xy = i.texcoord1.xy * r0.z + r0.xy;
	r0 = tex2D(g_tScreenTexture, r0);
	r1 = tex2D(g_tSplashTexture, i.texcoord);
	r0.w = r1.w / EXPOSURE_REVERSAL * 0.25 * i.texcoord.z; //reduce
	r1.xyz = r0.w * r1.xyz;
	r0.xyz = r0.w * r0.xyz;
	o.w = r0.w;
	o.xyz = lerp(r1.xyz, r0.xyz, g_RefractionParams.x);

	return o;
}
