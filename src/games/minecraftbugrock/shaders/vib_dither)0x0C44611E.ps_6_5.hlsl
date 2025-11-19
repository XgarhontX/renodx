Texture2D<float4> s_MatTextureTexture : register(t0);

cbuffer FragmentUniforms : register(b1) {
  row_major float4x4 u_view : packoffset(c000.x);
  row_major float4x4 u_invView : packoffset(c004.x);
  float4 OverlayColor : packoffset(c008.x);
  float4 HudOpacity : packoffset(c009.x);
  float4 AlphaMaskedTint : packoffset(c010.x);
  float4 CurrentColor : packoffset(c011.x);
  float4 DiscardValue : packoffset(c012.x);
  float4 DitherParams2[3] : packoffset(c013.x);
  float4 DitherParams : packoffset(c016.x);
  float4 DitheringEnabledToggle : packoffset(c017.x);
};

SamplerState s_MatTextureSampler : register(s0);

#include "../shared.h"

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 COLOR_3 : COLOR3,
  linear float4 COLOR : COLOR,
  linear float4 COLOR_2 : COLOR2,
  linear float4 COLOR_1 : COLOR1,
  float2 TEXCOORD : TEXCOORD,
  linear float3 TEXCOORD_3 : TEXCOORD3
) : SV_Target {
  float4 SV_Target;
  float4 _22 = s_MatTextureTexture.Sample(s_MatTextureSampler, float2(TEXCOORD.x, TEXCOORD.y));
  int _113;
  float _167;
  float _168;
  float _169;
  float _170;

  if (RENODX_TONE_MAP_TYPE == 0 && !(DitheringEnabledToggle.x == 0.0f)) {
    float _47 = rsqrt(dot(float3((u_view[0].z), (u_view[1].z), (u_view[2].z)), float3((u_view[0].z), (u_view[1].z), (u_view[2].z))));
    float _61 = saturate((dot(float3((-0.0f - ((u_view[0].z) * _47)), (-0.0f - ((u_view[1].z) * _47)), (-0.0f - ((u_view[2].z) * _47))), float3((TEXCOORD_3.x - (u_invView[3].x)), (TEXCOORD_3.y - (u_invView[3].y)), (TEXCOORD_3.z - (u_invView[3].z)))) - (DitherParams2[1].x)) / ((DitherParams2[1].y) - (DitherParams2[1].x)));
    float _78 = floor(((((COLOR_3.x / COLOR_3.w) * 0.5f) + 0.5f) * DitherParams.x) / (DitherParams2[1].z)) * (DitherParams2[1].z);
    float _79 = floor(((((COLOR_3.y / COLOR_3.w) * 0.5f) + 0.5f) * DitherParams.y) / (DitherParams2[1].z)) * (DitherParams2[1].z);
    float _83 = floor(_79 * 0.25f);
    float _93 = floor(_79 * 0.5f);
    float _102 = floor(_79);
    _113 = ((int)(uint)((bool)(((_61 * _61) * (3.0f - (_61 * 2.0f))) <= ((((frac(((_93 * _93) * 0.75f) + (floor(_78 * 0.5f) * 0.5f)) + (frac(((_83 * _83) * 0.75f) + (floor(_78 * 0.25f) * 0.5f)) * 0.25f)) * 0.25f) + 0.0078125f) + frac(((_102 * _102) * 0.75f) + (floor(_78) * 0.5f))))));
  } else {
    _113 = 0;
  }
  if (!(!(AlphaMaskedTint.x == 0.0f))) {
    if ((bool)(_113 != 0) || (bool)(_22.w < DiscardValue.x)) {
      if (true) discard;
    }
  }

  float _136 = ((OverlayColor.x - _22.x) * OverlayColor.w) + _22.x;
  float _137 = ((OverlayColor.y - _22.y) * OverlayColor.w) + _22.y;
  float _138 = ((OverlayColor.z - _22.z) * OverlayColor.w) + _22.z;
  float _146 = _136 * COLOR.x;
  float _147 = _137 * COLOR.y;
  float _148 = _138 * COLOR.z;

  if (!(AlphaMaskedTint.x == 0.0f)) {
    _167 = ((lerp(_136, _146, _22.w)) * COLOR.w);
    _168 = ((lerp(_137, _147, _22.w)) * COLOR.w);
    _169 = ((lerp(_138, _148, _22.w)) * COLOR.w);
    _170 = 1.0f;
  } else {
    _167 = _146;
    _168 = _147;
    _169 = _148;
    _170 = ((_22.w * COLOR.w) * CurrentColor.w);
  }
  float _171 = _169 * CurrentColor.z;
  float _172 = _168 * CurrentColor.y;
  float _173 = _167 * CurrentColor.x;
  SV_Target.x = (lerp(_173, COLOR_2.x, COLOR_2.w));
  SV_Target.y = (lerp(_172, COLOR_2.y, COLOR_2.w));
  SV_Target.z = (lerp(_171, COLOR_2.z, COLOR_2.w));
  SV_Target.w = (HudOpacity.x * _170);
  return SV_Target;
}
