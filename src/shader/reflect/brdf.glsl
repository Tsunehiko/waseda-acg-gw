precision mediump float;

#pragma glslify: brdfSpec = require('./specular/brdf.glsl')
#pragma glslify: brdfDiff = require('./diffuse/brdf.glsl')
#pragma glslify: FSchlick = require('./fschlick.glsl')

vec3 brdf(vec3 l, vec3 v, vec3 n, vec3 F0, float rg, vec3 albedo) {
    vec3 fspec = brdfSpec(l, v, n, F0, rg);
    vec3 fdiff = brdfDiff(l, v, n, F0, rg, albedo);
    vec3 F = FSchlick(n, l, F0);
    return fspec + (1.0 - F) * fdiff;  // TODO: (1-F)は必要？
}

#pragma glslify: export(brdf)
