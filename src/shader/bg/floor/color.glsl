precision mediump float;

#pragma glslify: normalFloor = require('./normal.glsl')
#pragma glslify: STONE_F0 = require('../../const/stonef0.glsl')
#pragma glslify: reflectColor = require('../../reflect/color.glsl')

const vec3 color1 = vec3(0.2);
const vec3 color2 = vec3(0.8);
const float freq = 10.0;
const vec3 F0 = STONE_F0;
const float rg = 0.5;

vec3 rawFloorColor(vec3 p) {
    vec2 xz = floor(p.xz * freq);
    return mod(xz[0] + xz[1], 2.0) == 0.0 ? color1 : color2;
}

vec3 floorColor(vec3 p, vec3 v, vec3 lightPos, vec3 clight) {
    // カメラ->背景->光源のみ考慮
    vec3 l = normalize(lightPos - p);
    vec3 n = normalFloor(p);
    vec3 albedo = rawFloorColor(p);
    return reflectColor(l, v, n, clight, albedo, F0, rg);
}

#pragma glslify: export(floorColor)
