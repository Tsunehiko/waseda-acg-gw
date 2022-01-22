precision mediump float;

#pragma glslify: brdf = require('./brdf.glsl')
#pragma glslify: btdf = require('./btdf.glsl')

vec3 bsdf(vec3 l, vec3 v, vec3 n, vec3 F0, float rg, vec3 albedo, float n1, float n2) {
    return brdf(l, v, n, F0, rg, albedo) + btdf(l, v, n, rg, n1, n2);
}

#pragma glslify: export(bsdf)
