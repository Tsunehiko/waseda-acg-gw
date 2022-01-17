precision mediump float;

#pragma glslify: sdAdd = require('../sdf/add.glsl')
#pragma glslify: sdBg = require('../bg/sdf.glsl')
#pragma glslify: sdObj = require('../obj/sdf.glsl')

float scene(vec3 p) { return sdAdd(sdObj(p), sdBg(p)); }

#pragma glslify: export(scene)
