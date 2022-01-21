precision mediump float;

#pragma glslify: sdFloor = require('./floor/sdf.glsl')

#pragma glslify: sdBox = require('../sdf/box.glsl')
float sdBg(vec3 p) {
    return -sdBox(p, vec3(2, 2, 2));
}

//float sdBg(vec3 p) { return sdFloor(p); }

#pragma glslify: export(sdBg)
