float4 g_BlendSettings : register( c29 );
float4 g_DepthFog : register( c25 );
float4 g_FogColour : register( c24 );
float4 g_vLuminance : register( c31 );
sampler2D textureMap : register( s0 );

struct PS_IN
{
	float3 texcoord : TEXCOORD;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
};

#include "../shared.h"

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float3 r2;
	r0.x = -g_DepthFog.y + i.texcoord2.w;
	r0.y = -r0.x * g_DepthFog.x;
	r0.y = r0.y * g_DepthFog.z;
	r0.y = r0.y * 1.442695;
	r0.y = exp2(r0.y);
	r0.x = (r0.x >= 0) ? r0.y : 1;
	r1 = tex2D(textureMap, i.texcoord);
	r2.xyz = g_FogColour.xyz;
	r0.yzw = r2.xxy * g_BlendSettings.x;
	r1.xyz = r1.xyz * i.texcoord3.xyz + -r0.yzw;
	r1.w = r1.w * i.texcoord3.w;
	r0.xyz = r0.x * r1.xyz + r0.yzw;
	r0.xyz = r0.xyz * g_vLuminance.x;
	r0.x = 1 / sqrt(r0.x);
	r1.x = 1 / r0.x;
	r0.x = 1 / sqrt(r0.y);
	r0.y = 1 / sqrt(r0.z);
	r1.z = 1 / r0.y;
	r1.y = 1 / r0.x;
	o.xyz = r1.w * r1.xyz / EXPOSURE_REVERSAL /* * 0.89 */;
	o.w = r1.w * i.texcoord.z;

	return o;
}
