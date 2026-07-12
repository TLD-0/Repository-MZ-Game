Shader "Shader Graphs/Clooood"
{
    Properties
    {
        _Rotate_Projection("Rotate Projection", Vector, 4) = (1, 0, 0, 0)
        _Noise_Scale("Noise Scale", Float) = 0
        _NegativeNoisespeed("NegativeNoisespeed", Float) = 0
        _Positive_Noiseheight("Positive Noiseheight", Float) = 100
        _Noise_remap("Noise remap", Vector, 4) = (0, 1, -1, 1)
        _NegativValleyColor("NegativValleyColor", Color) = (0, 0, 0, 0)
        _NegativPeakColor("NegativPeakColor", Color) = (0, 0, 0, 0)
        _Noise_Edge_1("Noise Edge 1", Float) = 0
        _Noise_Edge_2("Noise Edge 2", Float) = 1
        _Noise_Power("Noise Power", Float) = 2
        _Base_Scale("Base Scale", Float) = 1
        _negativenoisespeed("negativenoisespeed", Float) = 0
        _Base_Strength("Base Strength", Float) = 2
        _Emission_Strength("Emission Strength", Float) = 2
        _Bowl_Curvature("Bowl Curvature", Float) = 10
        _Fresnel_Power("Fresnel Power", Float) = 1
        _Fresnal_Opacity("Fresnal Opacity", Float) = 1
        _Transparency_range("Transparency range", Float) = 100
        _TileScale("TileScale", Float) = 20
        _Positive_ValleyColor("Positive ValleyColor", Color) = (1, 0.5828071, 0, 0)
        _PositivePeakColor("PositivePeakColor", Color) = (1, 0.8963448, 0.740566, 0)
        _MoodValue("MoodValue", Float) = 0
        _NegativeNoiseheight("NegativeNoiseheight", Float) = 30
        _PositiveNoisespeed("PositiveNoisespeed", Float) = 50
        _Positivebasespeed("Positivebasespeed", Float) = 50
        [HideInInspector]_BUILTIN_QueueOffset("Float", Float) = 0
        [HideInInspector]_BUILTIN_QueueControl("Float", Float) = -1
    }
    SubShader
    {
        Tags
        {
            // RenderPipeline: <None>
            "RenderType"="Transparent"
            "BuiltInMaterialType" = "Lit"
            "Queue"="Transparent"
            // DisableBatching: <None>
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="BuiltInLitSubTarget"
        }
        Pass
        {
            Name "BuiltIn Forward"
            Tags
            {
                "LightMode" = "ForwardBase"
            }
        
        // Render State
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite On
        ColorMask RGB
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.0
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma multi_compile_fwdbase
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
        #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        // GraphKeywords: <None>
        
        // Defines
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define BUILTIN_TARGET_API 1
        #define _BUILTIN_SURFACE_TYPE_TRANSPARENT 1
        #define _BUILTIN_AlphaClip 1
        #define _BUILTIN_ALPHATEST_ON 1
        #define REQUIRE_DEPTH_TEXTURE
        #ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #endif
        #ifdef _BUILTIN_ALPHATEST_ON
        #define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
        #endif
        #ifdef _BUILTIN_AlphaClip
        #define _AlphaClip _BUILTIN_AlphaClip
        #endif
        #ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
        #define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
        #endif
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
            #if defined(LIGHTMAP_ON)
             float2 lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
             float4 shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 TangentSpaceNormal;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 lightmapUV : INTERP0;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP1;
            #endif
             float4 tangentWS : INTERP2;
             float4 fogFactorAndVertexLight : INTERP3;
             float4 shadowCoord : INTERP4;
             float3 positionWS : INTERP5;
             float3 normalWS : INTERP6;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.lightmapUV = input.lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.shadowCoord.xyzw = input.shadowCoord;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.lightmapUV = input.lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.shadowCoord = input.shadowCoord.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _NegativeNoisespeed;
        float _Positive_Noiseheight;
        float4 _Noise_remap;
        float4 _NegativValleyColor;
        float4 _NegativPeakColor;
        float _Noise_Edge_1;
        float _Noise_Edge_2;
        float _Noise_Power;
        float _Base_Scale;
        float _negativenoisespeed;
        float _Base_Strength;
        float _Emission_Strength;
        float _Bowl_Curvature;
        float _Fresnel_Power;
        float _Fresnal_Opacity;
        float _Transparency_range;
        float _TileScale;
        float4 _Positive_ValleyColor;
        float4 _PositivePeakColor;
        float _MoodValue;
        float _NegativeNoiseheight;
        float _PositiveNoisespeed;
        float _Positivebasespeed;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
            float s, c;
            sincos(Rotation, s, c);
            Axis = normalize(Axis);
            Out = In * c + cross(Axis, In) * s + Axis * dot(Axis, In) * (1 - c);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
        {
            Out = pow((1.0 - saturate(dot(normalize(Normal), ViewDir))), Power);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_37b74d35aea7418684eea7308fed4dc2_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_37b74d35aea7418684eea7308fed4dc2_Out_2_Float);
            float _Multiply_6c95e880611244deac2b872b6decd88d_Out_2_Float;
            Unity_Multiply_float_float(_Distance_37b74d35aea7418684eea7308fed4dc2_Out_2_Float, -1, _Multiply_6c95e880611244deac2b872b6decd88d_Out_2_Float);
            float _Property_960eb8d9027b4ea1a34e2806e82d40da_Out_0_Float = _Bowl_Curvature;
            float _Divide_e3bfc6ac830e4502bdb64c805aa9a3ef_Out_2_Float;
            Unity_Divide_float(_Multiply_6c95e880611244deac2b872b6decd88d_Out_2_Float, _Property_960eb8d9027b4ea1a34e2806e82d40da_Out_0_Float, _Divide_e3bfc6ac830e4502bdb64c805aa9a3ef_Out_2_Float);
            float _Power_09d0ece4dc0f41e9b8894ee456c020c9_Out_2_Float;
            Unity_Power_float(_Divide_e3bfc6ac830e4502bdb64c805aa9a3ef_Out_2_Float, float(3), _Power_09d0ece4dc0f41e9b8894ee456c020c9_Out_2_Float);
            float3 _Multiply_c90d63e869b44661889a2e2dfe9e0e0b_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_09d0ece4dc0f41e9b8894ee456c020c9_Out_2_Float.xxx), _Multiply_c90d63e869b44661889a2e2dfe9e0e0b_Out_2_Vector3);
            float _Property_37396a43db5941909959cbd08cb7213b_Out_0_Float = _Noise_Edge_1;
            float _Property_2d5fab0c056b463089f63a339f94ac2b_Out_0_Float = _Noise_Edge_2;
            float4 _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4 = _Rotate_Projection;
            float _Split_83c34662c4394bda92d2da5990f2b124_R_1_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[0];
            float _Split_83c34662c4394bda92d2da5990f2b124_G_2_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[1];
            float _Split_83c34662c4394bda92d2da5990f2b124_B_3_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[2];
            float _Split_83c34662c4394bda92d2da5990f2b124_A_4_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[3];
            float3 _RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4.xyz), _Split_83c34662c4394bda92d2da5990f2b124_A_4_Float, _RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3);
            float _Property_77fe19067f40438693aa98df3480a426_Out_0_Float = _TileScale;
            float3 _Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3;
            Unity_Multiply_float3_float3(_RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3, (_Property_77fe19067f40438693aa98df3480a426_Out_0_Float.xxx), _Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3);
            float _Property_41dd9680a76949e29c341e472c8e41ee_Out_0_Float = _PositiveNoisespeed;
            float _Property_5ecd4183beb8451e9ef255004c349ad5_Out_0_Float = _NegativeNoisespeed;
            float _Property_7786adaa185c44daaca6ed08996d54d0_Out_0_Float = _MoodValue;
            float _Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float;
            Unity_Divide_float(_Property_7786adaa185c44daaca6ed08996d54d0_Out_0_Float, float(10), _Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float);
            float _Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float;
            Unity_Absolute_float(_Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float, _Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float);
            float _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float;
            Unity_Maximum_float(_Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float, float(0), _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float);
            float _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float;
            Unity_Lerp_float(_Property_41dd9680a76949e29c341e472c8e41ee_Out_0_Float, _Property_5ecd4183beb8451e9ef255004c349ad5_Out_0_Float, _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float, _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float);
            float _Multiply_91dd2cd366344500997788845d158666_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float, _Multiply_91dd2cd366344500997788845d158666_Out_2_Float);
            float2 _TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), (_Multiply_91dd2cd366344500997788845d158666_Out_2_Float.xx), _TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2);
            float _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float = _Noise_Scale;
            float _GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2, _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float, _GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float);
            float2 _TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2);
            float _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2, _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float, _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float);
            float _Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float;
            Unity_Add_float(_GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float, _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float, _Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float);
            float _Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float;
            Unity_Divide_float(_Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float, float(2), _Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float);
            float _Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float;
            Unity_Saturate_float(_Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float, _Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float);
            float _Property_84e8826753fe4fd08cbcedf557994d88_Out_0_Float = _Noise_Power;
            float _Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float;
            Unity_Power_float(_Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float, _Property_84e8826753fe4fd08cbcedf557994d88_Out_0_Float, _Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float);
            float4 _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4 = _Noise_remap;
            float _Split_48347984f6a84a9893ddcefdedd069b1_R_1_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[0];
            float _Split_48347984f6a84a9893ddcefdedd069b1_G_2_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[1];
            float _Split_48347984f6a84a9893ddcefdedd069b1_B_3_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[2];
            float _Split_48347984f6a84a9893ddcefdedd069b1_A_4_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[3];
            float4 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4;
            float3 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGB_5_Vector3;
            float2 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RG_6_Vector2;
            Unity_Combine_float(_Split_48347984f6a84a9893ddcefdedd069b1_R_1_Float, _Split_48347984f6a84a9893ddcefdedd069b1_G_2_Float, float(0), float(0), _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4, _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGB_5_Vector3, _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RG_6_Vector2);
            float4 _Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4;
            float3 _Combine_2bfc034140f647a78084b52cf23498dc_RGB_5_Vector3;
            float2 _Combine_2bfc034140f647a78084b52cf23498dc_RG_6_Vector2;
            Unity_Combine_float(_Split_48347984f6a84a9893ddcefdedd069b1_B_3_Float, _Split_48347984f6a84a9893ddcefdedd069b1_A_4_Float, float(0), float(0), _Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4, _Combine_2bfc034140f647a78084b52cf23498dc_RGB_5_Vector3, _Combine_2bfc034140f647a78084b52cf23498dc_RG_6_Vector2);
            float _Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float;
            Unity_Remap_float(_Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float, (_Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4.xy), (_Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4.xy), _Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float);
            float _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float;
            Unity_Absolute_float(_Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float, _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float);
            float _Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float;
            Unity_Smoothstep_float(_Property_37396a43db5941909959cbd08cb7213b_Out_0_Float, _Property_2d5fab0c056b463089f63a339f94ac2b_Out_0_Float, _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float, _Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float);
            float _Property_90b7a5c151634fc395d9f6d8cafa7bfb_Out_0_Float = _Positivebasespeed;
            float _Property_259361442b4a474a8ea19b196b10203b_Out_0_Float = _negativenoisespeed;
            float _Property_3c059a7fd1384747b0882ef29ca0c38b_Out_0_Float = _MoodValue;
            float _Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float;
            Unity_Divide_float(_Property_3c059a7fd1384747b0882ef29ca0c38b_Out_0_Float, float(10), _Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float);
            float _Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float;
            Unity_Absolute_float(_Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float, _Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float);
            float _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float;
            Unity_Maximum_float(_Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float, float(0), _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float);
            float _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float;
            Unity_Lerp_float(_Property_90b7a5c151634fc395d9f6d8cafa7bfb_Out_0_Float, _Property_259361442b4a474a8ea19b196b10203b_Out_0_Float, _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float, _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float);
            float _Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float, _Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float);
            float2 _TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), (_Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float.xx), _TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2);
            float _Property_9cdb12619ba0436c88021cdfb91f4ba2_Out_0_Float = _Base_Scale;
            float _GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2, _Property_9cdb12619ba0436c88021cdfb91f4ba2_Out_0_Float, _GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float);
            float _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float = _Base_Strength;
            float _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float, _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float, _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float);
            float _Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float;
            Unity_Add_float(_Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float, _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float, _Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float);
            float _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float;
            Unity_Add_float(float(1), _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float, _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float);
            float _Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float;
            Unity_Divide_float(_Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float, _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float, _Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float);
            float3 _Multiply_1c3e80d5ad544d37afeae348e005b1ce_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float.xxx), _Multiply_1c3e80d5ad544d37afeae348e005b1ce_Out_2_Vector3);
            float _Property_fbedcc335e4e489a88530feceac28a92_Out_0_Float = _Positive_Noiseheight;
            float _Property_51562b6bcc0e49889a5b042bd9dd3ec1_Out_0_Float = _NegativeNoiseheight;
            float _Property_4a38113a4b3d4df9a442abaf0dfc7175_Out_0_Float = _MoodValue;
            float _Divide_c3a203997247432380c98ea6f1105246_Out_2_Float;
            Unity_Divide_float(_Property_4a38113a4b3d4df9a442abaf0dfc7175_Out_0_Float, float(10), _Divide_c3a203997247432380c98ea6f1105246_Out_2_Float);
            float _Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float;
            Unity_Absolute_float(_Divide_c3a203997247432380c98ea6f1105246_Out_2_Float, _Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float);
            float _Maximum_ea3824aff9834aa6abb200d18549a1ab_Out_2_Float;
            Unity_Maximum_float(_Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float, float(0), _Maximum_ea3824aff9834aa6abb200d18549a1ab_Out_2_Float);
            float _Lerp_631ef014257c45109ba70e191310a027_Out_3_Float;
            Unity_Lerp_float(_Property_fbedcc335e4e489a88530feceac28a92_Out_0_Float, _Property_51562b6bcc0e49889a5b042bd9dd3ec1_Out_0_Float, _Maximum_ea3824aff9834aa6abb200d18549a1ab_Out_2_Float, _Lerp_631ef014257c45109ba70e191310a027_Out_3_Float);
            float3 _Multiply_f5b6315c130940588d7d1a13e6a6ff4b_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_1c3e80d5ad544d37afeae348e005b1ce_Out_2_Vector3, (_Lerp_631ef014257c45109ba70e191310a027_Out_3_Float.xxx), _Multiply_f5b6315c130940588d7d1a13e6a6ff4b_Out_2_Vector3);
            float3 _Add_61d8564b498f4b51a52cb66ee888a83f_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_f5b6315c130940588d7d1a13e6a6ff4b_Out_2_Vector3, _Add_61d8564b498f4b51a52cb66ee888a83f_Out_2_Vector3);
            float3 _Add_b49f2b0d3cc549f6a4a0e455f9e0e053_Out_2_Vector3;
            Unity_Add_float3(_Multiply_c90d63e869b44661889a2e2dfe9e0e0b_Out_2_Vector3, _Add_61d8564b498f4b51a52cb66ee888a83f_Out_2_Vector3, _Add_b49f2b0d3cc549f6a4a0e455f9e0e053_Out_2_Vector3);
            description.Position = _Add_b49f2b0d3cc549f6a4a0e455f9e0e053_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_288513cbd498440b82da4722d2a9ff59_Out_0_Vector4 = _Positive_ValleyColor;
            float4 _Property_78dea4090d6f48fba8829f6c8c2024cf_Out_0_Vector4 = _NegativValleyColor;
            float _Property_4a38113a4b3d4df9a442abaf0dfc7175_Out_0_Float = _MoodValue;
            float _Divide_c3a203997247432380c98ea6f1105246_Out_2_Float;
            Unity_Divide_float(_Property_4a38113a4b3d4df9a442abaf0dfc7175_Out_0_Float, float(10), _Divide_c3a203997247432380c98ea6f1105246_Out_2_Float);
            float _Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float;
            Unity_Absolute_float(_Divide_c3a203997247432380c98ea6f1105246_Out_2_Float, _Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float);
            float _Maximum_0bb8511684d44e4cb7bee914f9e77855_Out_2_Float;
            Unity_Maximum_float(_Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float, float(0), _Maximum_0bb8511684d44e4cb7bee914f9e77855_Out_2_Float);
            float4 _Lerp_48dc9b1b9cba40b79c1b6f9c5fe87467_Out_3_Vector4;
            Unity_Lerp_float4(_Property_288513cbd498440b82da4722d2a9ff59_Out_0_Vector4, _Property_78dea4090d6f48fba8829f6c8c2024cf_Out_0_Vector4, (_Maximum_0bb8511684d44e4cb7bee914f9e77855_Out_2_Float.xxxx), _Lerp_48dc9b1b9cba40b79c1b6f9c5fe87467_Out_3_Vector4);
            float4 _Property_58011cd26b9e4b0389d33a1be1815b68_Out_0_Vector4 = _PositivePeakColor;
            float4 _Property_58445f66054345ddbf670ee452dae706_Out_0_Vector4 = _NegativPeakColor;
            float _Maximum_863fe33b940b414eb6bb87d39e1a6653_Out_2_Float;
            Unity_Maximum_float(_Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float, float(0), _Maximum_863fe33b940b414eb6bb87d39e1a6653_Out_2_Float);
            float4 _Lerp_652f4c6a105746fba0956869d7bd7200_Out_3_Vector4;
            Unity_Lerp_float4(_Property_58011cd26b9e4b0389d33a1be1815b68_Out_0_Vector4, _Property_58445f66054345ddbf670ee452dae706_Out_0_Vector4, (_Maximum_863fe33b940b414eb6bb87d39e1a6653_Out_2_Float.xxxx), _Lerp_652f4c6a105746fba0956869d7bd7200_Out_3_Vector4);
            float _Property_37396a43db5941909959cbd08cb7213b_Out_0_Float = _Noise_Edge_1;
            float _Property_2d5fab0c056b463089f63a339f94ac2b_Out_0_Float = _Noise_Edge_2;
            float4 _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4 = _Rotate_Projection;
            float _Split_83c34662c4394bda92d2da5990f2b124_R_1_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[0];
            float _Split_83c34662c4394bda92d2da5990f2b124_G_2_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[1];
            float _Split_83c34662c4394bda92d2da5990f2b124_B_3_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[2];
            float _Split_83c34662c4394bda92d2da5990f2b124_A_4_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[3];
            float3 _RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4.xyz), _Split_83c34662c4394bda92d2da5990f2b124_A_4_Float, _RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3);
            float _Property_77fe19067f40438693aa98df3480a426_Out_0_Float = _TileScale;
            float3 _Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3;
            Unity_Multiply_float3_float3(_RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3, (_Property_77fe19067f40438693aa98df3480a426_Out_0_Float.xxx), _Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3);
            float _Property_41dd9680a76949e29c341e472c8e41ee_Out_0_Float = _PositiveNoisespeed;
            float _Property_5ecd4183beb8451e9ef255004c349ad5_Out_0_Float = _NegativeNoisespeed;
            float _Property_7786adaa185c44daaca6ed08996d54d0_Out_0_Float = _MoodValue;
            float _Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float;
            Unity_Divide_float(_Property_7786adaa185c44daaca6ed08996d54d0_Out_0_Float, float(10), _Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float);
            float _Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float;
            Unity_Absolute_float(_Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float, _Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float);
            float _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float;
            Unity_Maximum_float(_Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float, float(0), _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float);
            float _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float;
            Unity_Lerp_float(_Property_41dd9680a76949e29c341e472c8e41ee_Out_0_Float, _Property_5ecd4183beb8451e9ef255004c349ad5_Out_0_Float, _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float, _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float);
            float _Multiply_91dd2cd366344500997788845d158666_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float, _Multiply_91dd2cd366344500997788845d158666_Out_2_Float);
            float2 _TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), (_Multiply_91dd2cd366344500997788845d158666_Out_2_Float.xx), _TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2);
            float _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float = _Noise_Scale;
            float _GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2, _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float, _GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float);
            float2 _TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2);
            float _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2, _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float, _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float);
            float _Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float;
            Unity_Add_float(_GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float, _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float, _Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float);
            float _Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float;
            Unity_Divide_float(_Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float, float(2), _Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float);
            float _Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float;
            Unity_Saturate_float(_Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float, _Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float);
            float _Property_84e8826753fe4fd08cbcedf557994d88_Out_0_Float = _Noise_Power;
            float _Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float;
            Unity_Power_float(_Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float, _Property_84e8826753fe4fd08cbcedf557994d88_Out_0_Float, _Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float);
            float4 _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4 = _Noise_remap;
            float _Split_48347984f6a84a9893ddcefdedd069b1_R_1_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[0];
            float _Split_48347984f6a84a9893ddcefdedd069b1_G_2_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[1];
            float _Split_48347984f6a84a9893ddcefdedd069b1_B_3_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[2];
            float _Split_48347984f6a84a9893ddcefdedd069b1_A_4_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[3];
            float4 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4;
            float3 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGB_5_Vector3;
            float2 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RG_6_Vector2;
            Unity_Combine_float(_Split_48347984f6a84a9893ddcefdedd069b1_R_1_Float, _Split_48347984f6a84a9893ddcefdedd069b1_G_2_Float, float(0), float(0), _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4, _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGB_5_Vector3, _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RG_6_Vector2);
            float4 _Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4;
            float3 _Combine_2bfc034140f647a78084b52cf23498dc_RGB_5_Vector3;
            float2 _Combine_2bfc034140f647a78084b52cf23498dc_RG_6_Vector2;
            Unity_Combine_float(_Split_48347984f6a84a9893ddcefdedd069b1_B_3_Float, _Split_48347984f6a84a9893ddcefdedd069b1_A_4_Float, float(0), float(0), _Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4, _Combine_2bfc034140f647a78084b52cf23498dc_RGB_5_Vector3, _Combine_2bfc034140f647a78084b52cf23498dc_RG_6_Vector2);
            float _Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float;
            Unity_Remap_float(_Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float, (_Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4.xy), (_Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4.xy), _Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float);
            float _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float;
            Unity_Absolute_float(_Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float, _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float);
            float _Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float;
            Unity_Smoothstep_float(_Property_37396a43db5941909959cbd08cb7213b_Out_0_Float, _Property_2d5fab0c056b463089f63a339f94ac2b_Out_0_Float, _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float, _Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float);
            float _Property_90b7a5c151634fc395d9f6d8cafa7bfb_Out_0_Float = _Positivebasespeed;
            float _Property_259361442b4a474a8ea19b196b10203b_Out_0_Float = _negativenoisespeed;
            float _Property_3c059a7fd1384747b0882ef29ca0c38b_Out_0_Float = _MoodValue;
            float _Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float;
            Unity_Divide_float(_Property_3c059a7fd1384747b0882ef29ca0c38b_Out_0_Float, float(10), _Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float);
            float _Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float;
            Unity_Absolute_float(_Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float, _Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float);
            float _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float;
            Unity_Maximum_float(_Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float, float(0), _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float);
            float _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float;
            Unity_Lerp_float(_Property_90b7a5c151634fc395d9f6d8cafa7bfb_Out_0_Float, _Property_259361442b4a474a8ea19b196b10203b_Out_0_Float, _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float, _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float);
            float _Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float, _Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float);
            float2 _TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), (_Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float.xx), _TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2);
            float _Property_9cdb12619ba0436c88021cdfb91f4ba2_Out_0_Float = _Base_Scale;
            float _GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2, _Property_9cdb12619ba0436c88021cdfb91f4ba2_Out_0_Float, _GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float);
            float _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float = _Base_Strength;
            float _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float, _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float, _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float);
            float _Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float;
            Unity_Add_float(_Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float, _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float, _Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float);
            float _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float;
            Unity_Add_float(float(1), _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float, _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float);
            float _Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float;
            Unity_Divide_float(_Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float, _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float, _Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float);
            float4 _Lerp_fb7af46f9fec41169fb74d4ab0dcc7a2_Out_3_Vector4;
            Unity_Lerp_float4(_Lerp_48dc9b1b9cba40b79c1b6f9c5fe87467_Out_3_Vector4, _Lerp_652f4c6a105746fba0956869d7bd7200_Out_3_Vector4, (_Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float.xxxx), _Lerp_fb7af46f9fec41169fb74d4ab0dcc7a2_Out_3_Vector4);
            float _Property_f30af960d15d4bd09185cdced743d48b_Out_0_Float = _Fresnal_Opacity;
            float _Property_05a34a79e2f446b5a62bfdef015042d3_Out_0_Float = _Fresnel_Power;
            float _FresnelEffect_abf83ae6e1ce4e6390acbbf3425ada01_Out_3_Float;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_05a34a79e2f446b5a62bfdef015042d3_Out_0_Float, _FresnelEffect_abf83ae6e1ce4e6390acbbf3425ada01_Out_3_Float);
            float _Multiply_68f3b78bc36c4fc196ff85aba542d8e9_Out_2_Float;
            Unity_Multiply_float_float(_Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float, _FresnelEffect_abf83ae6e1ce4e6390acbbf3425ada01_Out_3_Float, _Multiply_68f3b78bc36c4fc196ff85aba542d8e9_Out_2_Float);
            float _Multiply_f392566f12e7459b9c4c85ea0c3a0e3d_Out_2_Float;
            Unity_Multiply_float_float(_Property_f30af960d15d4bd09185cdced743d48b_Out_0_Float, _Multiply_68f3b78bc36c4fc196ff85aba542d8e9_Out_2_Float, _Multiply_f392566f12e7459b9c4c85ea0c3a0e3d_Out_2_Float);
            float4 _Add_ae7e9a4a1843486783fb52fd19923b11_Out_2_Vector4;
            Unity_Add_float4(_Lerp_fb7af46f9fec41169fb74d4ab0dcc7a2_Out_3_Vector4, (_Multiply_f392566f12e7459b9c4c85ea0c3a0e3d_Out_2_Float.xxxx), _Add_ae7e9a4a1843486783fb52fd19923b11_Out_2_Vector4);
            float _Property_2a4bb7cf4f3744a9964fed029dbf7d01_Out_0_Float = _Emission_Strength;
            float4 _Multiply_4836e8cb4abc465e937a3c0c42105592_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Add_ae7e9a4a1843486783fb52fd19923b11_Out_2_Vector4, (_Property_2a4bb7cf4f3744a9964fed029dbf7d01_Out_0_Float.xxxx), _Multiply_4836e8cb4abc465e937a3c0c42105592_Out_2_Vector4);
            float _SceneDepth_1d62aecc09a14ac0bed9f4678f0448b6_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_1d62aecc09a14ac0bed9f4678f0448b6_Out_1_Float);
            float4 _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_acd842be6bac4afb80d042288e1ad842_R_1_Float = _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4[0];
            float _Split_acd842be6bac4afb80d042288e1ad842_G_2_Float = _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4[1];
            float _Split_acd842be6bac4afb80d042288e1ad842_B_3_Float = _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4[2];
            float _Split_acd842be6bac4afb80d042288e1ad842_A_4_Float = _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4[3];
            float _Subtract_fd02db5f391c43f490009d6955270e36_Out_2_Float;
            Unity_Subtract_float(_Split_acd842be6bac4afb80d042288e1ad842_A_4_Float, float(1), _Subtract_fd02db5f391c43f490009d6955270e36_Out_2_Float);
            float _Subtract_bef36b46422c4699a3d88565f075a16f_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_1d62aecc09a14ac0bed9f4678f0448b6_Out_1_Float, _Subtract_fd02db5f391c43f490009d6955270e36_Out_2_Float, _Subtract_bef36b46422c4699a3d88565f075a16f_Out_2_Float);
            float _Property_4b0a98bda8f04d7ea94b75ebe82dc08c_Out_0_Float = _Transparency_range;
            float _Divide_1aba6093906742d5a901c9be7459b7b5_Out_2_Float;
            Unity_Divide_float(_Subtract_bef36b46422c4699a3d88565f075a16f_Out_2_Float, _Property_4b0a98bda8f04d7ea94b75ebe82dc08c_Out_0_Float, _Divide_1aba6093906742d5a901c9be7459b7b5_Out_2_Float);
            float _Saturate_fd34f19222c3440ca94ce5e6730b5449_Out_1_Float;
            Unity_Saturate_float(_Divide_1aba6093906742d5a901c9be7459b7b5_Out_2_Float, _Saturate_fd34f19222c3440ca94ce5e6730b5449_Out_1_Float);
            float _Smoothstep_8a1ab4f73b564e069ca1c5812870bad5_Out_3_Float;
            Unity_Smoothstep_float(float(0), float(1), _Saturate_fd34f19222c3440ca94ce5e6730b5449_Out_1_Float, _Smoothstep_8a1ab4f73b564e069ca1c5812870bad5_Out_3_Float);
            surface.BaseColor = (_Add_ae7e9a4a1843486783fb52fd19923b11_Out_2_Vector4.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = (_Multiply_4836e8cb4abc465e937a3c0c42105592_Out_2_Vector4.xyz);
            surface.Metallic = float(0);
            surface.Smoothness = float(0.5);
            surface.Occlusion = float(1);
            surface.Alpha = _Smoothstep_8a1ab4f73b564e069ca1c5812870bad5_Out_3_Float;
            surface.AlphaClipThreshold = float(0.5);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
        {
            result.vertex     = float4(attributes.positionOS, 1);
            result.tangent    = attributes.tangentOS;
            result.normal     = attributes.normalOS;
            result.texcoord1  = attributes.uv1;
            result.vertex     = float4(vertexDescription.Position, 1);
            result.normal     = vertexDescription.Normal;
            result.tangent    = float4(vertexDescription.Tangent, 0);
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
        }
        
        void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
        {
            result.pos = varyings.positionCS;
            result.worldPos = varyings.positionWS;
            result.worldNormal = varyings.normalWS;
            // World Tangent isn't an available input on v2f_surf
        
            result._ShadowCoord = varyings.shadowCoord;
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            #if !defined(LIGHTMAP_ON)
            result.sh = varyings.sh;
            #endif
            #endif
            #if defined(LIGHTMAP_ON)
            result.lmap.xy = varyings.lightmapUV;
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogCoord = varyings.fogFactorAndVertexLight.x;
                COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
        }
        
        void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
        {
            result.positionCS = surfVertex.pos;
            result.positionWS = surfVertex.worldPos;
            result.normalWS = surfVertex.worldNormal;
            // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
            // World Tangent isn't an available input on v2f_surf
            result.shadowCoord = surfVertex._ShadowCoord;
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            #if !defined(LIGHTMAP_ON)
            result.sh = surfVertex.sh;
            #endif
            #endif
            #if defined(LIGHTMAP_ON)
            result.lightmapUV = surfVertex.lmap.xy;
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
                COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
        
        ENDHLSL
        }
        Pass
        {
            Name "BuiltIn ForwardAdd"
            Tags
            {
                "LightMode" = "ForwardAdd"
            }
        
        // Render State
        Blend SrcAlpha One
        ZWrite Off
        ColorMask RGB
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.0
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma multi_compile_fwdadd_fullshadows
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
        #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        // GraphKeywords: <None>
        
        // Defines
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD_ADD
        #define BUILTIN_TARGET_API 1
        #define _BUILTIN_SURFACE_TYPE_TRANSPARENT 1
        #define _BUILTIN_AlphaClip 1
        #define _BUILTIN_ALPHATEST_ON 1
        #define REQUIRE_DEPTH_TEXTURE
        #ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #endif
        #ifdef _BUILTIN_ALPHATEST_ON
        #define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
        #endif
        #ifdef _BUILTIN_AlphaClip
        #define _AlphaClip _BUILTIN_AlphaClip
        #endif
        #ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
        #define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
        #endif
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
            #if defined(LIGHTMAP_ON)
             float2 lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
             float4 shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 TangentSpaceNormal;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 lightmapUV : INTERP0;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP1;
            #endif
             float4 tangentWS : INTERP2;
             float4 fogFactorAndVertexLight : INTERP3;
             float4 shadowCoord : INTERP4;
             float3 positionWS : INTERP5;
             float3 normalWS : INTERP6;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.lightmapUV = input.lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.shadowCoord.xyzw = input.shadowCoord;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.lightmapUV = input.lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.shadowCoord = input.shadowCoord.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _NegativeNoisespeed;
        float _Positive_Noiseheight;
        float4 _Noise_remap;
        float4 _NegativValleyColor;
        float4 _NegativPeakColor;
        float _Noise_Edge_1;
        float _Noise_Edge_2;
        float _Noise_Power;
        float _Base_Scale;
        float _negativenoisespeed;
        float _Base_Strength;
        float _Emission_Strength;
        float _Bowl_Curvature;
        float _Fresnel_Power;
        float _Fresnal_Opacity;
        float _Transparency_range;
        float _TileScale;
        float4 _Positive_ValleyColor;
        float4 _PositivePeakColor;
        float _MoodValue;
        float _NegativeNoiseheight;
        float _PositiveNoisespeed;
        float _Positivebasespeed;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
            float s, c;
            sincos(Rotation, s, c);
            Axis = normalize(Axis);
            Out = In * c + cross(Axis, In) * s + Axis * dot(Axis, In) * (1 - c);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
        {
            Out = pow((1.0 - saturate(dot(normalize(Normal), ViewDir))), Power);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_37b74d35aea7418684eea7308fed4dc2_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_37b74d35aea7418684eea7308fed4dc2_Out_2_Float);
            float _Multiply_6c95e880611244deac2b872b6decd88d_Out_2_Float;
            Unity_Multiply_float_float(_Distance_37b74d35aea7418684eea7308fed4dc2_Out_2_Float, -1, _Multiply_6c95e880611244deac2b872b6decd88d_Out_2_Float);
            float _Property_960eb8d9027b4ea1a34e2806e82d40da_Out_0_Float = _Bowl_Curvature;
            float _Divide_e3bfc6ac830e4502bdb64c805aa9a3ef_Out_2_Float;
            Unity_Divide_float(_Multiply_6c95e880611244deac2b872b6decd88d_Out_2_Float, _Property_960eb8d9027b4ea1a34e2806e82d40da_Out_0_Float, _Divide_e3bfc6ac830e4502bdb64c805aa9a3ef_Out_2_Float);
            float _Power_09d0ece4dc0f41e9b8894ee456c020c9_Out_2_Float;
            Unity_Power_float(_Divide_e3bfc6ac830e4502bdb64c805aa9a3ef_Out_2_Float, float(3), _Power_09d0ece4dc0f41e9b8894ee456c020c9_Out_2_Float);
            float3 _Multiply_c90d63e869b44661889a2e2dfe9e0e0b_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_09d0ece4dc0f41e9b8894ee456c020c9_Out_2_Float.xxx), _Multiply_c90d63e869b44661889a2e2dfe9e0e0b_Out_2_Vector3);
            float _Property_37396a43db5941909959cbd08cb7213b_Out_0_Float = _Noise_Edge_1;
            float _Property_2d5fab0c056b463089f63a339f94ac2b_Out_0_Float = _Noise_Edge_2;
            float4 _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4 = _Rotate_Projection;
            float _Split_83c34662c4394bda92d2da5990f2b124_R_1_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[0];
            float _Split_83c34662c4394bda92d2da5990f2b124_G_2_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[1];
            float _Split_83c34662c4394bda92d2da5990f2b124_B_3_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[2];
            float _Split_83c34662c4394bda92d2da5990f2b124_A_4_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[3];
            float3 _RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4.xyz), _Split_83c34662c4394bda92d2da5990f2b124_A_4_Float, _RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3);
            float _Property_77fe19067f40438693aa98df3480a426_Out_0_Float = _TileScale;
            float3 _Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3;
            Unity_Multiply_float3_float3(_RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3, (_Property_77fe19067f40438693aa98df3480a426_Out_0_Float.xxx), _Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3);
            float _Property_41dd9680a76949e29c341e472c8e41ee_Out_0_Float = _PositiveNoisespeed;
            float _Property_5ecd4183beb8451e9ef255004c349ad5_Out_0_Float = _NegativeNoisespeed;
            float _Property_7786adaa185c44daaca6ed08996d54d0_Out_0_Float = _MoodValue;
            float _Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float;
            Unity_Divide_float(_Property_7786adaa185c44daaca6ed08996d54d0_Out_0_Float, float(10), _Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float);
            float _Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float;
            Unity_Absolute_float(_Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float, _Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float);
            float _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float;
            Unity_Maximum_float(_Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float, float(0), _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float);
            float _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float;
            Unity_Lerp_float(_Property_41dd9680a76949e29c341e472c8e41ee_Out_0_Float, _Property_5ecd4183beb8451e9ef255004c349ad5_Out_0_Float, _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float, _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float);
            float _Multiply_91dd2cd366344500997788845d158666_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float, _Multiply_91dd2cd366344500997788845d158666_Out_2_Float);
            float2 _TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), (_Multiply_91dd2cd366344500997788845d158666_Out_2_Float.xx), _TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2);
            float _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float = _Noise_Scale;
            float _GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2, _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float, _GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float);
            float2 _TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2);
            float _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2, _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float, _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float);
            float _Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float;
            Unity_Add_float(_GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float, _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float, _Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float);
            float _Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float;
            Unity_Divide_float(_Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float, float(2), _Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float);
            float _Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float;
            Unity_Saturate_float(_Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float, _Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float);
            float _Property_84e8826753fe4fd08cbcedf557994d88_Out_0_Float = _Noise_Power;
            float _Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float;
            Unity_Power_float(_Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float, _Property_84e8826753fe4fd08cbcedf557994d88_Out_0_Float, _Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float);
            float4 _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4 = _Noise_remap;
            float _Split_48347984f6a84a9893ddcefdedd069b1_R_1_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[0];
            float _Split_48347984f6a84a9893ddcefdedd069b1_G_2_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[1];
            float _Split_48347984f6a84a9893ddcefdedd069b1_B_3_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[2];
            float _Split_48347984f6a84a9893ddcefdedd069b1_A_4_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[3];
            float4 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4;
            float3 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGB_5_Vector3;
            float2 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RG_6_Vector2;
            Unity_Combine_float(_Split_48347984f6a84a9893ddcefdedd069b1_R_1_Float, _Split_48347984f6a84a9893ddcefdedd069b1_G_2_Float, float(0), float(0), _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4, _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGB_5_Vector3, _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RG_6_Vector2);
            float4 _Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4;
            float3 _Combine_2bfc034140f647a78084b52cf23498dc_RGB_5_Vector3;
            float2 _Combine_2bfc034140f647a78084b52cf23498dc_RG_6_Vector2;
            Unity_Combine_float(_Split_48347984f6a84a9893ddcefdedd069b1_B_3_Float, _Split_48347984f6a84a9893ddcefdedd069b1_A_4_Float, float(0), float(0), _Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4, _Combine_2bfc034140f647a78084b52cf23498dc_RGB_5_Vector3, _Combine_2bfc034140f647a78084b52cf23498dc_RG_6_Vector2);
            float _Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float;
            Unity_Remap_float(_Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float, (_Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4.xy), (_Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4.xy), _Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float);
            float _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float;
            Unity_Absolute_float(_Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float, _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float);
            float _Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float;
            Unity_Smoothstep_float(_Property_37396a43db5941909959cbd08cb7213b_Out_0_Float, _Property_2d5fab0c056b463089f63a339f94ac2b_Out_0_Float, _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float, _Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float);
            float _Property_90b7a5c151634fc395d9f6d8cafa7bfb_Out_0_Float = _Positivebasespeed;
            float _Property_259361442b4a474a8ea19b196b10203b_Out_0_Float = _negativenoisespeed;
            float _Property_3c059a7fd1384747b0882ef29ca0c38b_Out_0_Float = _MoodValue;
            float _Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float;
            Unity_Divide_float(_Property_3c059a7fd1384747b0882ef29ca0c38b_Out_0_Float, float(10), _Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float);
            float _Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float;
            Unity_Absolute_float(_Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float, _Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float);
            float _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float;
            Unity_Maximum_float(_Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float, float(0), _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float);
            float _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float;
            Unity_Lerp_float(_Property_90b7a5c151634fc395d9f6d8cafa7bfb_Out_0_Float, _Property_259361442b4a474a8ea19b196b10203b_Out_0_Float, _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float, _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float);
            float _Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float, _Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float);
            float2 _TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), (_Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float.xx), _TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2);
            float _Property_9cdb12619ba0436c88021cdfb91f4ba2_Out_0_Float = _Base_Scale;
            float _GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2, _Property_9cdb12619ba0436c88021cdfb91f4ba2_Out_0_Float, _GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float);
            float _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float = _Base_Strength;
            float _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float, _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float, _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float);
            float _Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float;
            Unity_Add_float(_Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float, _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float, _Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float);
            float _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float;
            Unity_Add_float(float(1), _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float, _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float);
            float _Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float;
            Unity_Divide_float(_Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float, _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float, _Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float);
            float3 _Multiply_1c3e80d5ad544d37afeae348e005b1ce_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float.xxx), _Multiply_1c3e80d5ad544d37afeae348e005b1ce_Out_2_Vector3);
            float _Property_fbedcc335e4e489a88530feceac28a92_Out_0_Float = _Positive_Noiseheight;
            float _Property_51562b6bcc0e49889a5b042bd9dd3ec1_Out_0_Float = _NegativeNoiseheight;
            float _Property_4a38113a4b3d4df9a442abaf0dfc7175_Out_0_Float = _MoodValue;
            float _Divide_c3a203997247432380c98ea6f1105246_Out_2_Float;
            Unity_Divide_float(_Property_4a38113a4b3d4df9a442abaf0dfc7175_Out_0_Float, float(10), _Divide_c3a203997247432380c98ea6f1105246_Out_2_Float);
            float _Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float;
            Unity_Absolute_float(_Divide_c3a203997247432380c98ea6f1105246_Out_2_Float, _Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float);
            float _Maximum_ea3824aff9834aa6abb200d18549a1ab_Out_2_Float;
            Unity_Maximum_float(_Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float, float(0), _Maximum_ea3824aff9834aa6abb200d18549a1ab_Out_2_Float);
            float _Lerp_631ef014257c45109ba70e191310a027_Out_3_Float;
            Unity_Lerp_float(_Property_fbedcc335e4e489a88530feceac28a92_Out_0_Float, _Property_51562b6bcc0e49889a5b042bd9dd3ec1_Out_0_Float, _Maximum_ea3824aff9834aa6abb200d18549a1ab_Out_2_Float, _Lerp_631ef014257c45109ba70e191310a027_Out_3_Float);
            float3 _Multiply_f5b6315c130940588d7d1a13e6a6ff4b_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_1c3e80d5ad544d37afeae348e005b1ce_Out_2_Vector3, (_Lerp_631ef014257c45109ba70e191310a027_Out_3_Float.xxx), _Multiply_f5b6315c130940588d7d1a13e6a6ff4b_Out_2_Vector3);
            float3 _Add_61d8564b498f4b51a52cb66ee888a83f_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_f5b6315c130940588d7d1a13e6a6ff4b_Out_2_Vector3, _Add_61d8564b498f4b51a52cb66ee888a83f_Out_2_Vector3);
            float3 _Add_b49f2b0d3cc549f6a4a0e455f9e0e053_Out_2_Vector3;
            Unity_Add_float3(_Multiply_c90d63e869b44661889a2e2dfe9e0e0b_Out_2_Vector3, _Add_61d8564b498f4b51a52cb66ee888a83f_Out_2_Vector3, _Add_b49f2b0d3cc549f6a4a0e455f9e0e053_Out_2_Vector3);
            description.Position = _Add_b49f2b0d3cc549f6a4a0e455f9e0e053_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_288513cbd498440b82da4722d2a9ff59_Out_0_Vector4 = _Positive_ValleyColor;
            float4 _Property_78dea4090d6f48fba8829f6c8c2024cf_Out_0_Vector4 = _NegativValleyColor;
            float _Property_4a38113a4b3d4df9a442abaf0dfc7175_Out_0_Float = _MoodValue;
            float _Divide_c3a203997247432380c98ea6f1105246_Out_2_Float;
            Unity_Divide_float(_Property_4a38113a4b3d4df9a442abaf0dfc7175_Out_0_Float, float(10), _Divide_c3a203997247432380c98ea6f1105246_Out_2_Float);
            float _Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float;
            Unity_Absolute_float(_Divide_c3a203997247432380c98ea6f1105246_Out_2_Float, _Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float);
            float _Maximum_0bb8511684d44e4cb7bee914f9e77855_Out_2_Float;
            Unity_Maximum_float(_Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float, float(0), _Maximum_0bb8511684d44e4cb7bee914f9e77855_Out_2_Float);
            float4 _Lerp_48dc9b1b9cba40b79c1b6f9c5fe87467_Out_3_Vector4;
            Unity_Lerp_float4(_Property_288513cbd498440b82da4722d2a9ff59_Out_0_Vector4, _Property_78dea4090d6f48fba8829f6c8c2024cf_Out_0_Vector4, (_Maximum_0bb8511684d44e4cb7bee914f9e77855_Out_2_Float.xxxx), _Lerp_48dc9b1b9cba40b79c1b6f9c5fe87467_Out_3_Vector4);
            float4 _Property_58011cd26b9e4b0389d33a1be1815b68_Out_0_Vector4 = _PositivePeakColor;
            float4 _Property_58445f66054345ddbf670ee452dae706_Out_0_Vector4 = _NegativPeakColor;
            float _Maximum_863fe33b940b414eb6bb87d39e1a6653_Out_2_Float;
            Unity_Maximum_float(_Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float, float(0), _Maximum_863fe33b940b414eb6bb87d39e1a6653_Out_2_Float);
            float4 _Lerp_652f4c6a105746fba0956869d7bd7200_Out_3_Vector4;
            Unity_Lerp_float4(_Property_58011cd26b9e4b0389d33a1be1815b68_Out_0_Vector4, _Property_58445f66054345ddbf670ee452dae706_Out_0_Vector4, (_Maximum_863fe33b940b414eb6bb87d39e1a6653_Out_2_Float.xxxx), _Lerp_652f4c6a105746fba0956869d7bd7200_Out_3_Vector4);
            float _Property_37396a43db5941909959cbd08cb7213b_Out_0_Float = _Noise_Edge_1;
            float _Property_2d5fab0c056b463089f63a339f94ac2b_Out_0_Float = _Noise_Edge_2;
            float4 _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4 = _Rotate_Projection;
            float _Split_83c34662c4394bda92d2da5990f2b124_R_1_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[0];
            float _Split_83c34662c4394bda92d2da5990f2b124_G_2_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[1];
            float _Split_83c34662c4394bda92d2da5990f2b124_B_3_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[2];
            float _Split_83c34662c4394bda92d2da5990f2b124_A_4_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[3];
            float3 _RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4.xyz), _Split_83c34662c4394bda92d2da5990f2b124_A_4_Float, _RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3);
            float _Property_77fe19067f40438693aa98df3480a426_Out_0_Float = _TileScale;
            float3 _Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3;
            Unity_Multiply_float3_float3(_RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3, (_Property_77fe19067f40438693aa98df3480a426_Out_0_Float.xxx), _Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3);
            float _Property_41dd9680a76949e29c341e472c8e41ee_Out_0_Float = _PositiveNoisespeed;
            float _Property_5ecd4183beb8451e9ef255004c349ad5_Out_0_Float = _NegativeNoisespeed;
            float _Property_7786adaa185c44daaca6ed08996d54d0_Out_0_Float = _MoodValue;
            float _Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float;
            Unity_Divide_float(_Property_7786adaa185c44daaca6ed08996d54d0_Out_0_Float, float(10), _Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float);
            float _Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float;
            Unity_Absolute_float(_Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float, _Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float);
            float _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float;
            Unity_Maximum_float(_Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float, float(0), _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float);
            float _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float;
            Unity_Lerp_float(_Property_41dd9680a76949e29c341e472c8e41ee_Out_0_Float, _Property_5ecd4183beb8451e9ef255004c349ad5_Out_0_Float, _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float, _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float);
            float _Multiply_91dd2cd366344500997788845d158666_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float, _Multiply_91dd2cd366344500997788845d158666_Out_2_Float);
            float2 _TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), (_Multiply_91dd2cd366344500997788845d158666_Out_2_Float.xx), _TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2);
            float _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float = _Noise_Scale;
            float _GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2, _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float, _GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float);
            float2 _TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2);
            float _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2, _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float, _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float);
            float _Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float;
            Unity_Add_float(_GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float, _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float, _Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float);
            float _Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float;
            Unity_Divide_float(_Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float, float(2), _Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float);
            float _Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float;
            Unity_Saturate_float(_Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float, _Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float);
            float _Property_84e8826753fe4fd08cbcedf557994d88_Out_0_Float = _Noise_Power;
            float _Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float;
            Unity_Power_float(_Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float, _Property_84e8826753fe4fd08cbcedf557994d88_Out_0_Float, _Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float);
            float4 _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4 = _Noise_remap;
            float _Split_48347984f6a84a9893ddcefdedd069b1_R_1_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[0];
            float _Split_48347984f6a84a9893ddcefdedd069b1_G_2_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[1];
            float _Split_48347984f6a84a9893ddcefdedd069b1_B_3_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[2];
            float _Split_48347984f6a84a9893ddcefdedd069b1_A_4_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[3];
            float4 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4;
            float3 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGB_5_Vector3;
            float2 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RG_6_Vector2;
            Unity_Combine_float(_Split_48347984f6a84a9893ddcefdedd069b1_R_1_Float, _Split_48347984f6a84a9893ddcefdedd069b1_G_2_Float, float(0), float(0), _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4, _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGB_5_Vector3, _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RG_6_Vector2);
            float4 _Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4;
            float3 _Combine_2bfc034140f647a78084b52cf23498dc_RGB_5_Vector3;
            float2 _Combine_2bfc034140f647a78084b52cf23498dc_RG_6_Vector2;
            Unity_Combine_float(_Split_48347984f6a84a9893ddcefdedd069b1_B_3_Float, _Split_48347984f6a84a9893ddcefdedd069b1_A_4_Float, float(0), float(0), _Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4, _Combine_2bfc034140f647a78084b52cf23498dc_RGB_5_Vector3, _Combine_2bfc034140f647a78084b52cf23498dc_RG_6_Vector2);
            float _Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float;
            Unity_Remap_float(_Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float, (_Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4.xy), (_Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4.xy), _Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float);
            float _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float;
            Unity_Absolute_float(_Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float, _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float);
            float _Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float;
            Unity_Smoothstep_float(_Property_37396a43db5941909959cbd08cb7213b_Out_0_Float, _Property_2d5fab0c056b463089f63a339f94ac2b_Out_0_Float, _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float, _Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float);
            float _Property_90b7a5c151634fc395d9f6d8cafa7bfb_Out_0_Float = _Positivebasespeed;
            float _Property_259361442b4a474a8ea19b196b10203b_Out_0_Float = _negativenoisespeed;
            float _Property_3c059a7fd1384747b0882ef29ca0c38b_Out_0_Float = _MoodValue;
            float _Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float;
            Unity_Divide_float(_Property_3c059a7fd1384747b0882ef29ca0c38b_Out_0_Float, float(10), _Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float);
            float _Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float;
            Unity_Absolute_float(_Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float, _Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float);
            float _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float;
            Unity_Maximum_float(_Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float, float(0), _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float);
            float _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float;
            Unity_Lerp_float(_Property_90b7a5c151634fc395d9f6d8cafa7bfb_Out_0_Float, _Property_259361442b4a474a8ea19b196b10203b_Out_0_Float, _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float, _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float);
            float _Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float, _Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float);
            float2 _TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), (_Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float.xx), _TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2);
            float _Property_9cdb12619ba0436c88021cdfb91f4ba2_Out_0_Float = _Base_Scale;
            float _GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2, _Property_9cdb12619ba0436c88021cdfb91f4ba2_Out_0_Float, _GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float);
            float _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float = _Base_Strength;
            float _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float, _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float, _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float);
            float _Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float;
            Unity_Add_float(_Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float, _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float, _Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float);
            float _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float;
            Unity_Add_float(float(1), _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float, _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float);
            float _Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float;
            Unity_Divide_float(_Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float, _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float, _Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float);
            float4 _Lerp_fb7af46f9fec41169fb74d4ab0dcc7a2_Out_3_Vector4;
            Unity_Lerp_float4(_Lerp_48dc9b1b9cba40b79c1b6f9c5fe87467_Out_3_Vector4, _Lerp_652f4c6a105746fba0956869d7bd7200_Out_3_Vector4, (_Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float.xxxx), _Lerp_fb7af46f9fec41169fb74d4ab0dcc7a2_Out_3_Vector4);
            float _Property_f30af960d15d4bd09185cdced743d48b_Out_0_Float = _Fresnal_Opacity;
            float _Property_05a34a79e2f446b5a62bfdef015042d3_Out_0_Float = _Fresnel_Power;
            float _FresnelEffect_abf83ae6e1ce4e6390acbbf3425ada01_Out_3_Float;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_05a34a79e2f446b5a62bfdef015042d3_Out_0_Float, _FresnelEffect_abf83ae6e1ce4e6390acbbf3425ada01_Out_3_Float);
            float _Multiply_68f3b78bc36c4fc196ff85aba542d8e9_Out_2_Float;
            Unity_Multiply_float_float(_Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float, _FresnelEffect_abf83ae6e1ce4e6390acbbf3425ada01_Out_3_Float, _Multiply_68f3b78bc36c4fc196ff85aba542d8e9_Out_2_Float);
            float _Multiply_f392566f12e7459b9c4c85ea0c3a0e3d_Out_2_Float;
            Unity_Multiply_float_float(_Property_f30af960d15d4bd09185cdced743d48b_Out_0_Float, _Multiply_68f3b78bc36c4fc196ff85aba542d8e9_Out_2_Float, _Multiply_f392566f12e7459b9c4c85ea0c3a0e3d_Out_2_Float);
            float4 _Add_ae7e9a4a1843486783fb52fd19923b11_Out_2_Vector4;
            Unity_Add_float4(_Lerp_fb7af46f9fec41169fb74d4ab0dcc7a2_Out_3_Vector4, (_Multiply_f392566f12e7459b9c4c85ea0c3a0e3d_Out_2_Float.xxxx), _Add_ae7e9a4a1843486783fb52fd19923b11_Out_2_Vector4);
            float _Property_2a4bb7cf4f3744a9964fed029dbf7d01_Out_0_Float = _Emission_Strength;
            float4 _Multiply_4836e8cb4abc465e937a3c0c42105592_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Add_ae7e9a4a1843486783fb52fd19923b11_Out_2_Vector4, (_Property_2a4bb7cf4f3744a9964fed029dbf7d01_Out_0_Float.xxxx), _Multiply_4836e8cb4abc465e937a3c0c42105592_Out_2_Vector4);
            float _SceneDepth_1d62aecc09a14ac0bed9f4678f0448b6_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_1d62aecc09a14ac0bed9f4678f0448b6_Out_1_Float);
            float4 _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_acd842be6bac4afb80d042288e1ad842_R_1_Float = _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4[0];
            float _Split_acd842be6bac4afb80d042288e1ad842_G_2_Float = _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4[1];
            float _Split_acd842be6bac4afb80d042288e1ad842_B_3_Float = _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4[2];
            float _Split_acd842be6bac4afb80d042288e1ad842_A_4_Float = _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4[3];
            float _Subtract_fd02db5f391c43f490009d6955270e36_Out_2_Float;
            Unity_Subtract_float(_Split_acd842be6bac4afb80d042288e1ad842_A_4_Float, float(1), _Subtract_fd02db5f391c43f490009d6955270e36_Out_2_Float);
            float _Subtract_bef36b46422c4699a3d88565f075a16f_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_1d62aecc09a14ac0bed9f4678f0448b6_Out_1_Float, _Subtract_fd02db5f391c43f490009d6955270e36_Out_2_Float, _Subtract_bef36b46422c4699a3d88565f075a16f_Out_2_Float);
            float _Property_4b0a98bda8f04d7ea94b75ebe82dc08c_Out_0_Float = _Transparency_range;
            float _Divide_1aba6093906742d5a901c9be7459b7b5_Out_2_Float;
            Unity_Divide_float(_Subtract_bef36b46422c4699a3d88565f075a16f_Out_2_Float, _Property_4b0a98bda8f04d7ea94b75ebe82dc08c_Out_0_Float, _Divide_1aba6093906742d5a901c9be7459b7b5_Out_2_Float);
            float _Saturate_fd34f19222c3440ca94ce5e6730b5449_Out_1_Float;
            Unity_Saturate_float(_Divide_1aba6093906742d5a901c9be7459b7b5_Out_2_Float, _Saturate_fd34f19222c3440ca94ce5e6730b5449_Out_1_Float);
            float _Smoothstep_8a1ab4f73b564e069ca1c5812870bad5_Out_3_Float;
            Unity_Smoothstep_float(float(0), float(1), _Saturate_fd34f19222c3440ca94ce5e6730b5449_Out_1_Float, _Smoothstep_8a1ab4f73b564e069ca1c5812870bad5_Out_3_Float);
            surface.BaseColor = (_Add_ae7e9a4a1843486783fb52fd19923b11_Out_2_Vector4.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = (_Multiply_4836e8cb4abc465e937a3c0c42105592_Out_2_Vector4.xyz);
            surface.Metallic = float(0);
            surface.Smoothness = float(0.5);
            surface.Occlusion = float(1);
            surface.Alpha = _Smoothstep_8a1ab4f73b564e069ca1c5812870bad5_Out_3_Float;
            surface.AlphaClipThreshold = float(0.5);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
        {
            result.vertex     = float4(attributes.positionOS, 1);
            result.tangent    = attributes.tangentOS;
            result.normal     = attributes.normalOS;
            result.texcoord1  = attributes.uv1;
            result.vertex     = float4(vertexDescription.Position, 1);
            result.normal     = vertexDescription.Normal;
            result.tangent    = float4(vertexDescription.Tangent, 0);
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
        }
        
        void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
        {
            result.pos = varyings.positionCS;
            result.worldPos = varyings.positionWS;
            result.worldNormal = varyings.normalWS;
            // World Tangent isn't an available input on v2f_surf
        
            result._ShadowCoord = varyings.shadowCoord;
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            #if !defined(LIGHTMAP_ON)
            result.sh = varyings.sh;
            #endif
            #endif
            #if defined(LIGHTMAP_ON)
            result.lmap.xy = varyings.lightmapUV;
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogCoord = varyings.fogFactorAndVertexLight.x;
                COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
        }
        
        void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
        {
            result.positionCS = surfVertex.pos;
            result.positionWS = surfVertex.worldPos;
            result.normalWS = surfVertex.worldNormal;
            // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
            // World Tangent isn't an available input on v2f_surf
            result.shadowCoord = surfVertex._ShadowCoord;
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            #if !defined(LIGHTMAP_ON)
            result.sh = surfVertex.sh;
            #endif
            #endif
            #if defined(LIGHTMAP_ON)
            result.lightmapUV = surfVertex.lmap.xy;
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
                COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/PBRForwardAddPass.hlsl"
        
        ENDHLSL
        }
        Pass
        {
            Name "BuiltIn Deferred"
            Tags
            {
                "LightMode" = "Deferred"
            }
        
        // Render State
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        ColorMask RGB
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma multi_compile_instancing
        #pragma exclude_renderers nomrt
        #pragma multi_compile_prepassfinal
        #pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        #pragma multi_compile _ _GBUFFER_NORMALS_OCT
        // GraphKeywords: <None>
        
        // Defines
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEFERRED
        #define BUILTIN_TARGET_API 1
        #define _BUILTIN_SURFACE_TYPE_TRANSPARENT 1
        #define _BUILTIN_AlphaClip 1
        #define _BUILTIN_ALPHATEST_ON 1
        #define REQUIRE_DEPTH_TEXTURE
        #ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #endif
        #ifdef _BUILTIN_ALPHATEST_ON
        #define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
        #endif
        #ifdef _BUILTIN_AlphaClip
        #define _AlphaClip _BUILTIN_AlphaClip
        #endif
        #ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
        #define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
        #endif
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
            #if defined(LIGHTMAP_ON)
             float2 lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
             float4 shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 TangentSpaceNormal;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 lightmapUV : INTERP0;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP1;
            #endif
             float4 tangentWS : INTERP2;
             float4 fogFactorAndVertexLight : INTERP3;
             float4 shadowCoord : INTERP4;
             float3 positionWS : INTERP5;
             float3 normalWS : INTERP6;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.lightmapUV = input.lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.shadowCoord.xyzw = input.shadowCoord;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.lightmapUV = input.lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.shadowCoord = input.shadowCoord.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _NegativeNoisespeed;
        float _Positive_Noiseheight;
        float4 _Noise_remap;
        float4 _NegativValleyColor;
        float4 _NegativPeakColor;
        float _Noise_Edge_1;
        float _Noise_Edge_2;
        float _Noise_Power;
        float _Base_Scale;
        float _negativenoisespeed;
        float _Base_Strength;
        float _Emission_Strength;
        float _Bowl_Curvature;
        float _Fresnel_Power;
        float _Fresnal_Opacity;
        float _Transparency_range;
        float _TileScale;
        float4 _Positive_ValleyColor;
        float4 _PositivePeakColor;
        float _MoodValue;
        float _NegativeNoiseheight;
        float _PositiveNoisespeed;
        float _Positivebasespeed;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
            float s, c;
            sincos(Rotation, s, c);
            Axis = normalize(Axis);
            Out = In * c + cross(Axis, In) * s + Axis * dot(Axis, In) * (1 - c);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
        {
            Out = pow((1.0 - saturate(dot(normalize(Normal), ViewDir))), Power);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_37b74d35aea7418684eea7308fed4dc2_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_37b74d35aea7418684eea7308fed4dc2_Out_2_Float);
            float _Multiply_6c95e880611244deac2b872b6decd88d_Out_2_Float;
            Unity_Multiply_float_float(_Distance_37b74d35aea7418684eea7308fed4dc2_Out_2_Float, -1, _Multiply_6c95e880611244deac2b872b6decd88d_Out_2_Float);
            float _Property_960eb8d9027b4ea1a34e2806e82d40da_Out_0_Float = _Bowl_Curvature;
            float _Divide_e3bfc6ac830e4502bdb64c805aa9a3ef_Out_2_Float;
            Unity_Divide_float(_Multiply_6c95e880611244deac2b872b6decd88d_Out_2_Float, _Property_960eb8d9027b4ea1a34e2806e82d40da_Out_0_Float, _Divide_e3bfc6ac830e4502bdb64c805aa9a3ef_Out_2_Float);
            float _Power_09d0ece4dc0f41e9b8894ee456c020c9_Out_2_Float;
            Unity_Power_float(_Divide_e3bfc6ac830e4502bdb64c805aa9a3ef_Out_2_Float, float(3), _Power_09d0ece4dc0f41e9b8894ee456c020c9_Out_2_Float);
            float3 _Multiply_c90d63e869b44661889a2e2dfe9e0e0b_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_09d0ece4dc0f41e9b8894ee456c020c9_Out_2_Float.xxx), _Multiply_c90d63e869b44661889a2e2dfe9e0e0b_Out_2_Vector3);
            float _Property_37396a43db5941909959cbd08cb7213b_Out_0_Float = _Noise_Edge_1;
            float _Property_2d5fab0c056b463089f63a339f94ac2b_Out_0_Float = _Noise_Edge_2;
            float4 _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4 = _Rotate_Projection;
            float _Split_83c34662c4394bda92d2da5990f2b124_R_1_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[0];
            float _Split_83c34662c4394bda92d2da5990f2b124_G_2_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[1];
            float _Split_83c34662c4394bda92d2da5990f2b124_B_3_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[2];
            float _Split_83c34662c4394bda92d2da5990f2b124_A_4_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[3];
            float3 _RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4.xyz), _Split_83c34662c4394bda92d2da5990f2b124_A_4_Float, _RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3);
            float _Property_77fe19067f40438693aa98df3480a426_Out_0_Float = _TileScale;
            float3 _Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3;
            Unity_Multiply_float3_float3(_RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3, (_Property_77fe19067f40438693aa98df3480a426_Out_0_Float.xxx), _Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3);
            float _Property_41dd9680a76949e29c341e472c8e41ee_Out_0_Float = _PositiveNoisespeed;
            float _Property_5ecd4183beb8451e9ef255004c349ad5_Out_0_Float = _NegativeNoisespeed;
            float _Property_7786adaa185c44daaca6ed08996d54d0_Out_0_Float = _MoodValue;
            float _Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float;
            Unity_Divide_float(_Property_7786adaa185c44daaca6ed08996d54d0_Out_0_Float, float(10), _Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float);
            float _Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float;
            Unity_Absolute_float(_Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float, _Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float);
            float _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float;
            Unity_Maximum_float(_Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float, float(0), _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float);
            float _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float;
            Unity_Lerp_float(_Property_41dd9680a76949e29c341e472c8e41ee_Out_0_Float, _Property_5ecd4183beb8451e9ef255004c349ad5_Out_0_Float, _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float, _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float);
            float _Multiply_91dd2cd366344500997788845d158666_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float, _Multiply_91dd2cd366344500997788845d158666_Out_2_Float);
            float2 _TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), (_Multiply_91dd2cd366344500997788845d158666_Out_2_Float.xx), _TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2);
            float _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float = _Noise_Scale;
            float _GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2, _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float, _GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float);
            float2 _TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2);
            float _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2, _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float, _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float);
            float _Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float;
            Unity_Add_float(_GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float, _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float, _Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float);
            float _Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float;
            Unity_Divide_float(_Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float, float(2), _Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float);
            float _Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float;
            Unity_Saturate_float(_Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float, _Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float);
            float _Property_84e8826753fe4fd08cbcedf557994d88_Out_0_Float = _Noise_Power;
            float _Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float;
            Unity_Power_float(_Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float, _Property_84e8826753fe4fd08cbcedf557994d88_Out_0_Float, _Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float);
            float4 _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4 = _Noise_remap;
            float _Split_48347984f6a84a9893ddcefdedd069b1_R_1_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[0];
            float _Split_48347984f6a84a9893ddcefdedd069b1_G_2_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[1];
            float _Split_48347984f6a84a9893ddcefdedd069b1_B_3_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[2];
            float _Split_48347984f6a84a9893ddcefdedd069b1_A_4_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[3];
            float4 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4;
            float3 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGB_5_Vector3;
            float2 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RG_6_Vector2;
            Unity_Combine_float(_Split_48347984f6a84a9893ddcefdedd069b1_R_1_Float, _Split_48347984f6a84a9893ddcefdedd069b1_G_2_Float, float(0), float(0), _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4, _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGB_5_Vector3, _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RG_6_Vector2);
            float4 _Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4;
            float3 _Combine_2bfc034140f647a78084b52cf23498dc_RGB_5_Vector3;
            float2 _Combine_2bfc034140f647a78084b52cf23498dc_RG_6_Vector2;
            Unity_Combine_float(_Split_48347984f6a84a9893ddcefdedd069b1_B_3_Float, _Split_48347984f6a84a9893ddcefdedd069b1_A_4_Float, float(0), float(0), _Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4, _Combine_2bfc034140f647a78084b52cf23498dc_RGB_5_Vector3, _Combine_2bfc034140f647a78084b52cf23498dc_RG_6_Vector2);
            float _Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float;
            Unity_Remap_float(_Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float, (_Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4.xy), (_Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4.xy), _Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float);
            float _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float;
            Unity_Absolute_float(_Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float, _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float);
            float _Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float;
            Unity_Smoothstep_float(_Property_37396a43db5941909959cbd08cb7213b_Out_0_Float, _Property_2d5fab0c056b463089f63a339f94ac2b_Out_0_Float, _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float, _Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float);
            float _Property_90b7a5c151634fc395d9f6d8cafa7bfb_Out_0_Float = _Positivebasespeed;
            float _Property_259361442b4a474a8ea19b196b10203b_Out_0_Float = _negativenoisespeed;
            float _Property_3c059a7fd1384747b0882ef29ca0c38b_Out_0_Float = _MoodValue;
            float _Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float;
            Unity_Divide_float(_Property_3c059a7fd1384747b0882ef29ca0c38b_Out_0_Float, float(10), _Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float);
            float _Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float;
            Unity_Absolute_float(_Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float, _Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float);
            float _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float;
            Unity_Maximum_float(_Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float, float(0), _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float);
            float _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float;
            Unity_Lerp_float(_Property_90b7a5c151634fc395d9f6d8cafa7bfb_Out_0_Float, _Property_259361442b4a474a8ea19b196b10203b_Out_0_Float, _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float, _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float);
            float _Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float, _Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float);
            float2 _TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), (_Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float.xx), _TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2);
            float _Property_9cdb12619ba0436c88021cdfb91f4ba2_Out_0_Float = _Base_Scale;
            float _GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2, _Property_9cdb12619ba0436c88021cdfb91f4ba2_Out_0_Float, _GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float);
            float _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float = _Base_Strength;
            float _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float, _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float, _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float);
            float _Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float;
            Unity_Add_float(_Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float, _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float, _Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float);
            float _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float;
            Unity_Add_float(float(1), _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float, _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float);
            float _Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float;
            Unity_Divide_float(_Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float, _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float, _Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float);
            float3 _Multiply_1c3e80d5ad544d37afeae348e005b1ce_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float.xxx), _Multiply_1c3e80d5ad544d37afeae348e005b1ce_Out_2_Vector3);
            float _Property_fbedcc335e4e489a88530feceac28a92_Out_0_Float = _Positive_Noiseheight;
            float _Property_51562b6bcc0e49889a5b042bd9dd3ec1_Out_0_Float = _NegativeNoiseheight;
            float _Property_4a38113a4b3d4df9a442abaf0dfc7175_Out_0_Float = _MoodValue;
            float _Divide_c3a203997247432380c98ea6f1105246_Out_2_Float;
            Unity_Divide_float(_Property_4a38113a4b3d4df9a442abaf0dfc7175_Out_0_Float, float(10), _Divide_c3a203997247432380c98ea6f1105246_Out_2_Float);
            float _Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float;
            Unity_Absolute_float(_Divide_c3a203997247432380c98ea6f1105246_Out_2_Float, _Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float);
            float _Maximum_ea3824aff9834aa6abb200d18549a1ab_Out_2_Float;
            Unity_Maximum_float(_Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float, float(0), _Maximum_ea3824aff9834aa6abb200d18549a1ab_Out_2_Float);
            float _Lerp_631ef014257c45109ba70e191310a027_Out_3_Float;
            Unity_Lerp_float(_Property_fbedcc335e4e489a88530feceac28a92_Out_0_Float, _Property_51562b6bcc0e49889a5b042bd9dd3ec1_Out_0_Float, _Maximum_ea3824aff9834aa6abb200d18549a1ab_Out_2_Float, _Lerp_631ef014257c45109ba70e191310a027_Out_3_Float);
            float3 _Multiply_f5b6315c130940588d7d1a13e6a6ff4b_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_1c3e80d5ad544d37afeae348e005b1ce_Out_2_Vector3, (_Lerp_631ef014257c45109ba70e191310a027_Out_3_Float.xxx), _Multiply_f5b6315c130940588d7d1a13e6a6ff4b_Out_2_Vector3);
            float3 _Add_61d8564b498f4b51a52cb66ee888a83f_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_f5b6315c130940588d7d1a13e6a6ff4b_Out_2_Vector3, _Add_61d8564b498f4b51a52cb66ee888a83f_Out_2_Vector3);
            float3 _Add_b49f2b0d3cc549f6a4a0e455f9e0e053_Out_2_Vector3;
            Unity_Add_float3(_Multiply_c90d63e869b44661889a2e2dfe9e0e0b_Out_2_Vector3, _Add_61d8564b498f4b51a52cb66ee888a83f_Out_2_Vector3, _Add_b49f2b0d3cc549f6a4a0e455f9e0e053_Out_2_Vector3);
            description.Position = _Add_b49f2b0d3cc549f6a4a0e455f9e0e053_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_288513cbd498440b82da4722d2a9ff59_Out_0_Vector4 = _Positive_ValleyColor;
            float4 _Property_78dea4090d6f48fba8829f6c8c2024cf_Out_0_Vector4 = _NegativValleyColor;
            float _Property_4a38113a4b3d4df9a442abaf0dfc7175_Out_0_Float = _MoodValue;
            float _Divide_c3a203997247432380c98ea6f1105246_Out_2_Float;
            Unity_Divide_float(_Property_4a38113a4b3d4df9a442abaf0dfc7175_Out_0_Float, float(10), _Divide_c3a203997247432380c98ea6f1105246_Out_2_Float);
            float _Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float;
            Unity_Absolute_float(_Divide_c3a203997247432380c98ea6f1105246_Out_2_Float, _Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float);
            float _Maximum_0bb8511684d44e4cb7bee914f9e77855_Out_2_Float;
            Unity_Maximum_float(_Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float, float(0), _Maximum_0bb8511684d44e4cb7bee914f9e77855_Out_2_Float);
            float4 _Lerp_48dc9b1b9cba40b79c1b6f9c5fe87467_Out_3_Vector4;
            Unity_Lerp_float4(_Property_288513cbd498440b82da4722d2a9ff59_Out_0_Vector4, _Property_78dea4090d6f48fba8829f6c8c2024cf_Out_0_Vector4, (_Maximum_0bb8511684d44e4cb7bee914f9e77855_Out_2_Float.xxxx), _Lerp_48dc9b1b9cba40b79c1b6f9c5fe87467_Out_3_Vector4);
            float4 _Property_58011cd26b9e4b0389d33a1be1815b68_Out_0_Vector4 = _PositivePeakColor;
            float4 _Property_58445f66054345ddbf670ee452dae706_Out_0_Vector4 = _NegativPeakColor;
            float _Maximum_863fe33b940b414eb6bb87d39e1a6653_Out_2_Float;
            Unity_Maximum_float(_Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float, float(0), _Maximum_863fe33b940b414eb6bb87d39e1a6653_Out_2_Float);
            float4 _Lerp_652f4c6a105746fba0956869d7bd7200_Out_3_Vector4;
            Unity_Lerp_float4(_Property_58011cd26b9e4b0389d33a1be1815b68_Out_0_Vector4, _Property_58445f66054345ddbf670ee452dae706_Out_0_Vector4, (_Maximum_863fe33b940b414eb6bb87d39e1a6653_Out_2_Float.xxxx), _Lerp_652f4c6a105746fba0956869d7bd7200_Out_3_Vector4);
            float _Property_37396a43db5941909959cbd08cb7213b_Out_0_Float = _Noise_Edge_1;
            float _Property_2d5fab0c056b463089f63a339f94ac2b_Out_0_Float = _Noise_Edge_2;
            float4 _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4 = _Rotate_Projection;
            float _Split_83c34662c4394bda92d2da5990f2b124_R_1_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[0];
            float _Split_83c34662c4394bda92d2da5990f2b124_G_2_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[1];
            float _Split_83c34662c4394bda92d2da5990f2b124_B_3_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[2];
            float _Split_83c34662c4394bda92d2da5990f2b124_A_4_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[3];
            float3 _RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4.xyz), _Split_83c34662c4394bda92d2da5990f2b124_A_4_Float, _RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3);
            float _Property_77fe19067f40438693aa98df3480a426_Out_0_Float = _TileScale;
            float3 _Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3;
            Unity_Multiply_float3_float3(_RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3, (_Property_77fe19067f40438693aa98df3480a426_Out_0_Float.xxx), _Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3);
            float _Property_41dd9680a76949e29c341e472c8e41ee_Out_0_Float = _PositiveNoisespeed;
            float _Property_5ecd4183beb8451e9ef255004c349ad5_Out_0_Float = _NegativeNoisespeed;
            float _Property_7786adaa185c44daaca6ed08996d54d0_Out_0_Float = _MoodValue;
            float _Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float;
            Unity_Divide_float(_Property_7786adaa185c44daaca6ed08996d54d0_Out_0_Float, float(10), _Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float);
            float _Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float;
            Unity_Absolute_float(_Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float, _Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float);
            float _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float;
            Unity_Maximum_float(_Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float, float(0), _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float);
            float _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float;
            Unity_Lerp_float(_Property_41dd9680a76949e29c341e472c8e41ee_Out_0_Float, _Property_5ecd4183beb8451e9ef255004c349ad5_Out_0_Float, _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float, _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float);
            float _Multiply_91dd2cd366344500997788845d158666_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float, _Multiply_91dd2cd366344500997788845d158666_Out_2_Float);
            float2 _TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), (_Multiply_91dd2cd366344500997788845d158666_Out_2_Float.xx), _TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2);
            float _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float = _Noise_Scale;
            float _GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2, _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float, _GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float);
            float2 _TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2);
            float _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2, _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float, _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float);
            float _Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float;
            Unity_Add_float(_GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float, _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float, _Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float);
            float _Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float;
            Unity_Divide_float(_Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float, float(2), _Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float);
            float _Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float;
            Unity_Saturate_float(_Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float, _Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float);
            float _Property_84e8826753fe4fd08cbcedf557994d88_Out_0_Float = _Noise_Power;
            float _Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float;
            Unity_Power_float(_Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float, _Property_84e8826753fe4fd08cbcedf557994d88_Out_0_Float, _Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float);
            float4 _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4 = _Noise_remap;
            float _Split_48347984f6a84a9893ddcefdedd069b1_R_1_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[0];
            float _Split_48347984f6a84a9893ddcefdedd069b1_G_2_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[1];
            float _Split_48347984f6a84a9893ddcefdedd069b1_B_3_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[2];
            float _Split_48347984f6a84a9893ddcefdedd069b1_A_4_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[3];
            float4 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4;
            float3 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGB_5_Vector3;
            float2 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RG_6_Vector2;
            Unity_Combine_float(_Split_48347984f6a84a9893ddcefdedd069b1_R_1_Float, _Split_48347984f6a84a9893ddcefdedd069b1_G_2_Float, float(0), float(0), _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4, _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGB_5_Vector3, _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RG_6_Vector2);
            float4 _Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4;
            float3 _Combine_2bfc034140f647a78084b52cf23498dc_RGB_5_Vector3;
            float2 _Combine_2bfc034140f647a78084b52cf23498dc_RG_6_Vector2;
            Unity_Combine_float(_Split_48347984f6a84a9893ddcefdedd069b1_B_3_Float, _Split_48347984f6a84a9893ddcefdedd069b1_A_4_Float, float(0), float(0), _Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4, _Combine_2bfc034140f647a78084b52cf23498dc_RGB_5_Vector3, _Combine_2bfc034140f647a78084b52cf23498dc_RG_6_Vector2);
            float _Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float;
            Unity_Remap_float(_Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float, (_Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4.xy), (_Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4.xy), _Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float);
            float _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float;
            Unity_Absolute_float(_Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float, _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float);
            float _Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float;
            Unity_Smoothstep_float(_Property_37396a43db5941909959cbd08cb7213b_Out_0_Float, _Property_2d5fab0c056b463089f63a339f94ac2b_Out_0_Float, _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float, _Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float);
            float _Property_90b7a5c151634fc395d9f6d8cafa7bfb_Out_0_Float = _Positivebasespeed;
            float _Property_259361442b4a474a8ea19b196b10203b_Out_0_Float = _negativenoisespeed;
            float _Property_3c059a7fd1384747b0882ef29ca0c38b_Out_0_Float = _MoodValue;
            float _Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float;
            Unity_Divide_float(_Property_3c059a7fd1384747b0882ef29ca0c38b_Out_0_Float, float(10), _Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float);
            float _Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float;
            Unity_Absolute_float(_Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float, _Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float);
            float _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float;
            Unity_Maximum_float(_Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float, float(0), _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float);
            float _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float;
            Unity_Lerp_float(_Property_90b7a5c151634fc395d9f6d8cafa7bfb_Out_0_Float, _Property_259361442b4a474a8ea19b196b10203b_Out_0_Float, _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float, _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float);
            float _Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float, _Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float);
            float2 _TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), (_Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float.xx), _TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2);
            float _Property_9cdb12619ba0436c88021cdfb91f4ba2_Out_0_Float = _Base_Scale;
            float _GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2, _Property_9cdb12619ba0436c88021cdfb91f4ba2_Out_0_Float, _GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float);
            float _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float = _Base_Strength;
            float _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float, _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float, _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float);
            float _Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float;
            Unity_Add_float(_Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float, _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float, _Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float);
            float _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float;
            Unity_Add_float(float(1), _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float, _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float);
            float _Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float;
            Unity_Divide_float(_Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float, _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float, _Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float);
            float4 _Lerp_fb7af46f9fec41169fb74d4ab0dcc7a2_Out_3_Vector4;
            Unity_Lerp_float4(_Lerp_48dc9b1b9cba40b79c1b6f9c5fe87467_Out_3_Vector4, _Lerp_652f4c6a105746fba0956869d7bd7200_Out_3_Vector4, (_Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float.xxxx), _Lerp_fb7af46f9fec41169fb74d4ab0dcc7a2_Out_3_Vector4);
            float _Property_f30af960d15d4bd09185cdced743d48b_Out_0_Float = _Fresnal_Opacity;
            float _Property_05a34a79e2f446b5a62bfdef015042d3_Out_0_Float = _Fresnel_Power;
            float _FresnelEffect_abf83ae6e1ce4e6390acbbf3425ada01_Out_3_Float;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_05a34a79e2f446b5a62bfdef015042d3_Out_0_Float, _FresnelEffect_abf83ae6e1ce4e6390acbbf3425ada01_Out_3_Float);
            float _Multiply_68f3b78bc36c4fc196ff85aba542d8e9_Out_2_Float;
            Unity_Multiply_float_float(_Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float, _FresnelEffect_abf83ae6e1ce4e6390acbbf3425ada01_Out_3_Float, _Multiply_68f3b78bc36c4fc196ff85aba542d8e9_Out_2_Float);
            float _Multiply_f392566f12e7459b9c4c85ea0c3a0e3d_Out_2_Float;
            Unity_Multiply_float_float(_Property_f30af960d15d4bd09185cdced743d48b_Out_0_Float, _Multiply_68f3b78bc36c4fc196ff85aba542d8e9_Out_2_Float, _Multiply_f392566f12e7459b9c4c85ea0c3a0e3d_Out_2_Float);
            float4 _Add_ae7e9a4a1843486783fb52fd19923b11_Out_2_Vector4;
            Unity_Add_float4(_Lerp_fb7af46f9fec41169fb74d4ab0dcc7a2_Out_3_Vector4, (_Multiply_f392566f12e7459b9c4c85ea0c3a0e3d_Out_2_Float.xxxx), _Add_ae7e9a4a1843486783fb52fd19923b11_Out_2_Vector4);
            float _Property_2a4bb7cf4f3744a9964fed029dbf7d01_Out_0_Float = _Emission_Strength;
            float4 _Multiply_4836e8cb4abc465e937a3c0c42105592_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Add_ae7e9a4a1843486783fb52fd19923b11_Out_2_Vector4, (_Property_2a4bb7cf4f3744a9964fed029dbf7d01_Out_0_Float.xxxx), _Multiply_4836e8cb4abc465e937a3c0c42105592_Out_2_Vector4);
            float _SceneDepth_1d62aecc09a14ac0bed9f4678f0448b6_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_1d62aecc09a14ac0bed9f4678f0448b6_Out_1_Float);
            float4 _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_acd842be6bac4afb80d042288e1ad842_R_1_Float = _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4[0];
            float _Split_acd842be6bac4afb80d042288e1ad842_G_2_Float = _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4[1];
            float _Split_acd842be6bac4afb80d042288e1ad842_B_3_Float = _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4[2];
            float _Split_acd842be6bac4afb80d042288e1ad842_A_4_Float = _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4[3];
            float _Subtract_fd02db5f391c43f490009d6955270e36_Out_2_Float;
            Unity_Subtract_float(_Split_acd842be6bac4afb80d042288e1ad842_A_4_Float, float(1), _Subtract_fd02db5f391c43f490009d6955270e36_Out_2_Float);
            float _Subtract_bef36b46422c4699a3d88565f075a16f_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_1d62aecc09a14ac0bed9f4678f0448b6_Out_1_Float, _Subtract_fd02db5f391c43f490009d6955270e36_Out_2_Float, _Subtract_bef36b46422c4699a3d88565f075a16f_Out_2_Float);
            float _Property_4b0a98bda8f04d7ea94b75ebe82dc08c_Out_0_Float = _Transparency_range;
            float _Divide_1aba6093906742d5a901c9be7459b7b5_Out_2_Float;
            Unity_Divide_float(_Subtract_bef36b46422c4699a3d88565f075a16f_Out_2_Float, _Property_4b0a98bda8f04d7ea94b75ebe82dc08c_Out_0_Float, _Divide_1aba6093906742d5a901c9be7459b7b5_Out_2_Float);
            float _Saturate_fd34f19222c3440ca94ce5e6730b5449_Out_1_Float;
            Unity_Saturate_float(_Divide_1aba6093906742d5a901c9be7459b7b5_Out_2_Float, _Saturate_fd34f19222c3440ca94ce5e6730b5449_Out_1_Float);
            float _Smoothstep_8a1ab4f73b564e069ca1c5812870bad5_Out_3_Float;
            Unity_Smoothstep_float(float(0), float(1), _Saturate_fd34f19222c3440ca94ce5e6730b5449_Out_1_Float, _Smoothstep_8a1ab4f73b564e069ca1c5812870bad5_Out_3_Float);
            surface.BaseColor = (_Add_ae7e9a4a1843486783fb52fd19923b11_Out_2_Vector4.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = (_Multiply_4836e8cb4abc465e937a3c0c42105592_Out_2_Vector4.xyz);
            surface.Metallic = float(0);
            surface.Smoothness = float(0.5);
            surface.Occlusion = float(1);
            surface.Alpha = _Smoothstep_8a1ab4f73b564e069ca1c5812870bad5_Out_3_Float;
            surface.AlphaClipThreshold = float(0.5);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
        {
            result.vertex     = float4(attributes.positionOS, 1);
            result.tangent    = attributes.tangentOS;
            result.normal     = attributes.normalOS;
            result.texcoord1  = attributes.uv1;
            result.vertex     = float4(vertexDescription.Position, 1);
            result.normal     = vertexDescription.Normal;
            result.tangent    = float4(vertexDescription.Tangent, 0);
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
        }
        
        void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
        {
            result.pos = varyings.positionCS;
            result.worldPos = varyings.positionWS;
            result.worldNormal = varyings.normalWS;
            // World Tangent isn't an available input on v2f_surf
        
            result._ShadowCoord = varyings.shadowCoord;
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            #if !defined(LIGHTMAP_ON)
            result.sh = varyings.sh;
            #endif
            #endif
            #if defined(LIGHTMAP_ON)
            result.lmap.xy = varyings.lightmapUV;
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogCoord = varyings.fogFactorAndVertexLight.x;
                COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
        }
        
        void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
        {
            result.positionCS = surfVertex.pos;
            result.positionWS = surfVertex.worldPos;
            result.normalWS = surfVertex.worldNormal;
            // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
            // World Tangent isn't an available input on v2f_surf
            result.shadowCoord = surfVertex._ShadowCoord;
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            #if !defined(LIGHTMAP_ON)
            result.sh = surfVertex.sh;
            #endif
            #endif
            #if defined(LIGHTMAP_ON)
            result.lightmapUV = surfVertex.lmap.xy;
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
                COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/PBRDeferredPass.hlsl"
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.0
        #pragma multi_compile_shadowcaster
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        // GraphKeywords: <None>
        
        // Defines
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        #define BUILTIN_TARGET_API 1
        #define _BUILTIN_SURFACE_TYPE_TRANSPARENT 1
        #define _BUILTIN_AlphaClip 1
        #define _BUILTIN_ALPHATEST_ON 1
        #define REQUIRE_DEPTH_TEXTURE
        #ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #endif
        #ifdef _BUILTIN_ALPHATEST_ON
        #define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
        #endif
        #ifdef _BUILTIN_AlphaClip
        #define _AlphaClip _BUILTIN_AlphaClip
        #endif
        #ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
        #define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
        #endif
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _NegativeNoisespeed;
        float _Positive_Noiseheight;
        float4 _Noise_remap;
        float4 _NegativValleyColor;
        float4 _NegativPeakColor;
        float _Noise_Edge_1;
        float _Noise_Edge_2;
        float _Noise_Power;
        float _Base_Scale;
        float _negativenoisespeed;
        float _Base_Strength;
        float _Emission_Strength;
        float _Bowl_Curvature;
        float _Fresnel_Power;
        float _Fresnal_Opacity;
        float _Transparency_range;
        float _TileScale;
        float4 _Positive_ValleyColor;
        float4 _PositivePeakColor;
        float _MoodValue;
        float _NegativeNoiseheight;
        float _PositiveNoisespeed;
        float _Positivebasespeed;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
            float s, c;
            sincos(Rotation, s, c);
            Axis = normalize(Axis);
            Out = In * c + cross(Axis, In) * s + Axis * dot(Axis, In) * (1 - c);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_37b74d35aea7418684eea7308fed4dc2_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_37b74d35aea7418684eea7308fed4dc2_Out_2_Float);
            float _Multiply_6c95e880611244deac2b872b6decd88d_Out_2_Float;
            Unity_Multiply_float_float(_Distance_37b74d35aea7418684eea7308fed4dc2_Out_2_Float, -1, _Multiply_6c95e880611244deac2b872b6decd88d_Out_2_Float);
            float _Property_960eb8d9027b4ea1a34e2806e82d40da_Out_0_Float = _Bowl_Curvature;
            float _Divide_e3bfc6ac830e4502bdb64c805aa9a3ef_Out_2_Float;
            Unity_Divide_float(_Multiply_6c95e880611244deac2b872b6decd88d_Out_2_Float, _Property_960eb8d9027b4ea1a34e2806e82d40da_Out_0_Float, _Divide_e3bfc6ac830e4502bdb64c805aa9a3ef_Out_2_Float);
            float _Power_09d0ece4dc0f41e9b8894ee456c020c9_Out_2_Float;
            Unity_Power_float(_Divide_e3bfc6ac830e4502bdb64c805aa9a3ef_Out_2_Float, float(3), _Power_09d0ece4dc0f41e9b8894ee456c020c9_Out_2_Float);
            float3 _Multiply_c90d63e869b44661889a2e2dfe9e0e0b_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_09d0ece4dc0f41e9b8894ee456c020c9_Out_2_Float.xxx), _Multiply_c90d63e869b44661889a2e2dfe9e0e0b_Out_2_Vector3);
            float _Property_37396a43db5941909959cbd08cb7213b_Out_0_Float = _Noise_Edge_1;
            float _Property_2d5fab0c056b463089f63a339f94ac2b_Out_0_Float = _Noise_Edge_2;
            float4 _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4 = _Rotate_Projection;
            float _Split_83c34662c4394bda92d2da5990f2b124_R_1_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[0];
            float _Split_83c34662c4394bda92d2da5990f2b124_G_2_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[1];
            float _Split_83c34662c4394bda92d2da5990f2b124_B_3_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[2];
            float _Split_83c34662c4394bda92d2da5990f2b124_A_4_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[3];
            float3 _RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4.xyz), _Split_83c34662c4394bda92d2da5990f2b124_A_4_Float, _RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3);
            float _Property_77fe19067f40438693aa98df3480a426_Out_0_Float = _TileScale;
            float3 _Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3;
            Unity_Multiply_float3_float3(_RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3, (_Property_77fe19067f40438693aa98df3480a426_Out_0_Float.xxx), _Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3);
            float _Property_41dd9680a76949e29c341e472c8e41ee_Out_0_Float = _PositiveNoisespeed;
            float _Property_5ecd4183beb8451e9ef255004c349ad5_Out_0_Float = _NegativeNoisespeed;
            float _Property_7786adaa185c44daaca6ed08996d54d0_Out_0_Float = _MoodValue;
            float _Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float;
            Unity_Divide_float(_Property_7786adaa185c44daaca6ed08996d54d0_Out_0_Float, float(10), _Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float);
            float _Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float;
            Unity_Absolute_float(_Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float, _Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float);
            float _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float;
            Unity_Maximum_float(_Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float, float(0), _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float);
            float _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float;
            Unity_Lerp_float(_Property_41dd9680a76949e29c341e472c8e41ee_Out_0_Float, _Property_5ecd4183beb8451e9ef255004c349ad5_Out_0_Float, _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float, _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float);
            float _Multiply_91dd2cd366344500997788845d158666_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float, _Multiply_91dd2cd366344500997788845d158666_Out_2_Float);
            float2 _TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), (_Multiply_91dd2cd366344500997788845d158666_Out_2_Float.xx), _TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2);
            float _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float = _Noise_Scale;
            float _GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2, _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float, _GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float);
            float2 _TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2);
            float _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2, _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float, _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float);
            float _Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float;
            Unity_Add_float(_GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float, _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float, _Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float);
            float _Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float;
            Unity_Divide_float(_Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float, float(2), _Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float);
            float _Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float;
            Unity_Saturate_float(_Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float, _Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float);
            float _Property_84e8826753fe4fd08cbcedf557994d88_Out_0_Float = _Noise_Power;
            float _Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float;
            Unity_Power_float(_Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float, _Property_84e8826753fe4fd08cbcedf557994d88_Out_0_Float, _Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float);
            float4 _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4 = _Noise_remap;
            float _Split_48347984f6a84a9893ddcefdedd069b1_R_1_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[0];
            float _Split_48347984f6a84a9893ddcefdedd069b1_G_2_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[1];
            float _Split_48347984f6a84a9893ddcefdedd069b1_B_3_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[2];
            float _Split_48347984f6a84a9893ddcefdedd069b1_A_4_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[3];
            float4 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4;
            float3 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGB_5_Vector3;
            float2 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RG_6_Vector2;
            Unity_Combine_float(_Split_48347984f6a84a9893ddcefdedd069b1_R_1_Float, _Split_48347984f6a84a9893ddcefdedd069b1_G_2_Float, float(0), float(0), _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4, _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGB_5_Vector3, _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RG_6_Vector2);
            float4 _Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4;
            float3 _Combine_2bfc034140f647a78084b52cf23498dc_RGB_5_Vector3;
            float2 _Combine_2bfc034140f647a78084b52cf23498dc_RG_6_Vector2;
            Unity_Combine_float(_Split_48347984f6a84a9893ddcefdedd069b1_B_3_Float, _Split_48347984f6a84a9893ddcefdedd069b1_A_4_Float, float(0), float(0), _Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4, _Combine_2bfc034140f647a78084b52cf23498dc_RGB_5_Vector3, _Combine_2bfc034140f647a78084b52cf23498dc_RG_6_Vector2);
            float _Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float;
            Unity_Remap_float(_Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float, (_Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4.xy), (_Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4.xy), _Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float);
            float _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float;
            Unity_Absolute_float(_Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float, _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float);
            float _Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float;
            Unity_Smoothstep_float(_Property_37396a43db5941909959cbd08cb7213b_Out_0_Float, _Property_2d5fab0c056b463089f63a339f94ac2b_Out_0_Float, _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float, _Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float);
            float _Property_90b7a5c151634fc395d9f6d8cafa7bfb_Out_0_Float = _Positivebasespeed;
            float _Property_259361442b4a474a8ea19b196b10203b_Out_0_Float = _negativenoisespeed;
            float _Property_3c059a7fd1384747b0882ef29ca0c38b_Out_0_Float = _MoodValue;
            float _Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float;
            Unity_Divide_float(_Property_3c059a7fd1384747b0882ef29ca0c38b_Out_0_Float, float(10), _Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float);
            float _Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float;
            Unity_Absolute_float(_Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float, _Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float);
            float _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float;
            Unity_Maximum_float(_Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float, float(0), _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float);
            float _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float;
            Unity_Lerp_float(_Property_90b7a5c151634fc395d9f6d8cafa7bfb_Out_0_Float, _Property_259361442b4a474a8ea19b196b10203b_Out_0_Float, _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float, _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float);
            float _Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float, _Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float);
            float2 _TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), (_Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float.xx), _TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2);
            float _Property_9cdb12619ba0436c88021cdfb91f4ba2_Out_0_Float = _Base_Scale;
            float _GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2, _Property_9cdb12619ba0436c88021cdfb91f4ba2_Out_0_Float, _GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float);
            float _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float = _Base_Strength;
            float _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float, _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float, _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float);
            float _Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float;
            Unity_Add_float(_Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float, _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float, _Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float);
            float _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float;
            Unity_Add_float(float(1), _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float, _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float);
            float _Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float;
            Unity_Divide_float(_Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float, _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float, _Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float);
            float3 _Multiply_1c3e80d5ad544d37afeae348e005b1ce_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float.xxx), _Multiply_1c3e80d5ad544d37afeae348e005b1ce_Out_2_Vector3);
            float _Property_fbedcc335e4e489a88530feceac28a92_Out_0_Float = _Positive_Noiseheight;
            float _Property_51562b6bcc0e49889a5b042bd9dd3ec1_Out_0_Float = _NegativeNoiseheight;
            float _Property_4a38113a4b3d4df9a442abaf0dfc7175_Out_0_Float = _MoodValue;
            float _Divide_c3a203997247432380c98ea6f1105246_Out_2_Float;
            Unity_Divide_float(_Property_4a38113a4b3d4df9a442abaf0dfc7175_Out_0_Float, float(10), _Divide_c3a203997247432380c98ea6f1105246_Out_2_Float);
            float _Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float;
            Unity_Absolute_float(_Divide_c3a203997247432380c98ea6f1105246_Out_2_Float, _Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float);
            float _Maximum_ea3824aff9834aa6abb200d18549a1ab_Out_2_Float;
            Unity_Maximum_float(_Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float, float(0), _Maximum_ea3824aff9834aa6abb200d18549a1ab_Out_2_Float);
            float _Lerp_631ef014257c45109ba70e191310a027_Out_3_Float;
            Unity_Lerp_float(_Property_fbedcc335e4e489a88530feceac28a92_Out_0_Float, _Property_51562b6bcc0e49889a5b042bd9dd3ec1_Out_0_Float, _Maximum_ea3824aff9834aa6abb200d18549a1ab_Out_2_Float, _Lerp_631ef014257c45109ba70e191310a027_Out_3_Float);
            float3 _Multiply_f5b6315c130940588d7d1a13e6a6ff4b_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_1c3e80d5ad544d37afeae348e005b1ce_Out_2_Vector3, (_Lerp_631ef014257c45109ba70e191310a027_Out_3_Float.xxx), _Multiply_f5b6315c130940588d7d1a13e6a6ff4b_Out_2_Vector3);
            float3 _Add_61d8564b498f4b51a52cb66ee888a83f_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_f5b6315c130940588d7d1a13e6a6ff4b_Out_2_Vector3, _Add_61d8564b498f4b51a52cb66ee888a83f_Out_2_Vector3);
            float3 _Add_b49f2b0d3cc549f6a4a0e455f9e0e053_Out_2_Vector3;
            Unity_Add_float3(_Multiply_c90d63e869b44661889a2e2dfe9e0e0b_Out_2_Vector3, _Add_61d8564b498f4b51a52cb66ee888a83f_Out_2_Vector3, _Add_b49f2b0d3cc549f6a4a0e455f9e0e053_Out_2_Vector3);
            description.Position = _Add_b49f2b0d3cc549f6a4a0e455f9e0e053_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _SceneDepth_1d62aecc09a14ac0bed9f4678f0448b6_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_1d62aecc09a14ac0bed9f4678f0448b6_Out_1_Float);
            float4 _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_acd842be6bac4afb80d042288e1ad842_R_1_Float = _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4[0];
            float _Split_acd842be6bac4afb80d042288e1ad842_G_2_Float = _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4[1];
            float _Split_acd842be6bac4afb80d042288e1ad842_B_3_Float = _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4[2];
            float _Split_acd842be6bac4afb80d042288e1ad842_A_4_Float = _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4[3];
            float _Subtract_fd02db5f391c43f490009d6955270e36_Out_2_Float;
            Unity_Subtract_float(_Split_acd842be6bac4afb80d042288e1ad842_A_4_Float, float(1), _Subtract_fd02db5f391c43f490009d6955270e36_Out_2_Float);
            float _Subtract_bef36b46422c4699a3d88565f075a16f_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_1d62aecc09a14ac0bed9f4678f0448b6_Out_1_Float, _Subtract_fd02db5f391c43f490009d6955270e36_Out_2_Float, _Subtract_bef36b46422c4699a3d88565f075a16f_Out_2_Float);
            float _Property_4b0a98bda8f04d7ea94b75ebe82dc08c_Out_0_Float = _Transparency_range;
            float _Divide_1aba6093906742d5a901c9be7459b7b5_Out_2_Float;
            Unity_Divide_float(_Subtract_bef36b46422c4699a3d88565f075a16f_Out_2_Float, _Property_4b0a98bda8f04d7ea94b75ebe82dc08c_Out_0_Float, _Divide_1aba6093906742d5a901c9be7459b7b5_Out_2_Float);
            float _Saturate_fd34f19222c3440ca94ce5e6730b5449_Out_1_Float;
            Unity_Saturate_float(_Divide_1aba6093906742d5a901c9be7459b7b5_Out_2_Float, _Saturate_fd34f19222c3440ca94ce5e6730b5449_Out_1_Float);
            float _Smoothstep_8a1ab4f73b564e069ca1c5812870bad5_Out_3_Float;
            Unity_Smoothstep_float(float(0), float(1), _Saturate_fd34f19222c3440ca94ce5e6730b5449_Out_1_Float, _Smoothstep_8a1ab4f73b564e069ca1c5812870bad5_Out_3_Float);
            surface.Alpha = _Smoothstep_8a1ab4f73b564e069ca1c5812870bad5_Out_3_Float;
            surface.AlphaClipThreshold = float(0.5);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
        {
            result.vertex     = float4(attributes.positionOS, 1);
            result.tangent    = attributes.tangentOS;
            result.normal     = attributes.normalOS;
            result.vertex     = float4(vertexDescription.Position, 1);
            result.normal     = vertexDescription.Normal;
            result.tangent    = float4(vertexDescription.Tangent, 0);
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
        }
        
        void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
        {
            result.pos = varyings.positionCS;
            result.worldPos = varyings.positionWS;
            // World Tangent isn't an available input on v2f_surf
        
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            #if !defined(LIGHTMAP_ON)
            #endif
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogCoord = varyings.fogFactorAndVertexLight.x;
                COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
        }
        
        void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
        {
            result.positionCS = surfVertex.pos;
            result.positionWS = surfVertex.worldPos;
            // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
            // World Tangent isn't an available input on v2f_surf
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            #if !defined(LIGHTMAP_ON)
            #endif
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
                COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
        // GraphKeywords: <None>
        
        // Defines
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        #define BUILTIN_TARGET_API 1
        #define _BUILTIN_SURFACE_TYPE_TRANSPARENT 1
        #define _BUILTIN_AlphaClip 1
        #define _BUILTIN_ALPHATEST_ON 1
        #define REQUIRE_DEPTH_TEXTURE
        #ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #endif
        #ifdef _BUILTIN_ALPHATEST_ON
        #define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
        #endif
        #ifdef _BUILTIN_AlphaClip
        #define _AlphaClip _BUILTIN_AlphaClip
        #endif
        #ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
        #define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
        #endif
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS : INTERP0;
             float3 normalWS : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _NegativeNoisespeed;
        float _Positive_Noiseheight;
        float4 _Noise_remap;
        float4 _NegativValleyColor;
        float4 _NegativPeakColor;
        float _Noise_Edge_1;
        float _Noise_Edge_2;
        float _Noise_Power;
        float _Base_Scale;
        float _negativenoisespeed;
        float _Base_Strength;
        float _Emission_Strength;
        float _Bowl_Curvature;
        float _Fresnel_Power;
        float _Fresnal_Opacity;
        float _Transparency_range;
        float _TileScale;
        float4 _Positive_ValleyColor;
        float4 _PositivePeakColor;
        float _MoodValue;
        float _NegativeNoiseheight;
        float _PositiveNoisespeed;
        float _Positivebasespeed;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
            float s, c;
            sincos(Rotation, s, c);
            Axis = normalize(Axis);
            Out = In * c + cross(Axis, In) * s + Axis * dot(Axis, In) * (1 - c);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
        {
            Out = pow((1.0 - saturate(dot(normalize(Normal), ViewDir))), Power);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_37b74d35aea7418684eea7308fed4dc2_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_37b74d35aea7418684eea7308fed4dc2_Out_2_Float);
            float _Multiply_6c95e880611244deac2b872b6decd88d_Out_2_Float;
            Unity_Multiply_float_float(_Distance_37b74d35aea7418684eea7308fed4dc2_Out_2_Float, -1, _Multiply_6c95e880611244deac2b872b6decd88d_Out_2_Float);
            float _Property_960eb8d9027b4ea1a34e2806e82d40da_Out_0_Float = _Bowl_Curvature;
            float _Divide_e3bfc6ac830e4502bdb64c805aa9a3ef_Out_2_Float;
            Unity_Divide_float(_Multiply_6c95e880611244deac2b872b6decd88d_Out_2_Float, _Property_960eb8d9027b4ea1a34e2806e82d40da_Out_0_Float, _Divide_e3bfc6ac830e4502bdb64c805aa9a3ef_Out_2_Float);
            float _Power_09d0ece4dc0f41e9b8894ee456c020c9_Out_2_Float;
            Unity_Power_float(_Divide_e3bfc6ac830e4502bdb64c805aa9a3ef_Out_2_Float, float(3), _Power_09d0ece4dc0f41e9b8894ee456c020c9_Out_2_Float);
            float3 _Multiply_c90d63e869b44661889a2e2dfe9e0e0b_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_09d0ece4dc0f41e9b8894ee456c020c9_Out_2_Float.xxx), _Multiply_c90d63e869b44661889a2e2dfe9e0e0b_Out_2_Vector3);
            float _Property_37396a43db5941909959cbd08cb7213b_Out_0_Float = _Noise_Edge_1;
            float _Property_2d5fab0c056b463089f63a339f94ac2b_Out_0_Float = _Noise_Edge_2;
            float4 _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4 = _Rotate_Projection;
            float _Split_83c34662c4394bda92d2da5990f2b124_R_1_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[0];
            float _Split_83c34662c4394bda92d2da5990f2b124_G_2_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[1];
            float _Split_83c34662c4394bda92d2da5990f2b124_B_3_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[2];
            float _Split_83c34662c4394bda92d2da5990f2b124_A_4_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[3];
            float3 _RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4.xyz), _Split_83c34662c4394bda92d2da5990f2b124_A_4_Float, _RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3);
            float _Property_77fe19067f40438693aa98df3480a426_Out_0_Float = _TileScale;
            float3 _Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3;
            Unity_Multiply_float3_float3(_RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3, (_Property_77fe19067f40438693aa98df3480a426_Out_0_Float.xxx), _Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3);
            float _Property_41dd9680a76949e29c341e472c8e41ee_Out_0_Float = _PositiveNoisespeed;
            float _Property_5ecd4183beb8451e9ef255004c349ad5_Out_0_Float = _NegativeNoisespeed;
            float _Property_7786adaa185c44daaca6ed08996d54d0_Out_0_Float = _MoodValue;
            float _Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float;
            Unity_Divide_float(_Property_7786adaa185c44daaca6ed08996d54d0_Out_0_Float, float(10), _Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float);
            float _Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float;
            Unity_Absolute_float(_Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float, _Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float);
            float _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float;
            Unity_Maximum_float(_Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float, float(0), _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float);
            float _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float;
            Unity_Lerp_float(_Property_41dd9680a76949e29c341e472c8e41ee_Out_0_Float, _Property_5ecd4183beb8451e9ef255004c349ad5_Out_0_Float, _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float, _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float);
            float _Multiply_91dd2cd366344500997788845d158666_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float, _Multiply_91dd2cd366344500997788845d158666_Out_2_Float);
            float2 _TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), (_Multiply_91dd2cd366344500997788845d158666_Out_2_Float.xx), _TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2);
            float _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float = _Noise_Scale;
            float _GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2, _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float, _GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float);
            float2 _TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2);
            float _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2, _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float, _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float);
            float _Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float;
            Unity_Add_float(_GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float, _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float, _Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float);
            float _Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float;
            Unity_Divide_float(_Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float, float(2), _Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float);
            float _Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float;
            Unity_Saturate_float(_Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float, _Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float);
            float _Property_84e8826753fe4fd08cbcedf557994d88_Out_0_Float = _Noise_Power;
            float _Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float;
            Unity_Power_float(_Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float, _Property_84e8826753fe4fd08cbcedf557994d88_Out_0_Float, _Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float);
            float4 _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4 = _Noise_remap;
            float _Split_48347984f6a84a9893ddcefdedd069b1_R_1_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[0];
            float _Split_48347984f6a84a9893ddcefdedd069b1_G_2_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[1];
            float _Split_48347984f6a84a9893ddcefdedd069b1_B_3_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[2];
            float _Split_48347984f6a84a9893ddcefdedd069b1_A_4_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[3];
            float4 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4;
            float3 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGB_5_Vector3;
            float2 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RG_6_Vector2;
            Unity_Combine_float(_Split_48347984f6a84a9893ddcefdedd069b1_R_1_Float, _Split_48347984f6a84a9893ddcefdedd069b1_G_2_Float, float(0), float(0), _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4, _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGB_5_Vector3, _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RG_6_Vector2);
            float4 _Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4;
            float3 _Combine_2bfc034140f647a78084b52cf23498dc_RGB_5_Vector3;
            float2 _Combine_2bfc034140f647a78084b52cf23498dc_RG_6_Vector2;
            Unity_Combine_float(_Split_48347984f6a84a9893ddcefdedd069b1_B_3_Float, _Split_48347984f6a84a9893ddcefdedd069b1_A_4_Float, float(0), float(0), _Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4, _Combine_2bfc034140f647a78084b52cf23498dc_RGB_5_Vector3, _Combine_2bfc034140f647a78084b52cf23498dc_RG_6_Vector2);
            float _Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float;
            Unity_Remap_float(_Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float, (_Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4.xy), (_Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4.xy), _Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float);
            float _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float;
            Unity_Absolute_float(_Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float, _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float);
            float _Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float;
            Unity_Smoothstep_float(_Property_37396a43db5941909959cbd08cb7213b_Out_0_Float, _Property_2d5fab0c056b463089f63a339f94ac2b_Out_0_Float, _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float, _Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float);
            float _Property_90b7a5c151634fc395d9f6d8cafa7bfb_Out_0_Float = _Positivebasespeed;
            float _Property_259361442b4a474a8ea19b196b10203b_Out_0_Float = _negativenoisespeed;
            float _Property_3c059a7fd1384747b0882ef29ca0c38b_Out_0_Float = _MoodValue;
            float _Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float;
            Unity_Divide_float(_Property_3c059a7fd1384747b0882ef29ca0c38b_Out_0_Float, float(10), _Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float);
            float _Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float;
            Unity_Absolute_float(_Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float, _Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float);
            float _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float;
            Unity_Maximum_float(_Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float, float(0), _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float);
            float _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float;
            Unity_Lerp_float(_Property_90b7a5c151634fc395d9f6d8cafa7bfb_Out_0_Float, _Property_259361442b4a474a8ea19b196b10203b_Out_0_Float, _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float, _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float);
            float _Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float, _Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float);
            float2 _TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), (_Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float.xx), _TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2);
            float _Property_9cdb12619ba0436c88021cdfb91f4ba2_Out_0_Float = _Base_Scale;
            float _GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2, _Property_9cdb12619ba0436c88021cdfb91f4ba2_Out_0_Float, _GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float);
            float _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float = _Base_Strength;
            float _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float, _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float, _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float);
            float _Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float;
            Unity_Add_float(_Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float, _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float, _Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float);
            float _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float;
            Unity_Add_float(float(1), _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float, _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float);
            float _Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float;
            Unity_Divide_float(_Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float, _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float, _Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float);
            float3 _Multiply_1c3e80d5ad544d37afeae348e005b1ce_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float.xxx), _Multiply_1c3e80d5ad544d37afeae348e005b1ce_Out_2_Vector3);
            float _Property_fbedcc335e4e489a88530feceac28a92_Out_0_Float = _Positive_Noiseheight;
            float _Property_51562b6bcc0e49889a5b042bd9dd3ec1_Out_0_Float = _NegativeNoiseheight;
            float _Property_4a38113a4b3d4df9a442abaf0dfc7175_Out_0_Float = _MoodValue;
            float _Divide_c3a203997247432380c98ea6f1105246_Out_2_Float;
            Unity_Divide_float(_Property_4a38113a4b3d4df9a442abaf0dfc7175_Out_0_Float, float(10), _Divide_c3a203997247432380c98ea6f1105246_Out_2_Float);
            float _Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float;
            Unity_Absolute_float(_Divide_c3a203997247432380c98ea6f1105246_Out_2_Float, _Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float);
            float _Maximum_ea3824aff9834aa6abb200d18549a1ab_Out_2_Float;
            Unity_Maximum_float(_Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float, float(0), _Maximum_ea3824aff9834aa6abb200d18549a1ab_Out_2_Float);
            float _Lerp_631ef014257c45109ba70e191310a027_Out_3_Float;
            Unity_Lerp_float(_Property_fbedcc335e4e489a88530feceac28a92_Out_0_Float, _Property_51562b6bcc0e49889a5b042bd9dd3ec1_Out_0_Float, _Maximum_ea3824aff9834aa6abb200d18549a1ab_Out_2_Float, _Lerp_631ef014257c45109ba70e191310a027_Out_3_Float);
            float3 _Multiply_f5b6315c130940588d7d1a13e6a6ff4b_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_1c3e80d5ad544d37afeae348e005b1ce_Out_2_Vector3, (_Lerp_631ef014257c45109ba70e191310a027_Out_3_Float.xxx), _Multiply_f5b6315c130940588d7d1a13e6a6ff4b_Out_2_Vector3);
            float3 _Add_61d8564b498f4b51a52cb66ee888a83f_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_f5b6315c130940588d7d1a13e6a6ff4b_Out_2_Vector3, _Add_61d8564b498f4b51a52cb66ee888a83f_Out_2_Vector3);
            float3 _Add_b49f2b0d3cc549f6a4a0e455f9e0e053_Out_2_Vector3;
            Unity_Add_float3(_Multiply_c90d63e869b44661889a2e2dfe9e0e0b_Out_2_Vector3, _Add_61d8564b498f4b51a52cb66ee888a83f_Out_2_Vector3, _Add_b49f2b0d3cc549f6a4a0e455f9e0e053_Out_2_Vector3);
            description.Position = _Add_b49f2b0d3cc549f6a4a0e455f9e0e053_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_288513cbd498440b82da4722d2a9ff59_Out_0_Vector4 = _Positive_ValleyColor;
            float4 _Property_78dea4090d6f48fba8829f6c8c2024cf_Out_0_Vector4 = _NegativValleyColor;
            float _Property_4a38113a4b3d4df9a442abaf0dfc7175_Out_0_Float = _MoodValue;
            float _Divide_c3a203997247432380c98ea6f1105246_Out_2_Float;
            Unity_Divide_float(_Property_4a38113a4b3d4df9a442abaf0dfc7175_Out_0_Float, float(10), _Divide_c3a203997247432380c98ea6f1105246_Out_2_Float);
            float _Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float;
            Unity_Absolute_float(_Divide_c3a203997247432380c98ea6f1105246_Out_2_Float, _Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float);
            float _Maximum_0bb8511684d44e4cb7bee914f9e77855_Out_2_Float;
            Unity_Maximum_float(_Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float, float(0), _Maximum_0bb8511684d44e4cb7bee914f9e77855_Out_2_Float);
            float4 _Lerp_48dc9b1b9cba40b79c1b6f9c5fe87467_Out_3_Vector4;
            Unity_Lerp_float4(_Property_288513cbd498440b82da4722d2a9ff59_Out_0_Vector4, _Property_78dea4090d6f48fba8829f6c8c2024cf_Out_0_Vector4, (_Maximum_0bb8511684d44e4cb7bee914f9e77855_Out_2_Float.xxxx), _Lerp_48dc9b1b9cba40b79c1b6f9c5fe87467_Out_3_Vector4);
            float4 _Property_58011cd26b9e4b0389d33a1be1815b68_Out_0_Vector4 = _PositivePeakColor;
            float4 _Property_58445f66054345ddbf670ee452dae706_Out_0_Vector4 = _NegativPeakColor;
            float _Maximum_863fe33b940b414eb6bb87d39e1a6653_Out_2_Float;
            Unity_Maximum_float(_Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float, float(0), _Maximum_863fe33b940b414eb6bb87d39e1a6653_Out_2_Float);
            float4 _Lerp_652f4c6a105746fba0956869d7bd7200_Out_3_Vector4;
            Unity_Lerp_float4(_Property_58011cd26b9e4b0389d33a1be1815b68_Out_0_Vector4, _Property_58445f66054345ddbf670ee452dae706_Out_0_Vector4, (_Maximum_863fe33b940b414eb6bb87d39e1a6653_Out_2_Float.xxxx), _Lerp_652f4c6a105746fba0956869d7bd7200_Out_3_Vector4);
            float _Property_37396a43db5941909959cbd08cb7213b_Out_0_Float = _Noise_Edge_1;
            float _Property_2d5fab0c056b463089f63a339f94ac2b_Out_0_Float = _Noise_Edge_2;
            float4 _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4 = _Rotate_Projection;
            float _Split_83c34662c4394bda92d2da5990f2b124_R_1_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[0];
            float _Split_83c34662c4394bda92d2da5990f2b124_G_2_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[1];
            float _Split_83c34662c4394bda92d2da5990f2b124_B_3_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[2];
            float _Split_83c34662c4394bda92d2da5990f2b124_A_4_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[3];
            float3 _RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4.xyz), _Split_83c34662c4394bda92d2da5990f2b124_A_4_Float, _RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3);
            float _Property_77fe19067f40438693aa98df3480a426_Out_0_Float = _TileScale;
            float3 _Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3;
            Unity_Multiply_float3_float3(_RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3, (_Property_77fe19067f40438693aa98df3480a426_Out_0_Float.xxx), _Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3);
            float _Property_41dd9680a76949e29c341e472c8e41ee_Out_0_Float = _PositiveNoisespeed;
            float _Property_5ecd4183beb8451e9ef255004c349ad5_Out_0_Float = _NegativeNoisespeed;
            float _Property_7786adaa185c44daaca6ed08996d54d0_Out_0_Float = _MoodValue;
            float _Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float;
            Unity_Divide_float(_Property_7786adaa185c44daaca6ed08996d54d0_Out_0_Float, float(10), _Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float);
            float _Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float;
            Unity_Absolute_float(_Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float, _Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float);
            float _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float;
            Unity_Maximum_float(_Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float, float(0), _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float);
            float _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float;
            Unity_Lerp_float(_Property_41dd9680a76949e29c341e472c8e41ee_Out_0_Float, _Property_5ecd4183beb8451e9ef255004c349ad5_Out_0_Float, _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float, _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float);
            float _Multiply_91dd2cd366344500997788845d158666_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float, _Multiply_91dd2cd366344500997788845d158666_Out_2_Float);
            float2 _TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), (_Multiply_91dd2cd366344500997788845d158666_Out_2_Float.xx), _TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2);
            float _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float = _Noise_Scale;
            float _GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2, _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float, _GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float);
            float2 _TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2);
            float _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2, _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float, _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float);
            float _Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float;
            Unity_Add_float(_GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float, _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float, _Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float);
            float _Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float;
            Unity_Divide_float(_Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float, float(2), _Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float);
            float _Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float;
            Unity_Saturate_float(_Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float, _Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float);
            float _Property_84e8826753fe4fd08cbcedf557994d88_Out_0_Float = _Noise_Power;
            float _Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float;
            Unity_Power_float(_Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float, _Property_84e8826753fe4fd08cbcedf557994d88_Out_0_Float, _Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float);
            float4 _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4 = _Noise_remap;
            float _Split_48347984f6a84a9893ddcefdedd069b1_R_1_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[0];
            float _Split_48347984f6a84a9893ddcefdedd069b1_G_2_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[1];
            float _Split_48347984f6a84a9893ddcefdedd069b1_B_3_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[2];
            float _Split_48347984f6a84a9893ddcefdedd069b1_A_4_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[3];
            float4 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4;
            float3 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGB_5_Vector3;
            float2 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RG_6_Vector2;
            Unity_Combine_float(_Split_48347984f6a84a9893ddcefdedd069b1_R_1_Float, _Split_48347984f6a84a9893ddcefdedd069b1_G_2_Float, float(0), float(0), _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4, _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGB_5_Vector3, _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RG_6_Vector2);
            float4 _Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4;
            float3 _Combine_2bfc034140f647a78084b52cf23498dc_RGB_5_Vector3;
            float2 _Combine_2bfc034140f647a78084b52cf23498dc_RG_6_Vector2;
            Unity_Combine_float(_Split_48347984f6a84a9893ddcefdedd069b1_B_3_Float, _Split_48347984f6a84a9893ddcefdedd069b1_A_4_Float, float(0), float(0), _Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4, _Combine_2bfc034140f647a78084b52cf23498dc_RGB_5_Vector3, _Combine_2bfc034140f647a78084b52cf23498dc_RG_6_Vector2);
            float _Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float;
            Unity_Remap_float(_Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float, (_Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4.xy), (_Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4.xy), _Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float);
            float _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float;
            Unity_Absolute_float(_Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float, _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float);
            float _Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float;
            Unity_Smoothstep_float(_Property_37396a43db5941909959cbd08cb7213b_Out_0_Float, _Property_2d5fab0c056b463089f63a339f94ac2b_Out_0_Float, _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float, _Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float);
            float _Property_90b7a5c151634fc395d9f6d8cafa7bfb_Out_0_Float = _Positivebasespeed;
            float _Property_259361442b4a474a8ea19b196b10203b_Out_0_Float = _negativenoisespeed;
            float _Property_3c059a7fd1384747b0882ef29ca0c38b_Out_0_Float = _MoodValue;
            float _Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float;
            Unity_Divide_float(_Property_3c059a7fd1384747b0882ef29ca0c38b_Out_0_Float, float(10), _Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float);
            float _Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float;
            Unity_Absolute_float(_Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float, _Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float);
            float _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float;
            Unity_Maximum_float(_Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float, float(0), _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float);
            float _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float;
            Unity_Lerp_float(_Property_90b7a5c151634fc395d9f6d8cafa7bfb_Out_0_Float, _Property_259361442b4a474a8ea19b196b10203b_Out_0_Float, _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float, _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float);
            float _Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float, _Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float);
            float2 _TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), (_Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float.xx), _TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2);
            float _Property_9cdb12619ba0436c88021cdfb91f4ba2_Out_0_Float = _Base_Scale;
            float _GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2, _Property_9cdb12619ba0436c88021cdfb91f4ba2_Out_0_Float, _GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float);
            float _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float = _Base_Strength;
            float _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float, _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float, _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float);
            float _Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float;
            Unity_Add_float(_Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float, _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float, _Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float);
            float _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float;
            Unity_Add_float(float(1), _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float, _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float);
            float _Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float;
            Unity_Divide_float(_Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float, _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float, _Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float);
            float4 _Lerp_fb7af46f9fec41169fb74d4ab0dcc7a2_Out_3_Vector4;
            Unity_Lerp_float4(_Lerp_48dc9b1b9cba40b79c1b6f9c5fe87467_Out_3_Vector4, _Lerp_652f4c6a105746fba0956869d7bd7200_Out_3_Vector4, (_Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float.xxxx), _Lerp_fb7af46f9fec41169fb74d4ab0dcc7a2_Out_3_Vector4);
            float _Property_f30af960d15d4bd09185cdced743d48b_Out_0_Float = _Fresnal_Opacity;
            float _Property_05a34a79e2f446b5a62bfdef015042d3_Out_0_Float = _Fresnel_Power;
            float _FresnelEffect_abf83ae6e1ce4e6390acbbf3425ada01_Out_3_Float;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_05a34a79e2f446b5a62bfdef015042d3_Out_0_Float, _FresnelEffect_abf83ae6e1ce4e6390acbbf3425ada01_Out_3_Float);
            float _Multiply_68f3b78bc36c4fc196ff85aba542d8e9_Out_2_Float;
            Unity_Multiply_float_float(_Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float, _FresnelEffect_abf83ae6e1ce4e6390acbbf3425ada01_Out_3_Float, _Multiply_68f3b78bc36c4fc196ff85aba542d8e9_Out_2_Float);
            float _Multiply_f392566f12e7459b9c4c85ea0c3a0e3d_Out_2_Float;
            Unity_Multiply_float_float(_Property_f30af960d15d4bd09185cdced743d48b_Out_0_Float, _Multiply_68f3b78bc36c4fc196ff85aba542d8e9_Out_2_Float, _Multiply_f392566f12e7459b9c4c85ea0c3a0e3d_Out_2_Float);
            float4 _Add_ae7e9a4a1843486783fb52fd19923b11_Out_2_Vector4;
            Unity_Add_float4(_Lerp_fb7af46f9fec41169fb74d4ab0dcc7a2_Out_3_Vector4, (_Multiply_f392566f12e7459b9c4c85ea0c3a0e3d_Out_2_Float.xxxx), _Add_ae7e9a4a1843486783fb52fd19923b11_Out_2_Vector4);
            float _Property_2a4bb7cf4f3744a9964fed029dbf7d01_Out_0_Float = _Emission_Strength;
            float4 _Multiply_4836e8cb4abc465e937a3c0c42105592_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Add_ae7e9a4a1843486783fb52fd19923b11_Out_2_Vector4, (_Property_2a4bb7cf4f3744a9964fed029dbf7d01_Out_0_Float.xxxx), _Multiply_4836e8cb4abc465e937a3c0c42105592_Out_2_Vector4);
            float _SceneDepth_1d62aecc09a14ac0bed9f4678f0448b6_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_1d62aecc09a14ac0bed9f4678f0448b6_Out_1_Float);
            float4 _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_acd842be6bac4afb80d042288e1ad842_R_1_Float = _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4[0];
            float _Split_acd842be6bac4afb80d042288e1ad842_G_2_Float = _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4[1];
            float _Split_acd842be6bac4afb80d042288e1ad842_B_3_Float = _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4[2];
            float _Split_acd842be6bac4afb80d042288e1ad842_A_4_Float = _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4[3];
            float _Subtract_fd02db5f391c43f490009d6955270e36_Out_2_Float;
            Unity_Subtract_float(_Split_acd842be6bac4afb80d042288e1ad842_A_4_Float, float(1), _Subtract_fd02db5f391c43f490009d6955270e36_Out_2_Float);
            float _Subtract_bef36b46422c4699a3d88565f075a16f_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_1d62aecc09a14ac0bed9f4678f0448b6_Out_1_Float, _Subtract_fd02db5f391c43f490009d6955270e36_Out_2_Float, _Subtract_bef36b46422c4699a3d88565f075a16f_Out_2_Float);
            float _Property_4b0a98bda8f04d7ea94b75ebe82dc08c_Out_0_Float = _Transparency_range;
            float _Divide_1aba6093906742d5a901c9be7459b7b5_Out_2_Float;
            Unity_Divide_float(_Subtract_bef36b46422c4699a3d88565f075a16f_Out_2_Float, _Property_4b0a98bda8f04d7ea94b75ebe82dc08c_Out_0_Float, _Divide_1aba6093906742d5a901c9be7459b7b5_Out_2_Float);
            float _Saturate_fd34f19222c3440ca94ce5e6730b5449_Out_1_Float;
            Unity_Saturate_float(_Divide_1aba6093906742d5a901c9be7459b7b5_Out_2_Float, _Saturate_fd34f19222c3440ca94ce5e6730b5449_Out_1_Float);
            float _Smoothstep_8a1ab4f73b564e069ca1c5812870bad5_Out_3_Float;
            Unity_Smoothstep_float(float(0), float(1), _Saturate_fd34f19222c3440ca94ce5e6730b5449_Out_1_Float, _Smoothstep_8a1ab4f73b564e069ca1c5812870bad5_Out_3_Float);
            surface.BaseColor = (_Add_ae7e9a4a1843486783fb52fd19923b11_Out_2_Vector4.xyz);
            surface.Emission = (_Multiply_4836e8cb4abc465e937a3c0c42105592_Out_2_Vector4.xyz);
            surface.Alpha = _Smoothstep_8a1ab4f73b564e069ca1c5812870bad5_Out_3_Float;
            surface.AlphaClipThreshold = float(0.5);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
        {
            result.vertex     = float4(attributes.positionOS, 1);
            result.tangent    = attributes.tangentOS;
            result.normal     = attributes.normalOS;
            result.texcoord1  = attributes.uv1;
            result.texcoord2  = attributes.uv2;
            result.vertex     = float4(vertexDescription.Position, 1);
            result.normal     = vertexDescription.Normal;
            result.tangent    = float4(vertexDescription.Tangent, 0);
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
        }
        
        void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
        {
            result.pos = varyings.positionCS;
            result.worldPos = varyings.positionWS;
            result.worldNormal = varyings.normalWS;
            // World Tangent isn't an available input on v2f_surf
        
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            #if !defined(LIGHTMAP_ON)
            #endif
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogCoord = varyings.fogFactorAndVertexLight.x;
                COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
        }
        
        void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
        {
            result.positionCS = surfVertex.pos;
            result.positionWS = surfVertex.worldPos;
            result.normalWS = surfVertex.worldNormal;
            // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
            // World Tangent isn't an available input on v2f_surf
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            #if !defined(LIGHTMAP_ON)
            #endif
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
                COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SceneSelectionPass
        #define BUILTIN_TARGET_API 1
        #define SCENESELECTIONPASS 1
        #define _BUILTIN_SURFACE_TYPE_TRANSPARENT 1
        #define _BUILTIN_AlphaClip 1
        #define _BUILTIN_ALPHATEST_ON 1
        #define REQUIRE_DEPTH_TEXTURE
        #ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #endif
        #ifdef _BUILTIN_ALPHATEST_ON
        #define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
        #endif
        #ifdef _BUILTIN_AlphaClip
        #define _AlphaClip _BUILTIN_AlphaClip
        #endif
        #ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
        #define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
        #endif
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _NegativeNoisespeed;
        float _Positive_Noiseheight;
        float4 _Noise_remap;
        float4 _NegativValleyColor;
        float4 _NegativPeakColor;
        float _Noise_Edge_1;
        float _Noise_Edge_2;
        float _Noise_Power;
        float _Base_Scale;
        float _negativenoisespeed;
        float _Base_Strength;
        float _Emission_Strength;
        float _Bowl_Curvature;
        float _Fresnel_Power;
        float _Fresnal_Opacity;
        float _Transparency_range;
        float _TileScale;
        float4 _Positive_ValleyColor;
        float4 _PositivePeakColor;
        float _MoodValue;
        float _NegativeNoiseheight;
        float _PositiveNoisespeed;
        float _Positivebasespeed;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
            float s, c;
            sincos(Rotation, s, c);
            Axis = normalize(Axis);
            Out = In * c + cross(Axis, In) * s + Axis * dot(Axis, In) * (1 - c);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_37b74d35aea7418684eea7308fed4dc2_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_37b74d35aea7418684eea7308fed4dc2_Out_2_Float);
            float _Multiply_6c95e880611244deac2b872b6decd88d_Out_2_Float;
            Unity_Multiply_float_float(_Distance_37b74d35aea7418684eea7308fed4dc2_Out_2_Float, -1, _Multiply_6c95e880611244deac2b872b6decd88d_Out_2_Float);
            float _Property_960eb8d9027b4ea1a34e2806e82d40da_Out_0_Float = _Bowl_Curvature;
            float _Divide_e3bfc6ac830e4502bdb64c805aa9a3ef_Out_2_Float;
            Unity_Divide_float(_Multiply_6c95e880611244deac2b872b6decd88d_Out_2_Float, _Property_960eb8d9027b4ea1a34e2806e82d40da_Out_0_Float, _Divide_e3bfc6ac830e4502bdb64c805aa9a3ef_Out_2_Float);
            float _Power_09d0ece4dc0f41e9b8894ee456c020c9_Out_2_Float;
            Unity_Power_float(_Divide_e3bfc6ac830e4502bdb64c805aa9a3ef_Out_2_Float, float(3), _Power_09d0ece4dc0f41e9b8894ee456c020c9_Out_2_Float);
            float3 _Multiply_c90d63e869b44661889a2e2dfe9e0e0b_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_09d0ece4dc0f41e9b8894ee456c020c9_Out_2_Float.xxx), _Multiply_c90d63e869b44661889a2e2dfe9e0e0b_Out_2_Vector3);
            float _Property_37396a43db5941909959cbd08cb7213b_Out_0_Float = _Noise_Edge_1;
            float _Property_2d5fab0c056b463089f63a339f94ac2b_Out_0_Float = _Noise_Edge_2;
            float4 _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4 = _Rotate_Projection;
            float _Split_83c34662c4394bda92d2da5990f2b124_R_1_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[0];
            float _Split_83c34662c4394bda92d2da5990f2b124_G_2_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[1];
            float _Split_83c34662c4394bda92d2da5990f2b124_B_3_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[2];
            float _Split_83c34662c4394bda92d2da5990f2b124_A_4_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[3];
            float3 _RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4.xyz), _Split_83c34662c4394bda92d2da5990f2b124_A_4_Float, _RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3);
            float _Property_77fe19067f40438693aa98df3480a426_Out_0_Float = _TileScale;
            float3 _Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3;
            Unity_Multiply_float3_float3(_RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3, (_Property_77fe19067f40438693aa98df3480a426_Out_0_Float.xxx), _Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3);
            float _Property_41dd9680a76949e29c341e472c8e41ee_Out_0_Float = _PositiveNoisespeed;
            float _Property_5ecd4183beb8451e9ef255004c349ad5_Out_0_Float = _NegativeNoisespeed;
            float _Property_7786adaa185c44daaca6ed08996d54d0_Out_0_Float = _MoodValue;
            float _Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float;
            Unity_Divide_float(_Property_7786adaa185c44daaca6ed08996d54d0_Out_0_Float, float(10), _Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float);
            float _Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float;
            Unity_Absolute_float(_Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float, _Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float);
            float _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float;
            Unity_Maximum_float(_Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float, float(0), _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float);
            float _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float;
            Unity_Lerp_float(_Property_41dd9680a76949e29c341e472c8e41ee_Out_0_Float, _Property_5ecd4183beb8451e9ef255004c349ad5_Out_0_Float, _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float, _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float);
            float _Multiply_91dd2cd366344500997788845d158666_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float, _Multiply_91dd2cd366344500997788845d158666_Out_2_Float);
            float2 _TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), (_Multiply_91dd2cd366344500997788845d158666_Out_2_Float.xx), _TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2);
            float _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float = _Noise_Scale;
            float _GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2, _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float, _GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float);
            float2 _TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2);
            float _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2, _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float, _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float);
            float _Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float;
            Unity_Add_float(_GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float, _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float, _Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float);
            float _Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float;
            Unity_Divide_float(_Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float, float(2), _Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float);
            float _Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float;
            Unity_Saturate_float(_Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float, _Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float);
            float _Property_84e8826753fe4fd08cbcedf557994d88_Out_0_Float = _Noise_Power;
            float _Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float;
            Unity_Power_float(_Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float, _Property_84e8826753fe4fd08cbcedf557994d88_Out_0_Float, _Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float);
            float4 _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4 = _Noise_remap;
            float _Split_48347984f6a84a9893ddcefdedd069b1_R_1_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[0];
            float _Split_48347984f6a84a9893ddcefdedd069b1_G_2_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[1];
            float _Split_48347984f6a84a9893ddcefdedd069b1_B_3_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[2];
            float _Split_48347984f6a84a9893ddcefdedd069b1_A_4_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[3];
            float4 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4;
            float3 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGB_5_Vector3;
            float2 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RG_6_Vector2;
            Unity_Combine_float(_Split_48347984f6a84a9893ddcefdedd069b1_R_1_Float, _Split_48347984f6a84a9893ddcefdedd069b1_G_2_Float, float(0), float(0), _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4, _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGB_5_Vector3, _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RG_6_Vector2);
            float4 _Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4;
            float3 _Combine_2bfc034140f647a78084b52cf23498dc_RGB_5_Vector3;
            float2 _Combine_2bfc034140f647a78084b52cf23498dc_RG_6_Vector2;
            Unity_Combine_float(_Split_48347984f6a84a9893ddcefdedd069b1_B_3_Float, _Split_48347984f6a84a9893ddcefdedd069b1_A_4_Float, float(0), float(0), _Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4, _Combine_2bfc034140f647a78084b52cf23498dc_RGB_5_Vector3, _Combine_2bfc034140f647a78084b52cf23498dc_RG_6_Vector2);
            float _Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float;
            Unity_Remap_float(_Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float, (_Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4.xy), (_Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4.xy), _Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float);
            float _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float;
            Unity_Absolute_float(_Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float, _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float);
            float _Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float;
            Unity_Smoothstep_float(_Property_37396a43db5941909959cbd08cb7213b_Out_0_Float, _Property_2d5fab0c056b463089f63a339f94ac2b_Out_0_Float, _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float, _Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float);
            float _Property_90b7a5c151634fc395d9f6d8cafa7bfb_Out_0_Float = _Positivebasespeed;
            float _Property_259361442b4a474a8ea19b196b10203b_Out_0_Float = _negativenoisespeed;
            float _Property_3c059a7fd1384747b0882ef29ca0c38b_Out_0_Float = _MoodValue;
            float _Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float;
            Unity_Divide_float(_Property_3c059a7fd1384747b0882ef29ca0c38b_Out_0_Float, float(10), _Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float);
            float _Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float;
            Unity_Absolute_float(_Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float, _Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float);
            float _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float;
            Unity_Maximum_float(_Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float, float(0), _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float);
            float _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float;
            Unity_Lerp_float(_Property_90b7a5c151634fc395d9f6d8cafa7bfb_Out_0_Float, _Property_259361442b4a474a8ea19b196b10203b_Out_0_Float, _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float, _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float);
            float _Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float, _Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float);
            float2 _TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), (_Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float.xx), _TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2);
            float _Property_9cdb12619ba0436c88021cdfb91f4ba2_Out_0_Float = _Base_Scale;
            float _GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2, _Property_9cdb12619ba0436c88021cdfb91f4ba2_Out_0_Float, _GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float);
            float _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float = _Base_Strength;
            float _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float, _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float, _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float);
            float _Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float;
            Unity_Add_float(_Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float, _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float, _Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float);
            float _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float;
            Unity_Add_float(float(1), _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float, _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float);
            float _Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float;
            Unity_Divide_float(_Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float, _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float, _Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float);
            float3 _Multiply_1c3e80d5ad544d37afeae348e005b1ce_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float.xxx), _Multiply_1c3e80d5ad544d37afeae348e005b1ce_Out_2_Vector3);
            float _Property_fbedcc335e4e489a88530feceac28a92_Out_0_Float = _Positive_Noiseheight;
            float _Property_51562b6bcc0e49889a5b042bd9dd3ec1_Out_0_Float = _NegativeNoiseheight;
            float _Property_4a38113a4b3d4df9a442abaf0dfc7175_Out_0_Float = _MoodValue;
            float _Divide_c3a203997247432380c98ea6f1105246_Out_2_Float;
            Unity_Divide_float(_Property_4a38113a4b3d4df9a442abaf0dfc7175_Out_0_Float, float(10), _Divide_c3a203997247432380c98ea6f1105246_Out_2_Float);
            float _Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float;
            Unity_Absolute_float(_Divide_c3a203997247432380c98ea6f1105246_Out_2_Float, _Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float);
            float _Maximum_ea3824aff9834aa6abb200d18549a1ab_Out_2_Float;
            Unity_Maximum_float(_Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float, float(0), _Maximum_ea3824aff9834aa6abb200d18549a1ab_Out_2_Float);
            float _Lerp_631ef014257c45109ba70e191310a027_Out_3_Float;
            Unity_Lerp_float(_Property_fbedcc335e4e489a88530feceac28a92_Out_0_Float, _Property_51562b6bcc0e49889a5b042bd9dd3ec1_Out_0_Float, _Maximum_ea3824aff9834aa6abb200d18549a1ab_Out_2_Float, _Lerp_631ef014257c45109ba70e191310a027_Out_3_Float);
            float3 _Multiply_f5b6315c130940588d7d1a13e6a6ff4b_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_1c3e80d5ad544d37afeae348e005b1ce_Out_2_Vector3, (_Lerp_631ef014257c45109ba70e191310a027_Out_3_Float.xxx), _Multiply_f5b6315c130940588d7d1a13e6a6ff4b_Out_2_Vector3);
            float3 _Add_61d8564b498f4b51a52cb66ee888a83f_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_f5b6315c130940588d7d1a13e6a6ff4b_Out_2_Vector3, _Add_61d8564b498f4b51a52cb66ee888a83f_Out_2_Vector3);
            float3 _Add_b49f2b0d3cc549f6a4a0e455f9e0e053_Out_2_Vector3;
            Unity_Add_float3(_Multiply_c90d63e869b44661889a2e2dfe9e0e0b_Out_2_Vector3, _Add_61d8564b498f4b51a52cb66ee888a83f_Out_2_Vector3, _Add_b49f2b0d3cc549f6a4a0e455f9e0e053_Out_2_Vector3);
            description.Position = _Add_b49f2b0d3cc549f6a4a0e455f9e0e053_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _SceneDepth_1d62aecc09a14ac0bed9f4678f0448b6_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_1d62aecc09a14ac0bed9f4678f0448b6_Out_1_Float);
            float4 _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_acd842be6bac4afb80d042288e1ad842_R_1_Float = _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4[0];
            float _Split_acd842be6bac4afb80d042288e1ad842_G_2_Float = _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4[1];
            float _Split_acd842be6bac4afb80d042288e1ad842_B_3_Float = _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4[2];
            float _Split_acd842be6bac4afb80d042288e1ad842_A_4_Float = _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4[3];
            float _Subtract_fd02db5f391c43f490009d6955270e36_Out_2_Float;
            Unity_Subtract_float(_Split_acd842be6bac4afb80d042288e1ad842_A_4_Float, float(1), _Subtract_fd02db5f391c43f490009d6955270e36_Out_2_Float);
            float _Subtract_bef36b46422c4699a3d88565f075a16f_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_1d62aecc09a14ac0bed9f4678f0448b6_Out_1_Float, _Subtract_fd02db5f391c43f490009d6955270e36_Out_2_Float, _Subtract_bef36b46422c4699a3d88565f075a16f_Out_2_Float);
            float _Property_4b0a98bda8f04d7ea94b75ebe82dc08c_Out_0_Float = _Transparency_range;
            float _Divide_1aba6093906742d5a901c9be7459b7b5_Out_2_Float;
            Unity_Divide_float(_Subtract_bef36b46422c4699a3d88565f075a16f_Out_2_Float, _Property_4b0a98bda8f04d7ea94b75ebe82dc08c_Out_0_Float, _Divide_1aba6093906742d5a901c9be7459b7b5_Out_2_Float);
            float _Saturate_fd34f19222c3440ca94ce5e6730b5449_Out_1_Float;
            Unity_Saturate_float(_Divide_1aba6093906742d5a901c9be7459b7b5_Out_2_Float, _Saturate_fd34f19222c3440ca94ce5e6730b5449_Out_1_Float);
            float _Smoothstep_8a1ab4f73b564e069ca1c5812870bad5_Out_3_Float;
            Unity_Smoothstep_float(float(0), float(1), _Saturate_fd34f19222c3440ca94ce5e6730b5449_Out_1_Float, _Smoothstep_8a1ab4f73b564e069ca1c5812870bad5_Out_3_Float);
            surface.Alpha = _Smoothstep_8a1ab4f73b564e069ca1c5812870bad5_Out_3_Float;
            surface.AlphaClipThreshold = float(0.5);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
        {
            result.vertex     = float4(attributes.positionOS, 1);
            result.tangent    = attributes.tangentOS;
            result.normal     = attributes.normalOS;
            result.vertex     = float4(vertexDescription.Position, 1);
            result.normal     = vertexDescription.Normal;
            result.tangent    = float4(vertexDescription.Tangent, 0);
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
        }
        
        void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
        {
            result.pos = varyings.positionCS;
            result.worldPos = varyings.positionWS;
            // World Tangent isn't an available input on v2f_surf
        
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            #if !defined(LIGHTMAP_ON)
            #endif
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogCoord = varyings.fogFactorAndVertexLight.x;
                COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
        }
        
        void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
        {
            result.positionCS = surfVertex.pos;
            result.positionWS = surfVertex.worldPos;
            // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
            // World Tangent isn't an available input on v2f_surf
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            #if !defined(LIGHTMAP_ON)
            #endif
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
                COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull Back
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS ScenePickingPass
        #define BUILTIN_TARGET_API 1
        #define SCENEPICKINGPASS 1
        #define _BUILTIN_SURFACE_TYPE_TRANSPARENT 1
        #define _BUILTIN_AlphaClip 1
        #define _BUILTIN_ALPHATEST_ON 1
        #define REQUIRE_DEPTH_TEXTURE
        #ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #endif
        #ifdef _BUILTIN_ALPHATEST_ON
        #define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
        #endif
        #ifdef _BUILTIN_AlphaClip
        #define _AlphaClip _BUILTIN_AlphaClip
        #endif
        #ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
        #define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
        #endif
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _NegativeNoisespeed;
        float _Positive_Noiseheight;
        float4 _Noise_remap;
        float4 _NegativValleyColor;
        float4 _NegativPeakColor;
        float _Noise_Edge_1;
        float _Noise_Edge_2;
        float _Noise_Power;
        float _Base_Scale;
        float _negativenoisespeed;
        float _Base_Strength;
        float _Emission_Strength;
        float _Bowl_Curvature;
        float _Fresnel_Power;
        float _Fresnal_Opacity;
        float _Transparency_range;
        float _TileScale;
        float4 _Positive_ValleyColor;
        float4 _PositivePeakColor;
        float _MoodValue;
        float _NegativeNoiseheight;
        float _PositiveNoisespeed;
        float _Positivebasespeed;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
            float s, c;
            sincos(Rotation, s, c);
            Axis = normalize(Axis);
            Out = In * c + cross(Axis, In) * s + Axis * dot(Axis, In) * (1 - c);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_37b74d35aea7418684eea7308fed4dc2_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_37b74d35aea7418684eea7308fed4dc2_Out_2_Float);
            float _Multiply_6c95e880611244deac2b872b6decd88d_Out_2_Float;
            Unity_Multiply_float_float(_Distance_37b74d35aea7418684eea7308fed4dc2_Out_2_Float, -1, _Multiply_6c95e880611244deac2b872b6decd88d_Out_2_Float);
            float _Property_960eb8d9027b4ea1a34e2806e82d40da_Out_0_Float = _Bowl_Curvature;
            float _Divide_e3bfc6ac830e4502bdb64c805aa9a3ef_Out_2_Float;
            Unity_Divide_float(_Multiply_6c95e880611244deac2b872b6decd88d_Out_2_Float, _Property_960eb8d9027b4ea1a34e2806e82d40da_Out_0_Float, _Divide_e3bfc6ac830e4502bdb64c805aa9a3ef_Out_2_Float);
            float _Power_09d0ece4dc0f41e9b8894ee456c020c9_Out_2_Float;
            Unity_Power_float(_Divide_e3bfc6ac830e4502bdb64c805aa9a3ef_Out_2_Float, float(3), _Power_09d0ece4dc0f41e9b8894ee456c020c9_Out_2_Float);
            float3 _Multiply_c90d63e869b44661889a2e2dfe9e0e0b_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_09d0ece4dc0f41e9b8894ee456c020c9_Out_2_Float.xxx), _Multiply_c90d63e869b44661889a2e2dfe9e0e0b_Out_2_Vector3);
            float _Property_37396a43db5941909959cbd08cb7213b_Out_0_Float = _Noise_Edge_1;
            float _Property_2d5fab0c056b463089f63a339f94ac2b_Out_0_Float = _Noise_Edge_2;
            float4 _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4 = _Rotate_Projection;
            float _Split_83c34662c4394bda92d2da5990f2b124_R_1_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[0];
            float _Split_83c34662c4394bda92d2da5990f2b124_G_2_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[1];
            float _Split_83c34662c4394bda92d2da5990f2b124_B_3_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[2];
            float _Split_83c34662c4394bda92d2da5990f2b124_A_4_Float = _Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4[3];
            float3 _RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_d6c6fb634a8e44628fdce8295a1d3540_Out_0_Vector4.xyz), _Split_83c34662c4394bda92d2da5990f2b124_A_4_Float, _RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3);
            float _Property_77fe19067f40438693aa98df3480a426_Out_0_Float = _TileScale;
            float3 _Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3;
            Unity_Multiply_float3_float3(_RotateAboutAxis_de1b8404ab1844baa2c40bcdba70ee1e_Out_3_Vector3, (_Property_77fe19067f40438693aa98df3480a426_Out_0_Float.xxx), _Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3);
            float _Property_41dd9680a76949e29c341e472c8e41ee_Out_0_Float = _PositiveNoisespeed;
            float _Property_5ecd4183beb8451e9ef255004c349ad5_Out_0_Float = _NegativeNoisespeed;
            float _Property_7786adaa185c44daaca6ed08996d54d0_Out_0_Float = _MoodValue;
            float _Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float;
            Unity_Divide_float(_Property_7786adaa185c44daaca6ed08996d54d0_Out_0_Float, float(10), _Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float);
            float _Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float;
            Unity_Absolute_float(_Divide_e7dac230a6fd4970b4f5718171be45be_Out_2_Float, _Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float);
            float _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float;
            Unity_Maximum_float(_Absolute_f2de25ef360d4ee0bbbd7a08be266a2d_Out_1_Float, float(0), _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float);
            float _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float;
            Unity_Lerp_float(_Property_41dd9680a76949e29c341e472c8e41ee_Out_0_Float, _Property_5ecd4183beb8451e9ef255004c349ad5_Out_0_Float, _Maximum_a3d4cc025a2041a4b9502c8b4fc92e72_Out_2_Float, _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float);
            float _Multiply_91dd2cd366344500997788845d158666_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Lerp_08702c3b6876467ea744704690cd7223_Out_3_Float, _Multiply_91dd2cd366344500997788845d158666_Out_2_Float);
            float2 _TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), (_Multiply_91dd2cd366344500997788845d158666_Out_2_Float.xx), _TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2);
            float _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float = _Noise_Scale;
            float _GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_439acce11c8e4d2c89b44b3d848f8e6f_Out_3_Vector2, _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float, _GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float);
            float2 _TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2);
            float _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_e7a0dc8d211443d6a151db8f9dfdb489_Out_3_Vector2, _Property_14ad7f7aa4184334a6a7c99a05e27af9_Out_0_Float, _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float);
            float _Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float;
            Unity_Add_float(_GradientNoise_0cc3a027e47542b693cd4c2bd5ff96b6_Out_2_Float, _GradientNoise_9bdb8bc6018b41c9bd554eae4f663169_Out_2_Float, _Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float);
            float _Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float;
            Unity_Divide_float(_Add_570f2c9358fc4d88aa66531baf9d1398_Out_2_Float, float(2), _Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float);
            float _Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float;
            Unity_Saturate_float(_Divide_b77ffe47df9f458a8b09d6c82517e6f8_Out_2_Float, _Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float);
            float _Property_84e8826753fe4fd08cbcedf557994d88_Out_0_Float = _Noise_Power;
            float _Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float;
            Unity_Power_float(_Saturate_a3b1d98f2cd54f298aeff5761a238e37_Out_1_Float, _Property_84e8826753fe4fd08cbcedf557994d88_Out_0_Float, _Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float);
            float4 _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4 = _Noise_remap;
            float _Split_48347984f6a84a9893ddcefdedd069b1_R_1_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[0];
            float _Split_48347984f6a84a9893ddcefdedd069b1_G_2_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[1];
            float _Split_48347984f6a84a9893ddcefdedd069b1_B_3_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[2];
            float _Split_48347984f6a84a9893ddcefdedd069b1_A_4_Float = _Property_6b398d6699ae487d82c8ab297b1ef28d_Out_0_Vector4[3];
            float4 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4;
            float3 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGB_5_Vector3;
            float2 _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RG_6_Vector2;
            Unity_Combine_float(_Split_48347984f6a84a9893ddcefdedd069b1_R_1_Float, _Split_48347984f6a84a9893ddcefdedd069b1_G_2_Float, float(0), float(0), _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4, _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGB_5_Vector3, _Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RG_6_Vector2);
            float4 _Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4;
            float3 _Combine_2bfc034140f647a78084b52cf23498dc_RGB_5_Vector3;
            float2 _Combine_2bfc034140f647a78084b52cf23498dc_RG_6_Vector2;
            Unity_Combine_float(_Split_48347984f6a84a9893ddcefdedd069b1_B_3_Float, _Split_48347984f6a84a9893ddcefdedd069b1_A_4_Float, float(0), float(0), _Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4, _Combine_2bfc034140f647a78084b52cf23498dc_RGB_5_Vector3, _Combine_2bfc034140f647a78084b52cf23498dc_RG_6_Vector2);
            float _Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float;
            Unity_Remap_float(_Power_2aa1d505dac34c17b3a4bb5420fef5fc_Out_2_Float, (_Combine_89ee2eb1c65d4f7591b0c61f8f24fb6e_RGBA_4_Vector4.xy), (_Combine_2bfc034140f647a78084b52cf23498dc_RGBA_4_Vector4.xy), _Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float);
            float _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float;
            Unity_Absolute_float(_Remap_2c0c4eb7d3cf4e109d1310074162251e_Out_3_Float, _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float);
            float _Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float;
            Unity_Smoothstep_float(_Property_37396a43db5941909959cbd08cb7213b_Out_0_Float, _Property_2d5fab0c056b463089f63a339f94ac2b_Out_0_Float, _Absolute_b45bedf8bd924738a0d6307a00c78495_Out_1_Float, _Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float);
            float _Property_90b7a5c151634fc395d9f6d8cafa7bfb_Out_0_Float = _Positivebasespeed;
            float _Property_259361442b4a474a8ea19b196b10203b_Out_0_Float = _negativenoisespeed;
            float _Property_3c059a7fd1384747b0882ef29ca0c38b_Out_0_Float = _MoodValue;
            float _Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float;
            Unity_Divide_float(_Property_3c059a7fd1384747b0882ef29ca0c38b_Out_0_Float, float(10), _Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float);
            float _Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float;
            Unity_Absolute_float(_Divide_2dbc42f6649a42c8810bf273c5cd2b89_Out_2_Float, _Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float);
            float _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float;
            Unity_Maximum_float(_Absolute_0cefcae60dad4557a7fb8efa38fe2533_Out_1_Float, float(0), _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float);
            float _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float;
            Unity_Lerp_float(_Property_90b7a5c151634fc395d9f6d8cafa7bfb_Out_0_Float, _Property_259361442b4a474a8ea19b196b10203b_Out_0_Float, _Maximum_2e5ccdc7dd284e5fa492bcdb215a1d1f_Out_2_Float, _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float);
            float _Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Lerp_7631cbc430ca4127a9b2e276c673a1f3_Out_3_Float, _Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float);
            float2 _TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Multiply_e635f6494e514c12be7011305f343bed_Out_2_Vector3.xy), float2 (1, 1), (_Multiply_f1884833900a4b9690706fd83734055c_Out_2_Float.xx), _TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2);
            float _Property_9cdb12619ba0436c88021cdfb91f4ba2_Out_0_Float = _Base_Scale;
            float _GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_a926f3f1ebe54f5b8f9ddf01168dc53c_Out_3_Vector2, _Property_9cdb12619ba0436c88021cdfb91f4ba2_Out_0_Float, _GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float);
            float _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float = _Base_Strength;
            float _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_38e68abe30b945debdc29a86d08d7464_Out_2_Float, _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float, _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float);
            float _Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float;
            Unity_Add_float(_Smoothstep_848de3c62b4243d981b4a3260a3f5246_Out_3_Float, _Multiply_08f7a5adbd6f444e9df40fbef008a5bf_Out_2_Float, _Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float);
            float _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float;
            Unity_Add_float(float(1), _Property_f83a03602be043cd8455f16c941669b3_Out_0_Float, _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float);
            float _Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float;
            Unity_Divide_float(_Add_57cfcc2c85b5422798ea976fcc92f176_Out_2_Float, _Add_a47714b6e2e643329283ef86cd7a8d5a_Out_2_Float, _Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float);
            float3 _Multiply_1c3e80d5ad544d37afeae348e005b1ce_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_aedc6f2ba14047f6b995840e7ab5419e_Out_2_Float.xxx), _Multiply_1c3e80d5ad544d37afeae348e005b1ce_Out_2_Vector3);
            float _Property_fbedcc335e4e489a88530feceac28a92_Out_0_Float = _Positive_Noiseheight;
            float _Property_51562b6bcc0e49889a5b042bd9dd3ec1_Out_0_Float = _NegativeNoiseheight;
            float _Property_4a38113a4b3d4df9a442abaf0dfc7175_Out_0_Float = _MoodValue;
            float _Divide_c3a203997247432380c98ea6f1105246_Out_2_Float;
            Unity_Divide_float(_Property_4a38113a4b3d4df9a442abaf0dfc7175_Out_0_Float, float(10), _Divide_c3a203997247432380c98ea6f1105246_Out_2_Float);
            float _Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float;
            Unity_Absolute_float(_Divide_c3a203997247432380c98ea6f1105246_Out_2_Float, _Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float);
            float _Maximum_ea3824aff9834aa6abb200d18549a1ab_Out_2_Float;
            Unity_Maximum_float(_Absolute_3b697cd103f045e3ad8358bb19bc570a_Out_1_Float, float(0), _Maximum_ea3824aff9834aa6abb200d18549a1ab_Out_2_Float);
            float _Lerp_631ef014257c45109ba70e191310a027_Out_3_Float;
            Unity_Lerp_float(_Property_fbedcc335e4e489a88530feceac28a92_Out_0_Float, _Property_51562b6bcc0e49889a5b042bd9dd3ec1_Out_0_Float, _Maximum_ea3824aff9834aa6abb200d18549a1ab_Out_2_Float, _Lerp_631ef014257c45109ba70e191310a027_Out_3_Float);
            float3 _Multiply_f5b6315c130940588d7d1a13e6a6ff4b_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_1c3e80d5ad544d37afeae348e005b1ce_Out_2_Vector3, (_Lerp_631ef014257c45109ba70e191310a027_Out_3_Float.xxx), _Multiply_f5b6315c130940588d7d1a13e6a6ff4b_Out_2_Vector3);
            float3 _Add_61d8564b498f4b51a52cb66ee888a83f_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_f5b6315c130940588d7d1a13e6a6ff4b_Out_2_Vector3, _Add_61d8564b498f4b51a52cb66ee888a83f_Out_2_Vector3);
            float3 _Add_b49f2b0d3cc549f6a4a0e455f9e0e053_Out_2_Vector3;
            Unity_Add_float3(_Multiply_c90d63e869b44661889a2e2dfe9e0e0b_Out_2_Vector3, _Add_61d8564b498f4b51a52cb66ee888a83f_Out_2_Vector3, _Add_b49f2b0d3cc549f6a4a0e455f9e0e053_Out_2_Vector3);
            description.Position = _Add_b49f2b0d3cc549f6a4a0e455f9e0e053_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _SceneDepth_1d62aecc09a14ac0bed9f4678f0448b6_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_1d62aecc09a14ac0bed9f4678f0448b6_Out_1_Float);
            float4 _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_acd842be6bac4afb80d042288e1ad842_R_1_Float = _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4[0];
            float _Split_acd842be6bac4afb80d042288e1ad842_G_2_Float = _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4[1];
            float _Split_acd842be6bac4afb80d042288e1ad842_B_3_Float = _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4[2];
            float _Split_acd842be6bac4afb80d042288e1ad842_A_4_Float = _ScreenPosition_460e0fd0fdcb4e07b2347fcebea09709_Out_0_Vector4[3];
            float _Subtract_fd02db5f391c43f490009d6955270e36_Out_2_Float;
            Unity_Subtract_float(_Split_acd842be6bac4afb80d042288e1ad842_A_4_Float, float(1), _Subtract_fd02db5f391c43f490009d6955270e36_Out_2_Float);
            float _Subtract_bef36b46422c4699a3d88565f075a16f_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_1d62aecc09a14ac0bed9f4678f0448b6_Out_1_Float, _Subtract_fd02db5f391c43f490009d6955270e36_Out_2_Float, _Subtract_bef36b46422c4699a3d88565f075a16f_Out_2_Float);
            float _Property_4b0a98bda8f04d7ea94b75ebe82dc08c_Out_0_Float = _Transparency_range;
            float _Divide_1aba6093906742d5a901c9be7459b7b5_Out_2_Float;
            Unity_Divide_float(_Subtract_bef36b46422c4699a3d88565f075a16f_Out_2_Float, _Property_4b0a98bda8f04d7ea94b75ebe82dc08c_Out_0_Float, _Divide_1aba6093906742d5a901c9be7459b7b5_Out_2_Float);
            float _Saturate_fd34f19222c3440ca94ce5e6730b5449_Out_1_Float;
            Unity_Saturate_float(_Divide_1aba6093906742d5a901c9be7459b7b5_Out_2_Float, _Saturate_fd34f19222c3440ca94ce5e6730b5449_Out_1_Float);
            float _Smoothstep_8a1ab4f73b564e069ca1c5812870bad5_Out_3_Float;
            Unity_Smoothstep_float(float(0), float(1), _Saturate_fd34f19222c3440ca94ce5e6730b5449_Out_1_Float, _Smoothstep_8a1ab4f73b564e069ca1c5812870bad5_Out_3_Float);
            surface.Alpha = _Smoothstep_8a1ab4f73b564e069ca1c5812870bad5_Out_3_Float;
            surface.AlphaClipThreshold = float(0.5);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
        {
            result.vertex     = float4(attributes.positionOS, 1);
            result.tangent    = attributes.tangentOS;
            result.normal     = attributes.normalOS;
            result.vertex     = float4(vertexDescription.Position, 1);
            result.normal     = vertexDescription.Normal;
            result.tangent    = float4(vertexDescription.Tangent, 0);
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
        }
        
        void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
        {
            result.pos = varyings.positionCS;
            result.worldPos = varyings.positionWS;
            // World Tangent isn't an available input on v2f_surf
        
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            #if !defined(LIGHTMAP_ON)
            #endif
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogCoord = varyings.fogFactorAndVertexLight.x;
                COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
        }
        
        void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
        {
            result.positionCS = surfVertex.pos;
            result.positionWS = surfVertex.worldPos;
            // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
            // World Tangent isn't an available input on v2f_surf
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            #if !defined(LIGHTMAP_ON)
            #endif
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
                COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
        ENDHLSL
        }
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    CustomEditorForRenderPipeline "UnityEditor.Rendering.BuiltIn.ShaderGraph.BuiltInLitGUI" ""
    FallBack "Hidden/Shader Graph/FallbackError"
}