#version 300 es
precision mediump float;
precision mediump usampler2D;

out vec4 colorOut;
uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;
uniform uint seed;
uniform usampler2D u_texture;

#pragma glslify: FSchlick = require('./bsdf/fschlick.glsl')
#pragma glslify: G1 = require('./bsdf/g1.glsl')
#pragma glslify: sampleM = require('./bsdf/samplem.glsl')
#pragma glslify: cameraRay = require('./camera/cameraray.glsl')
#pragma glslify: makeCamera = require('./camera/make.glsl')
#pragma glslify: Camera = require('./camera/struct.glsl')
#pragma glslify: Hit = require('./hit/struct.glsl')
#pragma glslify: Ray = require('./ray/struct.glsl')
#pragma glslify: hitScene = require('./scene/hit.glsl')
#pragma glslify: gammaCorrect = require('./util/gammacorrect.glsl')
#pragma glslify: nlPlus = require('./util/nlplus.glsl')

const float eps = 0.0001;
const int maxHitNum = 10;
const int sampleNum = 20;

// HACK: なんか別ファイルに定義するとsyntax errorで動かないのでここにrand関係を書く
struct RandState { uint x; };

uint xorShift32(inout RandState randState) {
    uint x = randState.x;
    x ^= x << 13u;
    x ^= x >> 17u;
    x ^= x << 5u;
    randState.x = x;
    return x;
}

float random(inout RandState randState) { return float(xorShift32(randState)) / 4294967296.0; }

vec3 sampleColor(Ray ray, inout RandState randState) {
    // 一定回数反射する・反射しなくなる・光源に当たるまでカメラからrayを飛ばす
    Ray nowRay = ray;
    vec3 coef = vec3(1);
    for (int i = 0; i < maxHitNum; i++) {
        Hit hit = hitScene(nowRay);
        if (!hit.check) break;
        if (hit.param.isLight) return coef * hit.param.clight;

        vec3 v = -nowRay.dir;
        bool goOut = dot(hit.normal, v) < 0.0;
        vec3 n = goOut ? -hit.normal : hit.normal;
        vec3 m = sampleM(n, hit.param.rg, random(randState), random(randState));

        // 反射させるか屈折させるかを決定する
        bool doRefract = false;
        float F = 1.0;
        vec3 refractDir;
        if (hit.param.canTransmit) {
            float n1 = ray.ior;
            float n2 = hit.param.ior;

            refractDir = refract(-v, n, n1 / n2);
            if (length(refractDir) > eps) {  // 全反射しない場合
                F = FSchlick(v, m, n1, n2);
                doRefract = random(randState) > F;
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
        coef *= hit.param.albedo * G1(l, n, m, hit.param.rg);
        nowRay.origin = hit.pos;
        nowRay.dir = l;
    }

    // ヒットしなかったら黒
    return vec3(0);
}

vec3 calcColor(Ray ray, inout RandState randState) {
    vec3 color = vec3(0);
    for (int i = 0; i < sampleNum; i++) color += sampleColor(ray, randState);
    return color / float(sampleNum);
}

void main() {
    RandState randState = RandState(texture(u_texture, gl_FragCoord.xy / resolution)[0]);

    Camera camera = makeCamera();
    Ray ray = cameraRay(camera, 2.0 * gl_FragCoord.xy / resolution - 1.0);
    vec3 color = calcColor(ray, randState);
    colorOut = vec4(gammaCorrect(color), 1);
}
