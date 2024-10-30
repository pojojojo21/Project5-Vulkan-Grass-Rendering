#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare fragment shader inputs
layout(location = 0) in vec3 fs_pos;
layout(location = 1) in vec3 fs_nor;
layout(location = 2) in vec2 fs_uv;
layout(location = 3) in float fs_teslevel;

layout(location = 0) out vec4 outColor;

vec3 pos_light = vec3(20, 20, 5);

void main() {
    // Compute lighting (Lambertian shading)
    vec3 light_Dir = normalize(fs_pos - pos_light);
    float diffuseTerm = clamp(dot(light_Dir, fs_nor), 0.0f, 1.0f);
    float ambientTerm = 0.2;
    float lightIntensity = diffuseTerm + ambientTerm;

     // Adjust color based on height
    float minHeight = 0.0; // Minimum expected height of the grass
    float maxHeight = 2.0; // Maximum expected height of the grass
    float heightFactor = clamp((fs_pos.y - minHeight) / (maxHeight - minHeight), 0.0, 1.0);
    
    // Set base green color and adjust brightness by heightFactor
    vec3 baseColor = vec3(0.0, 0.6, 0.0); // Base green color for grass
    vec3 heightAdjustedColor = mix(baseColor * 0.8, baseColor * 1.2, heightFactor); // Darker at low height, lighter at high

    //outColor = vec4(fs_pos, 1.0f);
    //outColor = vec4(vec3(diffuseTerm), 1.0f);
    //outColor = vec4(fs_nor, 1.0f);
    //outColor = vec4((fs_teslevel - 1.f) / 7.f);
    //outColor = vec4(0.0, lightIntensity, 0.0, 1.0);

    // Final output color with lighting applied
    outColor = vec4(heightAdjustedColor * lightIntensity, 1.0f);
}
