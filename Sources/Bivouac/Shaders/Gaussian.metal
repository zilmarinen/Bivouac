//
//  Gaussian.swift
//  
//
//  Created by Zack Brown on 03/12/2023.
//

#include "Bivouac.metal"

using namespace Bivouac;

struct GaussianFragment {
    
    float4 fragmentPosition [[position]];

    float2 uv;
};

constant float offset[] = { 0.0, 1.0, 2.0, 3.0, 4.0 };
constant float weight[] = { 0.2270270270, 0.1945945946, 0.1216216216, 0.0540540541, 0.0162162162 };

vertex GaussianFragment gaussian_vertex(SimpleVertex v [[ stage_in ]]) {
    
    return { .fragmentPosition = float4(v.position, 1.f),
             .uv = (v.position.xy + 1.0) * float2(0.5, -0.5) };
}

fragment float4 gaussian_horizontal_fragment(GaussianFragment f [[stage_in]],
                                             texture2d<half, access::sample> colorBuffer [[ texture(0) ]]) {
    
    float4 color = float4(colorBuffer.sample(sample, f.uv));
    
    float r = color.r * weight[0];
            
    for (int i = 1; i < 5; i++) {
        
        r += colorBuffer.sample(sample, ( f.uv + float2(offset[i], 0.f) / bufferSize)).r * weight[i];
        r += colorBuffer.sample(sample, ( f.uv - float2(offset[i], 0.f) / bufferSize)).r * weight[i];
    }
    
    return float4(r, color.g, color.b, 1.f);
}

fragment float4 gaussian_vertical_fragment(GaussianFragment f [[stage_in]],
                                           texture2d<half, access::sample> colorBuffer [[ texture(0) ]]) {
    
    float4 color = float4(colorBuffer.sample(sample, f.uv));
    
    float r = color.r * weight[0];
            
    for (int i = 1; i < 5; i++) {
        
        r += colorBuffer.sample(sample, ( f.uv + float2(0.f, offset[i]) / bufferSize)).r * weight[i];
        r += colorBuffer.sample(sample, ( f.uv - float2(0.f, offset[i]) / bufferSize)).r * weight[i];
    }
    
    return float4(r, color.g, color.b, 1.f);
}
