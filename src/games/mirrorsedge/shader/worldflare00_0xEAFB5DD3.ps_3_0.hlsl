sampler2D Texture2D_0 : register( s0 );
float4 UniformVector_0 : register( c0 );

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord4 : TEXCOORD4;
};

#include "./common.hlsl"

float4 main(PS_IN i) : COLOR
{
	float4 o;
	o.w = 0;


  float4 r0;
	r0 = tex2D(Texture2D_0, i.texcoord);

	r0.xyz = r0.xyz + float3(-1, -1, -0.75);
	r0.w = r0.w * i.texcoord1.w * 1.25;
	r0.xyz = r0.w * r0.xyz + float3(1, 1, 0.75);

	r0.xyz = r0.w * r0.xyz + UniformVector_0.xyz;
	r0.xyz = r0.xyz * i.texcoord4.w * 1.25;
	o.xyz = r0.w * r0.xyz;

	if (TONE_MAP_TYPE == 0) return o; // skip sunpass for non-HDR

	o.xyz *= 1.15;
		
	float3 colorCenter = tex2D(Texture2D_0, (float2)0.5f).xyz;
	float l = length(i.texcoord - float2(0.5, 0.5));
  l = l + 0.5;
  l = 1 - l;
  l = saturate(l * 2);
	// o.xyz = l; return o;
  l = pow(l, 3.75);

	o.xyz *= l;

  o.xyz += colorCenter * l * C_WORLDFLARE_ADDBLUR * 0.35;

  o.xyz *= C_WORLDFLARE * 1.15;

	return o;
}
