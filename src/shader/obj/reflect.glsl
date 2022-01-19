precision mediump float;

#pragma glslify: normalObj = require('./normal.glsl')
#pragma glslify: objAlbedo = require('./param/albedo.glsl')
#pragma glslify: objF0 = require('./param/f0.glsl')
#pragma glslify: reflectColor = require('../reflect/color.glsl')

const float rg = 0.5;

vec3 objReflectColor(vec3 p, vec3 v, vec3 lightPos, vec3 clight) {
    // カメラ->オブジェクト->光源のみ考慮
    vec3 l = normalize(lightPos - p);
    vec3 n = normalObj(p);
    return reflectColor(l, v, n, clight, objAlbedo(), objF0(), rg);
}

#pragma glslify: export(objReflectColor)
