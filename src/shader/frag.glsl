#version 300 es
precision mediump float;

out vec4 colorOut;
uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;

#pragma glslify: skyColor = require('./bg/sky/color.glsl')
#pragma glslify: cameraRay = require('./camera/cameraray.glsl')
#pragma glslify: makeCamera = require('./camera/make.glsl')
#pragma glslify: Camera = require('./camera/struct.glsl')
#pragma glslify: PI = require('./const/pi.glsl')
#pragma glslify: Hit = require('./hit/struct.glsl')
#pragma glslify: pointLight = require('./light/pointlight.glsl')
#pragma glslify: Ray = require('./ray/struct.glsl')
#pragma glslify: brdf = require('./reflect/brdf.glsl')
#pragma glslify: hitScene = require('./scene/hit.glsl')
#pragma glslify: hitLight = require('./scene/light.glsl')
#pragma glslify: gammaCorrect = require('./util/gammacorrect.glsl')
#pragma glslify: orthToSphere = require('./util/orthtosphere.glsl')
#pragma glslify: rand2 = require('./util/rand2.glsl')
#pragma glslify: sphereToOrth = require('./util/spheretoorth.glsl')

const vec3 lightPos = vec3(2, 2, 2);
const vec3 clight = vec3(1);
const int maxHitNum = 12;
const int sampleNum = 1;

// 球面からサンプル
vec3 randomReflectDir(vec3 n) {
    vec2 random = rand2(gl_FragCoord.xy);
    float randTheta = random[0] * PI;
    float randPhi = random[1] * 2.0 * PI;
    return sphereToOrth(vec3(1, randTheta, randPhi));
}

// 半球面からcosで重み付けしてサンプル
vec3 sampleReflectDirWithCos(vec3 n) {
    vec2 random = rand2(gl_FragCoord.xy);
    float u1 = random[0];
    float u2 = random[1];
    return vec3(
        sqrt(u2) * cos(2.0 * PI * u1),
        sqrt(u2) * sin(2.0 * PI * u1),
        sqrt(1.0 - u2)
    );
}

vec3 sampleColor(Ray ray) {
    // 一定回数反射するか反射しなくなるまでカメラからrayを飛ばす
    Ray nowRay = ray;
    Hit hitList[maxHitNum];
    int hitNum;
    for (hitNum = 0; hitNum < maxHitNum; hitNum++) {
        Hit hit = hitScene(nowRay);
        hitList[hitNum] = hit;

        if (!hit.check) break;

        // 単位半球面からランダムに選んだ方向に反射させる
        vec3 reflectDir = sampleReflectDirWithCos(hit.normal);
        nowRay = Ray(hit.pos, reflectDir);
    }

    // 1回もヒットしなかったら空と判定
    if (hitNum == 0) return skyColor();

    // カメラからの光線を逆にたどりながら光源から光線を飛ばす
    // 全ての反射において点光源として計算
    Hit lightHit = hitLight(nowRay);
    if (!lightHit.check) return vec3(0);
    vec3 color = clight;
    //if(!lightHit.check) color = skyColor();
    for (int i = hitNum - 1; i >= 0; i--) {
        Hit hit = hitList[i];

        vec3 l = (i == hitNum - 1) ? nowRay.dir : hitList[i + 1].pos - hit.pos;

        vec3 vEnd = (i == 0) ? ray.origin : hitList[i - 1].pos;
        vec3 v = normalize(vEnd - hit.pos);

        color = pointLight(l, v, color, hit);
    }

    return color;
}

vec3 calcColor(Ray ray) {
    vec3 color = vec3(0);
    for (int i = 0; i < sampleNum; i++) color += sampleColor(ray);
    return color / float(sampleNum);
}

void main() {
    Camera camera = makeCamera();
    Ray ray = cameraRay(camera, 2.0 * gl_FragCoord.xy / resolution - 1.0);
    vec3 color = calcColor(ray);
    colorOut = vec4(gammaCorrect(color), 1);
}
