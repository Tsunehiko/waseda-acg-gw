precision mediump float;

#pragma glslify: PI_INV = require('../../const/piinv.glsl')

const float eps = 0.000001;

float ndfGGX(vec3 n, vec3 m, float ag2) {
    float nm = dot(n, m);
    // MEMO: 0除算回避している
    return step(0.0, nm) * ag2 * PI_INV / (pow(1.0 + nm * nm * (ag2 - 1.0), 2.0) + eps);
}

#pragma glslify: export(ndfGGX)
