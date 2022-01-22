precision mediump float;

struct Param {
    float ior;
    vec3 F0;
    vec3 albedo;
    float rg;
    bool canTransmit;
    bool isLight;
    vec3 clight;
};

#pragma glslify: export(Param)
