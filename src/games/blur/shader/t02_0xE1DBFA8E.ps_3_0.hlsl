sampler2D bloomTexture : register( s3 );
sampler2D colourTexture : register( s0 );
sampler2D filmGrainTexture : register( s5 );
float4x4 g_mColour : register( c2 );
float4 g_vColourSep : register( c9 );
float4 g_vFilmGrain : register( c6 );
float4 g_vSettings1 : register( c0 );
float4 g_vSettings2 : register( c1 );
float4 g_vSpecialFX : register( c7 );
sampler2D lensEffectsTexture : register( s7 );
sampler3D lookupTexture : register( s8 );
sampler2D motionBlurTexture : register( s6 );
sampler2D overlayTexture : register( s10 );

#include "./common.hlsl"

//CA dazed
float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;

	// r0 = tex2D(colourTexture, texcoord);

// 	//CA: prep
// 	r1.xy = float2(1, 0);
// 	r0.xz = r1.x * g_vColourSep.zy;
// 
// 	//CA: sample 1
// 	r1.zw = g_vColourSep.x * -r1.xy + texcoord.xy;
// 	r2 = tex2D(colourTexture, r1.zw);
// 
// 	//CA: sample 2
// 	r1.yz = g_vColourSep.x * r1.x + texcoord.x;
// 	r3 = tex2D(colourTexture, r1.yz);
// 	
// 	//CA: combine
// 	if (-r0.x < 0) {
// 		r4 = tex2D(overlayTexture, texcoord); //prob when wrecked window crack overlay
// 		r3.x = r2.x;
// 		r3.y = r0.y;
// 		r3.xyz = r4.xyz * g_vColourSep.z + r3.xyz;
// 	} else {
// 		r3.x = r2.x;
// 		r3.y = r0.y;
// 	}
// 
// 	//CA: grain
// 	r0.xy = float2(0.625, 0.3515625) * texcoord.xy;
// 	r2.xy = g_vColourSep.xy;
// 	r0.xy = r2.yx * float2(7.123, 0) + r0.xy;
// 
// 	r2 = tex2D(filmGrainTexture, r0);
// 	r0.x = g_vColourSep.y * -r1.x + r2.x;
// 	r0.yw = texcoord.x * -0.25 + float2(-0.25, 0.625);
// 
// 	//CA: final
// 	r1 = tex2D(colourTexture, r0.yw);
// 	r0.xyw = (r0.x >= 0) ? r3.xyz : r1.xyz;
// 	r0.xyz = (-r0.z >= 0) ? r3.xyz : r0.xyw;

	float2 texCoordJitter = texcoord;
  float multiplier = T_ChromaticAberrationAndOverlay(r0, g_vColourSep, colourTexture, overlayTexture, filmGrainTexture, texCoordJitter);

  // EXPOSURE_REVERSAL
  r0.xyz *= EXPOSURE_REVERSAL;

	// //vignette (bruh)
	// r1.xy = -0.5 + texcoord.xy;
	// r0.w = dot(r1.x, r1.x) + 0;
	// r1.xy = r0.w * g_vSpecialFX.yx;

	//motion blur
	// r2 = tex2D(motionBlurTexture, texcoord);
	// r0.w = max(r2.w, r1.x);
	// r1.xzw = lerp(r0.xyy, r2.xyy, r0.w);
	T_MotionBlur(r0, motionBlurTexture, texCoordJitter);

	//lens effects
	// r0 = tex2D(lensEffectsTexture, texcoord);
	// r0.xyz = r1.xzw * r0.w + r0.xyz;
	T_Lens(r0, lensEffectsTexture, texCoordJitter);

	//bloom
	// r2 = tex2D(bloomTexture, texcoord);
	// r1.xzw = r2.xyy * r2.xyy;
	// r0.xyz = r0.xyz * r0.xyz + r1.xzw;
	T_Bloom(r0, bloomTexture, texCoordJitter);

	//lut & gamma
	// r2.x = log2(r0.x);
	// r2.y = log2(r0.y);
	// r2.z = log2(r0.z);
	// r0.xyz = r2.xyz * g_vSettings1.y;
	// r2.x = exp2(r0.x);
	// r2.y = exp2(r0.y);
	// r2.z = exp2(r0.z);
	// 
	// r0.xyz = r2.xyz * 0.96875 + 0.015625;
	// r0.w = 0;
	// r0 = tex3Dlod(lookupTexture, r0);
	T_LutGamma(r0, lookupTexture, g_vSettings1, g_mColour, texcoord);

	//color tint
	// r1.xzw = r0.y * g_mColour[1].xyy;
	// r0.xyw = r0.x * g_mColour[0].xyz + r1.xzz;
	// r0.xyz = r0.z * g_mColour[2].xyz + r0.xyw;
	// r0.xyz = r0.xyz + g_mColour[3].xyz;
	T_ColorTint(r0, g_mColour);

	r0.xyz *= multiplier;

	//film grain

	// r0.w = dot(r0.xyz, g_vFilmGrain.xyz);
	// r2.xy = g_vSettings2.xy;
	// r1.xz = texcoord.xy * r2.xy + g_vSpecialFX.z;
	// r2 = tex2D(filmGrainTexture, r1.xzzw);
	// r1.xzw = r2.xyy + -0.5;
	// r0.w = -r0.w + g_vFilmGrain.w;
	// r2.xyz = r0.xyz * r0.w + g_vSettings2.z;
	// r0.xyz = r1.xzw * r2.xyz + r0.xyz;
	T_FilmGrain(r0, filmGrainTexture, g_vFilmGrain, g_vSettings2, texcoord);

	//vignette
// 	r0.w = dot(r0.xyz, float3(0.195, 0.3835, 0.0715));
// 	r0.w = -r0.w * r1.y + r1.y;
// 	r0.w = r0.w + 1;
// 	r0.xyz = r0.w * r0.xyz;

	T_Vignette(r0, texcoord, g_vSpecialFX);

	//output
  return T_Output(r0, g_vSettings1, colourTexture);
}
