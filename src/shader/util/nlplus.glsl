precision mediump float;

float nlPlus(vec3 n, vec3 l) { return max(dot(n, l), 0.0); }

#pragma glslify: export(nlPlus)
