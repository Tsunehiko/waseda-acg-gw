precision mediump float;

#pragma glslify: Param = require('../param/struct.glsl')

struct Hit {
    bool check;
    vec3 pos;
    vec3 normal;
    Param param;
};

#pragma glslify: export(Hit)
