precision mediump float;

vec3 halfVec(vec3 u, vec3 v) { return normalize(u + v); }

#pragma glslify: export(halfVec)
