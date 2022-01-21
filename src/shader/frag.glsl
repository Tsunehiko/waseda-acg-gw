#version 300 es
precision mediump float;

out vec4 colorOut;
uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;

#pragma glslify: skyColor = require('./scene/sky.glsl')
#pragma glslify: cameraRay = require('./camera/cameraray.glsl')
#pragma glslify: makeCamera = require('./camera/make.glsl')
#pragma glslify: Camera = require('./camera/struct.glsl')
#pragma glslify: PI = require('./const/pi.glsl')
#pragma glslify: Hit = require('./hit/struct.glsl')
#pragma glslify: pointLight = require('./light/pointlight.glsl')
#pragma glslify: Ray = require('./ray/struct.glsl')
#pragma glslify: hitScene = require('./scene/hit.glsl')
#pragma glslify: gammaCorrect = require('./util/gammacorrect.glsl')
#pragma glslify: rand3 = require('./util/rand3.glsl')
#pragma glslify: rotate = require('./util/rotate.glsl')

const float eps = 0.000001;
const int maxHitNum = 2;
const int sampleNum = 12;

vec3 sampleReflectDirWithCos(vec3 n, float seed) {
    // pをサンプリング
    // pはnを+yとした座標系における座標を持つ
    // 半球面からcosで重み付けしてサンプリング
    vec3 random = rand3(vec3(gl_FragCoord.xy, seed));
    float u1 = 1.0 - (random[0] + random[1]) / 2.0;
    float u2 = 1.0 - (random[1] + random[2]) / 2.0;
    vec3 p = vec3(
        sqrt(u2) * cos(2.0 * PI * u1),
        sqrt(u2) * sin(2.0 * PI * u1),
        sqrt(1.0 - u2)
    );

    // pを元の座標に戻す
    // nから(0, 1, 0)への回転をpに施す
    float cosThetaN = dot(n, vec3(0, 1, 0));
    if (abs(cosThetaN) > 1.0 - eps) return sign(cosThetaN) * p;  // MEMO: nと(0, 1, 0)が平行な場合は場合分けが必要
    vec3 axis = cross(n, vec3(0, 1, 0));
    return rotate(p, axis, cosThetaN);
}

vec3 sampleColor(Ray ray, int sampleIdx) {
    // 一定回数反射する・反射しなくなる・光源に当たるまでカメラからrayを飛ばす
    Ray nowRay = ray;
    Hit hitList[maxHitNum];
    int hitNum;
    for (hitNum = 0; hitNum < maxHitNum; hitNum++) {
        Hit hit = hitScene(nowRay);
        hitList[hitNum] = hit;

        if (!hit.check) break;
        if (hit.param.isLight) {
            hitNum++;
            break;
        }

        // 単位半球面からランダムに選んだ方向に反射させる
        vec3 reflectDir = sampleReflectDirWithCos(hit.normal, pow(float(sampleIdx), 2.0));
        nowRay = Ray(hit.pos, reflectDir);
    }

    // 1回もヒットしなかったら空と判定
    if (hitNum == 0) return skyColor();
    // 光源にヒットしなかったら黒
    if (!hitList[hitNum - 1].param.isLight) return vec3(0);

    // カメラからの光線を逆にたどりながら光源から光線を飛ばす
    // 全ての反射において点光源として計算
    vec3 color = hitList[hitNum - 1].param.clight;
    for (int i = hitNum - 2; i >= 0; i--) {
        Hit hit = hitList[i];

        vec3 l = hitList[i + 1].pos - hit.pos;

        vec3 vEnd = (i == 0) ? ray.origin : hitList[i - 1].pos;
        vec3 v = normalize(vEnd - hit.pos);

        color = pointLight(l, v, color, hit);
    }

    return color;
}

vec3 calcColor(Ray ray) {
    vec3 color = vec3(0);
    for (int i = 0; i < sampleNum; i++) color += sampleColor(ray, i);
    return color / float(sampleNum);
}

void main() {
    Camera camera = makeCamera();
    Ray ray = cameraRay(camera, 2.0 * gl_FragCoord.xy / resolution - 1.0);
    vec3 color = calcColor(ray);
    colorOut = vec4(gammaCorrect(color), 1);
}
