precision mediump float;

#pragma glslify: sdPlane = require('../../sdf/plane.glsl')
#pragma glslify: sdCave = require('../../sdf/cave.glsl')
#pragma glslify: sdAdd = require('../../sdf/add.glsl')

const vec3 n = normalize(vec3(0, 1, 0));
const float w = 0.5;

float sdFloor(vec3 p) {
    return sdCave(p, vec3(0, 0, -5), vec3(0, 0, 3), 0.9, 0.2);
    }

#pragma glslify: export(sdFloor)
