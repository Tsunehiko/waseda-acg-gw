precision mediump float;

#pragma glslify: sdBg = require('./sdf.glsl')
#pragma glslify: floorColor = require('./floor/color.glsl')
#pragma glslify: skyColor = require('./sky/color.glsl')
#pragma glslify: end = require('../ray/end.glsl')
#pragma glslify: Ray = require('../ray/struct.glsl')

const float nearLen = 0.0;
const float farLen = 5.0;
const int maxStep = 256;
const float eps = 0.0001;

vec3 bgColor(vec3 p, vec3 v, vec3 lightPos, vec3 clight) { return floorColor(p, v, lightPos, clight); }

vec3 bgColor(Ray ray, vec3 lightPos, vec3 clight) {
    float t = nearLen;
    float h;
    bool isSky = true;
    for (int i = 0; i < maxStep; i++, t += h) {
        // 遠点まで光線がヒットせず
        if (t > farLen) break;

        // 光線の終点とそこでの符号距離を求める
        vec3 rayEnd = end(ray, t);
        h = sdBg(rayEnd);

        // 光線が背景にヒット
        if (abs(h) < eps) {
            isSky = false;
            break;
        }
    }

    // 光線がヒットしなかったので空と判定
    if (isSky) return skyColor();

    // 光線がヒットした点の床の色
    return bgColor(end(ray, t), -ray.dir, lightPos, clight);
}

#pragma glslify: export(bgColor)
