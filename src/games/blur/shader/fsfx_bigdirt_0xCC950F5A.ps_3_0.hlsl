sampler2D g_tSplashTexture : register( s0 );

#include "../shared.h"

float4 main(float3 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	r0 = tex2D(g_tSplashTexture, texcoord);
	r0.w = r0.w / EXPOSURE_REVERSAL * 0.25 * texcoord.z; //reduce
	o.xyz = r0.w * r0.xyz;
	o.w = r0.w;

	return o;
}
