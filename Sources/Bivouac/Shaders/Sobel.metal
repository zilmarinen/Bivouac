//
//  Sobel.metal
//
//  Created by Zack Brown on 02/12/2023.
//

#include "Bivouac.metal"

using namespace Bivouac;

struct SobelFragment {
    
    float4 fragmentPosition [[position]];

    float2 uv;
};

constant float2 offset[] = { { -1.f, -1.f }, { 0.f, -1.f }, { 1.f, -1.f },
                             { -1.f,  0.f }, { 0.f,  0.f }, { 1.f,  0.f },
                             { -1.f,  1.f }, { 0.f,  1.f }, { 1.f,  1.f } };

vertex SobelFragment sobel_vertex(SimpleVertex v [[ stage_in ]]) {
    
    return { .fragmentPosition = float4(v.position, 1.f),
             .uv = (v.position.xy + 1.f) * float2(0.5f, -0.5f) };
}

fragment float4 sobel_fragment(SobelFragment f [[stage_in]],
                               texture2d<float, access::sample> colorBuffer [[ texture(0) ]],
                               depth2d<float, access::sample> depthBuffer [[ texture(1) ]],
                               texture2d<float, access::sample> normalBuffer [[ texture(2) ]]) {
    
    float4 color = float4(colorBuffer.sample(sample, f.uv));
    float4 normal = float4(normalBuffer.sample(sample, f.uv));
    float depth = depthBuffer.sample(sample, f.uv);
    
    float3 sobelX = 0.f;
    float3 sobelY = 0.f;
    
    // Adjust this threshold to control the sensitivity of edge detection
    float threshold = 0.0001f;

    for (int i = 0; i < 9; i++) {
        
        float2 uv = f.uv + 0.00001f * offset[i];
        float3 sampleColor = float3(colorBuffer.sample(sample, uv).rgb);
        
        sobelX += sampleColor * offset[i].x;
        sobelY += sampleColor * offset[i].y;
    }

    float sobelMagnitude = length(sobelX.rgb) + length(sobelY.rgb);
    
    float line = 1.f - step(threshold, sobelMagnitude);

    // Use the sobel magnitude to create a binary edge map
    float4 edge = float4(float3(line), 1.f);
    
    color = normal;
    //color = float4(float3(depth), 1.f);
    
    return mix(edge, color, line);
}
