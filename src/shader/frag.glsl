#version 300 es
precision mediump float;

out vec4 colorOut;
uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;

#pragma glslify: bgColor = require('./bg/color.glsl')
#pragma glslify: sdBg = require('./bg/sdf.glsl')
#pragma glslify: skyColor = require('./bg/sky/color.glsl')
#pragma glslify: cameraRay = require('./camera/cameraray.glsl')
#pragma glslify: makeCamera = require('./camera/make.glsl')
#pragma glslify: Camera = require('./camera/struct.glsl')
#pragma glslify: objReflectColor = require('./obj/reflect.glsl')
#pragma glslify: objTransmitColor = require('./obj/transmit.glsl')
#pragma glslify: end = require('./ray/end.glsl')
#pragma glslify: Ray = require('./ray/struct.glsl')
#pragma glslify: scene = require('./scene/sdf.glsl')

// raymarch
const float nearLen = 0.0;
const float farLen = 5.0;
const int maxStep = 256;
const float eps = 0.0001;

// light
const vec3 lightPos = vec3(1, 1, 1);
const vec3 clight = vec3(1);

vec3 raymarch(Ray ray) {
    float t = nearLen;
    float h;
    for (int i = 0; i < maxStep; i++, t += h) {
        // 遠点まで光線がヒットせず
        if (t > farLen) break;

        // 光線の終点とそこでの符号距離を求める
        vec3 rayEnd = end(ray, t);
        h = scene(rayEnd);

        // 光線がヒットしなかったら光線を伸ばして次へ
        if (abs(h) > eps) continue;

        vec3 v = -ray.dir;

        // 光線が背景にヒット
        if (abs(sdBg(rayEnd)) < eps) return bgColor(rayEnd, v, lightPos, clight);

        // 光線がオブジェクトにヒット後，反射
        // NOTE: 添字の1は反射を表す（2は屈折）
        vec3 c1 = objReflectColor(rayEnd, v, lightPos, clight);

        // 光線がオブジェクトにヒット後，屈折
        vec3 c2 = objTransmitColor(rayEnd, v, lightPos, clight);

        return c1 + c2;
    }

    // 光線がヒットしなかったので空と判定
    return skyColor();
}

void main() {
    Camera camera = makeCamera();
    Ray ray = cameraRay(camera, 2.0 * gl_FragCoord.xy / resolution - 1.0);
    vec3 color = raymarch(ray);
    colorOut = vec4(color, 1);
}
