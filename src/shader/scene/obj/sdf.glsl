precision mediump float;

#pragma glslify: sdBody = require('./bodysdf.glsl')
#pragma glslify: sdEye = require('./eyesdf.glsl')
#pragma glslify: sdAdd = require('../../sdf/add.glsl')

float sdObj(vec3 p) { return sdAdd(sdBody(p), sdEye(p)); }

#pragma glslify: export(sdObj)
