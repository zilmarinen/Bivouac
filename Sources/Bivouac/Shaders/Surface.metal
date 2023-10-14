//
//  Surface.metal
//
//  Created by Zack Brown on 13/10/2023.
//

#include "Bivouac.metal"

constant float4 backgroundColor = float4(0.27f, 0.27f, 0.27f, 1.f);
constant float4 gridColor = float4(0.f, 0.f, 0.f, 1.f);

struct SurfaceVertex {
    
    float3 position [[ attribute(SCNVertexSemanticPosition) ]];
    float2 uv [[ attribute(SCNVertexSemanticTexcoord0) ]];
};

struct SurfaceFragment {
  
    float4 fragmentPosition [[position]];
    
    float4 position;
    float2 uv;
    
    float3 near;
    float3 far;
};

float3 unproject(float3 position,
                 constant SceneTransforms& scn_frame [[ buffer(0) ]]) {
    
    float4 unprojected = scn_frame.inverseViewTransform * scn_frame.inverseProjectionTransform * float4(position, 1.f);
    
    return unprojected.xyz / unprojected.w;
}

float4 grid(float2 position,
            float edgeLength) {
    
    float2 fractional  = abs(fract(position + 0.5));
    float2 partial = fwidth(position);

    float2 point = smoothstep(-partial, partial, fractional);

    float saturation = 1.0 - saturate(point.x * point.y);

    return float4(mix(backgroundColor.rgb, gridColor.rgb, saturation), 1.0);
}
 
vertex SurfaceFragment surface_vertex(SurfaceVertex v [[ stage_in ]],
                               constant SceneTransforms& scn_frame [[ buffer(0) ]],
                               constant NodeTransforms& scn_node [[ buffer(1) ]]) {
    
    float2 position =  v.position.xy;
    
    return {    .fragmentPosition = float4(v.position, 1.f),
                .position = scn_node.modelViewProjectionTransform * float4(v.position, 1.f),
                .uv = v.uv,
                .near = unproject(float3(position, 0.f),
                                  scn_frame),
                .far = unproject(float3(position, 1.f),
                                 scn_frame)
    };
}

//
//*******
//

// triangle rotation matrices
constant float PI = 3.1415926535897f;
constant float2 v60 = float2(cos(PI / 3.f), sin(PI / 3.f));
constant float2 vm60 = float2(cos(-PI / 3.f), sin(-PI / 3.f));
constant float2x2 rot60 = float2x2(v60.x, -v60.y, v60.y, v60.x);
constant float2x2 rotm60 = float2x2(vm60.x, -vm60.y, vm60.y, vm60.x);

fragment float4 surface_fragment(SurfaceFragment f [[stage_in]],
                                 constant SceneTransforms& scn_frame [[ buffer(0) ]],
                                 constant NodeTransforms& scn_node [[ buffer(1) ]]) {
    
    float clip = f.near.y / (f.far.y - f.near.y);
    
    float3 position = f.near + clip * (f.far - f.near);
    
    //return grid(position.xz, 1.f) * float(clip > 0.f);
    
    float2 p = position.xz;
    float stepSize = 0.1f;
    float vertexSize = 0.00005f;
    float lineSize = 0.005f;

    float2 fullStep = float2(stepSize, stepSize * v60.y);
    float2 halfStep = fullStep / 2.f;
    float2 grid = floor(p / fullStep);
    float2 offset = float2( (fmod(grid.y, 2.f) == 1.f) ? halfStep.x : 0.f, 0.f);

    // tiling
    float2 uv = fmod(p + offset, fullStep) - halfStep;
    
    float d = dot(uv, uv);
    float i = max(abs(lineSize / (uv * rot60).y),
                  abs(lineSize / uv.y));
    float j = max(abs(lineSize / (uv * rotm60).y),
                  i);
    //float line = vertexSize / d + j;
    float thing = d + j;
    float result = vertexSize / d;
    
    return float4(backgroundColor.xyz * result, 1.f);
}

/*
 
 return vertexSize/d2 + // vertices
         max( abs(lineSize/(uv*rotm60).y), // lines -60deg
              max ( abs(lineSize/(uv*rot60).y), // lines 60deg
                      abs(lineSize/(uv.y)) )); // h lines
 
 */
