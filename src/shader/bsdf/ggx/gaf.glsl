precision mediump float;

#pragma glslify: nlPlus = require('../../util/nlplus.glsl')

const float eps = 0.000001;

float gafOverDotGGX(vec3 l, vec3 v, vec3 n, float ag2) {
    // GではなくG / (|<n, l>| * |<n, v>|)を返す
    // 参考：教科書p.341 式9.43

    float muI = nlPlus(n, l);
    float muO = nlPlus(n, v);

    return 2.0 / (
        muO * sqrt(ag2 + muI * (muI - ag2 * muI))
        + muI * sqrt(ag2 + muO * (muO - ag2 * muO))
        + eps  // MEMO: 0除算回避
    );
}

#pragma glslify: export(gafOverDotGGX)
