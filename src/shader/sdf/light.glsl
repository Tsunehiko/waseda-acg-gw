precision mediump float;

#pragma glslify: sdSphere = require('./util/sphere.glsl')

float sdLight(vec3 p) { return sdSphere(p - vec3(0, 2, 0), 1.3); }

#pragma glslify: export(sdLight)
