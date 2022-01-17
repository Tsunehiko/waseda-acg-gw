precision mediump float;

vec3 NToF0(vec3 N) { return pow((N - 1.0) / (N + 1.0), vec3(2)); }

#pragma glslify: export(NToF0)
