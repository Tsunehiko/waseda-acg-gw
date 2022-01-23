precision mediump float;

#pragma glslify: scene = require('../scene/sdf.glsl')

const float intensity = 0.05;
const float stepSize = 0.03;
const int maxIter = 18;

// distance fielf ambient occlusion
float DFAO(vec3 p, vec3 n) {
    float ao = 0.0;
    for (int i = 0; i < maxIter; i++){
        float dist = stepSize * float(i);
        vec3 checkpoint = p + n * dist;
        ao += max((dist - scene(checkpoint)) / dist, 0.0);  // TODO: i=0のとき0除算になるはず
    }

    return clamp(1.0 - ao * intensity, 0.0, 1.0);
}

#pragma glslify: export(DFAO)
