struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
};

#include "../shared.h"

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float2 r0;
	float r1;
	r0.xy = i.texcoord.xy * 2 + -1;
	r0.xy = abs(r0.xy);
	r0.x = dot(r0.xy, -r0.xy) + 1;
	r1.x = max(r0.x, 0);
	r0.x = r1.x * r1.x;
	r0.y = r0.x * r0.x;
	r0.x = r0.y * r0.x;
	r0.y = r0.x * r0.x;
	o.w = (-r0.x >= 0) ? 0 : 0.003921569;
	o.xyz = r0.y * i.texcoord1.xyz;
	o.xyz /= EXPOSURE_REVERSAL;

	return o;
}
