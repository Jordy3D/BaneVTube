// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASETemplateShaders/Legacy/PostProcess"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_PixelCount("Pixel Count", Range( 0 , 128)) = 1
		_ScreenYRatio("Screen Y Ratio", Int) = 0
		_ScreenXRatio("Screen X Ratio", Int) = 0
		_Colour("Colour", Color) = (0,1,0,0)
		[Toggle]_GreyscaleToggle("Greyscale Toggle", Float) = 0
		[Toggle]_DitherToggle("Dither Toggle", Float) = 1
		[Toggle]_DitherSizeToggle("Dither Size Toggle", Float) = 1
		[Toggle]_InvertToggle("Invert Toggle", Float) = 1

	}

	SubShader
	{
		LOD 0

		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				float4 ase_texcoord4 : TEXCOORD4;
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float _DitherToggle;
			uniform float _GreyscaleToggle;
			uniform float _InvertToggle;
			uniform float _PixelCount;
			uniform int _ScreenXRatio;
			uniform int _ScreenYRatio;
			uniform float _DitherSizeToggle;
			uniform float4 _Colour;
			inline float Dither4x4Bayer( int x, int y )
			{
				const float dither[ 16 ] = {
			 1,  9,  3, 11,
			13,  5, 15,  7,
			 4, 12,  2, 10,
			16,  8, 14,  6 };
				int r = y * 4 + x;
				return dither[r] / 16; // same # of instructions as pre-dividing due to compiler magic
			}
			
			inline float Dither8x8Bayer( int x, int y )
			{
				const float dither[ 64 ] = {
			 1, 49, 13, 61,  4, 52, 16, 64,
			33, 17, 45, 29, 36, 20, 48, 32,
			 9, 57,  5, 53, 12, 60,  8, 56,
			41, 25, 37, 21, 44, 28, 40, 24,
			 3, 51, 15, 63,  2, 50, 14, 62,
			35, 19, 47, 31, 34, 18, 46, 30,
			11, 59,  7, 55, 10, 58,  6, 54,
			43, 27, 39, 23, 42, 26, 38, 22};
				int r = y * 8 + x;
				return dither[r] / 64; // same # of instructions as pre-dividing due to compiler magic
			}
			


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord4 = screenPos;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float2 texCoord3 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float pixelWidth4 =  1.0f / ( ( _PixelCount / _ScreenXRatio ) * _PixelCount );
				float pixelHeight4 = 1.0f / ( ( _PixelCount / _ScreenYRatio ) * _PixelCount );
				half2 pixelateduv4 = half2((int)(texCoord3.x / pixelWidth4) * pixelWidth4, (int)(texCoord3.y / pixelHeight4) * pixelHeight4);
				float4 tex2DNode2 = tex2D( _MainTex, pixelateduv4 );
				float grayscale8 = ((( _InvertToggle )?( ( 1.0 - tex2DNode2 ) ):( tex2DNode2 )).rgb.r + (( _InvertToggle )?( ( 1.0 - tex2DNode2 ) ):( tex2DNode2 )).rgb.g + (( _InvertToggle )?( ( 1.0 - tex2DNode2 ) ):( tex2DNode2 )).rgb.b) / 3;
				float4 temp_cast_1 = (grayscale8).xxxx;
				float4 temp_cast_2 = (grayscale8).xxxx;
				float4 temp_output_46_0 = ( _Colour * (( _GreyscaleToggle )?( temp_cast_2 ):( (( _InvertToggle )?( ( 1.0 - tex2DNode2 ) ):( tex2DNode2 )) )) );
				float4 screenPos = i.ase_texcoord4;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 clipScreen9 = ase_screenPosNorm.xy * _ScreenParams.xy;
				float dither9 = Dither4x4Bayer( fmod(clipScreen9.x, 4), fmod(clipScreen9.y, 4) );
				float4 temp_cast_3 = (grayscale8).xxxx;
				dither9 = step( dither9, (( _GreyscaleToggle )?( temp_cast_3 ):( (( _InvertToggle )?( ( 1.0 - tex2DNode2 ) ):( tex2DNode2 )) )).r );
				float4 temp_cast_5 = (grayscale8).xxxx;
				float2 clipScreen39 = ase_screenPosNorm.xy * _ScreenParams.xy;
				float dither39 = Dither8x8Bayer( fmod(clipScreen39.x, 8), fmod(clipScreen39.y, 8) );
				float4 temp_cast_6 = (grayscale8).xxxx;
				dither39 = step( dither39, (( _GreyscaleToggle )?( temp_cast_6 ):( (( _InvertToggle )?( ( 1.0 - tex2DNode2 ) ):( tex2DNode2 )) )).r );
				

				finalColor = (( _DitherToggle )?( (( _DitherSizeToggle )?( ( temp_output_46_0 * dither39 ) ):( ( temp_output_46_0 * dither9 ) )) ):( (( _GreyscaleToggle )?( temp_cast_1 ):( (( _InvertToggle )?( ( 1.0 - tex2DNode2 ) ):( tex2DNode2 )) )) ));

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18400
1957;197;1330;714;537.8504;824.4388;1.406566;True;False
Node;AmplifyShaderEditor.RangedFloatNode;5;-1884.094,-110.7277;Float;False;Property;_PixelCount;Pixel Count;0;0;Create;True;0;0;False;0;False;1;14;0;128;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;29;-1803.275,-3.42358;Float;False;Property;_ScreenXRatio;Screen X Ratio;2;0;Create;True;0;0;False;0;False;0;16;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;31;-1800.275,72.57642;Float;False;Property;_ScreenYRatio;Screen Y Ratio;1;0;Create;True;0;0;False;0;False;0;9;0;1;INT;0
Node;AmplifyShaderEditor.WireNode;34;-1549.275,-37.42361;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;27;-1542.275,51.57642;Inherit;False;2;0;FLOAT;0;False;1;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;26;-1542.275,-119.4236;Inherit;False;2;0;FLOAT;0;False;1;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;38;-1583.275,-59.42361;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;37;-1527.275,-30.42361;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1419.393,-206.228;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-1325.275,-89.42361;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-1326.275,2.576385;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;1;-1101.773,-183.1951;Inherit;False;0;0;_MainTex;Shader;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCPixelate;4;-1153.147,-101.849;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;2;-964.4099,-181.7132;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;19;-655.158,-114.775;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;20;-474.9016,-179.8783;Float;False;Property;_InvertToggle;Invert Toggle;7;0;Create;True;0;0;False;0;False;1;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;8;-230.9546,-116.4204;Inherit;False;2;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;10;-11.04976,-180.6429;Float;False;Property;_GreyscaleToggle;Greyscale Toggle;4;0;Create;True;0;0;False;0;False;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;6;254.7993,-317.9355;Float;False;Property;_Colour;Colour;3;0;Create;True;0;0;False;0;False;0,1,0,0;0,0.9433962,0.1713683,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;43;205.304,-360.2777;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DitheringNode;39;277.9781,11.58533;Inherit;False;1;True;3;0;FLOAT;0;False;1;SAMPLER2D;;False;2;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DitheringNode;9;276.0788,-89.17969;Inherit;False;0;True;3;0;FLOAT;0;False;1;SAMPLER2D;;False;2;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;493.3044,-201.5263;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;45;242.932,-373.3657;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;767.4344,-155.5968;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;768.041,-3.939496;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;47;1128.403,-365.0195;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;41;931.088,-69.98138;Float;False;Property;_DitherSizeToggle;Dither Size Toggle;6;0;Create;True;0;0;False;0;False;1;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;44;1152.922,-354.4948;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;11;1222.868,-199.1441;Float;False;Property;_DitherToggle;Dither Toggle;5;0;Create;True;0;0;False;0;False;1;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1449.458,-193.7006;Float;False;True;-1;2;ASEMaterialInspector;0;2;ASETemplateShaders/Legacy/PostProcess;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;34;0;5;0
WireConnection;27;0;5;0
WireConnection;27;1;31;0
WireConnection;26;0;5;0
WireConnection;26;1;29;0
WireConnection;38;0;5;0
WireConnection;37;0;34;0
WireConnection;32;0;26;0
WireConnection;32;1;37;0
WireConnection;33;0;27;0
WireConnection;33;1;38;0
WireConnection;4;0;3;0
WireConnection;4;1;32;0
WireConnection;4;2;33;0
WireConnection;2;0;1;0
WireConnection;2;1;4;0
WireConnection;19;0;2;0
WireConnection;20;0;2;0
WireConnection;20;1;19;0
WireConnection;8;0;20;0
WireConnection;10;0;20;0
WireConnection;10;1;8;0
WireConnection;43;0;10;0
WireConnection;39;0;10;0
WireConnection;9;0;10;0
WireConnection;46;0;6;0
WireConnection;46;1;10;0
WireConnection;45;0;43;0
WireConnection;7;0;46;0
WireConnection;7;1;9;0
WireConnection;40;0;46;0
WireConnection;40;1;39;0
WireConnection;47;0;45;0
WireConnection;41;0;7;0
WireConnection;41;1;40;0
WireConnection;44;0;47;0
WireConnection;11;0;44;0
WireConnection;11;1;41;0
WireConnection;0;0;11;0
ASEEND*/
//CHKSM=A1638242FD2654092751EDBCB6CDCDB6706DBD10