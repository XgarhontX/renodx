sampler2D g_tFlare : register( s0 );

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
	
  r0 = tex2D(g_tFlare, i.texcoord);
  r0.xyz = max(0, r0.xyz);

  r0.xyz = /* saturate */(r0.xyz /* / EXPOSURE_REVERSAL */ * 1.46);
  r0.w = min(r0.w * 1.46, 1);


  float3 flarething = i.texcoord1;
	// flarething = max(0, flarething);
	// flarething = saturate(flarething);

  {
    float y = max(flarething.x, max(flarething.y, flarething.z));
    if (y > 0) {
      // float y1 = renodx::tonemap::ReinhardPiecewise(y, 1.0, 0.3);
      float y1 = saturate(y);
      flarething *= y1 / y;
    }
  }
	
	r0.xyz = r0.xyz * flarething;

  // {
  //   float y = max(r0.x, max(r0.y, r0.z));
  //   if (y > 0) {
  //     // float y1 = renodx::tonemap::ReinhardPiecewise(y, 1., 0.3);
  //     float y1 = min(y, 1);
  //     r0.xyz *= y1 / y;
  //   }
  // }

	o.xyz = r0.w * r0.xyz;
	o.w = 0;

	return o;
}

/*

    ps_3_0
      0x00000090:     def c0, 0, 0, 0, 0
      0x000000A8:     dcl_texcoord v0.xy
      0x000000B4:     dcl_texcoord1 v1.xyz
      0x000000C0:     dcl_2d s0
   0  0x000000CC:     texld r0, v0, s0
   0  0x000000DC:     mul r0.xyz, r0, v1
   1  0x000000EC:     mul oC0.xyz, r0.w, r0
   2  0x000000FC:     mov oC0.w, c0.x

*/