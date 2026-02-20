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

#include "./common.hlsl"

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	// return tex2D(motionBlurTexture, texcoord);
	// return tex2D(lensEffectsTexture, texcoord);
	// return tex2D(bloomTexture, texcoord).w;
	// return tex2D(colourTexture, texcoord).w;
	
	// return T_Output(tex2D(colourTexture, texcoord) * EXPOSURE_REVERSAL, g_vSettings1, colourTexture) ;

	//color
	float4 r0;
	r0 = tex2D(colourTexture, texcoord);

	float2 texCoordJitter = texcoord;
  // T_ChromaticAberrationAndOverlay(r0, float4(0,C_MB_BLEND,0,0), colourTexture, filmGrainTexture, filmGrainTexture, texCoordJitter);

  // EXPOSURE_REVERSAL
  r0.xyz *= EXPOSURE_REVERSAL;

	//motion blur
	T_MotionBlur(r0, motionBlurTexture, texCoordJitter);

	//lens effects
	T_Lens(r0, lensEffectsTexture, texCoordJitter);

	//bloom
	T_Bloom(r0, bloomTexture, texCoordJitter);

	//lut & gamma
	T_LutGamma(r0, lookupTexture, g_vSettings1, g_mColour, texcoord);

	//color tint
	T_ColorTint(r0, g_mColour);

	//film grain
	T_FilmGrain(r0, filmGrainTexture, g_vFilmGrain, g_vSettings2, texcoord);

	//vignette
	T_Vignette(r0, texcoord, g_vSpecialFX);

	//output
  return T_Output(r0, g_vSettings1, colourTexture);
}