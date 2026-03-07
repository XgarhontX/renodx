sampler2D g_tAlbedo : register( s0 );
float4 g_vFogColour : register( c1 );
float4 g_vLuminance : register( c31 );
float4 g_vSkySettings : register( c0 );

float4 main(float4 color : COLOR) : COLOR
{
	float4 o;

	float4 r0;
	float3 r1;
	float4 r2;
	r0 = tex2D(g_tAlbedo, color);
	r0.w = r0.w * r0.w;
	r0.xyz = r0.xyz * r0.w;
	r1.xyz = r0.xyz * g_vSkySettings.y;
	r2.y = g_vSkySettings.y;
	r0.xyz = r0.xyz * -r2.y + g_vFogColour.xyz;
	r0.xyz = color.z * r0.xyz + r1.xyz;
	r0.w = dot(r0.xyz, float3(0.85, 2.8616, 0.2884));
	r0.xyz = r0.xyz * g_vLuminance.x;
	o.w = -r0.w + 1;

	r0.x = 1 / sqrt(r0.x);
	r1.x = 1 / r0.x;
	r0.x = 1 / sqrt(r0.y);
	r0.y = 1 / sqrt(r0.z);
	r1.z = 1 / r0.y;
	r1.y = 1 / r0.x;

	o.xyz = r1.xyz * color.w;
	o.xyz = pow(o.xyz, 1.2) * 1.2;

	return o;
}
