precision mediump float;

struct Ray {
    vec3 origin;
    vec3 dir;
    float ior;
};

#pragma glslify: export(Ray)
