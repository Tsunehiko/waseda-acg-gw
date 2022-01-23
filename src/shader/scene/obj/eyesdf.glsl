precision mediump float;

#pragma glslify: sdRegiceEye = require('../../sdf/eye.glsl')

float sdEye(vec3 p) { return sdRegiceEye(p); }

#pragma glslify: export(sdEye)
