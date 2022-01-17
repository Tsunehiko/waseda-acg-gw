precision mediump float;

#pragma glslify: sdBox = require('../../sdf/box.glsl')
#pragma glslify: sdRound = require('../../sdf/round.glsl')

const vec3 b = vec3(0.4, 0.2, 0.2);
const float r = 0.08;

float sdObjInt(vec3 p) { return sdRound(sdBox(p, b), r); }

#pragma glslify: export(sdObjInt)
