sampler2D ColorCurvesKTexture : register( s1 );
sampler2D ColorCurvesMTexture : register( s2 );
sampler2D ExposureTexture : register( s3 );
float4 GammaColorScaleAndInverse : register( c5 );
float4 GammaOverlayColor : register( c6 );
sampler2D SceneColorTexture : register( s0 );
float4 SceneInverseHighLights : register( c2 );
float4 SceneMidTones : register( c3 );
float4 SceneScaledLuminanceWeights : register( c4 );
float4 SceneShadowsAndDesaturation : register( c0 );

#include "./common.hlsl"
#include "./reinhard1.hlsl"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// float3 GammaAndLut(float3 color, float gammaInv) {
//   float4 r0;
//   float4 r1;
//   float4 o;
// 
//   r1.w = SceneShadowsAndDesaturation.w;
//   r0.xyz = color;
// 
//   //clamp before gamma
// 	r0.xyz = max(r0.xyz, 0); //clean
//   if (TONE_MAP_TYPE > 0)
// 	{
//     float l = max(r0.x, max(r0.y, r0.z));
//     if (l > 1) r1.xyz = r0.xyz * (1 / l);
// 	} else {
// 		r1.xyz = saturate(r0.xyz); //orig clamp
// 	}
// 
//   // gamma encode
// 	r0.xyz = pow(r1.xyz, gammaInv); //in-game brightness slider, usually ~1/2.0
// 
//   //curves LUTs
//   float3 colorTBeforeLut = r0.xyz;
// 	#if 1
//     const float padHigh = (15.f / 16.f);
// 
// 		r1 = tex2D(ColorCurvesKTexture, float2(r0.x * padHigh, 0));
// 		o.x = r0.x * r1.x + r1.y;
// 		r1 = tex2D(ColorCurvesKTexture, float2(r0.y * padHigh, 0));
// 		o.y = r0.y * r1.z + r1.w;
// 
// 		r1 = tex2D(ColorCurvesMTexture, float2(r0.z * padHigh, 0));
// 		o.z = r0.z * r1.x + r1.y;
// 
//     // return o; // debug
// 	#else
// 		// debug
// 		o.xyz = r0.xyz;
// 	#endif
//   o.xyz = lerp(colorTBeforeLut, o.xyz, VCG_LUT); //strength
// 
//   return o.xyz;
// }


float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;
	o.w = 1;

	float4 r0;
	float4 r1;
	float4 r2;

	//exposure
	r0 = tex2D(ExposureTexture, 0.5);
	r0.x = r0.x * 64 * VCG_EXPOSURE;

	//color
	r1 = tex2D(SceneColorTexture, texcoord);
  r0.xyz = r0.x * r1.xyz;  //scaled exposure
  r0.xyz = max(r0.xyz, 0); //clean

  float3 colorU = r0.xyz;
  // r0.xyz = saturate(r0.xyz); //orig clamp
  // return renodx::color::srgb::Encode(r0); //debug

  // colorU blowout
  if (TONE_MAP_TYPE == 2)
  {
    //custom perchannel blownout color from near SDR tonemap
    float3 colorUBlow;
    {
      const float sdrMax = PBLOW_MAX; //(arbitrary, just if it look nice!)
      const float sdrStart = PBLOW_START;
      if (sdrMax >= sdrStart) colorUBlow = renodx::tonemap::ReinhardPiecewise(colorU, sdrMax, sdrStart);
      else colorUBlow = min(colorU, sdrStart);
    }

    //to UCS
    float4 colorUUcsy = renodx::color::ictcp::from::BT709WithY(colorU);
    colorU = colorUUcsy.xyz;
    colorUBlow = renodx::color::ictcp::from::BT709(colorUBlow);

    //hue and chrominance
    colorU = RestoreHueAndChrominance(colorU, colorUBlow, PBLOW_CHUE, PBLOW_CSAT, 0, PBLOW_SATBOOST);

    //dechroma (from RenoDRT)
    if (PBLOW_GUARANTEED > 0) {
      float bc = lerp(1.f, 0.f, saturate(pow(colorUUcsy.w / (4000.f / PBLOW_GUARANTEED / 100.f), 0.9999)));
      colorU.yz *= bc;
    }

    //to BT709
    colorU = renodx::color::bt709::from::ICtCp(colorU);
    r0.xyz = colorU;
  }

	//color neutral
	float3 colorN = r0.xyz;
	if (TONE_MAP_TYPE > 0)
  {
    float l = max(colorN.x, max(colorN.y, colorN.z));
    // float l = renodx::color::y::from::BT709(colorN);
    if (l > 0) {
			float l1 = l;
    	if (VCG_COLORNWC > 1) l1 = renodx::tonemap1::ReinhardPiecewiseExtended(l1, VCG_COLORNWC, 1, 0.18);
    	l1 = min(l1, 1);
			colorN.xyz *= l1 / l;

      // {
      //   float m = max(colorN.x, max(colorN.y, colorN.z));
      //   if (m>1) colorN *= 1 / m;
      // }
		}
  	r0.xyz = colorN;
  }
  // return float4(renodx::color::srgb::Encode(colorN), 1); //debug

  //////////////////////////////////////////////////////////////////////////////////////

	//SceneShadowsAndDesaturation
	r1 = SceneShadowsAndDesaturation;
  // return float4(renodx::color::srgb::Encode(SceneInverseHighLights.xyz), 1); //debug
  #if 1 
	  r0.xyz = r0.xyz * SceneInverseHighLights.xyz + -r1.xyz; //SceneInverseHighLights.xyz usually 1
	  r1.xyz = max(abs(r0.xyz), 0);
  #else
    r1.xyz = r0.xyz;
  #endif

  //SceneMidTones
  // if ((max(max(SceneMidTones.x, SceneMidTones.y), SceneMidTones.z)) == 1) return float4(1,0,0,1); //debug
	#if 1 
		r1.xyz = pow(r1.xyz, SceneMidTones.xyz); ///has a gamma like effect, but is each channel is diff
	#else
		r0.xyz = r1.xyz; // debug
	#endif
  // return renodx::color::srgb::Encode(r1); //debug

  //Overlay
	#if 1 
  	r0.x = dot(r1.xyz, SceneScaledLuminanceWeights.xyz); //SceneScaledLuminanceWeights can be 0
		r0.yzw = r1.xyz * r1.w + GammaOverlayColor.xyz; //tint, like on damage
		r0.xyz = r0.x + r0.yzw;
	#else
		r0.xyz = r1.xyz; // debug
	#endif

  //other strength
  r0.xyz = lerp(colorN, r0.xyz, VCG_OTHER);
  // return float4(renodx::color::srgb::Encode(r0.xyz), 1); //debug

  //GammaColorScaleAndInverse
	r0.xyz = r0.xyz * GammaColorScaleAndInverse.xyz; //usually 1
	// r0.xyz = saturate(r0.xyz); //orig clamp
  // return float4(renodx::color::srgb::Encode(GammaColorScaleAndInverse.xyz), 1); //debug
  // return float4(renodx::color::srgb::Encode(GammaColorScaleAndInverse.www), 1); //debug

  //set
  r1.xyz = r0.xyz;

	//clamp 0 before gamma
	r1.xyz = max(r1.xyz, 0); //clean

  //clamp 1 before gamma
  if (TONE_MAP_TYPE > 0)
	{
    float l = max(r1.x, max(r1.y, r1.z));
    if (l > 1) r1.xyz = r1.xyz * (1 / l);
	} else {
		r1.xyz = min(r1.xyz, 1); //orig clamp
	}
  // return float4(renodx::color::srgb::Encode(r1.xyz), 1); //debug

  //gamma encode
  const float gammaInv = GammaColorScaleAndInverse.w;
	r0.xyz = pow(r1.xyz, gammaInv); //in-game brightness slider, usually ~1/2.0

  //curves LUTs
  float3 colorTBeforeLut = r0.xyz;
	#if 1
    const float padHigh = (15.f / 16.f);

		r1 = tex2D(ColorCurvesKTexture, float2(r0.x * padHigh, 0));
		o.x = r0.x * r1.x + r1.y;
		r1 = tex2D(ColorCurvesKTexture, float2(r0.y * padHigh, 0));
		o.y = r0.y * r1.z + r1.w;

		r1 = tex2D(ColorCurvesMTexture, float2(r0.z * padHigh, 0));
		o.z = r0.z * r1.x + r1.y;

    // return o; // debug
	#else
		// debug
		o.xyz = r0.xyz;
	#endif
  o.xyz = lerp(colorTBeforeLut, o.xyz, VCG_LUT); //strength

  //RETURN: SDR
  if (TONE_MAP_TYPE == 0) {
		o.xyz = saturate(o.xyz); //orig clamp
		o.xyz = renodx::color::srgb::Decode(o.xyz); 
		o.xyz *= DIFFUSE_WHITE_NITS / GRAPHICS_WHITE_NITS;
		o.xyz = renodx::color::srgb::Encode(o.xyz); 
		return o;
	}

  //////////////////////////////////////////////////////////////////////////////////////

	//Upgrade
  const float gamma = 1/gammaInv;
	o.xyz = max(o.xyz, 0);
	o.xyz = renodx::color::gamma::Decode(o.xyz, gamma); //gamma gives more warmth
  o.xyz = UpgradeToneMap1(colorU, colorN, o.xyz, 1);

  //2.2 to sRGB
  float3 oBack = o.xyz;
  o.xyz = renodx::color::correct::Gamma(o.xyz, true, gamma);
  o.xyz = lerp(oBack, o.xyz, VCG_LUT);

	// user color grade
  {
    float l = renodx::color::y::from::BT709(o.xyz);
    if (l > 0) {
      float l1 = l;
      float mg = 0.36 * CG_MIDDLE;
			l1 = renodx::color::grade::Contrast(l1, CG_CONTRAST, mg);
			l1 = renodx::color::grade::Shadows(l1, CG_SHADOWS, mg);
			l1 = renodx::color::grade::Highlights(l1, CG_HIGHLIGHTS /* * 1.05 */, mg); //highlights junky
			o.xyz *= l1 / l;
		}
	}

  // HDR Tonemap
	if (TONE_MAP_TYPE >= 2)
  {
    const float p = PEAK_WHITE_NITS / DIFFUSE_WHITE_NITS;
    const float e = EXPECTED_WHITE_NITS / DIFFUSE_WHITE_NITS;
    o.xyz = renodx::tonemap::HermiteSplineLuminanceRolloff(o.xyz, p, e);
	}

  //Fake WCG
	o.xyz = FakeWCGBT709(o.xyz, FAKEWCGCORRECT_GAMMA, FAKEWCGCORRECT_CHROMA, FAKEWCGCORRECT_LUMA, FAKEWCGCORRECT_SAT);

	//Intermediate
  o.xyz *= DIFFUSE_WHITE_NITS / GRAPHICS_WHITE_NITS;
  o.xyz = renodx::color::srgb::EncodeSafe(o.xyz);

	return o;
}


/*
    ps_3_0
      0x00000220:     def c1, 0.5, 64, 9.99999975e-005, 0.9375
      0x00000238:     def c7, 0, 1, 0, 0
      0x00000250:     dcl_texcoord v0.xy
      0x0000025C:     dcl_2d s0
      0x00000268:     dcl_2d s1
      0x00000274:     dcl_2d s2
      0x00000280:     dcl_2d s3
   0  0x0000028C:     texld r0, c1.x, s3
   0  0x0000029C:     mul_pp r0.x, r0.x, c1.y
   1  0x000002AC:     texld_pp r1, v0, s0
   1  0x000002BC:     mul_sat_pp r0.xyz, r0.x, r1
   2  0x000002CC:     mov r1, c0
   3  0x000002D8:     mad r0.xyz, r0, c2, -r1
   4  0x000002EC:     max r1.xyz, r0_abs, c1.z
   5  0x000002FC:     log r0.x, r1.x
   6  0x00000308:     log r0.y, r1.y
   7  0x00000314:     log r0.z, r1.z
   8  0x00000320:     mul r0.xyz, r0, c3
   9  0x00000330:     exp_pp r1.x, r0.x
  10  0x0000033C:     exp_pp r1.y, r0.y
  11  0x00000348:     exp_pp r1.z, r0.z

  12  0x00000354:     dp3_pp r0.x, r1, c4
  13  0x00000364:     mad r0.yzw, r1.xxyz, r1.w, c6.xxyz
  14  0x00000378:     add_pp r0.xyz, r0.x, r0.yzww
  15  0x00000388:     mul_sat r0.xyz, r0, c5
  16  0x00000398:     max r1.xyz, r0, c1.z
  17  0x000003A8:     log r0.x, r1.x
  18  0x000003B4:     log r0.y, r1.y
  19  0x000003C0:     log r0.z, r1.z
  20  0x000003CC:     mul r0.xyz, r0, c5.w
  21  0x000003DC:     exp r0.x, r0.x
  22  0x000003E8:     mul_sat r1.x, r0.x, c1.w
  23  0x000003F8:     mov r1.y, c7.x
  24  0x00000404:     texld r1, r1, s1
  24  0x00000414:     mad oC0.x, r0.x, r1.x, r1.y
  25  0x00000428:     exp r0.x, r0.y
  26  0x00000434:     exp r0.y, r0.z
  27  0x00000440:     mul_sat r0.z, r0.x, c1.w
  28  0x00000450:     mov r0.w, c7.x
  29  0x0000045C:     texld r1, r0.zwzw, s1
  29  0x0000046C:     mad oC0.y, r0.x, r1.z, r1.w
  30  0x00000480:     mul_sat r0.x, r0.y, c1.w
  31  0x00000490:     mov r0.z, c7.x
  32  0x0000049C:     texld r1, r0.xzzw, s2
  32  0x000004AC:     mad oC0.z, r0.y, r1.x, r1.y
  33  0x000004C0:     mov oC0.w, c7.y

// approximately 39 instruction slots used (5 texture, 34 arithmetic)

*/