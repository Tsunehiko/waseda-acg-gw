precision mediump float;

#pragma glslify: PI = require('./pi.glsl')

const float PI_INV = 1.0 / PI;

#pragma glslify: export(PI_INV)
