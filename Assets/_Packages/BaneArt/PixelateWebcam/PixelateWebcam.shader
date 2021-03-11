// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PixelateWebcam"
{
	Properties
	{
		_XPixelCount("X Pixel Count", Range( 1 , 256)) = 0
		_YPixelCount("Y Pixel Count", Range( 1 , 256)) = 0
		_Mask("Mask", 2D) = "white" {}
		_MaskXPixelCount("Mask X Pixel Count", Range( 1 , 256)) = 0
		_MaskYPixelCount("Mask Y Pixel Count", Range( 1 , 256)) = 0
		[Toggle]_ManualMaskPixelisation("Manual Mask Pixelisation", Float) = 0
		[Toggle]_MaskRGBAlphaSwitch("Mask RGB / Alpha Switch", Float) = 0
		[Toggle]_InvertMask("Invert Mask", Float) = 0
		_WebCam("WebCam", 2D) = "white" {}
		_Size("Size", Range( 0 , 50)) = 0.5647059
		_Falloff("Falloff", Range( 0.001 , 1)) = 0.5647059
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _WebCam;
		uniform float4 _WebCam_ST;
		uniform float _XPixelCount;
		uniform float _YPixelCount;
		uniform float _InvertMask;
		uniform float _MaskRGBAlphaSwitch;
		uniform sampler2D _Mask;
		uniform float _ManualMaskPixelisation;
		uniform float4 _Mask_ST;
		uniform float _MaskXPixelCount;
		uniform float _MaskYPixelCount;
		uniform float _Size;
		uniform float _Falloff;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv0_WebCam = i.uv_texcoord * _WebCam_ST.xy + _WebCam_ST.zw;
			float pixelWidth2 =  1.0f / _XPixelCount;
			float pixelHeight2 = 1.0f / _YPixelCount;
			half2 pixelateduv2 = half2((int)(uv0_WebCam.x / pixelWidth2) * pixelWidth2, (int)(uv0_WebCam.y / pixelHeight2) * pixelHeight2);
			o.Albedo = tex2D( _WebCam, pixelateduv2 ).rgb;
			float2 uv0_Mask = i.uv_texcoord * _Mask_ST.xy + _Mask_ST.zw;
			float pixelWidth10 =  1.0f / _MaskXPixelCount;
			float pixelHeight10 = 1.0f / _MaskYPixelCount;
			half2 pixelateduv10 = half2((int)(uv0_Mask.x / pixelWidth10) * pixelWidth10, (int)(uv0_Mask.y / pixelHeight10) * pixelHeight10);
			float4 tex2DNode6 = tex2D( _Mask, (( _ManualMaskPixelisation )?( pixelateduv10 ):( uv0_Mask )) );
			float4 temp_cast_1 = (tex2DNode6.a).xxxx;
			float4 temp_cast_2 = (tex2DNode6.a).xxxx;
			float4 temp_cast_3 = (_Size).xxxx;
			float4 clampResult35 = clamp( ( pow( (( _InvertMask )?( ( 1.0 - (( _MaskRGBAlphaSwitch )?( temp_cast_2 ):( tex2DNode6 )) ) ):( (( _MaskRGBAlphaSwitch )?( temp_cast_1 ):( tex2DNode6 )) )) , temp_cast_3 ) / _Falloff ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Alpha = clampResult35.r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17800
2097;199;1049;728;5.660767;-15.2355;1;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;12;-2073.819,257.2306;Inherit;True;Property;_Mask;Mask;2;0;Create;True;0;0;False;0;None;5a5b20f962bdb22428da08e032649287;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-1820.069,327.5211;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;-1843.069,466.5214;Inherit;False;Property;_MaskXPixelCount;Mask X Pixel Count;3;0;Create;True;0;0;False;0;0;64;1;256;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1847.013,542.0089;Inherit;False;Property;_MaskYPixelCount;Mask Y Pixel Count;4;0;Create;True;0;0;False;0;0;64;1;256;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCPixelate;10;-1533.268,410.5407;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ToggleSwitchNode;11;-1322.761,324.1004;Inherit;False;Property;_ManualMaskPixelisation;Manual Mask Pixelisation;5;0;Create;True;0;0;False;0;0;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;6;-1018.607,252.6633;Inherit;True;Property;_MaskValue;MaskValue;4;0;Create;True;0;0;False;0;-1;None;cf89fb6505f93104e90129de5f6432b3;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;14;-600.0738,251.2114;Inherit;False;Property;_MaskRGBAlphaSwitch;Mask RGB / Alpha Switch;6;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;16;-291.8811,330.5677;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;13;-852.8539,-128.5403;Inherit;True;Property;_WebCam;WebCam;8;0;Create;True;0;0;False;0;None;;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-173.9561,620.5549;Inherit;False;Property;_Size;Size;9;0;Create;True;0;0;False;0;0.5647059;0;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;15;-102.0285,250.1062;Inherit;True;Property;_InvertMask;Invert Mask;7;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-639.2039,136.7878;Inherit;False;Property;_YPixelCount;Y Pixel Count;1;0;Create;True;0;0;False;0;0;32;1;256;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-601.0746,-52.17759;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-643.5199,61.30033;Inherit;False;Property;_XPixelCount;X Pixel Count;0;0;Create;True;0;0;False;0;0;32;1;256;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;170.92,634.0268;Inherit;False;Property;_Falloff;Falloff;10;0;Create;True;0;0;False;0;0.5647059;0.001;0.001;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;32;146.5977,371.5923;Inherit;True;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCPixelate;2;-318.7821,-49.75867;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;33;487.92,522.0268;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-119.4931,-125.2703;Inherit;True;Property;_WebCamValue;WebCamValue;7;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;35;694.3392,437.2355;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;726.3238,-44.31573;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;PixelateWebcam;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;True;Transparent;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;2;12;0
WireConnection;10;0;7;0
WireConnection;10;1;8;0
WireConnection;10;2;9;0
WireConnection;11;0;7;0
WireConnection;11;1;10;0
WireConnection;6;0;12;0
WireConnection;6;1;11;0
WireConnection;14;0;6;0
WireConnection;14;1;6;4
WireConnection;16;0;14;0
WireConnection;15;0;14;0
WireConnection;15;1;16;0
WireConnection;3;2;13;0
WireConnection;32;0;15;0
WireConnection;32;1;22;0
WireConnection;2;0;3;0
WireConnection;2;1;4;0
WireConnection;2;2;5;0
WireConnection;33;0;32;0
WireConnection;33;1;34;0
WireConnection;1;0;13;0
WireConnection;1;1;2;0
WireConnection;35;0;33;0
WireConnection;0;0;1;0
WireConnection;0;9;35;0
ASEEND*/
//CHKSM=97D6B45DDFB45D7D1F82EFD57BD9357652111F71