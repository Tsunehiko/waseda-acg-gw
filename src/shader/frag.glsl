#version 300 es
precision mediump float;

out vec4 colorOut;
uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;

#pragma glslify: G1 = require('./bsdf/g1.glsl')
#pragma glslify: sampleM = require('./bsdf/samplem.glsl')
#pragma glslify: cameraRay = require('./camera/cameraray.glsl')
#pragma glslify: makeCamera = require('./camera/make.glsl')
#pragma glslify: Camera = require('./camera/struct.glsl')
#pragma glslify: Hit = require('./hit/struct.glsl')
#pragma glslify: Ray = require('./ray/struct.glsl')
#pragma glslify: hitScene = require('./scene/hit.glsl')
#pragma glslify: gammaCorrect = require('./util/gammacorrect.glsl')

const int maxHitNum = 2;
const int sampleNum = 2;

vec3 sampleColor(Ray ray, vec3 seed) {
    // 一定回数反射する・反射しなくなる・光源に当たるまでカメラからrayを飛ばす
    Ray nowRay = ray;
    vec3 coef = vec3(1);
    for (int i = 0; i < maxHitNum; i++) {
        Hit hit = hitScene(nowRay);
        if (!hit.check) break;
        if (hit.param.isLight) return coef * hit.param.clight;

        vec3 v = -nowRay.dir;
        vec3 n = hit.normal;
        vec3 m = sampleM(n, seed);
        vec3 l = reflect(-v, m);

        float G1Val = G1(l, n, m, hit.param.rg);

        coef *= hit.param.albedo * G1Val;
        nowRay = Ray(hit.pos, l);
    }

    // ヒットしなかったら黒
    return vec3(0);
}

vec3 calcColor(Ray ray) {
    vec3 color = vec3(0);
    for (int i = 0; i < sampleNum; i++) color += sampleColor(ray, vec3(gl_FragCoord.xy, i));
    return color / float(sampleNum);
}

void main() {
    Camera camera = makeCamera();
    Ray ray = cameraRay(camera, 2.0 * gl_FragCoord.xy / resolution - 1.0);
    vec3 color = calcColor(ray);
    colorOut = vec4(gammaCorrect(color), 1);
}
