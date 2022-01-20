precision mediump float;

#pragma glslify: Param = require('./struct.glsl')

// 参考：教科書p.324
vec3 F0(vec3 rawF0, vec3 csurf, float metalic) { return mix(rawF0, csurf, metalic); }
vec3 albedo(vec3 csurf, float metalic) { return mix(csurf, vec3(0), metalic); }

Param makeParam(vec3 rawF0, vec3 csurf, float rg, float metalic) {
    return Param(F0(rawF0, csurf, metalic), albedo(csurf, metalic), rg);
}

#pragma glslify: export(makeParam)
