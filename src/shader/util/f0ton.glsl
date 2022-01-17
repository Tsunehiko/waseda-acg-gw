precision mediump float;

vec3 F0ToN(vec3 F0) { return (1.0 - F0) / (1.0 + F0 + 2.0 * sqrt(F0)); }

#pragma glslify: export(F0ToN)
