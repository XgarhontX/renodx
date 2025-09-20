#include "./common.hlsl"

sampler2D ColorCurvesKTexture : register(s1);
sampler2D ColorCurvesMTexture : register(s2);
sampler2D ExposureTexture : register(s3);
float4 GammaColorScaleAndInverse : register(c5);
float4 GammaOverlayColor : register(c6);
sampler2D SceneColorTexture : register(s0);
float4 SceneInverseHighLights : register(c2);
float4 SceneMidTones : register(c3);
float4 SceneScaledLuminanceWeights : register(c4);
float4 SceneShadowsAndDesaturation : register(c0);

float4 main(float2 texcoord: TEXCOORD) : COLOR {
  float4 o;

  float4 r0;
  float4 r1;

  float3 colorUntonemapped, colorTonemapped, colorSDRNeutral;

  r0 = tex2D(ExposureTexture, 0.5);
  float exposure = r0.x;
  r0.x *= 64;
  r1 = tex2D(SceneColorTexture, texcoord);
  r0.xyz = r0.x * r1.xyz;
  colorUntonemapped = r0.xyz;

  r1 = SceneShadowsAndDesaturation;
  r0.xyz = r0.xyz * SceneInverseHighLights.xyz + -r1.xyz;
  r1.xyz = max(abs(r0.xyz), 9.99999975e-005);

  r0.x = log2(r1.x);
  r0.y = log2(r1.y);
  r0.z = log2(r1.z);
  // r0.xyz = log2(r1.xyz);

  r0.xyz = r0.xyz * SceneMidTones.xyz;

  r1.x = exp2(r0.x);
  r1.y = exp2(r0.y);
  r1.z = exp2(r0.z);
  // r1.xyz = log2(r0.xyz);

  r0.x = dot(r1.xyz, SceneScaledLuminanceWeights.xyz);
  r0.yzw = r1.xyz * r1.w + GammaOverlayColor.xyz;
  r0.xyz = r0.x + r0.yzw;
  r0.xyz = r0.xyz * GammaColorScaleAndInverse.xyz;

  r1.xyz = max(r0.xyz, 0.0001);
  // r1.x = max(r0.x, 0.0001);
  // r1.y = max(r0.y, 0.0001);
  // r1.z = max(r0.z, 0.0001);

  // r0.x = log2(r1.x);
  // r0.y = log2(r1.y);
  // r0.z = log2(r1.z);
  r0.xyz = log2(r1.xyz);

  r0.xyz = r0.xyz * GammaColorScaleAndInverse.w;
  r0.x = exp2(r0.x);
  r1.x = r0.x * 0.9375;
  r1.y = 0;
  r1 = tex2D(ColorCurvesKTexture, r1);
  o.x = r0.x * r1.x + r1.y;

  r0.x = exp2(r0.y);
  r0.y = exp2(r0.z);
  r0.z = r0.x * 0.9375;
  r0.w = 0;
  r1 = tex2D(ColorCurvesKTexture, r0.zwzw);
  o.y = r0.x * r1.z + r1.w;

  r0.x = r0.y * 0.9375;
  r0.z = 0;
  r1 = tex2D(ColorCurvesMTexture, r0.xzzw);
  o.z = r0.y * r1.x + r1.y;

  o.w = 1;

  colorTonemapped = o.xyz;
  o.xyz = Tonemap_Do(colorUntonemapped, colorTonemapped, exposure, SceneColorTexture, texcoord);

  // o.xyz = renodx::draw::RenderIntermediatePass(o.xyz);

  return o;
}

//     0x00000220:     def c1, 0.5, 64, 9.99999975e-005, 0.9375
//     0x00000238:     def c7, 0, 1, 0, 0
//     0x00000250:     dcl_texcoord v0.xy
//     0x0000025C:     dcl_2d s0
//     0x00000268:     dcl_2d s1
//     0x00000274:     dcl_2d s2
//     0x00000280:     dcl_2d s3
//  0  0x0000028C:     texld r0, c1.x, s3
//  0  0x0000029C:     mul_pp r0.x, r0.x, c1.y
//  1  0x000002AC:     texld_pp r1, v0, s0
//  1  0x000002BC:     mul_sat_pp r0.xyz, r0.x, r1
//  2  0x000002CC:     mov r1, c0
//  3  0x000002D8:     mad r0.xyz, r0, c2, -r1
//  4  0x000002EC:     max r1.xyz, r0_abs, c1.z
//  5  0x000002FC:     log r0.x, r1.x
//  6  0x00000308:     log r0.y, r1.y
//  7  0x00000314:     log r0.z, r1.z
//  8  0x00000320:     mul r0.xyz, r0, c3
//  9  0x00000330:     exp_pp r1.x, r0.x
// 10  0x0000033C:     exp_pp r1.y, r0.y
// 11  0x00000348:     exp_pp r1.z, r0.z
// 12  0x00000354:     dp3_pp r0.x, r1, c4
// 13  0x00000364:     mad r0.yzw, r1.xxyz, r1.w, c6.xxyz
// 14  0x00000378:     add_pp r0.xyz, r0.x, r0.yzww
// 15  0x00000388:     mul_sat r0.xyz, r0, c5
// 16  0x00000398:     max r1.xyz, r0, c1.z

// 17  0x000003A8:     log r0.x, r1.x
// 18  0x000003B4:     log r0.y, r1.y
// 19  0x000003C0:     log r0.z, r1.z
// 20  0x000003CC:     mul r0.xyz, r0, c5.w
// 21  0x000003DC:     exp r0.x, r0.x
// 22  0x000003E8:     mul_sat r1.x, r0.x, c1.w
// 23  0x000003F8:     mov r1.y, c7.x
// 24  0x00000404:     texld r1, r1, s1
// 24  0x00000414:     mad oC0.x, r0.x, r1.x, r1.y
// 25  0x00000428:     exp r0.x, r0.y
// 26  0x00000434:     exp r0.y, r0.z
// 27  0x00000440:     mul_sat r0.z, r0.x, c1.w
// 28  0x00000450:     mov r0.w, c7.x
// 29  0x0000045C:     texld r1, r0.zwzw, s1
// 29  0x0000046C:     mad oC0.y, r0.x, r1.z, r1.w
// 30  0x00000480:     mul_sat r0.x, r0.y, c1.w
// 31  0x00000490:     mov r0.z, c7.x
// 32  0x0000049C:     texld r1, r0.xzzw, s2
// 32  0x000004AC:     mad oC0.z, r0.y, r1.x, r1.y
// 33  0x000004C0:     mov oC0.w, c7.y