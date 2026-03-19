#include "./common.hlsl"

// Decompiled from DXBC cs_5_1 assembly
// Microsoft HLSL Shader Compiler 10.1
// Compute Shader: Tonemap + LUT + Vignette + Chromatic Aberration + Bloom + God Rays + Refraction

//-----------------------------------------------------------------------------
// Samplers
//-----------------------------------------------------------------------------
SamplerState g_point  : register(s6);
SamplerState g_linear : register(s7);

//-----------------------------------------------------------------------------
// Textures / UAVs
//-----------------------------------------------------------------------------
Texture2D<float4>    inputRT                    : register(t0);
Texture2D<float4>    inputGodRays               : register(t1);
Texture2D<float4>    inputRefraction            : register(t2);
Texture2D<float4>    inputLensDust              : register(t3);
Texture2D<float4>    inputBloom                 : register(t4);
Texture3D<float3>    lut3DTextureSRV            : register(t8);
Buffer<float>        g_sceneLuminanceAndExposure : register(t30);
RWTexture2D<float4>  outRWTexture               : register(u1);

//-----------------------------------------------------------------------------
// Constant Buffers
//-----------------------------------------------------------------------------

cbuffer ToneMapSettings : register(b0)
{
    uint   debugShowLuminance;              // [0].x  (unused)
    uint   debugShowCentreWeight;           // [0].y  (unused)
    uint   debugShowExposure;               // [0].z  (unused)
    uint   debugShowGradingClip;            // [0].w  (unused)
    float  exposureMaxExposure;             // [1].x  (unused)
    float  exposureMinExposure;             // [1].y  (unused)
    float  exposureCompensation;            // [1].z  (unused)
    float  exposureAdaptationSpeedDown;     // [1].w  (unused)
    float  exposureAdaptationSpeedUp;       // [2].x  (unused)
    float  exposureHistogramLowFraction;    // [2].y  (unused)
    float  exposureHistogramHighFraction;   // [2].z  (unused)
    float  exposureCentreWeight;            // [2].w  (unused)
    float  exposureManualAperture;          // [3].x  (unused)
    float  exposureManualISO;               // [3].y  (unused)
    float  exposureManualShutter;           // [3].z  (unused)
    float  tonemapBloomMax;                 // [3].w  (unused)
    float  tonemapBloomScale;               // [4].x  -- used: bloom scale
    float  tonemapLensStreaksScale;         // [4].y  (unused)
    float  tonemapLensDustScale;            // [4].z  -- used: lens dust scale / enable
    float  tonemapNumTapsDummy;             // [4].w  (unused in this shader)
    int    viewportYPxls;                   // [5].x  (unused)
    int    viewportWidthPxls;               // [5].y  (unused)
    int    viewportHeightPxls;              // [5].z  (unused)
    float  useIblExposure;                  // [5].w  (unused)
    float  iblExposureScale;                // [6].x  (unused)
    uint   enableGrading;                   // [6].y  (unused)
    float  gradingShaperMin;                // [6].z  (unused)
    float  gradingShaperMinRcp;             // [6].w  (unused)
    float  gradingShaperMaxRcp;             // [7].x  (unused)
    float  gradingShaperLogMin;             // [7].y  (unused)
    float  gradingShaperLogRange;           // [7].z  (unused)
    float  gradingShaperLogRangeRcp;        // [7].w  (unused)
    float  gradingLUTCubeScale;             // [8].x  -- used: LUT scale
    float  gradingLUTCubeBias;              // [8].y  -- used: LUT bias
    float  tonemap_Slope;                   // [8].z  (unused)
    float  tonemap_Toe;                     // [8].w  (unused)
    float  tonemap_Shoulder;                // [9].x  (unused)
    float  tonemap_ToeScale;                // [9].y  (unused)
    float  tonemap_ShoulderScale;           // [9].z  (unused)
    float  tonemap_ToeMatch;                // [9].w  (unused)
    float  tonemap_ShoulderMatch;           // [10].x (unused)
    float  tonemap_StraightMatch;           // [10].y (unused)
    float  tonemap_BlackClip;               // [10].z (unused)
    float  tonemap_WhiteClip;               // [10].w (unused)
    float  tonemap_BlueCorrection;          // [11].x (unused)
    float  tonemap_PreDesat;                // [11].y (unused)
    float  tonemap_PostDesat;               // [11].z (unused)
    float  tonemap_ExpandedGamut;           // [11].w (unused)
    float  tonemap_DebugOffset;             // [12].x (unused)
    float3 tonemap_Padding;                 // [12].yzw (unused)
    float4 tonemap_Tint;                    // [13].xyzw -- used: final tint multiply
    float2 tonemapOutputInvDim;             // [14].xy   -- used: 1/outputWidth, 1/outputHeight
    float2 tonemapOutputInvDim_pad;         // [14].zw   (unused padding)
};

cbuffer VignetteParams : register(b1)
{
    float4 vignetteParams1;     // [0].xyzw -- xy=scale, zw=offset
    float4 vignetteParams2;     // [1].xyzw -- x=rotation degrees
    float4 vignetteColourTL;    // [2].xyzw -- vignette tint colour
    float4 vignetteTransition;  // [3].xyzw -- x=slope, y=bias for smoothstep
    float  vignetteShape;       // [4].x    -- ellipse shape
    float  vignetteAmount;      // [4].y    -- vignette strength (0=disabled)
    float  vignetteBlend;       // [4].z    -- blend factor
    float  vignettePad;         // [4].w    (unused)
};

cbuffer ChromaticAberrationParams : register(b2)
{
    float chromaticAberrationK1;             // [0].x -- K1 barrel distortion coefficient
    float chromaticAberrationK2;             // [0].y -- K2 barrel distortion coefficient
    float chromaticAberrationMaxDistort;     // [0].z -- max distortion scale
    float chromaticAberrationNumTaps;        // [0].w -- number of sample taps
    float chromaticAberrationEffectOffset;   // [1].x -- radial offset added before distortion
    int   enableChromaticAberration;         // [1].y -- non-zero to enable
    float chromaticAberrationSpectrumScaleR; // [1].z -- R channel spectrum position
    float chromaticAberrationSpectrumScaleG; // [1].w -- G channel spectrum position
    float chromaticAberrationSpectrumScaleB; // [2].x -- B channel spectrum position
    float chromAbPad0;                       // [2].y (unused)
    float chromAbPad1;                       // [2].z (unused)
    float chromAbPad2;                       // [2].w (unused)
};

//-----------------------------------------------------------------------------
// g_scene cbuffer (register b4)
// Large scene constant buffer; only accessed fields are declared with correct
// byte offsets maintained via float4 padding arrays.
//
// Slot index N means byte offset N*16 from the start of the cbuffer.
// Accessed slots:
//   [625] vpUvToRenderTargetUvScaleBias         (.zw used)
//   [648] rtUvToNdcScaleBias                    (.xy bias, .zw scale)
//   [649] rtPixelCoordToRenderTargetUvScaleBias (.zw used)
//   [654] prevVpUvToRenderTargetUvScaleBias     (.xy and .zw used)
//-----------------------------------------------------------------------------
cbuffer g_scene : register(b4)
{
    float4 g_scene_pad0[625];                         // slots   0..624  (unused)
    float4 vpUvToRenderTargetUvScaleBias;             // slot  625 -- .zw = viewport->RT UV scale
    float4 g_scene_pad1[22];                          // slots 626..647  (unused)
    float4 rtUvToNdcScaleBias;                        // slot  648 -- .xy = bias, .zw = scale
    float4 rtPixelCoordToRtUvScaleBias;               // slot  649 -- .zw = per-pixel UV step (1/rtDims)
    float4 g_scene_pad2[4];                           // slots 650..653  (unused)
    float4 prevVpUvToRenderTargetUvScaleBias;         // slot  654 -- .xy scale, .zw bias
    float4 g_scene_pad3;                              // slot  655  (unused)
};

//-----------------------------------------------------------------------------
// Thread group: 8x8x1
//-----------------------------------------------------------------------------
[numthreads(8, 8, 1)]
void main(uint3 vThreadID : SV_DispatchThreadID)
{
    //-------------------------------------------------------------------------
    // r0.xy: compute normalised UV for this thread
    // Instructions 0-2
    //-------------------------------------------------------------------------
    float2 r0_xy = (float2(vThreadID.xy) + 0.5f) * tonemapOutputInvDim.xy;

    //-------------------------------------------------------------------------
    // r0.z / r0.w: read luminance and exposure from structured buffer
    // Instructions 3-5
    //   slot 1 = luminance, slot 2 = exposure (reciprocal stored, we invert)
    //-------------------------------------------------------------------------
    float r0_z = g_sceneLuminanceAndExposure[1];         // r0.z = luminance
    float r0_w = 1.0f / g_sceneLuminanceAndExposure[2];  // r0.w = 1/exposure

    //-------------------------------------------------------------------------
    // r1.xy: remap UV into god-rays / refraction texture space
    // Instruction 6: mad r1.xy, r0.xy, CB3[648].zw, CB3[648].xy
    //-------------------------------------------------------------------------
    float2 r1_xy = r0_xy * rtUvToNdcScaleBias.zw + rtUvToNdcScaleBias.xy;

    //-------------------------------------------------------------------------
    // Sample bloom (r2.xyz) at screen UV, god rays (r3.xyz) at remapped UV
    // Instructions 7-8
    //-------------------------------------------------------------------------
    float3 r2_xyz = inputBloom.SampleLevel(g_linear, r0_xy, 0.0f).xyz;
    float3 r3_xyz = inputGodRays.SampleLevel(g_linear, r1_xy, 0.0f).xyz;

    //-------------------------------------------------------------------------
    // Conditionally sample lens dust if tonemapLensDustScale > 0
    // Instructions 9-14: lt r1.z, 0, CB0[4].z  /  if_nz ... sample ... endif
    //-------------------------------------------------------------------------
    float3 r4_xyz;
    if (tonemapLensDustScale > 0.0f)
        r4_xyz = inputLensDust.SampleLevel(g_linear, r0_xy, 0.0f).xyz;
    else
        r4_xyz = float3(0.0f, 0.0f, 0.0f);

    //-------------------------------------------------------------------------
    // Sample refraction UV offset, add to remapped UV, clamp to viewport edge
    // Instructions 15-20
    //-------------------------------------------------------------------------
    // Instruction 15: sample_l r0.xy, r1.xy, T2  -> refraction UV delta
    float2 r0_xy_refrac = inputRefraction.SampleLevel(g_linear, r1_xy, 0.0f).xy;
    // Instruction 16: add r0.xy, r0.xy, r1.xy
    r0_xy_refrac += r1_xy;

    // Instructions 17-19: compute safe max UV = 0.5/rtDims - rtScale
    // utof r1.xy, CB3[649].zw  -> float pixel dimensions
    // div  r1.xy, 0.5, r1.xy   -> 0.5 / dims
    // add  r1.xy, -r1.xy, CB3[648].zw -> subtract from scale to get border
    // BUG FIX: rtPixelCoordToRtUvScaleBias.zw is the UV-per-pixel step (1/dims),
    // so 0.5 * step = half-pixel, then subtract from the scale-based max.
    float2 r1_xy_maxUV = 0.5f / float2(rtPixelCoordToRtUvScaleBias.zw)
                         - rtUvToNdcScaleBias.zw;
    // Instruction 20: min r0.xy, r0.xy, r1.xy
    r0_xy_refrac = min(r0_xy_refrac, r1_xy_maxUV);

    //-------------------------------------------------------------------------
    // Chromatic aberration (multi-tap) or plain point-sample of RT
    // Instructions 21-66
    //-------------------------------------------------------------------------
    float3 r1_xyz;

    if (enableChromaticAberration * SI.chromaticaberration > 1.f) // Instruction 21: if_nz CB2[1].y
    {
        // Instructions 22-23: remap refracted UV [0,1] -> NDC-like [-1,1]
        float2 r1_xy_ca = (r0_xy_refrac - 0.5f) * 2.0f;

        // Instruction 24: r1.z = numTaps - 1  (loop divisor)
        float r1_z = chromaticAberrationNumTaps - 1.0f;
        // Instruction 25: r1.w = spectrumScaleG - spectrumScaleR  (R range)
        float r1_w = chromaticAberrationSpectrumScaleG - chromaticAberrationSpectrumScaleR;
        // Instruction 26: r2.w = spectrumScaleG - spectrumScaleB  (B range)
        float r2_w = chromaticAberrationSpectrumScaleG - chromaticAberrationSpectrumScaleB;

        // Instruction 27-28: r3.w = dot(r1_xy_ca, r1_xy_ca) + effectOffset  (r^2 + bias)
        float r3_w = dot(r1_xy_ca, r1_xy_ca) + chromaticAberrationEffectOffset;
        // Instruction 30: r4.w = r3.w * r3.w  (r^4 for K2 term)
        float r4_w = r3_w * r3_w;

        // Instruction 29: r5.xy = safe max UV = rtScale * (1 - vpScale)
        // mad r5.xy, -CB3[625].zw, CB3[648].zw, CB3[648].zw
        float2 r5_xy = -vpUvToRenderTargetUvScaleBias.zw * rtUvToNdcScaleBias.zw
                        + rtUvToNdcScaleBias.zw;

        float3 r6_xyz = float3(0.0f, 0.0f, 0.0f); // weighted colour accumulator
        float3 r7_xyz = float3(0.0f, 0.0f, 0.0f); // weight accumulator

        float r5_z = 0.0f; // loop counter (matches asm float counter)
        [loop]
        while (true)
        {
            // Instructions 35-36: exit if r5.z >= numTaps
            if (r5_z >= chromaticAberrationNumTaps) break;

            // Instruction 37: r5.w = r5.z / r1.z  -> normalised tap t in [0,1]
            float r5_w = r5_z / r1_z;

            //--- Per-channel spectrum weights ---
            // Instructions 38-41: Red weight
            //   max(r5.w, specScaleG), min(..., specScaleR), sub specScaleR, div r1.w
            float r8_x = (clamp(r5_w, chromaticAberrationSpectrumScaleG,
                                       chromaticAberrationSpectrumScaleR)
                          - chromaticAberrationSpectrumScaleR) / r1_w;

            // Instructions 42-45: Blue intermediate (clamped, normalised)
            //   max(r5.w, specScaleB), min(..., specScaleG), sub specScaleB, div r2.w
            float r6_w = (clamp(r5_w, chromaticAberrationSpectrumScaleB,
                                       chromaticAberrationSpectrumScaleG)
                          - chromaticAberrationSpectrumScaleB) / r2_w;
            // Instruction 46: r8.z = 1 - r6.w  (blue weight, inverted)
            float r8_z = 1.0f - r6_w;
            // Instructions 47-48: r8.y = 1 - (r8.z + r8.x)  (green is remainder)
            float r8_y = 1.0f - (r8_z + r8_x);

            //--- Distorted UV for this tap ---
            // FIX: Instructions 49-50 in asm:
            //   mul r5.w,  r5.w,  CB2[0].z        -> r5.w = t * maxDistort
            //   mul r9.xy, r5.ww, CB2[0].xy        -> r9.x = r5.w*K1,  r9.y = r5.w*K2
            // Both K1 and K2 are scaled by (t * maxDistort), NOT just maxDistort alone.
            const float caScale = 0.1f * SI.chromaticaberration;
            float r5_w_scaled = r5_w * chromaticAberrationMaxDistort * caScale; // t * maxDistort
            float r9_x_k1     = r5_w_scaled * chromaticAberrationK1;  // t * maxDistort * K1
            float r9_y_k2     = r5_w_scaled * chromaticAberrationK2;  // t * maxDistort * K2

            // FIX: Instruction 51-52:
            //   mul r5.w,   r3.w,  r9.x             -> r5.w = r^2 * (t*maxDistort*K1)
            //   mad r9.xz, r5.ww, CB3[648].zzwz, 1  -> r9.x = r5.w*rtScale.x + 1
            //                                           r9.z = r5.w*rtScale.y + 1
            // Note the zzwz swizzle: .z maps to x-axis, .w maps to y-axis
            float  r5_w_k1term = r3_w * r9_x_k1;                               // r^2 * K1_scaled
            float2 r9_xz       = r5_w_k1term * rtUvToNdcScaleBias.zw + 1.0f;  // 1 + K1*r^2 per axis

            // FIX: Instructions 53-54:
            //   mul r5.w,   r4.w, r9.y              -> r5.w = r^4 * (t*maxDistort*K2)
            //   mad r9.xy, r5.ww, CB3[648].zwzz, r9.xzxx -> r9.xy += K2*r^4 per axis
            float  r5_w_k2term = r4_w * r9_y_k2;                               // r^4 * K2_scaled
            float2 r9_xy       = r5_w_k2term * rtUvToNdcScaleBias.zw + r9_xz; // add K2 term

            // Instruction 55: mul r9.xy, r1_xy_ca, r9.xy  -> apply distortion to NDC UV
            float2 r9_xy_dist = r1_xy_ca * r9_xy;
            // Instruction 56: mad r9.xy, r9.xy, 0.5, 0.5  -> back to [0,1] UV
            r9_xy_dist = r9_xy_dist * 0.5f + 0.5f;
            // Instruction 57: min r9.xy, r5.xy, r9.xy     -> clamp to safe region
            r9_xy_dist = min(r5_xy, r9_xy_dist);

            // Instruction 58: sample RT at distorted UV
            float3 r9_samp = inputRT.SampleLevel(g_linear, r9_xy_dist, 0.0f).xyz;

            // Instructions 59-60: accumulate weighted colour and weight
            r6_xyz += r9_samp * float3(r8_x, r8_y, r8_z);
            r7_xyz += float3(r8_x, r8_y, r8_z);

            // Instruction 61: r5.z += 1
            r5_z += 1.0f;
        }

        // Instruction 63: div r1.xyz, r6.xyz, r7.xyz  -> normalise by weight sum
        r1_xyz = r6_xyz / r7_xyz;
    }
    else // Instruction 64: else
    {
        // Instruction 65: plain point-sample of RT (no chrom. ab.)
        r1_xyz = inputRT.SampleLevel(g_point, r0_xy_refrac, 0.0f).xyz;
    }
    // Instruction 66: endif

    //-------------------------------------------------------------------------
    // Composite: scene + god rays + bloom + lens dust
    // Instructions 67-69
    //-------------------------------------------------------------------------
    // Instruction 67: add r1.xyz, r3.xyz, r1.xyz
    r1_xyz += r3_xyz * SI.godrays;
    // Instruction 68: mad r1.xyz, r2.xyz, CB0[4].x, r1.xyz
    r1_xyz += r2_xyz * (tonemapBloomScale * SI.bloom);
    // Instruction 69: mad r1.xyz, r4.xyz, CB0[4].z, r1.xyz
    r1_xyz += r4_xyz * (tonemapLensDustScale * SI.lensdust);

    //-------------------------------------------------------------------------
    // Apply auto-exposure
    // Instructions 70-71
    //   Instruction 70: mul r0.z, r0.w, r0.z  -> r0.z = (1/exposure) * luminance
    //   Instruction 71: mul r2.xyz, r0.zzzz, r1.xyz
    // NOTE: r0.z is kept alive through the vignette block and used at instr. 92!
    //-------------------------------------------------------------------------
    float r0_z_exp       = r0_w * r0_z;          // r0.z = exposure factor
    float3 r2_xyz_exposed = r0_z_exp * r1_xyz;   // r2.xyz = exposure-scaled colour

    //-------------------------------------------------------------------------
    // Vignette
    // Instructions 72-94
    //-------------------------------------------------------------------------

    // Instruction 72: lt r0.w, 0, CB1[4].y  -> r0.w = (vignetteAmount > 0) ? 1 : 0
    bool r0_w_vig = (vignetteAmount > 0.0f);

    // Instruction 73: mad r0.xy, r0.xy, CB3[654].xy, CB3[654].zw
    // Remap screen UV into vignette coordinate space
    float2 r0_xy_vig = r0_xy * prevVpUvToRenderTargetUvScaleBias.xy
                     + prevVpUvToRenderTargetUvScaleBias.zw;

    // Instructions 74-77: rotate vignette by vignetteParams2.x degrees
    float r1_w_vig = vignetteParams2.x * 0.017453f; // deg -> rad
    float sinA, cosA;
    sincos(r1_w_vig, sinA, cosA);
    // sincos writes: r3.x = sin(angle),  r4.x = cos(angle)
    // Instructions 76-77: r5.x = -sin,  r5.y = cos  (first dot product column)
    //                      r5.z = sin                (second dot product uses r5.y and r5.z)

    // Instructions 78-80: 2D rotation via two dp2's on r0.yx
    //   r4.x = dot(r0.yx, [-sin, cos])
    //   r4.y = dot(r0.yx, [ cos, sin])
    float2 rotated;
    rotated.x = dot(r0_xy_vig.yx, float2(-sinA, cosA));
    rotated.y = dot(r0_xy_vig.yx, float2( cosA, sinA));

    // Instructions 81-83: scale into ellipse space and apply magic constant
    //   mad r0.xy, rotated, CB1[4].x, CB1[0].zw  -> shape scale + offset
    //   mul r0.xy, r0.xy, CB1[0].xy               -> per-axis scale
    //   mul r0.xy, r0.xy, 0.89                    -> inner constant
    float2 r0_xy_vig2 = rotated * vignetteShape + vignetteParams1.zw;
    r0_xy_vig2        = r0_xy_vig2 * vignetteParams1.xy;
    r0_xy_vig2        = r0_xy_vig2 * 0.89f;

    // Instructions 84-85: radial distance squared, clamped to [0,1]
    float r0_x_dist2 = dot(r0_xy_vig2, r0_xy_vig2);
    r0_x_dist2       = min(r0_x_dist2, 1.0f);

    // Instructions 86-89: smoothstep  (3t^2 - 2t^3)
    //   mad_sat r0.x, dist2, CB1[3].x, CB1[3].y  -> t = saturate(dist2*slope + bias)
    //   mad     r0.y, -t, 2, 3                    -> 3 - 2t
    //   mul     r0.x, t, t                        -> t^2
    //   mul     r0.x, (3-2t), t^2                 -> smoothstep = (3-2t)*t^2
    float r0_x_t = saturate(r0_x_dist2 * vignetteTransition.x + vignetteTransition.y);
    float r0_y_t = -r0_x_t * 2.0f + 3.0f;
    r0_x_t       = r0_x_t * r0_x_t;
    r0_x_t       = r0_y_t * r0_x_t;

    // Instructions 90-91: modulate by vignetteAmount and vignetteBlend -> r0.x
    //   mul_sat r0.x, r0.x, CB1[4].y   -> saturate(smoothstep * vignetteAmount)
    //   mul     r0.x, r0.x, CB1[4].z   -> multiply by vignetteBlend
    float r0_x_vignAmt = saturate(r0_x_t * vignetteAmount * SI.vignette);
    r0_x_vignAmt       = r0_x_vignAmt * vignetteBlend;
    // r0.x now holds the final vignette blend weight

    // Instruction 92: mad r1.xyz, -r1.xyzx, r0.zzzz, CB1[2].xyzx
    // IMPORTANT: at this point in the asm r0.z is STILL r0_z_exp (the exposure
    // factor from instruction 70), NOT r0_x_vignAmt.  r1.xyz here is r2_xyz_exposed.
    //   r1.xyz = vignetteColourTL.xyz + (-r2_xyz_exposed) * r0_z_exp
    float3 r1_xyz_vig = vignetteColourTL.xyz - r2_xyz_exposed * r0_z_exp;

    // Instruction 93: mad r0.xyz, r0.xxxx, r1.xyzx, r2.xyzx
    // r0.x = r0_x_vignAmt, r1.xyz = above result, r2.xyz = r2_xyz_exposed
    //   r0.xyz = r0_x_vignAmt * r1_xyz_vig + r2_xyz_exposed
    float3 r0_xyz_final = r0_x_vignAmt * r1_xyz_vig + r2_xyz_exposed;

    // Instruction 94: movc r0.xyz, r0.wwww, r0.xyzx, r2.xyzx
    // movc selects src_if_nonzero when condition != 0:
    //   if vignette enabled -> use vignetted result, else use plain exposed colour
    r0_xyz_final = r0_w_vig ? r0_xyz_final : r2_xyz_exposed;

    //clamp BT2020
    r0_xyz_final = max(r0_xyz_final, 0.f);  // clamp bt2020

    //-------------------------------------------------------------------------
    // SDR log-shaper + 3D LUT lookup
    // Instructions 95-100
    //
    // The SDR path uses a direct mathematical log2 shaper instead of the
    // HDR path's 2000-entry ICB table lookup. Formula:
    //
    //   encoded = saturate( log2(linear + 0.002668) * 0.071429 + 0.610727 )
    //
    // Breaking down the constants:
    //   + 0.002668  : black offset / toe lift (prevents log2(0) = -inf)
    //   * 0.071429  : log range scale   = 1/14  (maps ~14 stops to [0,1])
    //   + 0.610727  : log range bias    (shifts the encoded midpoint)
    // The result is a normalised [0,1] value suitable as the 3D LUT input.
    //
    // Then scaled/biased into the LUT cube's actual UV range by:
    //   lutUV = encoded * gradingLUTCubeScale + gradingLUTCubeBias
    //-------------------------------------------------------------------------

    float3 x = r0_xyz_final;

    //exposure
    x *= SI.exposure;
    // x = mul(DCIP3_To_BT2020, x); x = renodx::color::pq::EncodeSafe(x, 203); outRWTexture[vThreadID.xy] = float4(x, 1); return; //debug
 
    //colorU
    float3 colorU = x;//DCI-P3

    //bandaid save exteme of extreme highlights
    const float saveMax = max(x.x, max(x.y, x.z));
    if (saveMax > 100.f) x *= 100.f / saveMax; //10000nits @ 100paper

    //encode 
    x = renodx::color::pq::Encode(x, 100.f); //matches scuffed 2000 entry PQ lookup array
    if (SI.peak_white_nits < 0.f) x = min(x, 0.508028f); //emulated broken

    //LUT to BT2020
    x = x * gradingLUTCubeScale + gradingLUTCubeBias;
    x = lut3DTextureSRV.SampleLevel(g_linear, x, 0.0f).xyz;

    //Tint
    x *= tonemap_Tint.xyz; //seems to boost up posthoc correct to 1000nits @ 203paper

    //decode
    x = renodx::color::pq::DecodeSafe(x, 203.f); //1000nits @ 203paper

    //Upgrade (stitch back on tonemapped/clamped luminance) & RenoDX Color Grade
    [branch]
    if (SI.tone_map_type > 0) x = UpgradeToneMap(colorU, x);

    // Paper White
    x *= SI.diffuse_white_nits / 203.f;

    // gamma correct
    [branch]
    if (SI.gamma_correction > 0) x = renodx::color::correct::Gamma(x, false, SI.gamma_correction);

    // HDR tonemap
    if (SI.tone_map_type > 0) {
        const float p = SI.peak_white_nits / SI.diffuse_white_nits;
        float y = renodx::color::y::from::BT2020(x);
        if (y > 0) {
            float y1 = y;
            [branch]
            if (SI.tone_map_type_hdr == 0.f) y1 = renodx::tonemap::Reinhard(y1, p);
            else if (SI.tone_map_type_hdr == 1.f) y1 = renodx::tonemap::HermiteSplineLuminanceRolloff(y1, p, SI.expected_peak_white_nits * 20000.f / SI.diffuse_white_nits);
            else y1 = renodx::tonemap::Neutwo(y1, p);
            x *= y1 / y;
        }
    }

    // to Display Output
    x = renodx::color::pq::Encode(x, SI.diffuse_white_nits);

    //-------------------------------------------------------------------------
    // Write output (alpha = 1)
    // Instructions 101-103
    //-------------------------------------------------------------------------

    outRWTexture[vThreadID.xy] = float4(x, 1.0f);
}