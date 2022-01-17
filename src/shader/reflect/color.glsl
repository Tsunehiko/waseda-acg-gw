precision mediump float;

#pragma glslify: brdfGGX = require('./brdf/ggx.glsl')
#pragma glslify: pointLight = require('../light/pointlight.glsl')

vec3 reflectColor(vec3 l, vec3 v, vec3 n, vec3 clight, vec3 albedo, vec3 F0, float roughness) {
    vec3 brdfVal = brdfGGX(l, v, n, albedo, F0, roughness);
    return pointLight(n, l, brdfVal, clight);
}

#pragma glslify: export(reflectColor)
