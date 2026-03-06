#include "./shared.h"

Texture2D t0 : register(t0);
SamplerState s0 : register(s0);

float4 main(float4 vpos: SV_POSITION, float2 uv: TEXCOORD0)
    : SV_TARGET {
  float3 x = t0.Sample(s0, uv).xyz;

  //intermediate encode inv
  x = renodx::color::srgb::DecodeSafe(x);

  //to BT2020
  x = renodx::color::bt2020::from::BT709(x);
  x = max(0, x);

  //EOTF Emulate (BT2020)
  if (SI.gamma_correction > 0.f) {
    x *= SI.graphics_white_nits / 203.f;

    x /= SI.gamma_correction / 203.f;
    float3 x1 = renodx::color::correct::Gamma(x, false, 2.2);
    x = x < 1 ? x1 : x;
    x *= SI.gamma_correction / 203.f;

    x /= SI.graphics_white_nits / 203.f;
  }

  //HDR10
  if (SI.swap_chain_encoding == 0) {
    x *= SI.graphics_white_nits / 10000.f;
    x = renodx::color::pq::Encode(x);
  }
  //scRGB
  else {
    x *= SI.graphics_white_nits / 80.f;
    x = renodx::color::bt709::from::BT2020(x);
  }

  return float4(x, 1.0);
}
