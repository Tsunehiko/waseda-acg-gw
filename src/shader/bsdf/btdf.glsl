precision mediump float;

#pragma glslify: FSchlick = require('./fschlick.glsl')
#pragma glslify: gafOverDotGGX = require('./ggx/gaf.glsl')
#pragma glslify: ndfGGX = require('./ggx/ndf.glsl')

const float eps = 0.000001;

float btdf(vec3 l, vec3 v, vec3 n, float rg, float n1, float n2) {
    float ag = rg * rg;
    float ag2 = ag * ag;

    vec3 h = -normalize(n1 * l + n2 * v);

    float F = FSchlick(h, l, n1, n2);
    float D = ndfGGX(h);
    float GOverDot = gafOverDotGGX(l, v, h, ag2);

    float lh = dot(l, h);
    float vh = dot(v, h);

    // MEMO: 0除算回避
    return abs(lh * vh) * n2 * n2 * (1.0 - F) * D * GOverDot / (pow(n1 * lh + n2 * vh, 2.0) + eps);
}

#pragma glslify: export(btdf)
