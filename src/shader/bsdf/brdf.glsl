precision mediump float;

#pragma glslify: FSchlick = require('./fschlick.glsl')
#pragma glslify: gafOverDotGGX = require('./ggx/gaf.glsl')
#pragma glslify: ndfGGX = require('./ggx/ndf.glsl')
#pragma glslify: PI = require('../const/pi.glsl')
#pragma glslify: halfVec = require('../util/halfvec.glsl')

vec3 brdfSpec(vec3 l, vec3 v, vec3 n, vec3 F0, float rg) {
    float ag = rg * rg;
    float ag2 = ag * ag;

    //vec3 h = halfVec(l, v);
    vec3 h = sign(dot(l, n)) * halfVec(l, v);  // TODO: sign項は必要？

    vec3 F = FSchlick(h, l, F0);
    float D = ndfGGX(n, h, ag2);
    float GOverDot = gafOverDotGGX(l, v, h, ag2);

    return F * D * GOverDot * 0.25;
}

vec3 brdfDiff(vec3 l, vec3 v, vec3 n, vec3 F0, float rg, vec3 albedo) {
    return albedo / PI;
}

vec3 brdf(vec3 l, vec3 v, vec3 n, vec3 F0, float rg, vec3 albedo) {
    vec3 fspec = brdfSpec(l, v, n, F0, rg);
    vec3 fdiff = brdfDiff(l, v, n, F0, rg, albedo);
    vec3 F = FSchlick(n, l, F0);
    return fspec + (1.0 - F) * fdiff;  // TODO: BTDFも考慮する場合はfdiffは本当に必要？
}

#pragma glslify: export(brdf)
