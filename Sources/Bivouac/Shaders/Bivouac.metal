//
//  Bivouac.metal
//
//  Created by Zack Brown on 13/10/2023.
//

using namespace metal;

#include <metal_stdlib>
#include <SceneKit/scn_metal>
 
struct SceneTransforms {
    
    float4x4 viewTransform;
    
    float4x4 projectionTransform;
    float4x4 inverseProjectionTransform;
    
    float4x4 inverseViewTransform;
    
    //
    //  X: Near
    //  Y: Far
    //
    float2 nearFar;
};

struct NodeTransforms {
    
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
    float2 uv [[ attribute(SCNVertexSemanticTexcoord0) ]];
};

struct Fragment {
  
    float4 fragmentPosition [[position]];
    
    float3 position;
    float3 normal;
    
    float4 color;
    float2 uv;
};

struct Buffer {
    
    float4 color  [[ color(0) ]];
    float4 position  [[ color(1) ]];
    float4 normal  [[ color(2) ]];
};
