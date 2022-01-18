precision mediump float;

#pragma glslify: brdfSpec = require('./specular/brdf.glsl')
#pragma glslify: brdfDiff = require('./diffuse/brdf.glsl')

vec3 brdf(vec3 l, vec3 v, vec3 n, vec3 F0, float rg, vec3 albedo) {
    vec3 fspec = brdfSpec(l, v, n, F0, rg);
    vec3 fdiff = brdfDiff(l, v, n, F0, rg, albedo);
    return fspec + fdiff;  // TODO: fdiffに何か係数をかける必要はある？
}

#pragma glslify: export(brdf)
