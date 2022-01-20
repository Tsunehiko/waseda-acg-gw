precision mediump float;

struct Param {
    vec3 F0;
    vec3 albedo;
    float rg;
};

#pragma glslify: export(Param)
