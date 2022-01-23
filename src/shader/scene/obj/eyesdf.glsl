precision mediump float;

#pragma glslify: sdRegiceEye = require('../../sdf/eye.glsl')

float sdEye(vec3 p) { 
    p = p / 0.2;
    return sdRegiceEye(p) * 0.2; }

#pragma glslify: export(sdEye)
