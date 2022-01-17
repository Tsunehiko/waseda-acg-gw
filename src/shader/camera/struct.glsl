precision mediump float;

struct Camera {
    vec3 pos;
    vec3 dir;
    vec3 up;
    vec3 side;
};

#pragma glslify: export(Camera)
