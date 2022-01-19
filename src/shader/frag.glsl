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
#pragma glslify: Hit = require('./hit/struct.glsl')
#pragma glslify: objReflectColor = require('./obj/reflect.glsl')
#pragma glslify: objTransmitColor = require('./obj/transmit.glsl')
#pragma glslify: Ray = require('./ray/struct.glsl')
#pragma glslify: hitScene = require('./scene/hit.glsl')

const vec3 lightPos = vec3(1, 1, 1);
const vec3 clight = vec3(1);

// NOTE: とりあえず適当に書いてある（後で処理全体を書き直すため）
vec3 calcColor(Ray ray) {
    Hit hit = hitScene(ray);

    if (!hit.check) return skyColor();

    vec3 v = -ray.dir;

    // 光線が背景にヒット
    const float eps = 0.0001;
    if (abs(sdBg(hit.pos)) < eps) return bgColor(hit.pos, v, lightPos, clight);

    // 光線がオブジェクトにヒット後，反射
    // NOTE: 添字の1は反射を表す（2は屈折）
    vec3 c1 = objReflectColor(hit.pos, v, lightPos, clight);

    // 光線がオブジェクトにヒット後，屈折
    vec3 c2 = objTransmitColor(hit.pos, v, lightPos, clight);

    return c1 + c2;
}

void main() {
    Camera camera = makeCamera();
    Ray ray = cameraRay(camera, 2.0 * gl_FragCoord.xy / resolution - 1.0);
    vec3 color = calcColor(ray);
    colorOut = vec4(color, 1);
}
