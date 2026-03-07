sampler2D g_Texture0 : register( s0 );

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

#include "./common.hlsl"

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	r0 = tex2D(g_Texture0, i.texcoord);
	r0 = r0.xyzx * float4(1, 1, 1, 0) + float4(0, 0, 0, 1);
	o = r0 * i.color;

  o = saturate(o);
	o.xyz = renodx::color::srgb::Decode(o.xyz);

  o.xyz = PumboAutoHDR(o.xyz, RENODX_EXPECTED_PEAK_WHITE_NITS, RENODX_DIFFUSE_WHITE_NITS, 3.5);

	o.xyz = max(0, o.xyz);
	o.xyz = renodx::color::srgb::Encode(o.xyz);

	return o;
}
