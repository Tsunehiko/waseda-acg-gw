precision mediump float;

#pragma glslify: nlPlus = require('./nlplus.glsl')

vec3 fresnelSchlick(vec3 n, vec3 l, vec3 F0) { return F0 + (1.0 - F0) * pow(1.0 - nlPlus(n, l), 5.0); }

#pragma glslify: export(fresnelSchlick)
