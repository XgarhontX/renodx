sampler2D AlbedoSampler : register( s0 );
sampler2D LightmapSampler : register( s9 );
float4 g_vLuminance : register( c48 );


#include "../shared.h"

float4 main(float4 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	r0 = tex2D(LightmapSampler, texcoord.zw);
	r0.xyz = r0.w * r0.xyz;
	r0.xyz = r0.xyz * r0.xyz;
	r1 = tex2D(AlbedoSampler, texcoord);
	r0.xyz = r0.xyz * r1.xyz;
	o.w = r1.w;
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
