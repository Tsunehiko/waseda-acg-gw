precision mediump float;

#pragma glslify: nlPlus = require('../util/nlplus.glsl')

vec3 FSchlick(vec3 n, vec3 l, vec3 F0) { return F0 + (1.0 - F0) * pow(1.0 - nlPlus(n, l), 5.0); }

#pragma glslify: export(FSchlick)
