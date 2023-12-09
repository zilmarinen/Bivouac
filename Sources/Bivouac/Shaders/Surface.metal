//
//  Surface.metal
//
//  Created by Zack Brown on 13/10/2023.
//

#include "Bivouac.metal"

using namespace Bivouac;

constant float4 backgroundColor = float4(0.21f, 0.21f, 0.21f, 1.f);
constant float4 gridColor = float4(0.f, 0.f, 0.f, 1.f);

struct SurfaceVertex {
    
    float3 position [[ attribute(SCNVertexSemanticPosition) ]];
};

struct SurfaceFragment {
  
    float4 fragmentPosition [[position]];
    
    float4 position;
    
    float3 near;
    float3 far;
};

#define PI 3.1415926535897

float grid(float2 p,
           float edgeLength,
           float lineWidth) {
    
    // triangle rotation matrices
    float2 v60 = float2( cos(PI/3.0), sin(PI/3.0));
    float2 vm60 = float2(cos(-PI/3.0), sin(-PI/3.0));
    float2x2 rot60 = float2x2(v60.x,-v60.y,v60.y,v60.x);
    float2x2 rotm60 = float2x2(vm60.x,-vm60.y,vm60.y,vm60.x);
    
    // equilateral triangle grid
    float2 fullStep= float2( edgeLength , edgeLength*v60.y);
    float2 halfStep=fullStep/2.f;
    float2 grid = floor(p/fullStep);
    float2 offset = float2( (fmod(grid.y, 2.f) == 1.f) ? halfStep.x : 0.f , 0.f);
       // tiling
    float2 uv = fmod(p+offset,fullStep)-halfStep;
    return max( abs(lineWidth/(uv*rotm60).y), // lines -60deg
             max ( abs(lineWidth/(uv*rot60).y), // lines 60deg
                     abs(lineWidth/(uv.y)) )); // h lines
}

vertex SurfaceFragment surface_vertex(SurfaceVertex v [[ stage_in ]],
                                      constant SceneBuffer& scn_frame [[ buffer(0) ]],
                                      constant NodeBuffer& scn_node [[ buffer(1) ]]) {
    float2 uv =  v.position.xy;

    return {    .fragmentPosition = float4(v.position,
                                           1.f),
                .position = scn_node.modelViewProjectionTransform * float4(v.position,
                                   1.f),
                .near = unproject(float3(uv,
                                         0.f),
                                  scn_frame),
                .far = unproject(float3(uv,
                                        -1.f),
                                 scn_frame)
    };
}

fragment float4 surface_fragment(SurfaceFragment f [[stage_in]],
                                 constant SceneBuffer& scn_frame [[ buffer(0) ]],
                                 constant NodeBuffer& scn_node [[ buffer(1) ]]) {
    return backgroundColor;
    float clip = -f.near.y / (f.far.y - f.near.y);
    
    float3 position = f.near + clip * (f.far - f.near);
    
    float gr = grid(f.position.xy, 1.f, 0.1f);
    
    return float4(backgroundColor.xyz * gr, 1.f * float(clip > 0.f));
    
//    float4 color = gridn(position.xz,
//                         10.f,
//                         scn_frame);
//    float4 color = gridz(position,
//                         10.f);
//    float4 color = grid(position.xz,
//                        10.f);
    //float gr = triangleGrid(position.xz, 1.f, 0.1f);
    //float gr = grid(f.fragmentPosition.xz, 1.f, 0.1f);
    //return backgroundColor * gr;
    //return backgroundColor * color;
    //return float4(color.rgb, 1.f * float(clip > 0.f));
    //return backgroundColor;
}
