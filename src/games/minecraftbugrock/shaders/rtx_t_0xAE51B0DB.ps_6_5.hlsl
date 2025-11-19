Texture2D<float4> s_RasterColorTexture : register(t0);

Texture2D<float4> s_gBloomBufferTexture : register(t1);

Texture2D<float4> s_gRasterizedInputTexture : register(t2);

Texture2D<float4> s_gToneCurveTexture : register(t3);

cbuffer FragmentUniforms : register(b1) {
  float4 gToneMappingDebugMode : packoffset(c000.x);
  float4 gToneMappingSaturation : packoffset(c001.x);
  float4 gToneMappingShadowContrastEnd : packoffset(c002.x);
  float4 gToneMappingShadowContrast : packoffset(c003.x);
  float4 ScreenSize : packoffset(c004.x);
  float4 gBloomMultiplier : packoffset(c005.x);
  float4 gColorGradingEnabled : packoffset(c006.x);
  float4 gPerformSRGBConversion : packoffset(c007.x);
  float4 gToneMappingColorBalance : packoffset(c008.x);
  float4 gToneMappingContrast : packoffset(c009.x);
  float4 gToneMappingFilmicSaturationCorrection : packoffset(c010.x);
  float4 gToneMappingGamma : packoffset(c011.x);
  float4 gToneMappingIntensity : packoffset(c012.x);
};

SamplerState s_RasterColorSampler : register(s0);

SamplerState s_gBloomBufferSampler : register(s1);

SamplerState s_gRasterizedInputSampler : register(s2);

SamplerState s_gToneCurveSampler : register(s3);

#include "./common.hlsl"

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _12 = s_RasterColorTexture.Sample(s_RasterColorSampler, float2(TEXCOORD.x, TEXCOORD.y)) /* * CUSTOM_BLOOM_MULTIPLIER */;
  float4 _16 = s_gBloomBufferTexture.Sample(s_gBloomBufferSampler, float2(TEXCOORD.x, TEXCOORD.y));
  float _22 = mad(_16.x, gBloomMultiplier.x, _12.x);
  float _23 = mad(_16.y, gBloomMultiplier.x, _12.y);
  float _24 = mad(_16.z, gBloomMultiplier.x, _12.z);

  float3 colorU = float3(_22, _23, _24);

  float _178;
  float _179;
  float _180;
  float _197;
  float _198;
  float _199;
  float _249;
  float _250;
  float _251;
  float _275;
  float _286;
  float _297;
  float _298;
  float _299;

  if (!(gToneMappingIntensity.x == 0.0f)) {
    if (gToneMappingDebugMode.x == 0.0f) {
      float _34 = max(dot(float3(_22, _23, _24), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f)), -24.0f);
      float4 _38 = s_gToneCurveTexture.SampleLevel(s_gToneCurveSampler, float2(((log2(_34) + 24.0f) * 0.0357142873108387f), 0.5f), 0.0f);
      float _40 = exp2(_38.x);
      float _44 = (_40 * _22) / _34;
      float _45 = (_40 * _23) / _34;
      float _46 = (_40 * _24) / _34;
      float _47 = dot(float3(_44, _45, _46), float3(0.3333333432674408f, 0.3333333432674408f, 0.3333333432674408f));
      float _62 = (gToneMappingFilmicSaturationCorrection.x * max(0.0f, (((((1486.4000244140625f - (_47 * 1489.699951171875f)) * _47) + -3.299999952316284f) / ((((_47 * 0.15000000596046448f) + 944.2000122070312f) * _47) + 1.0f)) + -1.0f))) + 1.0f;
      _197 = ((_62 * (_44 - _47)) + _47);
      _198 = ((_62 * (_45 - _47)) + _47);
      _199 = ((_62 * (_46 - _47)) + _47);
    } else {
      if (TEXCOORD.x < 0.25f) {
        float _75 = dot(float3(_22, _23, _24), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
        float _77 = _75 / (_75 + 1.0f);
        float _90 = (exp2(log2(min(1.0f, (exp2(gToneMappingShadowContrastEnd.x * -1.4426950216293335f) * _77))) * gToneMappingShadowContrast.x) * _77) / _75;
        _178 = (_90 * _22);
        _179 = (_90 * _23);
        _180 = (_90 * _24);
      } else {
        if (TEXCOORD.x < 0.5f) {
          float _100 = max(0.0f, (_22 + -0.004000000189989805f));
          float _101 = max(0.0f, (_23 + -0.004000000189989805f));
          float _102 = max(0.0f, (_24 + -0.004000000189989805f));
          float _103 = _100 * 6.199999809265137f;
          float _104 = _101 * 6.199999809265137f;
          float _105 = _102 * 6.199999809265137f;
          float _121 = ((_103 + 0.5f) * _100) / (((_103 + 1.7000000476837158f) * _100) + 0.05999999865889549f);
          float _122 = ((_104 + 0.5f) * _101) / (((_104 + 1.7000000476837158f) * _101) + 0.05999999865889549f);
          float _123 = ((_105 + 0.5f) * _102) / (((_105 + 1.7000000476837158f) * _102) + 0.05999999865889549f);
          if (!(gPerformSRGBConversion.x == 0.0f)) {
            _178 = (pow(_121, 2.200000047683716f));
            _179 = (pow(_122, 2.200000047683716f));
            _180 = (pow(_123, 2.200000047683716f));
          } else {
            _178 = _121;
            _179 = _122;
            _180 = _123;
          }
        } else {
          float _139 = max(dot(float3(_22, _23, _24), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f)), -24.0f);
          float4 _143 = s_gToneCurveTexture.SampleLevel(s_gToneCurveSampler, float2(((log2(_139) + 24.0f) * 0.0357142873108387f), 0.5f), 0.0f);
          float _145 = exp2(_143.x);
          float _149 = (_145 * _22) / _139;
          float _150 = (_145 * _23) / _139;
          float _151 = (_145 * _24) / _139;
          float _152 = dot(float3(_149, _150, _151), float3(0.3333333432674408f, 0.3333333432674408f, 0.3333333432674408f));
          float _167 = (gToneMappingFilmicSaturationCorrection.x * max(0.0f, (((((1486.4000244140625f - (_152 * 1489.699951171875f)) * _152) + -3.299999952316284f) / ((((_152 * 0.15000000596046448f) + 944.2000122070312f) * _152) + 1.0f)) + -1.0f))) + 1.0f;
          _178 = ((_167 * (_149 - _152)) + _152);
          _179 = ((_167 * (_150 - _152)) + _152);
          _180 = ((_167 * (_151 - _152)) + _152);
        }
      }
      float4 _181 = s_gToneCurveTexture.Sample(s_gToneCurveSampler, float2(TEXCOORD.x, TEXCOORD.y));
      if (TEXCOORD.y > (0.5f - (_181.x * 0.03207677975296974f))) {
        _197 = (lerp(_178, 1.0f, 0.20000000298023224f));
        _198 = (lerp(_179, 1.0f, 0.20000000298023224f));
        _199 = (lerp(_180, 1.0f, 0.20000000298023224f));
      } else {
        _197 = _178;
        _198 = _179;
        _199 = _180;
      }
    }
  } else {
    _197 = _22;
    _198 = _23;
    _199 = _24;
  }

  float _249d = colorU.x;
  float _250d = colorU.y;
  float _251d = colorU.z;

  if (!(gColorGradingEnabled.x == 0.0f)) {
    float _222 = saturate((((gToneMappingColorBalance.x * _197) + -0.18000000715255737f) * gToneMappingContrast.x) + 0.18000000715255737f);
    float _223 = saturate((((gToneMappingColorBalance.y * _198) + -0.18000000715255737f) * gToneMappingContrast.x) + 0.18000000715255737f);
    float _224 = saturate((((gToneMappingColorBalance.z * _199) + -0.18000000715255737f) * gToneMappingContrast.x) + 0.18000000715255737f);
    float _227 = dot(float3(_222, _223, _224), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
    _249 = exp2(log2(lerp(_227, _222, gToneMappingSaturation.x)) * gToneMappingGamma.x);
    _250 = exp2(log2(lerp(_227, _223, gToneMappingSaturation.x)) * gToneMappingGamma.x);
    _251 = exp2(log2(lerp(_227, _224, gToneMappingSaturation.x)) * gToneMappingGamma.x);

    float _222d = max(0, (((gToneMappingColorBalance.x * colorU.x) + -0.18000000715255737f) * gToneMappingContrast.x) + 0.18000000715255737f);
    float _223d = max(0, (((gToneMappingColorBalance.y * colorU.y) + -0.18000000715255737f) * gToneMappingContrast.x) + 0.18000000715255737f);
    float _224d = max(0, (((gToneMappingColorBalance.z * colorU.z) + -0.18000000715255737f) * gToneMappingContrast.x) + 0.18000000715255737f);
    float _227d = dot(float3(_222, _223, _224), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
    _249d = exp2(log2(lerp(_227, _222, gToneMappingSaturation.x)) * gToneMappingGamma.x);
    _250d = exp2(log2(lerp(_227, _223, gToneMappingSaturation.x)) * gToneMappingGamma.x);
    _251d = exp2(log2(lerp(_227, _224, gToneMappingSaturation.x)) * gToneMappingGamma.x);
  } else {
    _249 = _197;
    _250 = _198;
    _251 = _199;
  }

  float _258 = (gToneMappingIntensity.x * (_249 - _22)) + _22;
  float _259 = (gToneMappingIntensity.x * (_250 - _23)) + _23;
  float _260 = (gToneMappingIntensity.x * (_251 - _24)) + _24;

  colorU.x = (gToneMappingIntensity.x * (_249d - colorU.x)) + colorU.x;
  colorU.y = (gToneMappingIntensity.x * (_250d - colorU.y)) + colorU.y;
  colorU.z = (gToneMappingIntensity.x * (_251d - colorU.z)) + colorU.z;

  if (!(gPerformSRGBConversion.x == 0.0f)) {
    if (_258 < 0.0031308000907301903f) {
      _275 = (_258 * 12.920000076293945f);
    } else {
      _275 = (((pow(_258, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_259 < 0.0031308000907301903f) {
      _286 = (_259 * 12.920000076293945f);
    } else {
      _286 = (((pow(_259, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
    if (_260 < 0.0031308000907301903f) {
      _297 = _275;
      _298 = _286;
      _299 = (_260 * 12.920000076293945f);
    } else {
      _297 = _275;
      _298 = _286;
      _299 = (((pow(_260, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
    }
  } else {
    _297 = _258;
    _298 = _259;
    _299 = _260;
  }

  // uint _310 = ((uint)(uint(abs(ScreenSize.x * TEXCOORD.x))) << 16) + uint(abs(ScreenSize.y * TEXCOORD.y));
  // uint _314 = ((_310 ^ 61) ^ ((uint)(_310) >> 16)) * 9;
  // uint _317 = (((uint)(_314) >> 4) ^ _314) * 668265261;
  // float _322 = 0.0019607844296842813f - (float((uint)((int)(((uint)(_317) >> 15) ^ _317))) * 1.8261228033195076e-12f); //noise or dither
  float4 _326 = s_gRasterizedInputTexture.Sample(s_gRasterizedInputSampler, float2(TEXCOORD.x, TEXCOORD.y));
  float _331 = 1.0f - _326.w;
  float4 _326d = renodx::color::srgba::DecodeSafe(_326);
  colorU = (colorU * (1.0f - _326d.w)) + _326d.xyz;
  SV_Target.x = (((/* _322 +  */_297) * _331) + _326.x);
  SV_Target.y = (((/* _322 +  */_298) * _331) + _326.y);
  SV_Target.z = (((/* _322 +  */_299) * _331) + _326.z);
  SV_Target.w = 1.0f;

  SV_Target.xyz = Tonemap_Do(colorU, SV_Target.xyz, TEXCOORD.xy);

  return SV_Target;
}
