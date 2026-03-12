#include "../shared.h"


//
// Pixel Shader 3.0 - Sun Bloom Aggregate Start
// Reconstructed from DX9 SM3.0 assembly + Vulkan cross-compile
// Loop-optimised version
//

// --- Samplers ---
sampler2D SceneColorTexture : register(s0);

// --- Uniform Constants ---
float4 PackedParameters : register(c0);
// c1 : def float4(60000, 1, 0, 0.0625)
float4 MinMaxBlurClamp   : register(c2);
float4 BloomScale        : register(c3);
// c4 : def float4(9.99999975e-005, 0.25, 0, 0)

// --- Input ---
struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD5;
    float4 v6 : TEXCOORD6;
    float4 v7 : TEXCOORD7;
};

// --- Output ---
struct PS_OUTPUT
{
    float4 oC0 : COLOR0;
};

// Performs the HDR decode + bloom accumulation for one sample
void ProcessTap(
    sampler2D tex,
    float2    uv,
    float4    c1,
    inout float4 r0,   // running sum of raw samples
    inout float3 r1,   // running sum of bloom colour
    inout float  r1ch  // r1.x or r1.w depending on tap parity
)
{
    float4 r2 = tex2D(tex, uv);
    float4 r3 = -r2.wxyz + c1.xyyy;
    r3.x = saturate(r3.x);
    r3.y = (r3.y >= 0.0) ? c1.z : c1.y;
    r3.z = (r3.z >= 0.0) ? c1.z : c1.y;
    r3.w = (r3.w >= 0.0) ? c1.z : c1.y;
    float3 r4xyz = r2.xyz * r3.x;
    r0 += r2;
    float dp = dot(r3.yzw, r3.yzw);
    float3 r2xyz = (-dp >= 0.0) ? c1.zzz : r4xyz;
    r1 += r2xyz;
}

PS_OUTPUT main(PS_INPUT i)
{
    PS_OUTPUT o;

    const float4 c1 = float4(60000.0, 1.0, 0.0, 0.0625);
    const float4 c4 = float4(9.99999975e-005, 0.25, 0.0, 0.0);

    float4 r0 = float4(0, 0, 0, 0);
    float4 r1 = float4(0, 0, 0, 0);
    float4 r2 = float4(0, 0, 0, 0);

    // Pack all 8 texcoord registers as rows of a float4 array:
    // each row carries two UV pairs:  .xy = tap A,  .wz = tap B
    float4 taps[8];
    taps[0] = i.v0;
    taps[1] = i.v1;
    taps[2] = i.v2;
    taps[3] = i.v3;
    taps[4] = i.v4;
    taps[5] = i.v5;
    taps[6] = i.v6;
    taps[7] = i.v7;

    // ---- Tap 0: special first tap writes r1.xyz via cmp_pp ----
    {
        r0 = tex2D(SceneColorTexture, taps[0].xy);
        float4 r1tmp = -r0.wxyz + c1.xyyy;
        r1tmp.x = saturate(r1tmp.x);
        // r1tmp.y = (r1tmp.y >= 0.0) ? c1.z : c1.y;
        // r1tmp.z = (r1tmp.z >= 0.0) ? c1.z : c1.y;
        // r1tmp.w = (r1tmp.w >= 0.0) ? c1.z : c1.y;
        r1tmp.yzw = c1.yyy; // ungated
        float3 r2xyz = r0.xyz * r1tmp.x;
        // float dp = dot(r1tmp.yzw, r1tmp.yzw);
        // r1.xyz = (-dp >= 0.0) ? c1.zzz : r2xyz;
        r1.xyz = r2xyz; // ungated
    }

    // ---- Tap 1: v0.wz, writes into r1.w then adds to r1.xyz ----
    {
        r2 = tex2D(SceneColorTexture, taps[0].wz);
        float4 r3 = -r2.wxyz + c1.xyyy;
        r3.x = saturate(r3.x);
        // r3.y = (r3.y >= 0.0) ? c1.z : c1.y;
        // r3.z = (r3.z >= 0.0) ? c1.z : c1.y;
        // r3.w = (r3.w >= 0.0) ? c1.z : c1.y;
        r3.yzw = c1.yyy; //ungated
        float3 r4xyz = r2.xyz * r3.x;
        r0 += r2;
        // r1.w = dot(r3.yzw, r3.yzw);
        // float3 r2xyz = (-r1.w >= 0.0) ? c1.zzz : r4xyz;
        float3 r2xyz = r4xyz; //ungated
        r1.xyz += r2xyz;
    }

    // ---- Taps 2-15: pairs from taps[1..7], each .xy then .wz ----
    [unroll]
    for (int t = 1; t < 8; t++)
    {
        // -- even tap: vN.xy --
        {
            r2 = tex2D(SceneColorTexture, taps[t].xy);
            float4 r3 = -r2.wxyz + c1.xyyy;
            r3.x = saturate(r3.x);
            // r3.yzw = (r3.yzw >= 0.0) ? c1.zzz : c1.yyy;
            r3.yzw = c1.yyy; //ungated
            float3 r4xyz = r2.xyz * r3.x;

            r0 += r2;
            // r1.w = dot(r3.yzw, r3.yzw);
            // float3 r2xyz = (-r1.w >= 0.0) ? c1.zzz : r4xyz;
            float3 r2xyz = r4xyz;  // ungated
            r1.xyz += r2xyz;
        }
        // -- odd tap: vN.wz --
        {
            r2 = tex2D(SceneColorTexture, taps[t].wz);
            float4 r3 = -r2.wxyz + c1.xyyy;
            r3.x = saturate(r3.x);
            // r3.yzw = (r3.yzw >= 0.0) ? c1.zzz : c1.yyy;
            r3.yzw = c1.yyy; //ungated
            float3 r4xyz = r2.xyz * r3.x;

            r0 += r2;
            r1.w = dot(r3.yzw, r3.yzw);
            // float3 r2xyz = (-r1.w >= 0.0) ? c1.zzz : r4xyz;
            float3 r2xyz = r4xyz; //ungated
            r1.xyz += r2xyz;
        }
    }

    // ---- Final accumulation & output ----

    if (TONE_MAP_TYPE > 0)
    {
        const float y = renodx::color::y::from::BT709(r1.xyz);
        if (y > 0) {
            float y1 = y;
            y1 = renodx::color::grade::Contrast(y1, C_BLOOM_CONTRAST * 1.12, 0.36);
            y1 = renodx::color::grade::Shadows(y1, 0.1, 0.36);
            y1 *= C_BLOOM;
            r1.xyz *= y1 / y;
            r1.xyz = max(r1.xyz, 0);
        }
    }

    // mul_pp r1.xyz, r1, c3.x
    r1.xyz = r1.xyz * BloomScale.x;

    // mul_pp r1.xyz, r1, c1.w
    r1.xyz = r1.xyz * c1.w;

    // mov r1.w, c1.w
    r1.w = c1.w;

    // mad_pp r0.w, r0.w, r1.w, -c0.x
    r0.w = r0.w * r1.w + (-PackedParameters.x);

    // mul_pp r0.xyz, r0, c1.w
    r0.xyz = r0.xyz * c1.w;

    // mul_sat r1.w, r0_abs.w, c0.y
    r1.w = saturate(abs(r0.w) * PackedParameters.y);

    // cmp_pp r0.w, r0.w, c2.y, c2.x
    r0.w = (r0.w >= 0.0) ? MinMaxBlurClamp.y : MinMaxBlurClamp.x;

    // max r2.x, r1.w, c4.x
    r2.x = max(r1.w, c4.x);

    // pow_pp r1.w, r2.x, c0.z
    r1.w = pow(r2.x, PackedParameters.z);

    // min_pp r2.w, r1.w, r0.w
    r2.w = min(r1.w, r0.w);

    // mad_pp r2.xyz, r2.w, r0, r1
    r2.xyz = r2.w * r0.xyz + r1.xyz;

    // mul oC0, r2, c4.y
    o.oC0 = r2 * c4.y;

    return o;
}