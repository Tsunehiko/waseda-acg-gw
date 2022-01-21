precision mediump float;

#pragma glslify: FSchlick = require('../fschlick.glsl')
#pragma glslify: PI_INV = require('../../const/piinv.glsl')
#pragma glslify: halfVec = require('../../util/halfvec.glsl')
#pragma glslify: nlPlus = require('../../util/nlplus.glsl')

const float eps = 0.000001;

float ndf(vec3 n, vec3 m, float ag2) {
    float nm = dot(n, m);
    // MEMO: 0除算回避している
    return step(0.0, nm) * ag2 * PI_INV / (pow(abs(1.0 + nm * nm * (ag2 - 1.0)), 2.0) + eps);
}

vec3 brdfSpecGGX(vec3 l, vec3 v, vec3 n, vec3 F0, float rg) {
    // 参考：教科書p.341 式9.43
    float ag2 = pow(rg, 4.0);

    vec3 h = halfVec(l, v);

    vec3 F = FSchlick(n, l, F0);
    float D = ndf(n, h, ag2);

    float muI = nlPlus(n, l);
    float muO = nlPlus(n, v);

    return F * D * 0.5 / (
        muO * sqrt(ag2 + muI * (muI - ag2 * muI))
        + muI * sqrt(ag2 + muO * (muO - ag2 * muO))
        + eps  // MEMO: 0除算回避
    );
}

#pragma glslify: export(brdfSpecGGX)
