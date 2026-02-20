sampler2D bloomTexture : register( s3 );
sampler2D colourTexture : register( s0 );
sampler2D filmGrainTexture : register( s5 );
float4x4 g_mColour : register( c2 );
float4 g_vFilmGrain : register( c6 );
float4 g_vSettings1 : register( c0 );
float4 g_vSettings2 : register( c1 );
float4 g_vSpecialFX : register( c7 );
sampler2D lensEffectsTexture : register( s7 );
sampler3D lookupTexture : register( s8 );
sampler2D motionBlurTexture : register( s6 );
sampler2D reducedAlphaTexture : register( s9 );

#include "./common.hlsl"

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	r0 = tex2D(colourTexture, texcoord);
	r1.xy = -0.5 + texcoord.xy;
	r0.w = dot(r1.x, r1.x) + 0;
	r1.xy = r0.w * g_vSpecialFX.yx;
	r2 = tex2D(motionBlurTexture, texcoord);
	r0.w = max(r2.w, r1.x);
	r1.xzw = lerp(r0.xyy, r2.xyy, r0.w);
	r0 = tex2D(reducedAlphaTexture, texcoord);
	r0.xyz = r1.xzw * r0.w + r0.xyz;
	r2 = tex2D(lensEffectsTexture, texcoord);
	r0.xyz = r0.xyz * r2.w + r2.xyz;
	r2 = tex2D(bloomTexture, texcoord);
	r1.xzw = r2.xyy * r2.xyy;
	r0.xyz = r0.xyz * r0.xyz + r1.xzw;
	r2.x = log2(r0.x);
	r2.y = log2(r0.y);
	r2.z = log2(r0.z);
	r0.xyz = r2.xyz * g_vSettings1.y;
	r2.x = exp2(r0.x);
	r2.y = exp2(r0.y);
	r2.z = exp2(r0.z);
	r0.xyz = r2.xyz * 0.96875 + 0.015625;
	r0.w = 0;
	r0 = tex3Dlod(lookupTexture, r0);
	r1.xzw = r0.y * g_mColour[1].xyy;
	r0.xyw = r0.x * g_mColour[0].xyz + r1.xzz;
	r0.xyz = r0.z * g_mColour[2].xyz + r0.xyw;
	r0.xyz = r0.xyz + g_mColour[3].xyz;
	r0.w = dot(r0.xyz, g_vFilmGrain.xyz);
	r0.w = -r0.w + g_vFilmGrain.w;
	r1.xzw = r0.xyy * r0.w + g_vSettings2.z;
	r2.xy = g_vSettings2.xy;
	r2.xy = texcoord.xy * r2.xy + g_vSpecialFX.z;
	r2 = tex2D(filmGrainTexture, r2);
	r2.xyz = r2.xyz + -0.5;
	r0.xyz = r2.xyz * r1.xzw + r0.xyz;
	r0.w = dot(r0.xyz, float3(0.195, 0.3835, 0.0715));
	r0.w = -r0.w * r1.y + r1.y;
	r0.w = r0.w + 1;
	o.xyz = r0.w * r0.xyz;
	o.w = 1;

	return o;
}
