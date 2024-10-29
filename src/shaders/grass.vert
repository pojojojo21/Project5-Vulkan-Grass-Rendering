
#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 1, binding = 0) uniform ModelBufferObject {
    mat4 model;
};

// TODO: Declare vertex shader inputs and outputs
layout(location = 0) in vec4 vs_v0;
layout(location = 1) in vec4 vs_v1;
layout(location = 2) in vec4 vs_v2;
layout(location = 3) in vec4 vs_up;

// v0 is gl_Position
layout(location = 0) out vec4 tcs_v1;
layout(location = 1) out vec4 tcs_v2;
layout(location = 2) out vec4 tcs_up;

out gl_PerVertex {
    vec4 gl_Position;
};

void main() {
	// TODO: Write gl_Position and any other shader outputs
    gl_Position = vec4(vec3(model * vec4(vs_v0.xyz, 1.0f)), vs_v0.w);
    tcs_v1 = vec4(vec3(model * vec4(vs_v1.xyz, 1.0f)), vs_v1.w);
    tcs_v2 = vec4(vec3(model * vec4(vs_v2.xyz, 1.0f)), vs_v2.w);
    tcs_up = vec4(vec3(model * vec4(vs_up.xyz, 1.0f)), vs_up.w);
}
