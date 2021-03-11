// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "BaneArt/VHS/ScanlineCamera"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_ScanlineSpeed("Scanline Speed", Vector) = (0,0.1,0,0)
		_ScanlineTexture("Scanline Texture", 2D) = "white" {}
		_ScanlineTransparency("Scanline Transparency", Range( 0 , 0.2)) = 0.03388621
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		
		
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
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform sampler2D _ScanlineTexture;
			uniform float2 _ScanlineSpeed;
			uniform float4 _ScanlineTexture_ST;
			uniform float _ScanlineTransparency;

			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				
				o.pos = UnityObjectToClipPos ( v.vertex );
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
				float2 uv_MainTex = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float2 uv_ScanlineTexture = i.uv.xy * _ScanlineTexture_ST.xy + _ScanlineTexture_ST.zw;
				float2 panner44 = ( _Time.y * _ScanlineSpeed + uv_ScanlineTexture);
				float4 lerpResult53 = lerp( tex2D( _MainTex, uv_MainTex ) , tex2D( _ScanlineTexture, panner44 ) , _ScanlineTransparency);
				

				finalColor = lerpResult53;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=15500
-15;473;1293;685;442.2782;368.6509;1.3;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;52;-8.816513,-132.085;Float;True;Property;_ScanlineTexture;Scanline Texture;1;0;Create;True;0;0;False;0;None;05aa43dbbeddb24419e5b5b6e734d595;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.Vector2Node;48;251.799,61.7835;Float;False;Property;_ScanlineSpeed;Scanline Speed;0;0;Create;True;0;0;False;0;0,0.1;0,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;46;263.3498,187.1892;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;47;221.1439,-50.65293;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;44;471.0001,46.87996;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;1;547.6622,-324.1231;Float;False;0;0;_MainTex;Shader;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;54;690.3624,62.97441;Float;False;Property;_ScanlineTransparency;Scanline Transparency;2;0;Create;True;0;0;False;0;0.03388621;0.059;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;679.8882,-328.6851;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;43;676.4125,-132.3193;Float;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;False;0;05aa43dbbeddb24419e5b5b6e734d595;05aa43dbbeddb24419e5b5b6e734d595;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;53;1056.427,-176.7864;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1231.242,-176.5039;Float;False;True;2;Float;ASEMaterialInspector;0;2;ASETemplateShaders/Legacy/PostProcess;c71b220b631b6344493ea3cf87110c93;0;0;SubShader 0 Pass 0;1;False;False;True;2;False;-1;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;1;0;FLOAT4;0,0,0,0;False;0
WireConnection;47;2;52;0
WireConnection;44;0;47;0
WireConnection;44;2;48;0
WireConnection;44;1;46;0
WireConnection;2;0;1;0
WireConnection;43;0;52;0
WireConnection;43;1;44;0
WireConnection;53;0;2;0
WireConnection;53;1;43;0
WireConnection;53;2;54;0
WireConnection;0;0;53;0
ASEEND*/
//CHKSM=E68E95623908479053C9D312C176DF3224008EB2