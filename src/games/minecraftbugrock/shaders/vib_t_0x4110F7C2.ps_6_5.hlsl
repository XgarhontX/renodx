Texture2D<float4> s_AverageLuminanceTexture : register(t0);

Texture2D<float4> s_ColorTextureTexture : register(t1);

Texture2D<float4> s_CustomExposureCompensationTexture : register(t2);

Texture2D<float4> s_PreExposureLuminanceTexture : register(t3);

Texture2D<float4> s_RasterizedColorTexture : register(t5);

cbuffer FragmentUniforms : register(b1) {
  float4 ColorGrading_Misc : packoffset(c000.x);
  float4 GenericTonemapperContrastAndScaleAndOffsetAndCrosstalk : packoffset(c001.x);
  float4 ExposureCompensation : packoffset(c002.x);
  float4 ColorGrading_Offset_Highlights : packoffset(c003.x);
  float4 ColorGrading_Gamma_Highlights : packoffset(c004.x);
  float4 ColorGrading_Contrast_Highlights : packoffset(c005.x);
  float4 ColorGrading_Saturation_Highlights : packoffset(c006.x);
  float4 ColorGrading_Contrast_Midtones : packoffset(c007.x);
  float4 ColorGrading_Contrast_Shadows : packoffset(c008.x);
  float4 ColorGrading_Gain_Highlights : packoffset(c009.x);
  float4 ColorGrading_Gain_Midtones : packoffset(c010.x);
  float4 ColorGrading_Gain_Shadows : packoffset(c011.x);
  float4 ColorGrading_Offset_Shadows : packoffset(c012.x);
  float4 ColorGrading_Offset_Midtones : packoffset(c013.x);
  float4 ColorGrading_Gamma_Shadows : packoffset(c014.x);
  float4 ColorGrading_Gamma_Midtones : packoffset(c015.x);
  float4 GenericTonemapperCrosstalkParams : packoffset(c016.x);
  float4 ColorGrading_Misc2 : packoffset(c017.x);
  float4 TonemapParams0 : packoffset(c018.x);
  float4 ColorGrading_Saturation_Midtones : packoffset(c019.x);
  float4 ColorGrading_Saturation_Shadows : packoffset(c020.x);
  float4 ColorGrading_Temperature_Params : packoffset(c021.x);
  float4 LuminanceMinMaxAndWhitePointAndMinWhitePoint : packoffset(c022.x);
  float4 RasterizedColorEnabled : packoffset(c023.x);
};

SamplerState s_AverageLuminanceSampler : register(s0);

SamplerState s_ColorTextureSampler : register(s1);

SamplerState s_CustomExposureCompensationSampler : register(s2);

SamplerState s_PreExposureLuminanceSampler : register(s3);

SamplerState s_RasterizedColorSampler : register(s5);

#include "./common.hlsl"

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _14 = s_ColorTextureTexture.Sample(s_ColorTextureSampler, float2(TEXCOORD.x, TEXCOORD.y));

  float _30;
  float _31;
  float _32;
  float _45;
  float _74;
  float _173;
  float _174;
  float _175;
  float _241;
  float _242;
  float _243;
  float _328;
  float _329;
  float _330;
  float _405;
  float _406;
  float _407;
  float _475;
  float _476;
  float _477;
  float _691;
  float _692;
  float _693;
  float _758;
  float _759;
  float _760;
  float _883;
  float _884;
  float _885;
  float _944;
  float _945;
  float _946;
  float _1033;
  float _1034;
  float _1035;
  float _1094;
  float _1095;
  float _1096;
  float _1104;
  float _1105;
  float _1106;

  if (TonemapParams0.z > 0.0f) {
    float4 _22 = s_PreExposureLuminanceTexture.Sample(s_PreExposureLuminanceSampler, float2(0.5f, 0.5f));
    float _25 = (0.18000000715255737f / _22.x) + 9.999999747378752e-05f;
    _30 = (_14.x / _25);
    _31 = (_14.y / _25);
    _32 = (_14.z / _25);
  } else {
    _30 = _14.x;
    _31 = _14.y;
    _32 = _14.z;
  }

  if (ExposureCompensation.z > 0.5f) {
    float4 _40 = s_AverageLuminanceTexture.Sample(s_AverageLuminanceSampler, float2(0.5f, 0.5f));
    _45 = min(max(_40.x, LuminanceMinMaxAndWhitePointAndMinWhitePoint.x), LuminanceMinMaxAndWhitePointAndMinWhitePoint.y); //clamp
  } else {
    _45 = 0.18000000715255737f;
  }

  int _47 = int(ExposureCompensation.x);
  if (_47 == 1) {
    _74 = (1.0299999713897705f - (2.0f / ((log2(_45 + 1.0f) * 0.3010299801826477f) + 2.0f)));
  } else {
    if ((int)_47 > (int)1) {
      float _65 = log2(LuminanceMinMaxAndWhitePointAndMinWhitePoint.x);
      float4 _71 = s_CustomExposureCompensationTexture.Sample(s_CustomExposureCompensationSampler, float2(select((LuminanceMinMaxAndWhitePointAndMinWhitePoint.x == LuminanceMinMaxAndWhitePointAndMinWhitePoint.y), 0.5f, ((log2(_45) - _65) / (log2(LuminanceMinMaxAndWhitePointAndMinWhitePoint.y) - _65))), 0.5f));
      _74 = _71.x;
    } else {
      _74 = ExposureCompensation.y;
    }
  }

  float _75 = dot(float3(_30, _31, _32), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  if (!(ColorGrading_Temperature_Params.x == 0.0f)) {
    float _91 = ((((ColorGrading_Temperature_Params.y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * ColorGrading_Temperature_Params.y) + 0.8601177334785461f) / ((((ColorGrading_Temperature_Params.y * 7.081451371959702e-07f) + 0.0008424202096648514f) * ColorGrading_Temperature_Params.y) + 1.0f);
    float _101 = ((((ColorGrading_Temperature_Params.y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * ColorGrading_Temperature_Params.y) + 0.31739872694015503f) / ((1.0f - (ColorGrading_Temperature_Params.y * 2.8974181986995973e-05f)) + ((ColorGrading_Temperature_Params.y * ColorGrading_Temperature_Params.y) * 1.6145605741257896e-07f));
    float _107 = ((_91 * 2.0f) - (_101 * 8.0f)) + 4.0f;
    float _108 = (_91 * 3.0f) / _107;
    float _109 = (_101 * 2.0f) / _107;
    float _110 = _108 / _109;
    float _113 = ((1.0f - _108) - _109) / _109;
    float _116 = mad(-0.1624000072479248f, _113, ((_110 * 0.7328000068664551f) + 0.4296000003814697f));
    float _119 = mad(0.006099999882280827f, _113, (1.6974999904632568f - (_110 * 0.7035999894142151f)));
    float _122 = mad(0.9833999872207642f, _113, ((_110 * 0.003000000026077032f) + 0.01360000018030405f));
    bool _123 = (int(ColorGrading_Temperature_Params.z) == 0);
    float _130 = select(_123, (0.9492529630661011f / _116), (_116 * 1.0534600019454956f));
    float _131 = select(_123, (1.0354191064834595f / _119), (_119 * 0.9657924771308899f));
    float _132 = select(_123, (1.0871834754943848f / _122), (_122 * 0.9198079705238342f));
    float _133 = mad(_131, 0.07100000232458115f, 0.0f);
    float _134 = mad(_131, 0.9629999995231628f, 0.0f);
    float _135 = mad(_131, 0.0010000000474974513f, 0.0f);
    float _136 = mad(_132, 0.023000000044703484f, 0.0f);
    float _137 = mad(_132, 0.12800000607967377f, 0.0f);
    float _138 = mad(_132, 0.9359999895095825f, 0.0f);
    _173 = mad(mad(-0.02500000037252903f, _138, mad(-1.628999948501587f, _135, (_130 * 0.025730999186635017f))), _32, mad(mad(-0.02500000037252903f, _137, mad(-1.628999948501587f, _134, (_130 * 1.572450041770935f))), _31, (mad(-0.02500000037252903f, _136, mad(-1.628999948501587f, _133, (_130 * 1.1150099039077759f))) * _30)));
    _174 = mad(mad(1.1579999923706055f, _135, (_130 * -0.001889999839477241f)), _32, mad(mad(1.1579999923706055f, _134, (_130 * -0.11549999564886093f)), _31, (mad(1.1579999923706055f, _133, (_130 * -0.08189999312162399f)) * _30)));
    _175 = mad(mad(1.069000005722046f, _138, mad(-0.11800000071525574f, _135, (_130 * -0.0003779999678954482f))), _32, mad(mad(1.069000005722046f, _137, mad(-0.11800000071525574f, _134, (_130 * -0.023099999874830246f))), _31, (mad(1.069000005722046f, _136, mad(-0.11800000071525574f, _133, (_130 * -0.01637999899685383f))) * _30)));
  } else {
    _173 = _30;
    _174 = _31;
    _175 = _32;
  }

  bool _178 = !(ColorGrading_Contrast_Shadows.w == 0.0f);
  bool _181 = !(ColorGrading_Contrast_Highlights.w == 0.0f);
  float _194 = ColorGrading_Misc.y * _45;
  bool _195 = (_75 >= _194);
  if (!(_181 && _195)) {
    float _200 = ColorGrading_Misc.z * _45;
    bool _202 = _178 && (bool)(_75 <= _200);
    if (!((bool)(ColorGrading_Contrast_Midtones.w == 0.0f) || _202)) {
      if ((bool)(_75 < _45) && _178) {
        float _214 = (_75 - _200) / (_45 - _200);
        _241 = ((_214 * (ColorGrading_Contrast_Midtones.x - ColorGrading_Contrast_Shadows.x)) + ColorGrading_Contrast_Shadows.x);
        _242 = ((_214 * (ColorGrading_Contrast_Midtones.y - ColorGrading_Contrast_Shadows.y)) + ColorGrading_Contrast_Shadows.y);
        _243 = ((_214 * (ColorGrading_Contrast_Midtones.z - ColorGrading_Contrast_Shadows.z)) + ColorGrading_Contrast_Shadows.z);
      } else {
        if ((bool)(_75 > _45) && _181) {
          float _230 = (_75 - _45) / (_194 - _45);
          _241 = ((_230 * (ColorGrading_Contrast_Highlights.x - ColorGrading_Contrast_Midtones.x)) + ColorGrading_Contrast_Midtones.x);
          _242 = ((_230 * (ColorGrading_Contrast_Highlights.y - ColorGrading_Contrast_Midtones.y)) + ColorGrading_Contrast_Midtones.y);
          _243 = ((_230 * (ColorGrading_Contrast_Highlights.z - ColorGrading_Contrast_Midtones.z)) + ColorGrading_Contrast_Midtones.z);
        } else {
          _241 = ColorGrading_Contrast_Midtones.x;
          _242 = ColorGrading_Contrast_Midtones.y;
          _243 = ColorGrading_Contrast_Midtones.z;
        }
      }
    } else {
      _241 = select(_202, ColorGrading_Contrast_Shadows.x, 1.0f);
      _242 = select(_202, ColorGrading_Contrast_Shadows.y, 1.0f);
      _243 = select(_202, ColorGrading_Contrast_Shadows.z, 1.0f);
    }
  } else {
    _241 = ColorGrading_Contrast_Highlights.x;
    _242 = ColorGrading_Contrast_Highlights.y;
    _243 = ColorGrading_Contrast_Highlights.z;
  }

  float _245 = ColorGrading_Misc.x * _45;
  float _264 = max((exp2(log2(max(_173, 0.0f) / _245) * _241) * _245), 0.0f);
  float _265 = max((exp2(log2(max(_174, 0.0f) / _245) * _242) * _245), 0.0f);
  float _266 = max((exp2(log2(max(_175, 0.0f) / _245) * _243) * _245), 0.0f);
  bool _269 = !(ColorGrading_Saturation_Shadows.w == 0.0f);
  bool _272 = !(ColorGrading_Saturation_Highlights.w == 0.0f);

  if (!(_272 && _195)) {
    float _287 = ColorGrading_Misc.z * _45;
    bool _289 = _269 && (bool)(_75 <= _287);
    if (!((bool)(ColorGrading_Saturation_Midtones.w == 0.0f) || _289)) {
      if ((bool)(_75 < _45) && _269) {
        float _301 = (_75 - _287) / (_45 - _287);
        _328 = ((_301 * (ColorGrading_Saturation_Midtones.x - ColorGrading_Saturation_Shadows.x)) + ColorGrading_Saturation_Shadows.x);
        _329 = ((_301 * (ColorGrading_Saturation_Midtones.y - ColorGrading_Saturation_Shadows.y)) + ColorGrading_Saturation_Shadows.y);
        _330 = ((_301 * (ColorGrading_Saturation_Midtones.z - ColorGrading_Saturation_Shadows.z)) + ColorGrading_Saturation_Shadows.z);
      } else {
        if ((bool)(_75 > _45) && _272) {
          float _317 = (_75 - _45) / (_194 - _45);
          _328 = ((_317 * (ColorGrading_Saturation_Highlights.x - ColorGrading_Saturation_Midtones.x)) + ColorGrading_Saturation_Midtones.x);
          _329 = ((_317 * (ColorGrading_Saturation_Highlights.y - ColorGrading_Saturation_Midtones.y)) + ColorGrading_Saturation_Midtones.y);
          _330 = ((_317 * (ColorGrading_Saturation_Highlights.z - ColorGrading_Saturation_Midtones.z)) + ColorGrading_Saturation_Midtones.z);
        } else {
          _328 = ColorGrading_Saturation_Midtones.x;
          _329 = ColorGrading_Saturation_Midtones.y;
          _330 = ColorGrading_Saturation_Midtones.z;
        }
      }
    } else {
      _328 = select(_289, ColorGrading_Saturation_Shadows.x, 1.0f);
      _329 = select(_289, ColorGrading_Saturation_Shadows.y, 1.0f);
      _330 = select(_289, ColorGrading_Saturation_Shadows.z, 1.0f);
    }
  } else {
    _328 = ColorGrading_Saturation_Highlights.x;
    _329 = ColorGrading_Saturation_Highlights.y;
    _330 = ColorGrading_Saturation_Highlights.z;
  }

  float _331 = dot(float3(_264, _265, _266), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  bool _346 = !(ColorGrading_Gain_Shadows.w == 0.0f);
  bool _349 = !(ColorGrading_Gain_Highlights.w == 0.0f);
  if (!(_349 && _195)) {
    float _364 = ColorGrading_Misc.z * _45;
    bool _366 = _346 && (bool)(_75 <= _364);
    if (!((bool)(ColorGrading_Gain_Midtones.w == 0.0f) || _366)) {
      if ((bool)(_75 < _45) && _346) {
        float _378 = (_75 - _364) / (_45 - _364);
        _405 = ((_378 * (ColorGrading_Gain_Midtones.x - ColorGrading_Gain_Shadows.x)) + ColorGrading_Gain_Shadows.x);
        _406 = ((_378 * (ColorGrading_Gain_Midtones.y - ColorGrading_Gain_Shadows.y)) + ColorGrading_Gain_Shadows.y);
        _407 = ((_378 * (ColorGrading_Gain_Midtones.z - ColorGrading_Gain_Shadows.z)) + ColorGrading_Gain_Shadows.z);
      } else {
        if ((bool)(_75 > _45) && _349) {
          float _394 = (_75 - _45) / (_194 - _45);
          _405 = ((_394 * (ColorGrading_Gain_Highlights.x - ColorGrading_Gain_Midtones.x)) + ColorGrading_Gain_Midtones.x);
          _406 = ((_394 * (ColorGrading_Gain_Highlights.y - ColorGrading_Gain_Midtones.y)) + ColorGrading_Gain_Midtones.y);
          _407 = ((_394 * (ColorGrading_Gain_Highlights.z - ColorGrading_Gain_Midtones.z)) + ColorGrading_Gain_Midtones.z);
        } else {
          _405 = ColorGrading_Gain_Midtones.x;
          _406 = ColorGrading_Gain_Midtones.y;
          _407 = ColorGrading_Gain_Midtones.z;
        }
      }
    } else {
      _405 = select(_366, ColorGrading_Gain_Shadows.x, 1.0f);
      _406 = select(_366, ColorGrading_Gain_Shadows.y, 1.0f);
      _407 = select(_366, ColorGrading_Gain_Shadows.z, 1.0f);
    }
  } else {
    _405 = ColorGrading_Gain_Highlights.x;
    _406 = ColorGrading_Gain_Highlights.y;
    _407 = ColorGrading_Gain_Highlights.z;
  }

  bool _416 = !(ColorGrading_Offset_Shadows.w == 0.0f);
  bool _419 = !(ColorGrading_Offset_Highlights.w == 0.0f);
  if (!(_419 && _195)) {
    float _434 = ColorGrading_Misc.z * _45;
    bool _436 = _416 && (bool)(_75 <= _434);
    if (!((bool)(ColorGrading_Offset_Midtones.w == 0.0f) || _436)) {
      if ((bool)(_75 < _45) && _416) {
        float _448 = (_75 - _434) / (_45 - _434);
        _475 = ((_448 * (ColorGrading_Offset_Midtones.x - ColorGrading_Offset_Shadows.x)) + ColorGrading_Offset_Shadows.x);
        _476 = ((_448 * (ColorGrading_Offset_Midtones.y - ColorGrading_Offset_Shadows.y)) + ColorGrading_Offset_Shadows.y);
        _477 = ((_448 * (ColorGrading_Offset_Midtones.z - ColorGrading_Offset_Shadows.z)) + ColorGrading_Offset_Shadows.z);
      } else {
        if ((bool)(_75 > _45) && _419) {
          float _464 = (_75 - _45) / (_194 - _45);
          _475 = ((_464 * (ColorGrading_Offset_Highlights.x - ColorGrading_Offset_Midtones.x)) + ColorGrading_Offset_Midtones.x);
          _476 = ((_464 * (ColorGrading_Offset_Highlights.y - ColorGrading_Offset_Midtones.y)) + ColorGrading_Offset_Midtones.y);
          _477 = ((_464 * (ColorGrading_Offset_Highlights.z - ColorGrading_Offset_Midtones.z)) + ColorGrading_Offset_Midtones.z);
        } else {
          _475 = ColorGrading_Offset_Midtones.x;
          _476 = ColorGrading_Offset_Midtones.y;
          _477 = ColorGrading_Offset_Midtones.z;
        }
      }
    } else {
      _475 = select(_436, ColorGrading_Offset_Shadows.x, 0.0f);
      _476 = select(_436, ColorGrading_Offset_Shadows.y, 0.0f);
      _477 = select(_436, ColorGrading_Offset_Shadows.z, 0.0f);
    }
  } else {
    _475 = ColorGrading_Offset_Highlights.x;
    _476 = ColorGrading_Offset_Highlights.y;
    _477 = ColorGrading_Offset_Highlights.z;
  }

  float _484 = max(((_475 * _45) + max((_405 * max((lerp(_331, _264, _328)), 0.0f)), 0.0f)), 0.0f);
  float _485 = max(((_476 * _45) + max((_406 * max((lerp(_331, _265, _329)), 0.0f)), 0.0f)), 0.0f);
  float _486 = max(((_477 * _45) + max((_407 * max((lerp(_331, _266, _330)), 0.0f)), 0.0f)), 0.0f);
  float _490 = (0.18000000715255737f / _45) * _74;
  float _491 = _490 * _484;
  float _492 = _490 * _485;
  float _493 = _490 * _486;

  float3 colorU = float3(_491, _492, _493);

  if (!(!(TonemapParams0.y >= 0.5f))) {
    int _501 = int(TonemapParams0.x);
    float _502 = select((LuminanceMinMaxAndWhitePointAndMinWhitePoint.z < LuminanceMinMaxAndWhitePointAndMinWhitePoint.w), LuminanceMinMaxAndWhitePointAndMinWhitePoint.w, LuminanceMinMaxAndWhitePointAndMinWhitePoint.z) * _490;
    float _503 = _502 * _502;
    if (_501 == 1) {
      _691 = ((((_491 / _503) + 1.0f) * _491) / (_491 + 1.0f));
      _692 = ((((_492 / _503) + 1.0f) * _492) / (_492 + 1.0f));
      _693 = ((((_493 / _503) + 1.0f) * _493) / (_493 + 1.0f));
    } else {
      if (_501 == 2) {
        float _524 = dot(float3(_491, _492, _493), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
        float _530 = (((_524 / _503) + 1.0f) * _524) / ((_524 + 1.0f) * _524);
        _691 = (_530 * _491);
        _692 = (_530 * _492);
        _693 = (_530 * _493);
      } else {
        if (_501 == 3) {
          float _537 = _491 * 2.0f;
          float _538 = _492 * 2.0f;
          float _539 = _493 * 2.0f;
          float _540 = _491 * 0.30000001192092896f;
          float _541 = _492 * 0.30000001192092896f;
          float _542 = _493 * 0.30000001192092896f;
          float _567 = _503 * 0.15000000596046448f;
          float _576 = 1.0f / (((((_567 + 0.05000000074505806f) * _503) + 0.004000000189989805f) / (((_567 + 0.5f) * _503) + 0.06000000238418579f)) + -0.06666666269302368f);
          _691 = (_576 * (((((_540 + 0.05000000074505806f) * _537) + 0.004000000189989805f) / (((_540 + 0.5f) * _537) + 0.06000000238418579f)) + -0.06666666269302368f));
          _692 = (_576 * (((((_541 + 0.05000000074505806f) * _538) + 0.004000000189989805f) / (((_541 + 0.5f) * _538) + 0.06000000238418579f)) + -0.06666666269302368f));
          _693 = (_576 * (((((_542 + 0.05000000074505806f) * _539) + 0.004000000189989805f) / (((_542 + 0.5f) * _539) + 0.06000000238418579f)) + -0.06666666269302368f));
        } else {
          if (_501 == 4) {
            float _585 = mad(0.04822999984025955f, _493, mad(0.35457998514175415f, _492, (_491 * 0.5971900224685669f)));
            float _588 = mad(0.01565999910235405f, _493, mad(0.9083399772644043f, _492, (_491 * 0.07599999755620956f)));
            float _591 = mad(0.8377699851989746f, _493, mad(0.1338299959897995f, _492, (_491 * 0.0284000001847744f)));
            float _613 = (((_585 + 0.024578599259257317f) * _585) + -9.053700341610238e-05f) / ((((_585 * 0.9837290048599243f) + 0.4329510033130646f) * _585) + 0.23808099329471588f);
            float _614 = (((_588 + 0.024578599259257317f) * _588) + -9.053700341610238e-05f) / ((((_588 * 0.9837290048599243f) + 0.4329510033130646f) * _588) + 0.23808099329471588f);
            float _615 = (((_591 + 0.024578599259257317f) * _591) + -9.053700341610238e-05f) / ((((_591 * 0.9837290048599243f) + 0.4329510033130646f) * _591) + 0.23808099329471588f);
            _691 = saturate(mad(-0.07366999983787537f, _615, mad(-0.5310800075531006f, _614, (_613 * 1.6047500371932983f))));
            _692 = saturate(mad(-0.006049999967217445f, _615, mad(1.1081299781799316f, _614, (_613 * -0.10208000242710114f))));
            _693 = saturate(mad(1.0760200023651123f, _615, mad(-0.07276000082492828f, _614, (_613 * -0.003269999986514449f))));
          } else {
            if (_501 == 5) {
              float _632 = max(_491, max(_492, _493));
              float _640 = (pow(_632, GenericTonemapperContrastAndScaleAndOffsetAndCrosstalk.x));
              float _645 = _640 / ((GenericTonemapperContrastAndScaleAndOffsetAndCrosstalk.y * _640) + GenericTonemapperContrastAndScaleAndOffsetAndCrosstalk.z);
              float _648 = 1.0f / GenericTonemapperCrosstalkParams.x;
              float _655 = exp2(log2(_491 / _632) * _648);
              float _656 = exp2(log2(_492 / _632) * _648);
              float _657 = exp2(log2(_493 / _632) * _648);
              float _661 = (pow(_645, GenericTonemapperContrastAndScaleAndOffsetAndCrosstalk.w));
              _691 = (exp2(log2((_661 * (1.0f - _655)) + _655) * GenericTonemapperCrosstalkParams.x) * _645);
              _692 = (exp2(log2((_661 * (1.0f - _656)) + _656) * GenericTonemapperCrosstalkParams.x) * _645);
              _693 = (exp2(log2((_661 * (1.0f - _657)) + _657) * GenericTonemapperCrosstalkParams.x) * _645);
            } else {
              _691 = (_491 / (_491 + 1.0f));
              _692 = (_492 / (_492 + 1.0f));
              _693 = (_493 / (_493 + 1.0f));
            }
          }
        }
      }
    }

    float _694 = dot(float3(_691, _692, _693), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
    bool _697 = !(ColorGrading_Gamma_Shadows.w == 0.0f);
    bool _700 = !(ColorGrading_Gamma_Highlights.w == 0.0f);
    float _711 = ColorGrading_Misc.y * 0.18000000715255737f;
    if (!(_700 && (bool)(_694 >= _711))) {
      float _717 = ColorGrading_Misc.z * 0.18000000715255737f;
      bool _719 = _697 && (bool)(_694 <= _717);
      if (!((bool)(ColorGrading_Gamma_Midtones.w == 0.0f) || _719)) {
        if ((bool)(_694 < 0.18000000715255737f) && _697) {
          float _731 = (_694 - _717) / (0.18000000715255737f - _717);
          _758 = ((_731 * (ColorGrading_Gamma_Midtones.x - ColorGrading_Gamma_Shadows.x)) + ColorGrading_Gamma_Shadows.x);
          _759 = ((_731 * (ColorGrading_Gamma_Midtones.y - ColorGrading_Gamma_Shadows.y)) + ColorGrading_Gamma_Shadows.y);
          _760 = ((_731 * (ColorGrading_Gamma_Midtones.z - ColorGrading_Gamma_Shadows.z)) + ColorGrading_Gamma_Shadows.z);
        } else {
          if ((bool)(_694 > 0.18000000715255737f) && _700) {
            float _747 = (_694 + -0.18000000715255737f) / (_711 + -0.18000000715255737f);
            _758 = ((_747 * (ColorGrading_Gamma_Highlights.x - ColorGrading_Gamma_Midtones.x)) + ColorGrading_Gamma_Midtones.x);
            _759 = ((_747 * (ColorGrading_Gamma_Highlights.y - ColorGrading_Gamma_Midtones.y)) + ColorGrading_Gamma_Midtones.y);
            _760 = ((_747 * (ColorGrading_Gamma_Highlights.z - ColorGrading_Gamma_Midtones.z)) + ColorGrading_Gamma_Midtones.z);
          } else {
            _758 = ColorGrading_Gamma_Midtones.x;
            _759 = ColorGrading_Gamma_Midtones.y;
            _760 = ColorGrading_Gamma_Midtones.z;
          }
        }
      } else {
        _758 = select(_719, ColorGrading_Gamma_Shadows.x, 2.200000047683716f);
        _759 = select(_719, ColorGrading_Gamma_Shadows.y, 2.200000047683716f);
        _760 = select(_719, ColorGrading_Gamma_Shadows.z, 2.200000047683716f);
      }
    } else {
      _758 = ColorGrading_Gamma_Highlights.x;
      _759 = ColorGrading_Gamma_Highlights.y;
      _760 = ColorGrading_Gamma_Highlights.z;
    }

    float _765 = ColorGrading_Misc.w * _758;
    float _766 = ColorGrading_Misc.w * _759;
    float _767 = ColorGrading_Misc.w * _760;
    if (!(ColorGrading_Misc2.x == 0.0f)) {
      _944 = (log2(max(_691, 0.0f)) * (1.0f / _765));
      _945 = (log2(max(_692, 0.0f)) * (1.0f / _766));
      _946 = (log2(max(_693, 0.0f)) * (1.0f / _767));
    } else {
      _944 = (log2(select((_691 <= 0.0031308000907301903f), (_691 * 12.920000076293945f), ((exp2(log2(abs(_691)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f))) * (2.200000047683716f / _765));
      _945 = (log2(select((_692 <= 0.0031308000907301903f), (_692 * 12.920000076293945f), ((exp2(log2(abs(_692)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f))) * (2.200000047683716f / _766));
      _946 = (log2(select((_693 <= 0.0031308000907301903f), (_693 * 12.920000076293945f), ((exp2(log2(abs(_693)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f))) * (2.200000047683716f / _767));
    }
  } else {
    float _819 = dot(float3(_484, _485, _486), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
    bool _822 = !(ColorGrading_Gamma_Shadows.w == 0.0f);
    bool _825 = !(ColorGrading_Gamma_Highlights.w == 0.0f);
    float _836 = ColorGrading_Misc.y * 0.18000000715255737f;
    if (!(_825 && (bool)(_819 >= _836))) {
      float _842 = ColorGrading_Misc.z * 0.18000000715255737f;
      bool _844 = _822 && (bool)(_819 <= _842);
      if (!((bool)(ColorGrading_Gamma_Midtones.w == 0.0f) || _844)) {
        if ((bool)(_819 < 0.18000000715255737f) && _822) {
          float _856 = (_819 - _842) / (0.18000000715255737f - _842);
          _883 = ((_856 * (ColorGrading_Gamma_Midtones.x - ColorGrading_Gamma_Shadows.x)) + ColorGrading_Gamma_Shadows.x);
          _884 = ((_856 * (ColorGrading_Gamma_Midtones.y - ColorGrading_Gamma_Shadows.y)) + ColorGrading_Gamma_Shadows.y);
          _885 = ((_856 * (ColorGrading_Gamma_Midtones.z - ColorGrading_Gamma_Shadows.z)) + ColorGrading_Gamma_Shadows.z);
        } else {
          if ((bool)(_819 > 0.18000000715255737f) && _825) {
            float _872 = (_819 + -0.18000000715255737f) / (_836 + -0.18000000715255737f);
            _883 = ((_872 * (ColorGrading_Gamma_Highlights.x - ColorGrading_Gamma_Midtones.x)) + ColorGrading_Gamma_Midtones.x);
            _884 = ((_872 * (ColorGrading_Gamma_Highlights.y - ColorGrading_Gamma_Midtones.y)) + ColorGrading_Gamma_Midtones.y);
            _885 = ((_872 * (ColorGrading_Gamma_Highlights.z - ColorGrading_Gamma_Midtones.z)) + ColorGrading_Gamma_Midtones.z);
          } else {
            _883 = ColorGrading_Gamma_Midtones.x;
            _884 = ColorGrading_Gamma_Midtones.y;
            _885 = ColorGrading_Gamma_Midtones.z;
          }
        }
      } else {
        _883 = select(_844, ColorGrading_Gamma_Shadows.x, 2.200000047683716f);
        _884 = select(_844, ColorGrading_Gamma_Shadows.y, 2.200000047683716f);
        _885 = select(_844, ColorGrading_Gamma_Shadows.z, 2.200000047683716f);
      }
    } else {
      _883 = ColorGrading_Gamma_Highlights.x;
      _884 = ColorGrading_Gamma_Highlights.y;
      _885 = ColorGrading_Gamma_Highlights.z;
    }
    float _890 = ColorGrading_Misc.w * _883;
    float _891 = ColorGrading_Misc.w * _884;
    float _892 = ColorGrading_Misc.w * _885;
    if (!(ColorGrading_Misc2.x == 0.0f)) {
      _944 = (log2(max(_484, 0.0f)) * (1.0f / _890));
      _945 = (log2(max(_485, 0.0f)) * (1.0f / _891));
      _946 = (log2(max(_486, 0.0f)) * (1.0f / _892));
    } else {
      _944 = (log2(select((_484 <= 0.0031308000907301903f), (_484 * 12.920000076293945f), ((exp2(log2(abs(_484)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f))) * (2.200000047683716f / _890));
      _945 = (log2(select((_485 <= 0.0031308000907301903f), (_485 * 12.920000076293945f), ((exp2(log2(abs(_485)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f))) * (2.200000047683716f / _891));
      _946 = (log2(select((_486 <= 0.0031308000907301903f), (_486 * 12.920000076293945f), ((exp2(log2(abs(_486)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f))) * (2.200000047683716f / _892));
    }
  }
  float _953 = min(max(exp2(_944), 0.0f), 1.0f);
  float _954 = min(max(exp2(_945), 0.0f), 1.0f);
  float _955 = min(max(exp2(_946), 0.0f), 1.0f);
  if (RasterizedColorEnabled.x > 0.0f) {
    float4 _960 = s_RasterizedColorTexture.Sample(s_RasterizedColorSampler, float2(TEXCOORD.x, TEXCOORD.y));
    float _965 = 1.0f - _960.w;
    float _969 = dot(float3(_960.x, _960.y, _960.z), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
    bool _972 = !(ColorGrading_Gamma_Shadows.w == 0.0f);
    bool _975 = !(ColorGrading_Gamma_Highlights.w == 0.0f);
    float _986 = ColorGrading_Misc.y * 0.18000000715255737f;
    if (!(_975 && (bool)(_969 >= _986))) {
      float _992 = ColorGrading_Misc.z * 0.18000000715255737f;
      bool _994 = _972 && (bool)(_969 <= _992);
      if (!((bool)(ColorGrading_Gamma_Midtones.w == 0.0f) || _994)) {
        if ((bool)(_969 < 0.18000000715255737f) && _972) {
          float _1006 = (_969 - _992) / (0.18000000715255737f - _992);
          _1033 = ((_1006 * (ColorGrading_Gamma_Midtones.x - ColorGrading_Gamma_Shadows.x)) + ColorGrading_Gamma_Shadows.x);
          _1034 = ((_1006 * (ColorGrading_Gamma_Midtones.y - ColorGrading_Gamma_Shadows.y)) + ColorGrading_Gamma_Shadows.y);
          _1035 = ((_1006 * (ColorGrading_Gamma_Midtones.z - ColorGrading_Gamma_Shadows.z)) + ColorGrading_Gamma_Shadows.z);
        } else {
          if ((bool)(_969 > 0.18000000715255737f) && _975) {
            float _1022 = (_969 + -0.18000000715255737f) / (_986 + -0.18000000715255737f);
            _1033 = ((_1022 * (ColorGrading_Gamma_Highlights.x - ColorGrading_Gamma_Midtones.x)) + ColorGrading_Gamma_Midtones.x);
            _1034 = ((_1022 * (ColorGrading_Gamma_Highlights.y - ColorGrading_Gamma_Midtones.y)) + ColorGrading_Gamma_Midtones.y);
            _1035 = ((_1022 * (ColorGrading_Gamma_Highlights.z - ColorGrading_Gamma_Midtones.z)) + ColorGrading_Gamma_Midtones.z);
          } else {
            _1033 = ColorGrading_Gamma_Midtones.x;
            _1034 = ColorGrading_Gamma_Midtones.y;
            _1035 = ColorGrading_Gamma_Midtones.z;
          }
        }
      } else {
        _1033 = select(_994, ColorGrading_Gamma_Shadows.x, 2.200000047683716f);
        _1034 = select(_994, ColorGrading_Gamma_Shadows.y, 2.200000047683716f);
        _1035 = select(_994, ColorGrading_Gamma_Shadows.z, 2.200000047683716f);
      }
    } else {
      _1033 = ColorGrading_Gamma_Highlights.x;
      _1034 = ColorGrading_Gamma_Highlights.y;
      _1035 = ColorGrading_Gamma_Highlights.z;
    }
    float _1040 = ColorGrading_Misc.w * _1033;
    float _1041 = ColorGrading_Misc.w * _1034;
    float _1042 = ColorGrading_Misc.w * _1035;
    if (!(ColorGrading_Misc2.x == 0.0f)) {
      _1094 = (log2(max(_960.x, 0.0f)) * (1.0f / _1040));
      _1095 = (log2(max(_960.y, 0.0f)) * (1.0f / _1041));
      _1096 = (log2(max(_960.z, 0.0f)) * (1.0f / _1042));
    } else {
      _1094 = (log2(select((_960.x <= 0.0031308000907301903f), (_960.x * 12.920000076293945f), ((exp2(log2(abs(_960.x)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f))) * (2.200000047683716f / _1040));
      _1095 = (log2(select((_960.y <= 0.0031308000907301903f), (_960.y * 12.920000076293945f), ((exp2(log2(abs(_960.y)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f))) * (2.200000047683716f / _1041));
      _1096 = (log2(select((_960.z <= 0.0031308000907301903f), (_960.z * 12.920000076293945f), ((exp2(log2(abs(_960.z)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f))) * (2.200000047683716f / _1042));
    }
    _1104 = (exp2(_1094) + (_965 * _953));
    _1105 = (exp2(_1095) + (_965 * _954));
    _1106 = (exp2(_1096) + (_965 * _955));
  } else {
    _1104 = _953;
    _1105 = _954;
    _1106 = _955;
  }
  SV_Target.x = _1104;
  SV_Target.y = _1105;
  SV_Target.z = _1106;
  SV_Target.w = 1.0f;

  SV_Target.xyz = Tonemap_Do(colorU, SV_Target.xyz, TEXCOORD.xy);

  return SV_Target;
}
