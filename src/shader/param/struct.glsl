precision mediump float;

struct Param {
    vec3 F0;
    vec3 albedo;
    float rg;
    bool isLight;
    vec3 clight;
};

#pragma glslify: export(Param)
