// Input to the shader. The length of the array is determined by what buffer is bound.
//
// Out of bounds accesses 
layout(set = 0, binding = 0) readonly buffer inputs {
    float input[];
};
// Output of the shader.  
layout(set = 0, binding = 1) buffer outputs {
    float output[];
};

layout (local_size_x = 64, local_size_y = 1, local_size_z = 1) in;

// Ideal workgroup size depends on the hardware, the workload, and other factors. However, it should
// _generally_ be a multiple of 64. Common sizes are 64x1x1, 256x1x1; or 8x8x1, 16x16x1 for 2D workloads.
void main() {
    // While compute invocations are 3d, we're only using one dimension.
    uint index = gl_GlobalInvocationID.x;

    // Because we're using a workgroup size of 64, if the input size isn't a multiple of 64,
    // we will have some "extra" invocations. This is fine, but we should tell them to stop
    // to avoid out-of-bounds accesses.
    uint array_length = input.length();
    if (index >= array_length) {
        return;
    }

    // Do the multiply by two and write to the output.
    output[index] = input[index] * 2.0;
}