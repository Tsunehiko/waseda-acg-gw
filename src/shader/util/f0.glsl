precision mediump float;

// 参考：教科書p.324
vec3 F0(vec3 rawF0, vec3 csurf, float metal) { return mix(rawF0, csurf, metal); }

#pragma glslify: export(F0)
