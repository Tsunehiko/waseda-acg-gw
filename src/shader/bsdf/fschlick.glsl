precision mediump float;

#pragma glslify: nlPlus = require('../util/nlplus.glsl')

float FSchlick(vec3 l, vec3 n, float n1, float n2) {
    float rootF0 = (n1 - n2) / (n1 + n2);
    float F0 = rootF0 * rootF0;
    return F0 + (1.0 - F0) * pow(1.0 - nlPlus(n, l), 5.0);
}

#pragma glslify: export(FSchlick)
