// Pixel Shader 3.0 - UI Shader
// Reconstructed from DX9 SM3.0 assembly + Vulkan cross-compile

// --- Samplers ---
sampler2D Texture2D_0 : register(s0);
sampler2D Texture2D_1 : register(s1);
sampler2D Texture2D_2 : register(s2);
sampler2D Texture2D_3 : register(s3);

// --- Uniform Constants ---
float4 UniformVector_0 : register(c0);
// c1 is a def: float4(-0.100000001, -0.200000003, -0.400000006, -1)
float4 UniformVector_1 : register(c2);
float4 UniformVector_2 : register(c3);
float4 UniformVector_3 : register(c4);
float4 UniformVector_4 : register(c5);
float4 UniformScalar_1 : register(c6);
float4 UniformScalar_3 : register(c7);
float4 UniformScalar_5 : register(c8);
float4 UniformScalar_13 : register(c9);
float4 UniformScalar_17 : register(c10);
float4 UniformScalar_18 : register(c11);
float4 UniformScalar_26 : register(c12);
// c13 is a def: float4(512, 20, -0.5, 5)
// c14 is a def: float4(0, 40, 0.150000006, 0.5)

// --- Input ---
struct PS_INPUT
{
    float2 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD4;
};

// --- Output ---
struct PS_OUTPUT
{
    float4 oC0 : COLOR0;
};

#include "../shared.h"

PS_OUTPUT main(PS_INPUT i)
{
    if (!UI) discard;

    PS_OUTPUT o;

    const float4 c1  = float4(-0.100000001, -0.200000003, -0.400000006, -1);
    const float4 c13 = float4(512, 20, -0.5, 5);
    const float4 c14 = float4(0, 40, 0.150000006, 0.5);

    float4 r0, r1, r2, r3;

    // texld r0, c10.x, s0
    r0 = tex2D(Texture2D_0, UniformScalar_17.xx);

    // add r0.x, r0.y, c13.z
    r0.x = r0.y + c13.z;

    // mul r0.x, r0.x, c11.x
    r0.x = r0.x * UniformScalar_18.x;

    // mul r0.y, r0.x, c13.w
    r0.y = r0.x * c13.w;

    // mov r1.xy, c13
    r1.xy = c13.xy;

    // mad r0.y, c12.x, r1.y, r0.y
    r0.y = UniformScalar_26.x * r1.y + r0.y;

    // add r2.z, r0.y, c1.w
    r2.z = r0.y + c1.w;

    // mov r2.yw, c14.x
    r2.y = c14.x;
    r2.w = c14.x;

    // mad r0.yz, v0.xxyw, c14, -r2.xzww
    r0.y = i.v0.x * c14.y - r2.z;
    r0.z = i.v0.y * c14.z - r2.w;

    // add r0.yz, r0, c5.xxyw
    r0.y = r0.y + UniformVector_4.x;
    r0.z = r0.z + UniformVector_4.y;

    // texld r3, r0.yzzw, s3
    r3 = tex2D(Texture2D_3, r0.yz);

    // mad r0.y, c9.x, r1.y, r1.y
    r0.y = UniformScalar_13.x * r1.y + r1.y;

    // mad r2.x, r0.x, c13.w, r0.y
    r2.x = r0.x * c13.w + r0.y;

    // mad r0.xy, v0, c14.yzzw, -r2
    r0.x = i.v0.x * c14.y - r2.x;
    r0.y = i.v0.y * c14.z - r2.y;

    // add r0.xy, r0, c4
    r0.xy = r0.xy + UniformVector_3.xy;

    // add r0.zw, r0.xyxy, -c14.xywx
    r0.z = r0.x - c14.w;
    r0.w = r0.y - c14.x;

    // texld r2, r0, s1
    r2 = tex2D(Texture2D_1, r0.xy);

    // texld r0, r0.zwzw, s2
    r0 = tex2D(Texture2D_2, r0.zw);

    // add_sat r0.x, r2.x, r0.x
    r0.x = saturate(r2.x + r0.x);

    // mul_pp oC0.w, r3.x, r0.x
    o.oC0.w = r3.x * r0.x;
		o.oC0.w = saturate(o.oC0.w);

    // mad_sat r0.x, v0.y, -r1.x, c6.x
    r0.x = saturate(i.v0.y * (-r1.x) + UniformScalar_1.x);

    // mad_sat r0.y, v0.y, r1.x, -c7.x
    r0.y = saturate(i.v0.y * r1.x + (-UniformScalar_3.x));

    // add r0.x, r0.x, r0.y
    r0.x = r0.x + r0.y;

    // add_sat r0.x, r0.x, c8.x
    r0.x = saturate(r0.x + UniformScalar_5.x);

    // mov r1.xyz, c2
    r1.xyz = UniformVector_1.xyz;

    // add r0.yzw, -r1.xxyz, c3.xxyz
    r0.y = -r1.x + UniformVector_2.x;
    r0.z = -r1.y + UniformVector_2.y;
    r0.w = -r1.z + UniformVector_2.z;

    // mad r0.xyz, r0.x, r0.yzww, c2
    r0.xyz = r0.x * r0.yzw + UniformVector_1.xyz;

    // add r0.xyz, r0, c1
    r0.xyz = r0.xyz + c1.xyz;

    // mad r0.xyz, r2.y, r0, c0
    r0.xyz = r2.y * r0.xyz + UniformVector_0.xyz;

    // add_pp r0.xyz, r0, -c1
    r0.xyz = r0.xyz + (-c1.xyz);

    // mad_pp oC0.xyz, r0, v1.w, v1
    o.oC0.xyz = r0.xyz * i.v1.w + i.v1.xyz;
		o.oC0.xyz = saturate(o.oC0.xyz);

    return o;
}