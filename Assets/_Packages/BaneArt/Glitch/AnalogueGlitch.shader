Shader "glitch/AnalogueGlitch"
{
  Properties
  {
    _MainTex ("Albedo (RGB)", 2D) = "white" {}
  }
  CGINCLUDE 
  #include "UnityCG.cginc"

  sampler2D _MainTex;
  float2 _MainTex_TexelSize;

  float2 _ScanLineJitter;   //displacement
  float2 _VerticalJump;     //amount over time
  float _HorizontalShake;
  float2 _ColourDrift;      //amount over time

  float nrand(float x, float y)
  {
    return frac(sin(dot(float2(x,y), float2(12.9898, 78.233)))*43758.5453);
  }

  half4 frag(v2f_img i): SV_Target
  {
    float u = i.uv.x;
    float v = i.uv.y;

    float jitter = nrand(v, _Time.x) * 2 - 1;
    jitter *= step(_ScanLineJitter.y, abs(jitter))*_ScanLineJitter.x;

    float jump = lerp(v, frac(v + _VerticalJump.y), _VerticalJump.x);

    float shake = (nrand(_Time.x, 2) - 0.5) * _HorizontalShake;

    float drift = _ColourDrift.x;

    half4 scr1 = tex2D (_MainTex, frac(float2(u + jitter + shake - drift, jump)));
    half4 scr2 = tex2D (_MainTex, frac(float2(u + jitter + shake + drift, jump)));

    return half4(scr1.r, scr2.g, scr2.b, 1);
  }

  ENDCG

  SubShader
  {
    Pass 
    {
      ZTest Always Cull Off Zwrite Off
      CGPROGRAM
      #pragma vertex vert_img
      #pragma fragment frag
      #pragma target 3.0


      ENDCG
    }
  }
}
