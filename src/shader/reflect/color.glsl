precision mediump float;

#pragma glslify: brdf = require('./brdf.glsl')
#pragma glslify: pointLight = require('../light/pointlight.glsl')

vec3 reflectColor(vec3 l, vec3 v, vec3 n, vec3 clight, vec3 albedo, vec3 F0, float rg) {
    vec3 brdfVal = brdf(l, v, n, F0, rg, albedo);
    return pointLight(n, l, brdfVal, clight);
}

#pragma glslify: export(reflectColor)
