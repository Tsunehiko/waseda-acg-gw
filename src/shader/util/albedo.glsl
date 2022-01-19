precision mediump float;

// 参考：教科書p.324
vec3 albedo(vec3 csurf, float metal) { return mix(csurf, vec3(0), metal); }

#pragma glslify: export(albedo)
