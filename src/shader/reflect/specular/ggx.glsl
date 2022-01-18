precision mediump float;

#pragma glslify: FSchlick = require('../fschlick.glsl')
#pragma glslify: PI = require('../../const/pi.glsl')
#pragma glslify: halfVec = require('../../util/halfvec.glsl')
#pragma glslify: nlPlus = require('../../util/nlplus.glsl')

float ndf(vec3 n, vec3 m, float ag) {
   float nm = dot(n, m);
   return step(0.0, nm) * ag / (PI * pow(1.0 + pow(nm, 2.0) * (ag - 1.0), 2.0));
}

vec3 brdfSpecGGX(vec3 l, vec3 v, vec3 n, vec3 F0, float rg) {
    // 参考：教科書p.341 式9.43
    float ag = pow(rg, 2.0);
    float ag2 = pow(ag, 2.0);

    vec3 h = halfVec(l, v);

    vec3 F = FSchlick(n, l, F0);
    float D = ndf(n, h, ag);

    float muI = nlPlus(n, l);
    float muO = nlPlus(n, v);

    return F * D * 0.5 / (
        muO * sqrt(ag2 + muI * (muI - ag2 * muI))
        + muI * sqrt(ag2 + muO * (muO - ag2 * muO))
    );
}

#pragma glslify: export(brdfSpecGGX)
