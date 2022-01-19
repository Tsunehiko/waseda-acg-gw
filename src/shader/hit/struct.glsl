precision mediump float;

struct Hit {
    bool check;
    vec3 pos;
    vec3 normal;
    vec3 albedo;
};

#pragma glslify: export(Hit)
