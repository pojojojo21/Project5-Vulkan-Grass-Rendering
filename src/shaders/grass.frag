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

layout(location = 0) out vec4 outColor;

vec3 pos_light = vec3(10, 50, 10);

void main() {
    // TODO: Compute fragment color
    vec3 light_Dir = normalize(fs_pos - pos_light);
    float diffuseTerm = clamp(dot(light_Dir, fs_nor), 0.0f, 1.0f);

    float ambientTerm = 0.2;
    float lightIntensity = diffuseTerm + ambientTerm;

    outColor = vec4(0.0, lightIntensity, 0.0, 1.0);
}
