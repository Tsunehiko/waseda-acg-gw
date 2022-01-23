precision mediump float;

#pragma glslify: sdCave = require('../../sdf/cave.glsl')

float sdBg(vec3 p) { return sdCave(p, vec3(0, 0, -5), vec3(0, 0, 3), 0.9, 0.2); }

#pragma glslify: export(sdBg)
