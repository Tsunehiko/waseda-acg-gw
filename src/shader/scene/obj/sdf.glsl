precision mediump float;

#pragma glslify: sdBody = require('./bodysdf.glsl')
#pragma glslify: sdEye = require('./eyesdf.glsl')
#pragma glslify: sdAdd = require('../../sdf/add.glsl')
#pragma glslify: sdSphere = require('../../sdf/sphere.glsl')

float sdObj(vec3 p) { 
    return sdSphere(p, 0.07);
    // return sdAdd(sdBody(p), sdEye(p));
    }

#pragma glslify: export(sdObj)
