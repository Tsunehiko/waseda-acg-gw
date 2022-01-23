precision mediump float;

#pragma glslify: sdCave = require('../../sdf/cave.glsl')

float sdBg(vec3 p) { return sdCave(p, vec3(0, 0, -5), vec3(0, 0, 5), 0.8, 0.1); }

#pragma glslify: export(sdBg)
