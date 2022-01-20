precision mediump float;

#pragma glslify: sdBg = require('../bg/sdf.glsl')
#pragma glslify: ICE_F0 = require('../const/icef0.glsl')
#pragma glslify: STONE_F0 = require('../const/stonef0.glsl')
#pragma glslify: sdObj = require('../obj/sdf.glsl')
#pragma glslify: dummyParam = require('../param/dummy.glsl')
#pragma glslify: makeParam = require('../param/make.glsl')
#pragma glslify: Param = require('../param/struct.glsl')

vec3 floorColor(vec3 p, vec3 color1, vec3 color2, float freq) {
    vec2 xz = floor(p.xz * freq);
    return mod(xz[0] + xz[1], 2.0) == 0.0 ? color1 : color2;
}

int getIdx(vec3 p, float eps) {
    if (sdBg(p) < eps) return 0;
    if (sdObj(p) < eps) return 1;

    return -1;
}

Param getParam(vec3 p, float eps) {
    vec3 rawF0;
    vec3 csurf;
    float rg;
    float metalic;
    switch (getIdx(p, eps)) {
        // 床
        case 0:
            rawF0 = STONE_F0;
            csurf = floorColor(p, vec3(0.2), vec3(0.8), 10.0);
            rg = 0.0;
            metalic = 0.0;
            break;
        // レジアイス（外部）
        case 1:
            rawF0 = ICE_F0;
            csurf = vec3(0, 0.3, 0.7);
            rg = 0.0;
            metalic = 0.0;
            break;
        default:
            return dummyParam;
    }

    return makeParam(rawF0, csurf, rg, metalic);
}

#pragma glslify: export(getParam)
