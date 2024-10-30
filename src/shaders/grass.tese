#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(quads, equal_spacing, ccw) in;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare tessellation evaluation shader inputs and outputs
layout(location = 0) in vec4 tes_v1[];
layout(location = 1) in vec4 tes_v2[];
layout(location = 2) in vec4 tes_up[];
layout(location = 3) in float tes_teslevel[];

layout(location = 0) out vec3 fs_pos;
layout(location = 1) out vec3 fs_nor;
layout(location = 2) out vec2 fs_uv;
layout(location = 3) out float fs_teslevel;

void main() {
    float u = gl_TessCoord.x;
    float v = gl_TessCoord.y;

	// TODO: Use u and v to parameterize along the grass blade and output positions for each vertex of the grass blade
    vec3 v0 = gl_in[0].gl_Position.xyz;
    vec3 v1 = tes_v1[0].xyz;
    vec3 v2 = tes_v2[0].xyz;

    float angle = gl_in[0].gl_Position.w;
    float height = tes_v1[0].w;
    float width = tes_v2[0].w;
    float stiffness = tes_up[0].w;

    vec3 a = v0 + v * (v1 - v0);
    vec3 b = v1 + v * (v2 - v1);
    vec3 c = a + v * (b - a);
    vec3 t1 = vec3(cos(angle), 0.0f, sin(angle)); // bitangent
    vec3 c0 = c - width * t1;
    vec3 c1 = c + width * t1;
    vec3 t0 = normalize(b - a);
    vec3 n = normalize(cross(t0,t1));

    // triangle
    // float t = u + 0.5f * v - u * v;

    // quadratic
    float t = u - u * v * v;

    fs_pos = (1 - t) * c0 + t * c1;
    fs_nor = n;
    fs_uv = vec2(u,v);
    fs_teslevel = tes_teslevel[0];

    gl_Position = camera.proj * camera.view * vec4(fs_pos, 1.f);
}
