//
//  Technique.metal
//
//  Created by Zack Brown on 30/11/2023.
//

#include "Bivouac.metal"

using namespace Bivouac;

vertex Fragment technique_vertex(Vertex v [[ stage_in ]],
                                 constant SceneBuffer& scn_frame [[ buffer(0) ]],
                                 constant NodeBuffer& scn_node [[ buffer(1) ]]) {
    
    //
    //  Geometry
    //
    Geometry geometry;
    
    geometry.position = float4(v.position, 1.f);
    geometry.normal = v.normal;
    geometry.color = v.color;
    
    //
    //  Surface
    //
    Surface surface;
    
    float3x3 normalTransform = float3x3(scn_node.normalTransform[0].xyz,
                                        scn_node.normalTransform[1].xyz,
                                        scn_node.normalTransform[2].xyz);
    
    float3 inverseScaleSquared = 1.f / float3(length_squared(normalTransform[0]),
                                              length_squared(normalTransform[1]),
                                              length_squared(normalTransform[2]));
    
    surface.position = (scn_node.modelViewTransform * geometry.position).xyz;
    surface.normal = normalize(normalTransform * (geometry.normal * inverseScaleSquared));
    surface.view = normalize(-surface.position);
    
    //
    //  Fragment
    //
    Fragment out;
    
    out.fragmentPosition = scn_node.modelViewProjectionTransform * geometry.position;
    out.position = surface.position;
    out.normal = surface.normal;
    out.uv = geometry.uv;
    out.color = geometry.color;
    out.view = surface.view;

    return out;
}
    
fragment CombinedBuffer technique_fragment(Fragment f [[stage_in]]) {
    
    return { .color = f.color,//float4(gooch(f), 1.f);
             .depth = f.fragmentPosition.z };
}

fragment NormalBuffer technique_normal_fragment_modified(Fragment f [[stage_in]]) {
    
    return { .normal = float4(1.f, 0.f, 1.f, 1.f) }; // float4(f.normal * 0.5 + 0.5, 1.f) };
}
