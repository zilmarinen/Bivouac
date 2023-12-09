////////////////////////////////////////////////
// CommonProfile Shader v2

#import <metal_stdlib>
/*
using namespace metal;

enum {
    SCNVertexSemanticPosition,
    SCNVertexSemanticNormal,
    SCNVertexSemanticTangent,
    SCNVertexSemanticColor,
    SCNVertexSemanticBoneIndices,
    SCNVertexSemanticBoneWeights,
    SCNVertexSemanticTexcoord0,
    SCNVertexSemanticTexcoord1,
    SCNVertexSemanticTexcoord2,
    SCNVertexSemanticTexcoord3,
    SCNVertexSemanticTexcoord4,
    SCNVertexSemanticTexcoord5,
    SCNVertexSemanticTexcoord6,
    SCNVertexSemanticTexcoord7
};

// This structure hold all the informations that are constant through a render pass
// In a shader modifier, it is given both in vertex and fragment stage through an argument named "scn_frame".
struct SCNSceneBuffer {
    float4x4    viewTransform;
    float4x4    inverseViewTransform; // transform from view space to world space
    float4x4    projectionTransform;
    float4x4    viewProjectionTransform;
    float4x4    viewToCubeTransform; // transform from view space to cube texture space (canonical Y Up space)
    float4x4    lastFrameViewProjectionTransform;
    float4      ambientLightingColor;
    float4        fogColor;
    float3        fogParameters; // x:-1/(end-start) y:1-start*x z:exp
    float2      inverseResolution;
    float       time;
    float       sinTime;
    float       cosTime;
    float       random01;
    float       motionBlurIntensity;
    // new in macOS 10.12 and iOS 10
    float       environmentIntensity;
    float4x4    inverseProjectionTransform;
    float4x4    inverseViewProjectionTransform;
    // new in macOS 10.13 and iOS 11
    float2      nearFar; // x: near, y: far
    float4      viewportSize; // xy:size, zw:origin
    // new in macOS 10.14 and iOS 12
    float4x4    inverseTransposeViewTransform;

    // internal, DO NOT USE
    float4      clusterScale; // w contains z bias
};

// In custom shaders or in shader modifiers, you also have access to node relative information.
// This is done using an argument named "scn_node", which must be a struct with only the necessary fields
// among the following list:
//
// float4x4 modelTransform;
// float4x4 inverseModelTransform;
// float4x4 modelViewTransform;
// float4x4 inverseModelViewTransform;
// float4x4 normalTransform; // This is the inverseTransposeModelViewTransform, need for normal transformation
// float4x4 modelViewProjectionTransform;
// float4x4 inverseModelViewProjectionTransform;
// float2x3 boundingBox;
// float2x3 worldBoundingBox;

// Tool function

namespace scn {

    // convert from [0..1] to [-1..1]
    template <class T>
    inline T signed_unit(T uv) {
        return uv * 2.0 - 1.0;
    }

    // convert from [-1..1] to [0..1]
    template <class T>
    inline T unsigned_unit(T uv) {
        return uv * 0.5 + 0.5;
    }
    
    static inline float rect(float2 lt, float2 rb, float2 uv)
    {
        float2 borders = step(lt, uv) * step(uv, rb);
        return borders.x * borders.y;
    }
    
    inline float grid(float2 lt, float2 rb, float2 gridSize, float thickness, float2 uv)
    {
        float insideRect = rect(lt, rb + thickness, uv);
        float2 gt = thickness * gridSize;
        float2 lines = step(abs(lt - fract(uv * gridSize)), gt);
        return insideRect * (lines.x + lines.y);
    }

    inline float checkerboard(float2 gridSize, float2 uv)
    {
        float2 check = floor(uv * gridSize);
        return step(fmod(check.x + check.y, 2.f), 0.f);
    }
}

// MARK: GL helpers

template <typename T>
inline T dFdx(T v) {
    return dfdx(v);
}

// Y is up in GL and down in Metal
template <typename T>
inline T dFdy(T v) {
    return -dfdy(v);
}

namespace NAMESPACE_HASH {

// Inputs

typedef struct {

    float4x4 modelTransform;
    float4x4 inverseModelTransform;
    float4x4 modelViewTransform;
    float4x4 inverseModelViewTransform;
    float4x4 normalTransform;
    float4x4 modelViewProjectionTransform;
    float4x4 inverseModelViewProjectionTransform;

    //motion blur
    float4x4 lastFrameModelTransform;
    float motionBlurIntensity;
} commonprofile_node;

typedef struct {
    float3 position         [[attribute(SCNVertexSemanticPosition)]];
    float3 normal           [[attribute(SCNVertexSemanticNormal)]];
    float4 tangent          [[attribute(SCNVertexSemanticTangent)]];
    float4 color            [[attribute(SCNVertexSemanticColor)]];
    float4 skinningWeights  [[attribute(SCNVertexSemanticBoneWeights)]];
    uint4  skinningJoints   [[attribute(SCNVertexSemanticBoneIndices)]];

    float2 texcoord0        [[attribute(SCNVertexSemanticTexcoord0)]];
} scn_vertex_t; // __attribute__((scn_per_frame));

typedef struct {
    float4 fragmentPosition [[position]]; // The window relative coordinate (x, y, z, 1/w) values for the fragment
    float4 vertexColor;
    float3 diffuse;
    float3 specular;
    float3 position;
    float3 normal;
    float3 tangent;
    float3 bitangent;

    float nodeOpacity;

    float2 texcoord0;
    
    //motion blur
    float3 mv_fragment;
    float3 mv_lastFragment;
} commonprofile_io;

// 256 bytes
struct scn_light
{
    float4 color; // color.rgb + shadowColor.a                                      16
    float3 pos; //                                                                  16 (12)
    float3 dir; //                                                                  16 (12)
    float shadowRadius; //                                                          4
    uint8_t lightType; //                                                           1
    uint8_t attenuationType; //                                                     1
    uint8_t shadowSampleCount; //                                                   1
};

#if defined(__METAL_VERSION__) && __METAL_VERSION__ >= 120

#define ambientOcclusionTexcoord ambientTexcoord

struct SCNShaderSurface {
    float3 view;                // Direction from the point on the surface toward the camera (V)
    float3 position;            // Position of the fragment
    float3 normal;              // Normal of the fragment (N)
    float3 geometryNormal;      // Normal of the fragment - not taking into account normal map
    float2 normalTexcoord;      // Normal texture coordinates
    float3 tangent;             // Tangent of the fragment
    float3 bitangent;           // Bitangent of the fragment
    float4 ambient;             // Ambient property of the fragment
    float2 ambientTexcoord;     // Ambient texture coordinates
    float4 diffuse;             // Diffuse property of the fragment. Alpha contains the opacity.
    float2 diffuseTexcoord;     // Diffuse texture coordinates
    float fresnel;              // Fresnel property of the fragment.
    float ambientOcclusion;     // Ambient occlusion term of the fragment
};

// Structure to gather property of a light, packed to give access in a light shader modifier
// This must be kept intact for back compatibility in lighting modifiers
struct SCNShaderLight {
    float4 intensity;
    float3 direction;

    float  _att;
    float3 _spotDirection;
    float  _distance;
};

struct SCNShaderLightingContribution
{
    float3 ambient;
    float3 diffuse;
    float3 specular;
    float3 modulate;

    thread SCNShaderSurface& surface;

    commonprofile_io in;

    SCNShaderLightingContribution(thread SCNShaderSurface& iSurface, commonprofile_io io):surface(iSurface)
    ,in(io)
    {
        ambient = 0.f;
        diffuse = 0.f;
        specular = 0.f;
        modulate = 0.f;
    }

    float4 debug_pixel(float2 fragmentPosition)
    {
        const int width = 64;
        switch (int(fragmentPosition.x + fragmentPosition.y ) / width) {
            case 0: return float4(surface.view, 1.f);
            case 1: return float4(surface.position, 1.f);
            case 2: return float4(surface.normal, 1.f);
            case 3: return float4(surface.geometryNormal, 1.f);
            case 4: return float4(float3(surface.ambientOcclusion), 1.f);
            case 5: return surface.diffuse;
            case 6: return float4(ambient, 1.f);
            case 7: return float4(diffuse, 1.f);
            default: return float4(specular, 1.f);
        }
    }

    // tool functions, could be external

    static inline float3 lambert_diffuse(float3 l, float3 n, float3 color, float intensity) {
        return color * (intensity * saturate(dot(n, l)));
    }

    void lambert(float3 l, float3 color, float intensity)
    {
        diffuse += lambert_diffuse(l, surface.normal, color, intensity);
    }

    void blinn(float3 l, float3 color, float intensity)
    {
        float3 D = lambert_diffuse(l, surface.normal, color, intensity);
        diffuse += D;

        //float3 h = normalize(l + surface.view);
        //specular += powr(saturate(dot(surface.normal, h)), surface.shininess) * D;
    }

    void phong(float3 l, float3 color, float intensity)
    {
        float3 D = lambert_diffuse(l, surface.normal, color, intensity);
        diffuse += D;

        //float3 r = reflect(-l, surface.normal);
        //specular += powr(saturate(dot(r, surface.view)), surface.shininess) * D;
    }
};

#endif // #if defined(__METAL_VERSION__) && __METAL_VERSION__ >= 120

struct SCNShaderGeometry
{
    float4 position;
    float3 normal;
    float4 tangent;
    float4 color;
    float2 texcoords[8]; // MAX_UV
};

struct commonprofile_uniforms {
    // [id(0)]]
    float4 diffuseColor;
    float4 ambientColor;
    float diffuseIntensity;
    float normalIntensity;
    float ambientIntensity;
    float3 fresnel; // x: ((n1-n2)/(n1+n2))^2 y:1-x z:exponent
};
} // namespace

using namespace NAMESPACE_HASH;
    
    
//
// MARK: - Vertex and post-tessellation vertex functions
//
    
    
vertex commonprofile_io commonprofile_vert(
                                           scn_vertex_t                       in                               [[ stage_in ]]
                                           , uint                             scn_vertexID                     [[ vertex_id ]]
                                           
                                           , constant SCNSceneBuffer&         scn_frame                        [[ buffer(0) ]]
                                           , constant commonprofile_node&     scn_node                         [[ buffer(1) ]]
                                           // used for texture transform and materialShininess in case of perVertexLighting
                                           , constant commonprofile_uniforms& scn_commonprofile
                                           , uint                             scn_instanceID                   [[ instance_id ]]
                                           )
{
    commonprofile_io out;
    
    //
    // MARK: Populating the `_geometry` struct
    //
    
    SCNShaderGeometry _geometry;
    
    // OPTIM in could be already float4?
    _geometry.position = float4(in.position, 1.f);
    _geometry.normal = in.normal;
    _geometry.tangent = in.tangent;

    //_geometry.texcoords[0] = in.texcoord0;
    //_geometry.texcoords[1] = in.texcoord1;

    _geometry.color = in.color;
    
    //
    // MARK: Populating the `_surface` struct
    //
    
    // Transform the geometry elements in view space
    SCNShaderSurface _surface;

    _surface.position = (scn_node.modelViewTransform * _geometry.position).xyz;
    
    //float3x3 nrmTransform = scn::mat3(scn_node.modelViewTransform);
    //float3 invScaleSquared = 1.f / float3(length_squared(nrmTransform[0]), length_squared(nrmTransform[1]), length_squared(nrmTransform[2]));
    //_surface.normal = normalize(nrmTransform * (_geometry.normal * invScaleSquared));

    //_surface.tangent = normalize(scn::mat3(scn_node.modelViewTransform) * _geometry.tangent.xyz);
    _surface.bitangent = _geometry.tangent.w * cross(_surface.tangent, _surface.normal); // no need to renormalize since tangent and normal should be orthogonal
    
    _surface.view = normalize(-_surface.position);
    
    //
    // MARK: Per-vertex lighting
    //
    
    out.position = _surface.position;
    out.normal = _surface.normal;
    out.tangent = _surface.tangent;
    out.bitangent = _surface.bitangent;
    out.vertexColor = _geometry.color;
    out.texcoord0 = _geometry.texcoords[0].xy;
    
    //
    // MARK: Determining the fragment position
    //
    
    out.fragmentPosition = scn_node.modelViewProjectionTransform * _geometry.position;
    
    float4 lastFrameFragmentPosition = scn_frame.lastFrameViewProjectionTransform * scn_node.lastFrameModelTransform * _geometry.position;
    out.mv_fragment = out.fragmentPosition.xyw;
    out.mv_lastFragment = lastFrameFragmentPosition.xyw;
    
    return out;
}

//
// MARK: - Fragment shader function
//

struct SCNOutput
{
    float4 color [[ color(0) ]];
    half4 color1 [[ color(1) ]];
    half4 normals [[ color(2) ]];
    half4 motionblur [[ color(3) ]];
};

fragment SCNOutput commonprofile_frag(commonprofile_io                 in                               [[ stage_in  ]]
                                      , constant commonprofile_uniforms& scn_commonprofile              [[ buffer(0) ]]
                                      , constant SCNSceneBuffer&         scn_frame                      [[ buffer(1) ]]
                                      , constant commonprofile_node&  scn_node                          [[ buffer(2) ]]
#ifdef USE_SSAO
                                      , texture2d<float>              u_ssaoTexture
#endif
                                      )
{
    SCNOutput _output;

    //
    // MARK: Populating the `_surface` struct
    //
    
    SCNShaderSurface _surface;

    _surface.diffuseTexcoord = in.texcoord0;
    _surface.ambientOcclusion = 1.f; // default to no AO
    _surface.ambient = scn_commonprofile.ambientColor;
    _surface.ambient *= in.vertexColor;

    //_surface.ambientOcclusion *= u_ssaoTexture.sample( sampler(filter::linear), in.fragmentPosition.xy * scn_frame.inverseResolution.xy ).x;

    _surface.diffuse = scn_commonprofile.diffuseColor;

    _surface.diffuse.rgb    *= in.vertexColor.rgb;
    _surface.diffuse        *= in.vertexColor.a; // vertex color are not premultiplied to allow interpolation
 
    _surface.position = in.position;
    _surface.geometryNormal = normalize(in.normal.xyz);
    _surface.normal = _surface.geometryNormal;
    _surface.tangent = in.tangent;
    _surface.bitangent = in.bitangent;
    _surface.view = normalize(-in.position);
    
#ifdef USE_FRESNEL
    _surface.fresnel = scn_commonprofile.fresnel.x + scn_commonprofile.fresnel.y * pow(1.f - saturate(dot(_surface.view, _surface.normal)), scn_commonprofile.fresnel.z);
    _surface.reflective *= _surface.fresnel;
#endif
    
    //
    // MARK: Lighting
    //
    
    SCNShaderLightingContribution _lightingContribution(_surface, in);

    _lightingContribution.ambient = scn_frame.ambientLightingColor.rgb;


    _lightingContribution.diffuse = in.diffuse;
    
    //
    // MARK: Fragment shader modifier
    //
    
    if (_output.color.a == 0.) // we could set a different limit here
        discard_fragment();
    
    _output.motionblur.xy = half2((in.mv_fragment.xy / in.mv_fragment.z) - (in.mv_lastFragment.xy / in.mv_lastFragment.z))*half2(1.,-1.) * scn_frame.motionBlurIntensity;
    _output.motionblur.z = length(_output.motionblur.xy);
    _output.motionblur.w = half(-_surface.position.z);

    //_output.normals = half4( half3(_surface.normal.xyz), half(_surface.roughness) );
    _output.color = min(_output.color, float4(160.));

    return _output;
}
*/
