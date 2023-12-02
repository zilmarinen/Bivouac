//
//  Technique.metal
//
//  Created by Zack Brown on 30/11/2023.
//

#include "Bivouac.metal"

using namespace Bivouac;

constant float3 goochCool = float3(0.356f, 0.819f, 0.843f);
constant float3 goochWarm = float3(1.f, 0.18f, 0.298f);

//
//  MARK: Technique
//

vertex Fragment technique_vertex(Vertex v [[ stage_in ]],
                                 constant SceneBuffer& scn_frame [[ buffer(0) ]],
                                 constant NodeBuffer& scn_node [[ buffer(1) ]]) {
    
    //
    //  Geometry
    //
    Geometry geometry;
    
    geometry.position = float4(v.position, 1.f);
    geometry.normal = v.normal;
    //geometry.tangent = v.tangent;
    //geometry.uv = v.uv;
    geometry.color = v.color;
    
    //
    //  Surface
    //
    Surface surface;
    
    float3x3 normalTransform = float3x3(scn_node.modelViewTransform[0].xyz,
                                        scn_node.modelViewTransform[1].xyz,
                                        scn_node.modelViewTransform[2].xyz);
    
    float3 inverseScaleSquared = 1.f / float3(length_squared(normalTransform[0]),
                                              length_squared(normalTransform[1]),
                                              length_squared(normalTransform[2]));
    
    surface.position = (scn_node.modelViewTransform * geometry.position).xyz;
    surface.normal = normalize(normalTransform * (geometry.normal * inverseScaleSquared));
    //surface.tangent = normalize(normalTransform * geometry.tangent.xyz);
    //surface.bitangent = geometry.tangent.w * cross(surface.tangent,
    //                                               surface.normal);
    surface.view = normalize(-surface.position);
    
    //
    //  Fragment
    //
    Fragment out;
    
    out.fragmentPosition = scn_node.modelViewProjectionTransform * geometry.position;
    out.position = surface.position;
    out.normal = surface.normal;
    //out.tangent = surface.tangent;
    //out.bitangent = surface.bitangent;
    out.uv = geometry.uv;
    out.color = geometry.color;
    out.view = surface.view;

    return out;
}
    
fragment Buffer technique_fragment(Fragment f [[stage_in]],
                                   constant SceneBuffer& scn_frame [[ buffer(0) ]],
                                   constant NodeBuffer& scn_node [[ buffer(1) ]]) {
    
    float3 normal = normalize(f.normal);
    float3 lightDirection = normalize(float3(1.f, 1.f, 0.f));
    float3 reflectionDirection = reflect(-lightDirection, normal);
    float3 specular = dotClamped(f.view, reflectionDirection);
    float diffuse = (1.f + dot(lightDirection,
                               normal)) / 2.f;
    
    float3 cool = goochCool * f.color.rgb;
    float3 warm = goochWarm * f.color.rgb;
    
    float3 gooch = (diffuse * warm) + ((1.f - diffuse) * cool);
    
    //
    //  Buffer
    //
    Buffer buffer;
    
    buffer.color = float4(gooch, 1.f);
    buffer.depth = f.fragmentPosition.z;
    
    return buffer;
}

//
//  MARK: Edge Detection
//

struct EdgeVertex {
    
    float3 position [[ attribute(SCNVertexSemanticPosition) ]];
};

struct EdgeFragment {
    
    float4 fragmentPosition [[position]];

    float2 uv;
};

vertex EdgeFragment edge_detection_vertex(EdgeVertex v [[ stage_in ]]) {
    
    //
    //  Fragment
    //
    EdgeFragment out;
    
    out.fragmentPosition = float4(v.position, 1.f);
    out.uv = (v.position.xy + 1.0) * float2(0.5, -0.5);

    return out;
}

fragment float4 edge_detection_fragment(EdgeFragment f [[stage_in]],
                                        texture2d<half, access::sample> colorBuffer [[ texture(0) ]]) {
    
    return float4(colorBuffer.sample(sample, f.uv));
}
