precision mediump float;

#pragma glslify: sdAdd = require('../sdf/add.glsl')
#pragma glslify: sdBg = require('./bg.glsl')
#pragma glslify: sdObj = require('./obj.glsl')
#pragma glslify: sdLight1 = require('./light.glsl')

float scene(vec3 p) {
    return sdAdd(sdAdd(sdObj(p), sdBg(p)), sdLight1(p));
}

#pragma glslify: export(scene)
