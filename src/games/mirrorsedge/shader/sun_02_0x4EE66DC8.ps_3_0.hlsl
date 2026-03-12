#include "./common.hlsl"
// sampler2D Texture2D_0 : register(s0);
// float4 UniformVector_0 : register(c0);
// 
// struct PS_IN {
//   float2 texcoord : TEXCOORD;
//   float3 texcoord1 : TEXCOORD1;
//   float2 texcoord2 : TEXCOORD2;
//   float2 texcoord3 : TEXCOORD3;
//   float4 texcoord4 : TEXCOORD4;
// };
// 
// float4 main(PS_IN i) : COLOR {
//   float4 o;
// 
//   float4 r0;
//   float4 r1;
//   float2 r2;
//   r0.xy = -0.5 + i.texcoord.xy;
//   r0.z = dot(-0.12467473, r0.x) + 0;
//   r0.w = dot(0.12467473, r0.x) + 0;
//   r0.xy = r0.zw + 0.5;
//   r0 = tex2D(Texture2D_0, r0);
//   r1 = tex2D(Texture2D_0, i.texcoord);
//   r0.xyz = r0.xyz * r1.xyz;
//   r0.w = max(i.texcoord2.y, 0.1);
//   r1.x = min(r0.w, 1000);
//   r0.w = -r1.x + 1;
//   r1.xyz = r0.w * i.texcoord1.xyz;
//   r0.xyz = r0.xyz * r1.xyz;
//   r1.xy = max(i.texcoord3.yx, float2(0.1, 1));
//   r2.xy = min(r1.xy, 1000);
//   r0.xyz = r0.xyz * r2.y;
//   r0.xyz = r2.x * r0.xyz + UniformVector_0.xyz;
//   o.xyz = r0.xyz * i.texcoord4.w;
//   o.xyz = SunPass(o.xyz, Texture2D_0, i.texcoord.xy, i.texcoord4.w);
//   o.w = 0;
// 
//   return o;
// }
// 
// // ps_3_0
// //       0x000000C4 : def c1, 0.100000001, 1, 1000, -0.5
// //       0x000000DC : def c2, 0.992197692, -0.12467473, 0, 0.12467473
// //       0x000000F4 : dcl_texcoord v0.xy
// //       0x00000100 : dcl_texcoord1 v1.xyz
// //       0x0000010C : dcl_texcoord2 v2.y
// //       0x00000118 : dcl_texcoord3 v3.xy
// //       0x00000124 : dcl_texcoord4_pp v4.w
// //       0x00000130 : dcl_2d s0
// //    0 0x0000013C : add r0.xy, c1.w, v0
// //    1 0x0000014C : dp2add r0.z, c2, r0, c2.z
// //    3 0x00000160 : dp2add r0.w, c2.wxzw, r0, c2.z
// //    5 0x00000174 : add r0.xy, r0.zwzw, -c1.w
// //    6 0x00000184 : texld r0, r0, s0
// //    6 0x00000194 : texld r1, v0, s0
// //    6 0x000001A4 : mul r0.xyz, r0, r1
// //    7 0x000001B4 : max r0.w, v2.y, c1.x
// //    8 0x000001C4 : min r1.x, r0.w, c1.z
// //    9 0x000001D4 : add_sat r0.w, -r1.x, c1.y
// //   10 0x000001E4 : mul r1.xyz, r0.w, v1
// //   11 0x000001F4 : mul r0.xyz, r0, r1
// //   12 0x00000204 : max r1.xy, v3.yxzw, c1
// //   13 0x00000214 : min r2.xy, r1, c1.z
// //   14 0x00000224 : mul r0.xyz, r0, r2.y
// //   15 0x00000234 : mad_pp r0.xyz, r2.x, r0, c0
// //   16 0x00000248 : mul_pp oC0.xyz, r0, v4.w
// //   17 0x00000258 : mov_pp oC0.w, c2.z


//
// Pixel Shader 3.0 - Sun Lens Flare
// Reconstructed from DX9 SM3.0 assembly + Vulkan cross-compile
//

// --- Samplers ---
sampler2D Texture2D_0 : register(s0);

// --- Uniform Constants ---
float4 UniformVector_0 : register(c0);
// c1 : def float4(0.100000001, 1, 1000, -0.5)
// c2 : def float4(0.992197692, -0.12467473, 0, 0.12467473)

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

//TODO: still not 100% exact
PS_OUTPUT main(PS_INPUT i)
{
    PS_OUTPUT o;

    const float4 c1 = float4(0.100000001, 1.0, 1000.0, -0.5);
    const float4 c2 = float4(0.992197692, -0.12467473, 0.0, 0.12467473);

    float4 r0, r1, r2;

    // add r0.xy, c1.w, v0
    r0.xy = c1.w + i.v0.xy;

    // dp2add r0.z, c2, r0, c2.z
    // r0.z = dot(c2.xy, r0.xy) + c2.z
    r0.z = dot(c2.xy, r0.xy) + c2.z;

    // dp2add r0.w, c2.wxzw, r0, c2.z
    // c2.wxzw -> xy used = c2.w, c2.x
    // r0.w = dot(float2(c2.w, c2.x), r0.xy) + c2.z
    r0.w = dot(float2(c2.w, c2.x), r0.xy) + c2.z;

    // add r0.xy, r0.zwzw, -c1.w
    r0.xy = r0.zw + (-c1.w);

    // texld r0, r0, s0
    r0 = tex2D(Texture2D_0, r0.xy);

    // texld r1, v0, s0
    r1 = tex2D(Texture2D_0, i.v0.xy);

    // mul r0.xyz, r0, r1
    r0.xyz = r0.xyz * r1.xyz;

    // max r0.w, v2.y, c1.x
    r0.w = max(i.v2.x, c1.x);

    // min r1.x, r0.w, c1.z
    r1.x = min(r0.w, c1.z);

    // add_sat r0.w, -r1.x, c1.y
    r0.w = saturate(-r1.x + c1.y);

    // mul r1.xyz, r0.w, v1
    r1.xyz = r0.w * i.v1.xyz;

    // mul r0.xyz, r0, r1
    r0.xyz = r0.xyz * r1.xyz;

    // max r1.xy, v3.yxzw, c1
    // v3.yxzw -> xy used = v3.y, v3.x
    // c1 used as float2 -> c1.x, c1.y
    r1.xy = max(float2(i.v3.y, i.v3.x), c1.xy);

    // min r2.xy, r1, c1.z
    r2.xy = min(r1.xy, c1.z);

    // mul r0.xyz, r0, r2.y
    r0.xyz = r0.xyz * r2.y;

    // mad_pp r0.xyz, r2.x, r0, c0
    r0.xyz = r2.x * r0.xyz + UniformVector_0.xyz;

    // mul_pp oC0.xyz, r0, v4.w
    o.oC0.xyz = r0.xyz * i.v4.w;
    o.oC0.xyz = SunPass(o.oC0.xyz, Texture2D_0, i.v0.xy, i.v4.w);

    // mov_pp oC0.w, c2.z  (= 0.0)
    o.oC0.w = c2.z;

    return o;
}