sampler2D bloomTexture : register( s3 );
sampler2D colourTexture : register( s0 );
sampler2D filmGrainTexture : register( s5 );
float4x4 g_mColour : register( c2 );
float4 g_vBloomScale : register( c8 );
float4 g_vFilmGrain : register( c6 );
float4 g_vSettings1 : register( c0 );
float4 g_vSettings2 : register( c1 );
float4 g_vSpecialFX : register( c7 );
sampler2D lensEffectsTexture : register( s7 );
sampler3D lookupTexture : register( s8 );

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	r0 = tex2D(colourTexture, texcoord);
	r1.xy = -0.5 + texcoord.xy;
	r1.xy = r1.xy * g_vBloomScale.z + -g_vBloomScale.xy;
	r1.zw = r1.xy + 0.5;
	r0.w = dot(r1.x, r1.x) + 0;
	r0.w = r0.w * g_vSpecialFX.x;
	r2 = tex2D(lensEffectsTexture, r1.zwzw);
	r0.xyz = r0.xyz * r2.w + r2.xyz;
	r2 = tex2D(bloomTexture, r1.zwzw);
	r1.xy = g_vSettings2.xy;
	r1.xy = r1.zw * r1.xy + g_vSpecialFX.z;
	r1 = tex2D(filmGrainTexture, r1);
	r1.xyz = r1.xyz + -0.5;
	r2.xyz = r2.xyz * g_vBloomScale.w;
	r2.xyz = r2.xyz * r2.xyz;
	r0.xyz = r0.xyz * r0.xyz + r2.xyz;
	r2.x = log2(r0.x);
	r2.y = log2(r0.y);
	r2.z = log2(r0.z);
	r0.xyz = r2.xyz * g_vSettings1.y;
	r2.x = exp2(r0.x);
	r2.y = exp2(r0.y);
	r2.z = exp2(r0.z);
	r2.xyz = r2.xyz * 0.96875 + 0.015625;
	r2.w = 0;
	r2 = tex3Dlod(lookupTexture, r2);
	r0.xyz = r2.y * g_mColour[1].xyz;
	r0.xyz = r2.x * g_mColour[0].xyz + r0.xyz;
	r0.xyz = r2.z * g_mColour[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + g_mColour[3].xyz;
	r1.w = dot(r0.xyz, g_vFilmGrain.xyz);
	r1.w = -r1.w + g_vFilmGrain.w;
	r2.xyz = r0.xyz * r1.w + g_vSettings2.z;
	r0.xyz = r1.xyz * r2.xyz + r0.xyz;
	r1.x = dot(r0.xyz, float3(0.195, 0.3835, 0.0715));
	r0.w = -r1.x * r0.w + r0.w;
	r0.w = r0.w + 1;
	o.xyz = r0.w * r0.xyz;
	o.w = 1;

	return o;
}
