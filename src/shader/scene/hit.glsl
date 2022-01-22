precision mediump float;

#pragma glslify: getParam = require('./getparam.glsl')
#pragma glslify: normal = require('./normal.glsl')
#pragma glslify: scene = require('./sdf.glsl')
#pragma glslify: Hit = require('../hit/struct.glsl')
#pragma glslify: notHit = require('../hit/not.glsl')
#pragma glslify: dummyParam = require('../param/dummy.glsl')
#pragma glslify: end = require('../ray/end.glsl')
#pragma glslify: Ray = require('../ray/struct.glsl')

const float nearLen = 0.01;  // MEMO: epsよりは大きくする
const float farLen = 5.0;
const int maxStep = 256;
const float eps = 0.0001;

Hit hitScene(Ray ray) {
    float t = nearLen;
    float h;
    for (int i = 0; i < maxStep; i++, t += abs(h)) {
        // 遠点まで光線がヒットせず
        if (t > farLen) break;

        // 光線の終点とそこでの符号距離を求める
        vec3 rayEnd = end(ray, t);
        h = scene(rayEnd);

        // 光線がヒットした
        if (abs(h) < eps) return Hit(true, rayEnd, normal(rayEnd), getParam(rayEnd, eps));
    }

    // 光線がヒットしなかった
    return notHit;
}

#pragma glslify: export(hitScene)
