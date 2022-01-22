#pragma glslify: G1GGX = require('./ggx/g1.glsl')

float G1(vec3 V, vec3 n, vec3 m, float rg) { return G1GGX(V, n, m, pow(rg, 4.0)); }

#pragma glslify: export(G1)
