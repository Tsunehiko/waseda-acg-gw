precision mediump float;

float sdPlane(vec3 p, vec4 n) { return dot(p, n.xyz) + n.w; }

#pragma glslify: export(sdPlane)
