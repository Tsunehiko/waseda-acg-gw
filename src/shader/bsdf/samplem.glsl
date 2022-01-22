precision mediump float;

#pragma glslify: sampleMGGX = require('./ggx/samplem.glsl')

vec3 sampleM(vec3 n, vec3 seed) { return sampleMGGX(n, seed); }

#pragma glslify: export(sampleM)
