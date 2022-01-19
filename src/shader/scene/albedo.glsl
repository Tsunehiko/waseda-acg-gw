precision mediump float;

#pragma glslify: bgAlbedo = require('../bg/albedo.glsl')
#pragma glslify: sdBg = require('../bg/sdf.glsl')
#pragma glslify: objAlbedo = require('../obj/param/albedo.glsl')
#pragma glslify: sdObj = require('../obj/sdf.glsl')

vec3 albedo(vec3 p, float eps) {
    if (sdBg(p) < eps) return bgAlbedo(p, eps);
    if (sdObj(p) < eps) return objAlbedo();

    return vec3(0);
}

#pragma glslify: export(albedo)
