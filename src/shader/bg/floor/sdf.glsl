precision mediump float;

#pragma glslify: sdPlane = require('../../sdf/plane.glsl')
#pragma glslify: sdCave = require('../../sdf/cave.glsl')

const vec3 n = normalize(vec3(0, 1, 0));
const float w = 0.5;

float sdFloor(vec3 p) { return sdPlane(p, vec4(n, w)); }

#pragma glslify: export(sdFloor)
