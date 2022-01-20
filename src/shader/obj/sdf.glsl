precision mediump float;

#pragma glslify: sdBox = require('../sdf/box.glsl')
#pragma glslify: sdRound = require('../sdf/round.glsl')
#pragma glslify: sdSphere = require('../sdf/sphere.glsl')

const vec3 b = vec3(0.5, 0.3, 0.3);
const float r = 0.08;

//float sdObj(vec3 p) { return sdRound(sdBox(p, b), r); }
float sdObj(vec3 p) { return sdSphere(p, 0.5); }

#pragma glslify: export(sdObj)
