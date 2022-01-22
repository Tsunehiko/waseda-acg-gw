precision mediump float;

#pragma glslify: sampleMGGX = require('./ggx/samplem.glsl')

vec3 sampleM(vec3 n, float u1, float u2) { return sampleMGGX(n, u1, u2); }

#pragma glslify: export(sampleM)
