sampler2D ColourSampler : register( s0 );

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
};

#include "../shared.h"

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	r0 = tex2D(ColourSampler, i.texcoord);
  r0.xyz = r0.xyz * i.texcoord1.xyz;
	
  float y = renodx::color::y::from::BT709(r0.xyz);
  if (y > 0 /* && C_CG_SHADOWS_MID > 1. */) {
    // float y1 = renodx::color::grade::Highlights(y, 1.8, 0.12);
    float y1 = renodx::color::grade::Highlights(y, 1.6, 0.5);
		y1 *= 1.2; //boost
    y1 = pow(y1, 1.1);
		// /* float */ y1 = renodx::color::grade::Contrast(y1, 1.2, 0.46);
    r0.xyz *= y1 / y;
	}
	
	o.xyz = r0.w * r0.xyz;
	o.xyz *= EXPOSURE_BILLBOARDS;

	r0.x = (-r0.w >= 0) ? 0 : 1;
	r0.y = (r0.w >= 0) ? -0 : -1;

	r0.x = r0.y + r0.x;
	o.w = r0.x * 0.003921569;

	return o;
}
