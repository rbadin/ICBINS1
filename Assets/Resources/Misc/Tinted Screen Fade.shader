﻿Shader "Custom/Tinted Screen Fade"
{
    Properties
    {
        [Slider]
        _Brightness ("Brightness", Float) = 1.125
        _RedOffset ("Red Offset", Float) = -0.125
        _BlueOffset ("Blue Offset", Float) = 0
        _GreenOffset ("Green Offset", Float) = -0.125
    }
    SubShader
    {
        // Draw ourselves after all opaque geometry
        Tags { "Queue" = "Transparent" }

        // Grab the screen behind the object into _BackgroundTexture
        GrabPass
        {
            "_BackgroundTexture"
        }

        // Render the object with the texture generated above, and invert the colors
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f
            {
                float4 grabPos : TEXCOORD0;
                float4 pos : SV_POSITION;
            };

            v2f vert(appdata_base v) {
                v2f o;
                // use UnityObjectToClipPos from UnityCG.cginc to calculate 
                // the clip-space of the vertex
                o.pos = UnityObjectToClipPos(v.vertex);
                // use ComputeGrabScreenPos function from UnityCG.cginc
                // to get the correct texture coordinate
                o.grabPos = ComputeGrabScreenPos(o.pos);
                return o;
            }

            sampler2D _BackgroundTexture;
            float _Brightness;
            float _RedOffset;
            float _BlueOffset;
            float _GreenOffset;

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 bgcolor = tex2Dproj(_BackgroundTexture, i.grabPos);
                float rBright = _Brightness + _RedOffset; 
                rBright = min(1, max(0, rBright));

                float gBright = _Brightness + _GreenOffset; 
                gBright = min(1, max(0, gBright));
                
                float bBright = _Brightness + _BlueOffset; 
                bBright = min(1, max(0, bBright));
                
                return fixed4(
                    bgcolor.r * rBright,
                    bgcolor.g * gBright,
                    bgcolor.b * bBright,
                    bgcolor.a
                );
            }
            ENDCG
        }

    }
}