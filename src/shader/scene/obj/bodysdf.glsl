precision mediump float;

#pragma glslify: sdRegiceNoEye = require('../../sdf/regicenoeye.glsl')

float sdBody(vec3 p) { return sdRegiceNoEye(p); }

#pragma glslify: export(sdBody)
