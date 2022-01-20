precision mediump float;

#pragma glslify: brdfDiffNormLambert = require('./normlambert.glsl')

vec3 brdfDiff(vec3 l, vec3 v, vec3 n, vec3 F0, float rg, vec3 albedo) {
    return brdfDiffNormLambert(F0, albedo);
}

#pragma glslify: export(brdfDiff)
