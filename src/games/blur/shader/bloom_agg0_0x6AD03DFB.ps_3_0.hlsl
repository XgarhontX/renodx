sampler2D colourTexture : register( s0 );
float4 g_vSettings2 : register( c15 );
sampler2D lookupTexture : register( s1 );

#include "../shared.h"

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	r0 = tex2D(colourTexture, texcoord);
	r0 = max(0, r0); //safe

	r0.xyz *= EXPOSURE_REVERSAL;
  r0.xyz = pow(r0.xyz, C_BLOOM_POW);
  r0.xyz *= C_BLOOM_STRENGTH * 0.75;

	r0.w = -r0.w + 1;
	r1.x = dot(r0.xyz, g_vSettings2.yzw);
	r1.x = 1 / r1.x;
	r0.w = r0.w * r1.x;
	r1.x = max(1, r0.w);
	r0.xyz = r0.xyz * r1.x;
	r0.w = dot(r0.xyz, float3(0.3, 0.59, 0.11));
	r1.x = r0.w * 0.99609375 + 0.001953125;
	r1.y = 0.5;
	r1 = tex2D(lookupTexture, r1);

	r0.xyz = r0.xyz * r1.x;
	r0.xyz = r0.xyz * g_vSettings2.x;
	
  // r0.xyz = rcp(sqrt(r0.xyz));
	// o.xyz = r0.xyz;

	// r0.x = 1 / sqrt(r0.x);
	// o.x = 1 / r0.x;
	// r0.x = 1 / sqrt(r0.y);
	// r0.y = 1 / sqrt(r0.z);
	// o.z = 1 / r0.y;
	// o.y = 1 / r0.x;

	r0.x = 1 / sqrt(r0.x);
	o.x = 1 / r0.x;

	r0.y = 1 / sqrt(r0.y);
	o.y = 1 / r0.y;

	r0.z = 1 / sqrt(r0.z);
	o.z = 1 / r0.z;

	o.xyz = max(0.0000001, o.xyz);
	o.w = 1;
	return o;
}
