precision mediump float;

#pragma glslify: Param = require('./struct.glsl')

// 参考：教科書p.324
vec3 F0(vec3 rawF0, vec3 csurf, float metallic) { return mix(rawF0, csurf, metallic); }
vec3 albedo(vec3 csurf, float metallic) { return mix(csurf, vec3(0), metallic); }

Param makeParam(vec3 rawF0, vec3 csurf, float rg, float metallic, bool isLight, vec3 clight) {
    return Param(F0(rawF0, csurf, metallic), albedo(csurf, metallic), rg, isLight, clight);
}

#pragma glslify: export(makeParam)
