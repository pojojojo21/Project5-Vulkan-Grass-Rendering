#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(vertices = 1) out;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare tessellation control shader inputs and outputs
in gl_PerVertex
{
    vec4 gl_Position;
} gl_in[gl_MaxPatchVertices];

layout(location = 0) in vec4 tcs_v1[];
layout(location = 1) in vec4 tcs_v2[];
layout(location = 2) in vec4 tcs_up[];

layout(location = 0) out vec4 tes_v1[];
layout(location = 1) out vec4 tes_v2[];
layout(location = 2) out vec4 tes_up[];
layout(location = 3) out float tes_teslevel[];

void main() {
	// Don't move the origin location of the patch
    gl_out[gl_InvocationID].gl_Position = gl_in[gl_InvocationID].gl_Position;

	// TODO: Write any shader outputs
    tes_v1[gl_InvocationID] = tcs_v1[gl_InvocationID];
    tes_v2[gl_InvocationID] = tcs_v2[gl_InvocationID];
    tes_up[gl_InvocationID] = tcs_up[gl_InvocationID];

	// Extract camera position from view matrix (assuming the camera's position is in the fourth column)
    vec3 cam_pos = vec3(camera.view * vec4(gl_out[gl_InvocationID].gl_Position.xyz, 1.0f));

    // Calculate the distance between the patch and the camera
    float distance = length(cam_pos);

    // Set tessellation level based on distance
    float maxTessLevel = 8.0;
    float minTessLevel = 1.0;
    float thresholdNear = 5.0;  // Distance at which tessellation level is highest
    float thresholdFar = 40.0;  // Distance at which tessellation level is lowest

    // Interpolate tessellation level based on distance
    float tessLevel = mix(maxTessLevel, minTessLevel, clamp((distance - thresholdNear) / (thresholdFar - thresholdNear), 0.0, 1.0));
    
    tes_teslevel[gl_InvocationID] = tessLevel;
    
    // Assign calculated tessellation levels
    gl_TessLevelInner[0] = tessLevel;
    gl_TessLevelInner[1] = tessLevel;
    gl_TessLevelOuter[0] = tessLevel;
    gl_TessLevelOuter[1] = tessLevel;
    gl_TessLevelOuter[2] = tessLevel;
    gl_TessLevelOuter[3] = tessLevel;
}
