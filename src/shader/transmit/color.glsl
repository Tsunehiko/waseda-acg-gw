precision mediump float;

#pragma glslify: F0ToN = require('../util/f0ton.glsl')
#pragma glslify: FSchlick = require('../util/fschlick.glsl')

vec3 transmittanceVector(vec3 extinct, float d) { return exp(-extinct * d); }

vec3 translucentColor(vec3 cs, vec3 cb, vec3 extinct, float d, float coverage) {
    return mix(cb, cs + transmittanceVector(extinct, d) * cb, coverage);
}

vec3 transmitColor(
    vec3 n, vec3 reflectDir, vec3 clight, vec3 albedo, vec3 F0, vec3 extinct, float d, float coverage
) {
    vec3 F = FSchlick(n, reflectDir, F0);
    vec3 energyCoef = (1.0 - F) / pow(F0ToN(F0), vec3(2));
    return energyCoef * translucentColor(albedo, clight, extinct, d, coverage);
}

#pragma glslify: export(transmitColor)
