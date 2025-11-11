// ---- Created with 3Dmigoto v1.3.16 on Sun Nov 09 21:38:41 2025



// 3Dmigoto declarations
#define cmp -
#include "../shared.h"


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  if (!CUSTOM_IS_UI) discard;
  o0.xyzw = v1.xyzw;
  return;
}