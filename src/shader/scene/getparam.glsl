precision mediump float;

#pragma glslify: sdLight1 = require('./light.glsl')
#pragma glslify: sdBg = require('./bg.glsl')
#pragma glslify: sdObj = require('./obj.glsl')
#pragma glslify: ICE_F0 = require('../const/icef0.glsl')
#pragma glslify: STONE_F0 = require('../const/stonef0.glsl')
#pragma glslify: dummyParam = require('../param/dummy.glsl')
#pragma glslify: getLightParam = require('../param/light.glsl')
#pragma glslify: makeParam = require('../param/make.glsl')
#pragma glslify: Param = require('../param/struct.glsl')

vec3 bgColor(vec3 p, vec3 color1, vec3 color2, float freq) {
    p = floor(p * freq);
    return mod(p.x + p.y + p.z, 2.0) == 0.0 ? color1 : color2;
}

int getIdx(vec3 p, float eps) {
    if (sdLight1(p) < eps) return 0;
    if (sdBg(p) < eps) return 1;
    if (sdObj(p) < eps) return 2;

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
        // 光源（上）
        case 0:
            return getLightParam(vec3(15));
        // 背景
        case 1:
            ior = 0.0;
            rawF0 = STONE_F0;
            csurf = bgColor(p, vec3(0.2), vec3(0.8), 2.0);
            rg = 0.9;
            metallic = 0.0;
            canTransmit = false;
            break;
        // レジアイス（外部）
        case 2:
            ior = 1.31;
            rawF0 = ICE_F0;
            csurf = vec3(0, 0.3, 0.7);
            rg = 0.0;
            metallic = 0.0;
            canTransmit = true;
            break;
        default:
            return dummyParam;
    }

    return makeParam(ior, rawF0, csurf, rg, metallic, canTransmit, false, vec3(0));
}

#pragma glslify: export(getParam)
