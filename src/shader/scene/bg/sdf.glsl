precision mediump float;

#pragma glslify: sdCave = require('../../sdf/cave.glsl')
#pragma glslify: sdSphere = require('../../sdf/sphere.glsl')
#pragma glslify: sdBox = require('../../sdf/box.glsl')

float sdBg(vec3 p) { 
    return -sdBox(p, vec3(0.75, 0.75, 5));
    //return sdCave(p, vec3(0, 0, -5), vec3(0, 0, 5), 0.8, 0.1); 
    }

#pragma glslify: export(sdBg)
