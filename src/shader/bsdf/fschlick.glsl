precision mediump float;

#pragma glslify: nlPlus = require('../util/nlplus.glsl')

vec3 FSchlick(vec3 n, vec3 l, vec3 F0) { return F0 + (1.0 - F0) * pow(1.0 - nlPlus(n, l), 5.0); }

vec3 FSchlick(vec3 n, vec3 l, float F0) { return FSchlick(n, l, vec3(F0)); }

vec3 FSchlick(vec3 n, vec3 l, float n1, float n2) {
    return FSchlick(n, l, pow(abs((n1 - n2) / (n1 + n2)), 2.0));
}

#pragma glslify: export(FSchlick)
