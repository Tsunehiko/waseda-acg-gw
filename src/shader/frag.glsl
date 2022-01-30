#version 300 es
precision mediump float;

out vec4 colorOut;
uniform vec2 resolution;
uniform float time;
uniform sampler2D caveTexture;

#pragma glslify: DFAO = require('./ao/dfao.glsl')
#pragma glslify: FSchlick = require('./bsdf/fschlick.glsl')
#pragma glslify: G1 = require('./bsdf/g1.glsl')
#pragma glslify: sampleM = require('./bsdf/samplem.glsl')
#pragma glslify: cameraRay = require('./camera/cameraray.glsl')
#pragma glslify: makeCamera = require('./camera/make.glsl')
#pragma glslify: Camera = require('./camera/struct.glsl')
#pragma glslify: Hit = require('./hit/struct.glsl')
#pragma glslify: Ray = require('./ray/struct.glsl')
#pragma glslify: hitScene = require('./scene/hit.glsl')
#pragma glslify: skyColor = require('./scene/sky.glsl')
#pragma glslify: gammaCorrect = require('./util/gammacorrect.glsl')
#pragma glslify: random3 = require('./util/random.glsl')

const int maxHitNum = 8;
const int sampleNum = 20;

vec3 sampleColor(Ray ray, vec3 randoms) {
    // 一定回数反射する・反射しなくなる・光源に当たるまでカメラからrayを飛ばす
    Ray nowRay = ray;
    vec3 coef = vec3(1);
    for (int i = 0; i < maxHitNum; i++) {
        Hit hit = hitScene(nowRay, caveTexture);

        if (!hit.check) return coef * skyColor();
        if (hit.param.isLight) return coef * hit.param.clight;

        vec3 v = -nowRay.dir;
        bool goOut = dot(hit.normal, v) < 0.0;
        vec3 n = goOut ? -hit.normal : hit.normal;
        vec3 m = sampleM(n, hit.param.rg, randoms[0], randoms[1]);

        // 反射させるか屈折させるかを決定する
        bool doRefract = false;
        float F = 1.0;
        vec3 refractDir;
        if (hit.param.canTransmit) {
            float n1 = ray.ior;
            float n2 = hit.param.ior;

            refractDir = refract(-v, n, n1 / n2);
            if (length(refractDir) > 0.5) {  // 全反射しない場合
                F = FSchlick(v, m, n1, n2);
                doRefract = randoms[2] > F;
            }
        }

        // 確率と次の光線を求める
        vec3 l;
        if (doRefract) {
            l = refractDir;
            nowRay.ior = hit.param.ior;
            coef *= 1.0 - F;
        } else {
            l = reflect(-v, m);
            coef *= F;
        }
        coef *= hit.param.albedo * G1(l, n, m, hit.param.rg) * DFAO(hit.pos, hit.normal);
        nowRay.origin = hit.pos;
        nowRay.dir = l;
    }

    // ヒットしなかったら黒
    return vec3(0);
}

vec3 calcColor(Ray ray) {
    // HACK: 配列を渡すのは面倒なのでここで初期s0生成などをやる
    uint s0 = uint(fract(sin(dot(gl_FragCoord.xy, vec2(12.9898, 78.233))) * 43758.5453) * 4294967296.0);
    vec3 randomsAry[sampleNum];
    for (int i = 0; i < sampleNum; i++) randomsAry[i] = random3(s0);

    vec3 color = vec3(0);
    for (int i = 0; i < sampleNum; i++) color += sampleColor(ray, randomsAry[i]);
    return color / float(sampleNum);
}

void main() {
    Camera camera = makeCamera();
    Ray ray = cameraRay(camera, 2.0 * gl_FragCoord.xy / resolution - 1.0);
    vec3 color = calcColor(ray);
    colorOut = vec4(gammaCorrect(color), 1);
}
