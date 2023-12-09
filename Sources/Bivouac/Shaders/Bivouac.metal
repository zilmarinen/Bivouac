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

    constant float3 goochCool = float3(0.356f, 0.819f, 0.843f);
    constant float3 goochWarm = float3(1.f, 0.18f, 0.298f);

    constant float bufferSize = 1024.f;
    
    struct SceneBuffer {
        
        float4x4 viewTransform;
        float4x4 projectionTransform;
        float4x4 viewProjectionTransform;
        float4x4 lastFrameViewProjectionTransform;
        
        float4x4 inverseViewTransform;
        float4x4 inverseProjectionTransform;
        float4x4 inverseViewProjectionTransform;
        float4x4 inverseTransposeViewTransform;
        
        float4 ambientLightingColor;
        float2 inverseResolution;
        
        float time;
        float sinTime;
        float cosTime;
        float random01;
        
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
        float4 color [[ attribute(SCNVertexSemanticColor) ]];
    };

    struct SimpleVertex {
    
        float3 position [[ attribute(SCNVertexSemanticPosition) ]];
    };
    
    struct Fragment {
        
        float4 fragmentPosition [[position]];
        
        float3 position;
        float3 normal;
        float2 uv;
        float4 color;
        float3 diffuse;
        float3 specular;
        
        //
        // Direction from the fragment toward the camera
        //
        float3 view;
    };
    
    struct CombinedBuffer {
        
        float4 color [[ color(0) ]];
        float depth [[ depth(any) ]];
    };

    struct NormalBuffer {
    
        float4 normal [[ color(1) ]];
    };
    
    struct Light {
        
        float3 position;
        float3 direction;
        float4 color;
    };
    
    struct Geometry {
        
        float4 position;
        float3 normal;
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

    inline float3 gooch(Fragment f) {
        
        float3 normal = normalize(f.normal);
        float3 lightDirection = normalize(float3(1.f, 1.f, 0.f));
        float3 reflectionDirection = reflect(-lightDirection, normal);
        float3 specular = dotClamped(f.view, reflectionDirection);
        float diffuse = (1.f + dot(lightDirection,
                                   normal)) / 2.f;

        float3 cool = goochCool * f.color.rgb;
        float3 warm = goochWarm * f.color.rgb;

        return (diffuse * warm) + ((1.f - diffuse) * cool);
    }
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
