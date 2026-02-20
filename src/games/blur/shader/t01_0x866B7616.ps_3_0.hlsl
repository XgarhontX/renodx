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

#include "./common.hlsl"

//main menu
float4 main(float2 texcoord: TEXCOORD) : COLOR
{
	// return tex2D(motionBlurTexture, texcoord);
	// return tex2D(lensEffectsTexture, texcoord);
	// return tex2D(bloomTexture, texcoord);
	
	// return T_Output(tex2D(colourTexture, texcoord) * EXPOSURE_REVERSAL, g_vSettings1, colourTexture) ;

  float4 r0;
	r0 = tex2D(colourTexture, texcoord);

  // EXPOSURE_REVERSAL
  r0.xyz *= EXPOSURE_REVERSAL;

	//lens
	T_Lens(r0, lensEffectsTexture, texcoord);

	//bloom
	T_Bloom(r0, bloomTexture, texcoord);
	
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
