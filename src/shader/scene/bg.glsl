precision mediump float;

#pragma glslify: sdBox = require('../sdf/box.glsl')

float sdBg(vec3 p) {
    const vec3 b = vec3(2, 2, 2);
    return -sdBox(p, b);
}

#pragma glslify: export(sdBg)
