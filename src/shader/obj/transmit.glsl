precision mediump float;

#pragma glslify: normalObj = require('./normal.glsl')
#pragma glslify: objColor = require('./param/color.glsl')
#pragma glslify: objF0 = require('./param/f0.glsl')
#pragma glslify: bgColor = require('../bg/color.glsl')
#pragma glslify: Ray = require('../ray/struct.glsl')
#pragma glslify: transmitColor = require('../transmit/color.glsl')
#pragma glslify: F0ToN = require('../util/f0ton.glsl')

const vec3 extinct = vec3(0);
const float coverage = 0.0;

vec3 objTransmitColor(vec3 p, vec3 v, vec3 lightPos, vec3 clight) {
    // とりあえずrefract方向の背景から単に色を持ってくる実装
    // 本来はBTDFを使用すべき
    vec3 n = normalObj(p);
    vec3 refractDir = refract(-v, n, F0ToN(objF0).b);  // とりあえず青のF0値を使う
    vec3 refractColor = bgColor(Ray(p, refractDir), lightPos, clight);

    vec3 reflectDir = reflect(-v, n);
    float d = 0.0;  // とりあえず半透明効果は無視する
    return transmitColor(n, reflectDir, refractColor, objColor, objF0, extinct, d, coverage);
}

#pragma glslify: export(objTransmitColor)
