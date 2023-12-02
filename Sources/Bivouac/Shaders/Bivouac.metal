//
//  Bivouac.metal
//
//  Created by Zack Brown on 13/10/2023.
//

using namespace metal;

#include <metal_stdlib>
#include <metal_math>
#include <SceneKit/scn_metal>

#ifndef __Bivouac__
#define __Bivouac__

namespace Bivouac {
    
    struct SceneBuffer {
        
        float4x4 viewTransform;
        
        float4x4 projectionTransform;
        float4x4 inverseProjectionTransform;
        
        float4x4 inverseViewTransform;
        float4x4 inverseViewProjectionTransform;
        
        //
        //  x: Near
        //  y: Far
        //
        float2 nearFar;
        
        //
        //  xy: Size
        //  zw: Origin
        //
        float4 viewportSize;
    };
    
    struct NodeBuffer {
        
        float4x4 modelTransform;
        float4x4 inverseModelTransform;
        float4x4 modelViewTransform;
        float4x4 inverseModelViewTransform;
        float4x4 normalTransform;
        float4x4 modelViewProjectionTransform;
        float4x4 inverseModelViewProjectionTransform;
        float2x3 boundingBox;
        float2x3 worldBoundingBox;
    };
    
    struct Vertex {
        
        float3 position [[ attribute(SCNVertexSemanticPosition) ]];
        float3 normal [[ attribute(SCNVertexSemanticNormal) ]];
        float4 tangent [[ attribute(SCNVertexSemanticTangent) ]];
        float4 color [[ attribute(SCNVertexSemanticColor) ]];
    };

    struct TexturedVertex {
        
        float3 position [[ attribute(SCNVertexSemanticPosition) ]];
        float3 normal [[ attribute(SCNVertexSemanticNormal) ]];
        float4 tangent [[ attribute(SCNVertexSemanticTangent) ]];
        float4 color [[ attribute(SCNVertexSemanticColor) ]];
        float2 uv [[ attribute(SCNVertexSemanticTexcoord0) ]];
    };
    
    struct Fragment {
        
        float4 fragmentPosition [[position]];
        
        float3 position;
        float3 normal;
        float3 tangent;
        float3 bitangent;
        float2 uv;
        float4 color;
        float3 diffuse;
        float3 specular;
        
        //
        // Direction from the fragment toward the camera
        //
        float3 view;
    };
    
    struct Buffer {
        
        float4 color  [[ color(0) ]];
        float depth [[ depth(any) ]];
    };
    
    struct Light {
        
        float3 position;
        float3 direction;
        float4 color;
    };
    
    struct Geometry {
        
        float4 position;
        float3 normal;
        float4 tangent;
        float2 uv;
        float4 color;
    };
    
    struct Surface {
        
        //
        // Direction from the surface toward the camera
        //
        float3 view;
        
        //
        // Fragment properties
        //
        float3 position;
        float3 normal;
        float3 tangent;
        float3 bitangent;
        
        float4 diffuse;
        float4 specular;
    };

    constexpr sampler sample = sampler(coord::normalized,
                                       r_address::clamp_to_edge,
                                       t_address::repeat,
                                       filter::linear);

    inline float3 unproject(float3 projected,
                     constant SceneBuffer& scn_frame [[ buffer(0) ]]) {
    
        float4 unprojected = scn_frame.inverseViewProjectionTransform * float4(projected, 1.f);
    
        return unprojected.xyz / unprojected.w;
    }

    inline half dotClamped(float3 lhs,
                           float3 rhs) { return saturate(dot(lhs,
                                                             rhs)); }
}

#endif

//
//float4 debug_pixel(float2 fragmentPosition)
//    {
//        const int width = 64;
//        switch (int(fragmentPosition.x + fragmentPosition.y ) / width) {
//            case 0: return float4(surface.view, 1.f);
//            case 1: return float4(surface.position, 1.f);
//            case 2: return float4(surface.normal, 1.f);
//            case 3: return float4(surface.geometryNormal, 1.f);
//            case 4: return float4(float3(surface.ambientOcclusion), 1.f);
//            case 5: return surface.diffuse;
//            case 6: return float4(float3(surface.metalness), 1.f);
//            case 7: return float4(float3(surface.roughness), 1.f);
//            case 8: return float4(ambient, 1.f);
//            case 9: return float4(diffuse, 1.f);
//            default: return float4(specular, 1.f);
//        }
//    }
