precision mediump float;

#pragma glslify: brdfDiffHammon = require('./hammon.glsl')

vec3 brdfDiff(vec3 l, vec3 v, vec3 n, vec3 F0, float rg, vec3 albedo) {
    return brdfDiffHammon(l, v, n, F0, rg, albedo);
}

#pragma glslify: export(brdfDiff)
