#include "./common.hlsl"

static const float4 icb[10] =
{
    { -4.000000f, -0.718548f, -4.970622f,  0.808913f },
    { -4.000000f,  2.081031f, -3.029378f,  1.191087f },
    { -3.157377f,  3.668124f, -2.126200f,  1.568300f },
    { -0.485250f,  4.000000f, -1.510500f,  1.948300f },
    {  1.847732f,  4.000000f, -1.057800f,  2.308300f },
    {  1.847732f,  4.000000f, -0.466800f,  2.638400f },
    {  0.000000f,  0.000000f,  0.119380f,  2.859500f },
    {  0.000000f,  0.000000f,  0.708813f,  2.987261f },
    {  0.000000f,  0.000000f,  1.291187f,  3.012739f },
    {  0.000000f,  0.000000f,  1.291187f,  3.012739f }
};

// Quadratic B-spline on 3 knots from icb[idx..idx+2], column col, at parameter t.
float EvalSpline(int idx, float t, int col)
{
    float3 p;
    if      (col == 0) p = float3(icb[idx].x, icb[idx+1].x, icb[idx+2].x);
    else if (col == 1) p = float3(icb[idx].y, icb[idx+1].y, icb[idx+2].y);
    else if (col == 2) p = float3(icb[idx].z, icb[idx+1].z, icb[idx+2].z);
    else               p = float3(icb[idx].w, icb[idx+1].w, icb[idx+2].w);

    float a = dot(float3(p.x, p.z, p.y), float3(0.5f, 0.5f, -1.0f));
    float b = dot(p.xy, float2(-1.0f, 1.0f));
    float c = dot(p.xy, float2( 0.5f, 0.5f));
    return a*t*t + b*t + c;
}

float DecodeSplineInner(float v)
{
    if (v > -17.473932f && v < -2.473931f)
    {
        float u  = v * 0.301030f + 5.260178f;
        float fi = u * 0.664386f;
        int   idx = (int)trunc(fi);
        return EvalSpline(idx, fi - trunc(fi), 0);
    }
    if (v >= -2.473931f && v < 15.526069f)
    {
        float u  = v * 0.301030f + 0.744727f;
        float fi = u * 0.553655f;
        int   idx = (int)trunc(fi);
        return EvalSpline(idx, fi - trunc(fi), 1);
    }
    return (v <= -17.473932f) ? -4.0f : 4.0f;
}

float EncodeSplineInner(float v)
{
    if (-12.783868f >= v)
        return v * 0.903090f + 7.544983f;

    if (v > -12.783868f && v < 2.263035f)
    {
        float u  = v * 0.301030f + 3.848328f;
        float fi = u * 1.545401f;
        int   idx = (int)trunc(fi);
        return EvalSpline(idx, fi - trunc(fi), 2);
    }
    if (v >= 2.263035f && v < 12.137337f)
    {
        float u  = v * 0.301030f - 0.681241f;
        float fi = u * 2.354951f;
        int   idx = (int)trunc(fi);
        return EvalSpline(idx, fi - trunc(fi), 3);
    }
    return v * 0.018062f + 2.780778f;
}

cbuffer ToneMapSettings : register(b0)
{
    uint  debugShowLuminance;
    uint  debugShowCentreWeight;
    uint  debugShowExposure;
    uint  debugShowGradingClip;
    float exposureMaxExposure;
    float exposureMinExposure;
    float exposureCompensation;
    float exposureAdaptationSpeedDown;
    float exposureAdaptationSpeedUp;
    float exposureHistogramLowFraction;
    float exposureHistogramHighFraction;
    float exposureCentreWeight;
    float exposureManualAperture;
    float exposureManualISO;
    float exposureManualShutter;
    float tonemapBloomMax;
    float tonemapBloomScale;
    float tonemapLensStreaksScale;
    float tonemapLensDustScale;
    int   viewportXPxls;
    int   viewportYPxls;
    int   viewportWidthPxls;
    int   viewportHeightPxls;
    float useIblExposure;
    float iblExposureScale;
    uint  enableGrading;
    float gradingShaperMin;
    float gradingShaperMinRcp;
    float gradingShaperMaxRcp;
    float gradingShaperLogMin;
    float gradingShaperLogRange;
    float gradingShaperLogRangeRcp;
    float gradingLUTCubeScale;
    float gradingLUTCubeBias;
    float tonemap_Slope;
    float tonemap_Toe;
    float tonemap_Shoulder;
    float tonemap_ToeScale;
    float tonemap_ShoulderScale;
    float tonemap_ToeMatch;
    float tonemap_ShoulderMatch;
    float tonemap_StraightMatch;
    float tonemap_BlackClip;
    float tonemap_WhiteClip;
    float tonemap_BlueCorrection;
    float tonemap_PreDesat;
    float tonemap_PostDesat;
    float tonemap_ExpandedGamut;
    float tonemap_DebugOffset;
    float3 tonemap_Padding;
    float4 tonemap_Tint;
    float2 tonemapOutputInvDim;
};

cbuffer g_scene : register(b4)
{
    float4 _g_scene_pad[644];
    float4 _g_scene_slot644;
};

cbuffer ColorGradingParams : register(b5)
{
    float4 global_0; float4 global_1; float4 global_2; float4 global_3;
    float4 global_4; float4 global_5; float4 global_6; float4 global_7;

    float4 shadows_0; float4 shadows_1; float4 shadows_2; float4 shadows_3;
    float4 shadows_4; float4 shadows_5; float4 shadows_6; float4 shadows_7;

    float4 midtones_0; float4 midtones_1; float4 midtones_2; float4 midtones_3;
    float4 midtones_4; float4 midtones_5; float4 midtones_6; float4 midtones_7;

    float4 highlights_0; float4 highlights_1; float4 highlights_2; float4 highlights_3;
    float4 highlights_4; float4 highlights_5; float4 highlights_6; float4 highlights_7;

    float4 gradingScalars;
};

RWTexture3D<float4> lut3DTextureUAV : register(u0);

float3 ApplyGrading(
    float4 g0, float4 g1, float4 g2, float4 g3, float4 g5, float4 g6, float4 g7,
    float4 z0, float4 z1, float4 z2, float4 z3, float4 z5, float4 z6, float4 z7,
    float3 chromaOffset, float luma)
{
    float4 p0  = g0 * z0;
    float3 p1  = g1.xyz * z1.xyz;
    float4 p2  = float4(g2.x * z2.x, g2.y * z2.y, g2.y * z2.z, g2.y * z2.w);

    float3 v = max(p0.xyz * chromaOffset + luma, 0.0f);
    v *= 5.586592f;
    float3 vl = log2(v);
    vl.x *= p0.w;  v.x = exp2(vl.x);
    vl.yz *= p1.xy; v.yz = exp2(vl.yz);
    v *= 0.179f;
    vl.x = log2(v.x); vl.x *= p1.z; v.x = exp2(vl.x);
    vl.yz = log2(v.yz); vl.y *= p1.z; v.y = exp2(vl.y);
    vl.z *= p2.x; v.z = exp2(vl.z);
    v *= p2.yzw;
    v.x = v.x * (g5.x * z5.x) + (g5.y * z5.y);
    v.y = v.y * (g6.x * z6.x) + (g6.y * z6.y);
    v.z = v.z * (g7.x * z7.x) + (g7.y * z7.y);
    v += g3.yzw + z3.yzw;
    return v;
}

[numthreads(32, 1, 1)]
void main(
    uint3 vThreadGroupID   : SV_GroupID,
    uint  vThreadIDInGroup : SV_GroupThreadID)
{
    float3 r0xyz = float3((float)vThreadIDInGroup,
                          (float)vThreadGroupID.y,
                          (float)vThreadGroupID.z) * 0.032258f;

    // PQ decode
    // r0xyz = exp2(log2(r0xyz) * 0.012683f);
    // float3 r1num = max(r0xyz - 0.835938f, 0.0f);
    // float3 r1den = -r0xyz * 18.687500f + 18.851562f;
    // r0xyz = exp2(log2(r1num / r1den) * 6.277395f) * 100.0f;
    r0xyz = renodx::color::pq::DecodeSafe(r0xyz, 100.f);
    float3 r0xyzBackup = r0xyz;

    // White balance — CCT → (u,v)
    float wbTemp = gradingScalars.z;
    float r0w    = wbTemp * 1.000556f;
    bool  wbWarm = (6996.107910f >= wbTemp);
    float2 r1yz  = float2(4607000064.0f, 2006400000.0f) / r0w;
    r1yz = (-r1yz + float2(2967800.0f, 1901800.0f)) / r0w;
    r1yz = (r1yz  + float2(99.110001f, 247.479996f))  / r0w;
    r1yz += float2(0.244063f, 0.237040f);
    float r1x = wbWarm ? r1yz.x : r1yz.y;

    // Planckian white-point XYZ
    float r0w2 = r1x * r1x * (-3.0f) + r1x * 2.870000f;
    float r1y2 = r0w2 - 0.275000f;
    float3 r2  = wbTemp * float3(0.000154f, 0.000842f, 0.000042f)
               + float3(0.860118f, 1.000000f, 0.317399f)
               + (wbTemp * wbTemp) * float3(0.0f, 0.000001f, 0.0f);
    float r1z3 = r2.x / r2.y;
    float r0w4 = r2.z / (-wbTemp * 0.000029f + 1.0f);
    float r1z4 = r1z3 * 2.0f - r0w4 * 8.0f + 4.0f;
    float r2xw = (r1z3 * 3.0f) / r1z4;
    float r0w5 = (r0w4 * 2.0f) / r1z4;
    bool  wbLt4k = (wbTemp < 4000.0f);
    float r1xu   = wbLt4k ? r2xw : r1x;
    float r1yv   = wbLt4k ? r0w5 : r1y2;
    float r0w6   = max(r1yv, 0.0f);
    float3 r2wb  = float3(r1xu / r0w6, 1.0f, (1.0f - r1xu - r1yv) / r0w6);

    // von Kries CAT → 3×3 WB matrix
    float r0w7 = dot(float3( 0.895100f,  0.266400f, -0.161400f), r2wb);
    float r1x3 = dot(float3(-0.750200f,  1.713500f,  0.036700f), r2wb);
    float r1y3 = dot(float3( 0.038900f, -0.068500f,  1.029600f), r2wb);
    float  scL  = 0.941379f  / r0w7;
    float2 scMC = float2(1.040436f, 1.089767f) / float2(r1x3, r1y3);
    float3 col0 = scL    * float3( 0.895100f,  0.266400f, -0.161400f);
    float3 col1 = scMC.x * float3(-0.750200f,  1.713500f,  0.036700f);
    float3 col2 = scMC.y * float3( 0.038900f, -0.068500f,  1.029600f);
    float3 r4v  = float3(col0.x, col1.x, col2.x);
    float3 r6v  = float3(col0.y, col1.y, col2.y);
    float3 r3v  = float3(col0.z, col1.z, col2.z);
    float3 r5v, r1m3, r2m3;
    r5v.x  = dot(float3( 0.986993f, -0.147054f,  0.159963f), r4v);
    r5v.y  = dot(float3( 0.986993f, -0.147054f,  0.159963f), r6v);
    r5v.z  = dot(float3( 0.986993f, -0.147054f,  0.159963f), r3v);
    r1m3.x = dot(float3( 0.432305f,  0.518360f,  0.049291f), r4v);
    r1m3.y = dot(float3( 0.432305f,  0.518360f,  0.049291f), r6v);
    r1m3.z = dot(float3( 0.432305f,  0.518360f,  0.049291f), r3v);
    r2m3.x = dot(float3(-0.008529f,  0.040043f,  0.968487f), r4v);
    r2m3.y = dot(float3(-0.008529f,  0.040043f,  0.968487f), r6v);
    r2m3.z = dot(float3(-0.008529f,  0.040043f,  0.968487f), r3v);
    float3 r3a, r4a, r5a;
    r3a.x = dot(r5v,   float3(0.412456f, 0.212673f, 0.019334f));
    r4a.x = dot(r5v,   float3(0.357576f, 0.715152f, 0.119192f));
    r5a.x = dot(r5v,   float3(0.180438f, 0.072175f, 0.950304f));
    r3a.y = dot(r1m3,  float3(0.412456f, 0.212673f, 0.019334f));
    r4a.y = dot(r1m3,  float3(0.357576f, 0.715152f, 0.119192f));
    r5a.y = dot(r1m3,  float3(0.180438f, 0.072175f, 0.950304f));
    r3a.z = dot(r2m3,  float3(0.412456f, 0.212673f, 0.019334f));
    r4a.z = dot(r2m3,  float3(0.357576f, 0.715152f, 0.119192f));
    r5a.z = dot(r2m3,  float3(0.180438f, 0.072175f, 0.950304f));
    float3 r1wb, r2wb2, r3wb;
    r1wb.x  = dot(float3( 3.240970f, -1.537383f, -0.498611f), r3a);
    r1wb.y  = dot(float3( 3.240970f, -1.537383f, -0.498611f), r4a);
    r1wb.z  = dot(float3( 3.240970f, -1.537383f, -0.498611f), r5a);
    r2wb2.x = dot(float3(-0.969244f,  1.875968f,  0.041555f), r3a);
    r2wb2.y = dot(float3(-0.969244f,  1.875968f,  0.041555f), r4a);
    r2wb2.z = dot(float3(-0.969244f,  1.875968f,  0.041555f), r5a);
    r3wb.x  = dot(float3( 0.055630f, -0.203977f,  1.056972f), r3a);
    r3wb.y  = dot(float3( 0.055630f, -0.203977f,  1.056972f), r4a);
    r3wb.z  = dot(float3( 0.055630f, -0.203977f,  1.056972f), r5a);
    float3 r1pwb;
    r1pwb.x = dot(r1wb,  r0xyz);
    r1pwb.y = dot(r2wb2, r0xyz);
    r1pwb.z = dot(r3wb,  r0xyz);
    r1pwb = lerp(r0xyzBackup, r1pwb, SI.lut_whitebalance); //user settings

    // sRGB → AP1
    float3 r0ap1;
    r0ap1.x = dot(float3(0.613191f,  0.339512f,  0.047366f), r1pwb);
    r0ap1.y = dot(float3(0.070207f,  0.916336f,  0.013450f), r1pwb);
    r0ap1.z = dot(float3(0.020619f,  0.109567f,  0.869607f), r1pwb);

    // Expanded gamut blend
    float r0wl = dot(r0ap1, float3(0.272229f, 0.674082f, 0.053690f));
    float3 chr = r0ap1 / r0wl - 1.0f;
    float  chmask = 1.0f - exp2(dot(chr, chr) * (-4.0f));
    float  lumask = 1.0f - exp2(r0wl * r0wl * tonemap_ExpandedGamut * SI.lut_expandgamut * (-4.0f));
    float  egmask = lumask * chmask;
    float3 r1wide;
    r1wide.x = dot(float3( 1.370413f, -0.329291f, -0.063683f), r0ap1);
    r1wide.y = dot(float3(-0.083434f,  1.097091f, -0.010862f), r0ap1);
    r1wide.z = dot(float3(-0.025793f, -0.098626f,  1.203694f), r0ap1);
    r0ap1 = egmask * (r1wide - r0ap1) + r0ap1;

    // Colour grading
    float3 r0ap1Backup = r0ap1;
    float  r0wg  = dot(r0ap1, float3(0.272229f, 0.674082f, 0.053690f));
    float3 r0co  = r0ap1 - r0wg;
    float3 r3g   = ApplyGrading(global_0,global_1,global_2,global_3,global_5,global_6,global_7,
                                 shadows_0,shadows_1,shadows_2,shadows_3,shadows_5,shadows_6,shadows_7,
                                 r0co, r0wg);
    float  r1xt  = saturate(r0wg / gradingScalars.x);
    float  r1yt  = r1xt * (-2.0f) + 3.0f;
    r1xt         = r1xt * r1xt;
    float  r1sw  = -(r1yt * r1xt) + 1.0f;

    float3 r4g   = ApplyGrading(global_0,global_1,global_2,global_3,global_5,global_6,global_7,
                                 highlights_0,highlights_1,highlights_2,highlights_3,highlights_5,highlights_6,highlights_7,
                                 r0co, r0wg);
    float  r1y5  = 1.0f / (1.0f - gradingScalars.y);
    float  r1y6  = saturate(r1y5 * (r0wg - gradingScalars.y));
    float  r1z6  = r1y6 * (-2.0f) + 3.0f;
    r1y6         = r1y6 * r1y6;
    float  r1wh  = r1y6 * r1z6;

    float3 r5g   = ApplyGrading(global_0,global_1,global_2,global_3,global_5,global_6,global_7,
                                 midtones_0,midtones_1,midtones_2,midtones_3,midtones_5,midtones_6,midtones_7,
                                 r0co, r0wg);
    float  r0xm  = (1.0f - r1sw) - (r1z6 * r1y6);
    float3 r0bl  = r0xm * r5g + r3g * r1sw + r4g * r1wh;
    
    r0bl = lerp(r0ap1Backup, r0bl, SI.lut_colorgrade); //user settings

    r0bl *= _g_scene_slot644.w * (50.f / SI.graphics_white_nits); //scale back to 50 Brightness setting

    // AP1 → display × 1.5
    float3 r1dp;
    r1dp.x = dot(float3( 1.705052f, -0.621791f, -0.083258f), r0bl);
    r1dp.y = dot(float3(-0.130257f,  1.140803f, -0.010549f), r0bl);
    r1dp.z = dot(float3(-0.024003f, -0.128969f,  1.152972f), r0bl);
    r0bl   = r1dp * 1.5f;

    // → ICtCp LMS
    float3 r1lms;
    r1lms.x = dot(float3(0.439701f, 0.382978f, 0.177335f), r0bl);
    r1lms.y = dot(float3(0.089792f, 0.813423f, 0.096762f), r0bl);
    r1lms.z = dot(float3(0.017544f, 0.111544f, 0.870704f), r0bl);
    float3 r1lmsBackup = r1lms;

    #if 1
        // Hue–chroma / vibrance (BLOWOUT SECTION)
        float r0cmn = min(r1lms.x, min(r1lms.y, r1lms.z));
        float r0cmx = max(r1lms.x, max(r1lms.y, r1lms.z));
        float r0sat = (max(r0cmx,0.0f) - max(r0cmn,0.0f)) / max(r0cmx, 0.01f);

        float hy = (-r1lms.y + r1lms.z) * r1lms.z;
        float hz = (-r1lms.x + r1lms.y) * r1lms.y;
        float hw = -r1lms.z + r1lms.x;
        float r0yhd = sqrt(abs(hz + hy + r1lms.x * hw));
        float r0zs  = r1lms.x + r1lms.y + r1lms.z;
        r0yhd       = r0yhd * 1.750000f + r0zs;

        float r0wco  = r0sat - 0.400000f;
        float r1xv   = max(1.0f - abs(r0wco * 2.500000f), 0.0f);
        int   isgn   = ((r0wco < 0.0f) ? 1 : 0) - ((0.0f < r0wco) ? 1 : 0);
        float r0wf   = (float)isgn * (-(r1xv * r1xv) + 1.0f) + 1.0f;

        float r0zdv  = r0yhd * 0.333333f;
        float r0wdv  = r0wf * 0.025000f; 
        float r0zhf  = (0.080000f / r0zdv - 0.500000f) * r0wdv;
        r0zhf        = (r0yhd >= 0.480000f) ? 0.0f   : r0zhf;
        r0zhf        = (0.160000f >= r0yhd) ? r0wdv  : r0zhf;    // FIX: was r0wf
        r0zhf       += 1.0f;

        float3 r2lms = r0zhf * r1lms;
        bool   r0zb  = (r2lms.y == r2lms.x) && (r2lms.z == r2lms.x);

        // ASM 268-269: mad r0.w, r1.z, r0.y, -r2.w  → M*zhf - S'  then ×1.732051
        float r0wdh  = (r1lms.y * r0zhf - r2lms.z) * 1.732051f;
        // ASM 270-271: 2*L' - M' - S*zhf
        float r1xcp  = r2lms.x * 2.0f - r2lms.y - r1lms.z * r0zhf;

        float r1za  = min(abs(r0wdh), abs(r1xcp)) / max(abs(r0wdh), abs(r1xcp));
        float t2a   = r1za * r1za;
        float rp    = t2a * 0.020835f - 0.085133f;
        rp          = t2a * rp + 0.180141f;
        rp          = t2a * rp - 0.330299f;
        rp          = t2a * rp + 0.999866f;
        // mul r3.x, r1.w, r1.z
        float r3x_at = rp * r1za;
        // lt r3.y, |r1.x|, |r0.w|  → |Cp| < |Ct|
        bool r3y_oc = (abs(r1xcp) < abs(r0wdh));
        // mad r3.x, r3.x, -2, 1.570796  then  and r3.x, r3.y, r3.x
        float r3x_oc = r3x_at * (-2.0f) + 1.570796f;
        r3x_at = r3y_oc ? r3x_oc : 0.0f;
        // mad r1.z, r1.z, r1.w, r3.x
        r1za = r1za * rp + r3x_at;
        // π correction
        r1za += (r1xcp < -r1xcp) ? asfloat(0xC0490FDBU) : 0.0f;
        // sign resolution
        float r1wmin = min(r0wdh, r1xcp);
        float r0wmx  = max(r0wdh, r1xcp);
        float r0ang  = ((r0wmx >= -r0wmx) && (r1wmin < -r1wmin)) ? -r1za : r1za;
        r0ang       *= 57.295780f;

        float r0zhue = r0zb ? 0.0f : r0ang;
        r0zhue = (r0zhue < 0.0f)   ? r0zhue + 360.0f : r0zhue;
        r0zhue = clamp(r0zhue, 0.0f, 360.0f);
        r0zhue = (r0zhue > 180.0f) ? r0zhue - 360.0f : r0zhue;

        // Hue-keyed spline (-67.5°, 67.5°)
        float r0zhs = 0.0f;
        if ((-67.5f < r0zhue) && (r0zhue < 67.5f))
        {
            float hs  = r0zhue + 67.5f;
            float wn  = hs * 0.029630f;
            int   idx = (int)trunc(wn);
            float t   = wn - trunc(wn);
            float t2h = t * t, t3h = t * t2h;
            float r3x = t3h*(-0.166667f) + t2h*0.500000f + t*(-0.500000f);
            float r3y = t3h*(-0.500000f) + t2h*0.500000f + t* 0.500000f;
            float r3z = t3h* 0.166667f;
            float r1zs = r3x + 0.166667f;                    // B-spline basis B₀(t)
            float r1ws = r3y + 0.166667f;                    // B-spline basis B₂(t)
            float r1ws_alt = t3h * 0.500000f - t2h + 0.666667f; // B-spline basis B₁(t)  ← FIX
            float seg;
            seg    = (idx == 0) ? 0.0f    : r3z;
            seg    = (idx == 1) ? r1ws    : seg;
            r0zhs  = (idx == 2) ? r1ws_alt : seg;            // FIX: was `t`, should be B₁(t)
            r0zhs  = (idx == 3) ? r1zs    : r0zhs;
        }

        // Apply vibrance
        // ASM lines 330-334:
        r0sat  *= r0zhs * 1.500000f;
        float r0vib_scale = -(r1lms.x) * r0zhf + 0.030000f;
        r0sat  *= r0vib_scale;
        float r2xv  = r0sat * 0.180000f + r2lms.x;

        float3 r0lo = float3(r2xv, r2lms.y, r2lms.z);
        r0lo = lerp(r1lmsBackup, r0lo, SI.lut_hueshiftblowout); //user settings
        r0lo = clamp(r0lo, 0.0f, 65535.0f);
    #else
        //skip
        float3 r0lo = r1lms;
    #endif

    // LMS → display (ICtCp inverse → BT.2020)
    float3 r1dd;
    r1dd.x = dot(float3( 1.451439f, -0.236511f, -0.214929f), r0lo);
    r1dd.y = dot(float3(-0.076554f,  1.176230f, -0.099676f), r0lo);
    r1dd.z = dot(float3( 0.008316f, -0.006032f,  0.997716f), r0lo);
    r0lo = clamp(r1dd, 0.f, 65535.f);

    // Desaturation toward luma
    float3 r0loBackup = r0lo;
    float r0wdl = dot(r0lo, float3(0.272229f, 0.674082f, 0.053690f));
    r0lo = (r0lo - r0wdl) * 0.960000f + r0wdl;
    r0lo = lerp(r0loBackup, r0lo, SI.lut_desaturation);  // user settings

    // Per-channel decode spline
    float3 r2enc;
    #if 1
        // RED
        {
            bool   neg = (r0lo.x <= 0.0f);
            float  lv  = neg ? -14.0f : log2(r0lo.x);
            float  sv  = neg ? -4.0f  : DecodeSplineInner(lv);
            r2enc.x = exp2(sv * 3.321928f);
        }
        // GREEN
        {
            bool   neg = (r0lo.y <= 0.0f);
            float  lv  = neg ? -14.0f : log2(r0lo.y);
            float  sv  = neg ? -4.0f  : DecodeSplineInner(lv);
            r2enc.y = exp2(sv * 3.321928f);
        }
        // BLUE
        {
            bool   neg = (r0lo.z <= 0.0f);
            float  lv  = neg ? -14.0f : log2(r0lo.z);
            float  sv  = neg ? -4.0f  : DecodeSplineInner(lv);
            r2enc.z = exp2(sv * 3.321928f);
        }
    #else
        float3 r2enc = 1000000000;
    #endif

    //P3(?) to BT2020 
    #if 1
        float3 r0xp;
        r0xp.x = dot(float3( 0.695452f,  0.140679f,  0.163869f), r2enc);
        r0xp.y = dot(float3( 0.044795f,  0.859671f,  0.095534f), r2enc);
        r0xp.z = dot(float3(-0.005526f,  0.004025f,  1.001501f), r2enc);
        float3 r0sg;
        r0sg.x = dot(float3( 1.451439f, -0.236511f, -0.214929f), r0xp);
        r0sg.y = dot(float3(-0.076554f,  1.176230f, -0.099676f), r0xp);
        r0sg.z = dot(float3( 0.008316f, -0.006032f,  0.997716f), r0xp);
    #else
        float3 r0sg = r2enc;
    #endif

    // per channel tonemap to 1000 nits BRUHHHHHHHHH!!!!
    float3 r2f;
    {
        bool   neg = (r0sg.x <= 0.0f);
        float  lv  = neg ? -13.287712f : log2(r0sg.x);
        r2f.x = exp2(EncodeSplineInner(lv) * 3.321928f);
    }
    {
        bool   neg = (r0sg.y <= 0.0f);
        float  lv  = neg ? -13.287712f : log2(r0sg.y);
        r2f.y = exp2(EncodeSplineInner(lv) * 3.321928f);
    }
    {
        bool   neg = (r0sg.z <= 0.0f);
        float  lv  = neg ? -13.287712f : log2(r0sg.z);
        r2f.z = exp2(EncodeSplineInner(lv) * 3.321928f);
    }

    // steal blowout
    {
        float3 r0sgUcs = JzAzBz::rgbToJzazbz(r0sg);
        float3 r2fUcs = JzAzBz::rgbToJzazbz(r2f);
        r2f = RestoreHueAndChrominance(r0sgUcs, r2fUcs, SI.lutpcb_hue, SI.lutpcb_chroma, SI.lutpcb_saturation);
        if (SI.tone_map_type <= 1.f) r2f.x = r2fUcs.x;
        r2f = JzAzBz::jzazbzToRgb(r2f);
    }

    // Final normalisation (barely does anything idk)
    r2f -= 0.000035f;
    float3 r1fn;
    #if 1
        r1fn.x = dot(float3( 1.025799f, -0.020053f, -0.005771f), r2f);
        r1fn.y = dot(float3(-0.002235f,  1.004583f, -0.002352f), r2f);
        r1fn.z = dot(float3(-0.005014f, -0.025293f,  1.030440f), r2f);
    #else
        r1fn = r2f;
    #endif

    // 4-wide (r1.xyzx duplicates r1fn.x into .w slot)
    // float4 r0e = float4(r1fn.x, r1fn.y, r1fn.z, r1fn.x) * 0.000100f;
    // r0e = exp2(log2(r0e) * 0.159302f);
    // float4 r1n = float4(r0e.w, r0e.y, r0e.z, r0e.w) * 18.851562f + 0.835938f;
    // float4 r0d = r0e * 18.687500f + 1.0f;
    // r0e = exp2(log2(rcp(r0d) * r1n) * 78.843750f) * 0.952381f;
    float3 r0e = renodx::color::pq::Encode(r1fn, 1.f /* * SI.tone_map_type == 2.f ? 0.05f : 1 */) * 0.952381f;
        
    lut3DTextureUAV[uint3(vThreadIDInGroup, vThreadGroupID.y, vThreadGroupID.z)] = float4(r0e.xyz, 1.0f);
}