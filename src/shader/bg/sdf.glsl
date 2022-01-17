precision mediump float;

#pragma glslify: sdFloor = require('./floor/sdf.glsl')

float sdBg(vec3 p) { return sdFloor(p); }

#pragma glslify: export(sdBg)
