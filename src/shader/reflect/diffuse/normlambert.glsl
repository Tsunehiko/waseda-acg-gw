precision mediump float;

#pragma glslify: PI = require('../../const/pi.glsl')
#pragma glslify: halfVec = require('../../util/halfvec.glsl')

vec3 brdfDiffNormLambert(vec3 F0, vec3 albedo) {
    return (1.0 - F0) * albedo / PI;
}

#pragma glslify: export(brdfDiffNormLambert)
