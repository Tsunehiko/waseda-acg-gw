precision mediump float;

#pragma glslify: normalObjInt = require('./normalObjInt.glsl')
#pragma glslify: ICE_TO_SILVER_F0 = require('../../const/icetosilverf0.glsl')
#pragma glslify: reflectColor = require('../../reflect/color.glsl')

const vec3 color = vec3(1);
const vec3 F0 = ICE_TO_SILVER_F0;
const float rg = 0.0;

vec3 objIntColor(vec3 p, vec3 v, vec3 lightPos, vec3 clight) {
    vec3 l = normalize(lightPos - p);
    vec3 n = normalObjInt(p);
    vec3 albedo = color;
    return reflectColor(l, v, n, clight, albedo, F0, rg);
}

#pragma glslify: export(objIntColor)
