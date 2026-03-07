sampler2D AlbedoSampler : register( s0 );
sampler2D DetailAlbedoSampler : register( s2 );
sampler2D LightmapSampler : register( s9 );
float4 g_vLuminance : register( c48 );

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float2 texcoord5 : TEXCOORD5;
	float4 color : COLOR;
};

#include "../shared.h"

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float3 r3;
	r0 = tex2D(LightmapSampler, i.texcoord.zw);
	r0.xyz = r0.w * r0.xyz;
	r0.xyz = r0.xyz * r0.xyz;
	r1 = tex2D(DetailAlbedoSampler, i.texcoord5);
	r0.w = r1.w * i.color.w;
	r2 = tex2D(AlbedoSampler, i.texcoord) ;
	r3.xyz = lerp(r2.xyz, r1.xyz, r0.w);
	o.w = r2.w;
	r0.xyz = r0.xyz * r3.xyz;
	r0.xyz = r0.xyz * g_vLuminance.x;
	r0.x = 1 / sqrt(r0.x);
	o.x = 1 / r0.x;
	r0.x = 1 / sqrt(r0.y);
	r0.y = 1 / sqrt(r0.z);
	o.z = 1 / r0.y;
	o.y = 1 / r0.x;

  o.xyz /= EXPOSURE_REVERSAL;

	return o;
}
