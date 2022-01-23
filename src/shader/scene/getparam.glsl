precision mediump float;

#pragma glslify: bgColor = require('./bg/color.glsl')
#pragma glslify: sdBg = require('./bg/sdf.glsl')
#pragma glslify: sdLight1 = require('./light.glsl')
#pragma glslify: sdBody = require('./obj/bodysdf.glsl')
#pragma glslify: sdEye = require('./obj/eyesdf.glsl')
#pragma glslify: dummyParam = require('../param/dummy.glsl')
#pragma glslify: getLightParam = require('../param/light.glsl')
#pragma glslify: makeParam = require('../param/make.glsl')
#pragma glslify: Param = require('../param/struct.glsl')

int getIdx(vec3 p, float eps) {
    if (sdLight1(p) < eps) return 0;
    if (sdBg(p) < eps) return 1;
    if (sdBody(p) < eps) return 2;
    if (sdEye(p) < eps) return 3;

    return -1;
}

Param getParam(vec3 p, float eps) {
    float ior;
    vec3 rawF0;
    vec3 csurf;
    float rg;
    float metallic;
    bool canTransmit;
    switch (getIdx(p, eps)) {
        // 光源
        case 0:
            return getLightParam(vec3(1));
        // 背景
        case 1:
            ior = 0.0;
            rawF0 = vec3(0.045);  // stone
            csurf = bgColor(p);
            rg = 0.9;
            metallic = 0.0;
            canTransmit = false;
            break;
        // レジアイス（外部）
        case 2:
            ior = 1.31;
            rawF0 = vec3(0.018);  // ice
            csurf = vec3(0, 0.3, 0.7);
            rg = 0.0;
            metallic = 0.0;
            canTransmit = true;
            break;
        // レジアイス（目？）
        case 3:
            return getLightParam(vec3(15));
        default:
            return dummyParam;
    }

    return makeParam(ior, rawF0, csurf, rg, metallic, canTransmit, false, vec3(0));
}

#pragma glslify: export(getParam)
