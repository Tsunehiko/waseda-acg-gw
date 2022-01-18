precision mediump float;

#pragma glslify: brdfSpecGGX = require('./ggx.glsl')

vec3 brdfSpec(vec3 l, vec3 v, vec3 n, vec3 F0, float rg) { return brdfSpecGGX(l, v, n, F0, rg); }

#pragma glslify: export(brdfSpec)
