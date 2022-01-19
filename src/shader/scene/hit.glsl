precision mediump float;

#pragma glslify: albedo = require('./albedo.glsl')
#pragma glslify: normal = require('./normal.glsl')
#pragma glslify: scene = require('./sdf.glsl')
#pragma glslify: Hit = require('../hit/struct.glsl')
#pragma glslify: end = require('../ray/end.glsl')
#pragma glslify: Ray = require('../ray/struct.glsl')

const float nearLen = 0.0;
const float farLen = 5.0;
const int maxStep = 256;
const float eps = 0.0001;

Hit hitScene(Ray ray) {
    float t = nearLen;
    float h;
    for (int i = 0; i < maxStep; i++, t += h) {
        // 遠点まで光線がヒットせず
        if (t > farLen) break;

        // 光線の終点とそこでの符号距離を求める
        vec3 rayEnd = end(ray, t);
        h = scene(rayEnd);

        // 光線がヒットした
        if (abs(h) < eps) return Hit(true, rayEnd, normal(rayEnd), albedo(rayEnd, eps));
    }

    // 光線がヒットしなかった
    return Hit(false, vec3(0), vec3(0), vec3(0));
}

#pragma glslify: export(hitScene)
