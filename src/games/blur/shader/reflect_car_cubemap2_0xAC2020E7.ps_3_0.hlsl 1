sampler2D s0 : register(s0);
sampler2D s2 : register(s2);

float4 c15 : register(c15);
float4 c48 : register(c48);

struct PS_IN
{
    float2 tex0  : TEXCOORD0;
    float  tex1w : TEXCOORD1;
    float3 color : COLOR0;
};

struct PS_OUT
{
    float4 color : COLOR0;
};

#include "../shared.h"
//aint no way, ChatGPT got it.
PS_OUT main(PS_IN input)
{
    PS_OUT o;

    float4 texS2 = tex2D(s2, input.tex0);
    float4 texS0 = tex2D(s0, input.tex0);

    // mul r0.xyz, r0.y, r1.xyz
    float3 r0 = texS2.y * texS0.xyz;

    // mul r0.xyz, r0.xyz, c15.xyz
    r0 *= c15.xyz;

    // mad r0.xyz, v2.xyz, r1.xyz, r0.xyz
    r0 = input.color * texS0.xyz + r0;

    // mul r0.xyz, r0.xyz, c48.x
    r0 *= c48.x;

    // RSQ/RCP sequence → sqrt per component
    float3 sqrtColor = sqrt(max(r0, 0.0));

    // mul oC0.xyz, r1.w, r1.xyz
    o.color.xyz = texS0.a * sqrtColor / EXPOSURE_REVERSAL;

    // mov_sat r0.x, v1.w
    float alphaFactor = saturate(input.tex1w);

    // mul oC0.w, r0.x, r1.w
    o.color.w = alphaFactor * texS0.a;

    return o;
}
