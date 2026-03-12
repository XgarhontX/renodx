//
// Pixel Shader 3.0 - Sun Lens Flare
// Reconstructed from DX9 SM3.0 assembly
//

// --- Samplers ---
sampler2D Texture2D_0 : register(s0);

// --- Uniform Constants ---
float4 UniformVector_0 : register(c0);
// c1 : def float4(-0.5, 0, 0.5, 0.100000001)
float4 UniformVector_1 : register(c2);
float4 UniformVector_2 : register(c3);
float4 UniformVector_3 : register(c4);
float4 UniformVector_4 : register(c5);
// c6 : def float4(1000, 1, 0, 0)

#include "./common.hlsl"

// --- Input ---
struct PS_INPUT
{
    float2 v0 : TEXCOORD0;
    float3 v1 : TEXCOORD1;
    float1 v2 : TEXCOORD2; // dcl_texcoord2 v2.y
    float2 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4; // dcl_texcoord4_pp, only .w used
};

// --- Output ---
struct PS_OUTPUT
{
    float4 oC0 : COLOR0;
};

PS_OUTPUT main(PS_INPUT i)
{
    PS_OUTPUT o;

    const float4 c1 = float4(-0.5, 0.0, 0.5, 0.100000001);
    const float4 c6 = float4(1000.0, 1.0, 0.0, 0.0);

    float4 r0, r1, r2;

    // 0: add r0.xy, c1.x, v0
    r0.xy = c1.x + i.v0.xy;

    // 1: mov r1.y, c1.y
    r1.y = c1.y; // 0.0

    // 2: dp2add r0.z, c2, r0, r1.y
    //    r0.z = dot(c2.xy, r0.xy) + r1.y
    r0.z = dot(UniformVector_1.xy, r0.xy) + r1.y;

    // 4: dp2add r0.w, c3, r0, r1.y
    //    r0.w = dot(c3.xy, r0.xy) + r1.y
    r0.w = dot(UniformVector_2.xy, r0.xy) + r1.y;

    // 6: add r0.zw, r0, c1.z
    r0.z = r0.z + c1.z;
    r0.w = r0.w + c1.z;

    // 7: texld r2, r0.zwzw, s0
    r2 = tex2D(Texture2D_0, r0.zw);

    // 7: dp2add r0.z, c4, r0, r1.y
    //    r0.z = dot(c4.xy, r0.xy) + r1.y
    r0.z = dot(UniformVector_3.xy, r0.xy) + r1.y;

    // 9: dp2add r0.w, c5, r0, r1.y
    //    r0.w = dot(c5.xy, r0.xy) + r1.y
    r0.w = dot(UniformVector_4.xy, r0.xy) + r1.y;

    // 11: add r0.xy, r0.zwzw, c1.z
    r0.xy = r0.zw + c1.z;

    // 12: texld r0, r0, s0
    r0 = tex2D(Texture2D_0, r0.xy);

    // 12: mul r0.x, r2.y, r0.y
    r0.x = r2.y * r0.y;

    // 13: max r0.y, v2.y, c1.w
    r0.y = max(i.v2.x, c1.w);

    // 14: min r1.x, r0.y, c6.x
    r1.x = min(r0.y, c6.x);

    // 15: add_sat r0.y, -r1.x, c6.y
    r0.y = saturate(-r1.x + c6.y);

    // 16: mul r0.yzw, r0.y, v1.xxyz
    //     r0.y = r0.y * v1.x
    //     r0.z = r0.y * v1.y  (source r0.y is the pre-mul scalar, must cache)
    //     r0.w = r0.y * v1.z
    float _r0y = r0.y;
    r0.y = _r0y * i.v1.x;
    r0.z = _r0y * i.v1.y;
    r0.w = _r0y * i.v1.z;

    // 17: mul r0.xyz, r0.x, r0.yzww
    r0.xyz = r0.x * r0.yzw;

    // 18: mul r0.xyz, r0, v3.x
    r0.xyz = r0.xyz * i.v3.x;

    // 19: mad_pp r0.xyz, v3.y, r0, c0
    r0.xyz = i.v3.y * r0.xyz + UniformVector_0.xyz;

    // 20: mul_pp oC0.xyz, r0, v4.w
    o.oC0.xyz = r0.xyz * i.v4.w;

    // 21: mov_pp oC0.w, c1.y  (= 0.0)
    o.oC0.w = c1.y;

    o.oC0.xyz = SunPass(o.oC0.xyz, Texture2D_0, i.v0.xy, i.v4.w);


    return o;
}