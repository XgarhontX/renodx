sampler2D adaptedLumTexture : register( s1 );
sampler2D currentLumTexture : register( s0 );
float4 g_vSettings : register( c0 );

#include "../shared.h"

float4 main() : COLOR
{
	float4 o;

	float2 r0;
	float4 r1;
	float4 r2;

	r0.y = -0.87439036 /* -0.1 */;
	r0.x = r0.y * g_vSettings.x;
	r0.x = exp2(r0.x);
	r0.x = -r0.x + 1;

  r1 = tex2D(currentLumTexture, 0.5);
  // r1.x /= EXPOSURE_FINAL_FUDGE;
  // float curr = r1.x;

	r2 = tex2D(adaptedLumTexture, 0.5);
  // r1.x /= EXPOSURE_FINAL_FUDGE;

	// r0.y = r1.x + -r2.x;
  // o.x = r0.y * r0.x + r2.x;
  o.x = (r1.x + -r2.x) * r0.x + r2.x;
  o.x *= EXPOSURE_FINAL_FUDGE;

	o.yzw = float3(0.5, 0, 0);
	return o;
}
