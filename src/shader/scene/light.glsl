precision mediump float;

#pragma glslify: albedo = require('./albedo.glsl')
#pragma glslify: normal = require('./normal.glsl')
#pragma glslify: getParam = require('./param.glsl')
#pragma glslify: Hit = require('../hit/struct.glsl')
#pragma glslify: dummyHit = require('../hit/dummy.glsl')
#pragma glslify: dummyParam = require('../param/dummy.glsl')
#pragma glslify: Param = require('../param/struct.glsl')
#pragma glslify: end = require('../ray/end.glsl')
#pragma glslify: Ray = require('../ray/struct.glsl')
#pragma glslify: sdLight = require('../sdf/light.glsl')

const float nearLen = 0.1;  // MEMO: epsよりは大きくする
const float farLen = 5.0;
const int maxStep = 256;
const float eps = 0.0001;

Hit hitLight(Ray ray) {
    float t = nearLen;
    float h;
    for (int i = 0; i < maxStep; i++, t += h) {
        // 遠点まで光線がヒットせず
        if (t > farLen) break;

        // 光線の終点とそこでの符号距離を求める
        vec3 rayEnd = end(ray, t);
        h = sdLight(rayEnd);

        // 光線がヒットした
        // normalとparamは適当
        if (abs(h) < eps) return Hit(true, rayEnd, vec3(0), dummyParam);
    }

    // 光線がヒットしなかった
    return dummyHit;
}

#pragma glslify: export(hitLight)
