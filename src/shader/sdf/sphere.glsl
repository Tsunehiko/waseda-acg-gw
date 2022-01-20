precision mediump float;

float sdSphere(vec3 p, float r) { return length(p) - r; }

#pragma glslify: export(sdSphere)
