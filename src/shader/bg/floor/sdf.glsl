precision mediump float;

#pragma glslify: sdPlane = require('../../sdf/plane.glsl')
#pragma glslify: sdCave = require('../../sdf/cave.glsl')
#pragma glslify: sdCylinder = require('../../sdf/cylinder.glsl')
#pragma glslify: sdAdd = require('../../sdf/add.glsl')

const vec3 n = normalize(vec3(0, 1, 0));
const float w = 0.5;

float sdFloor(vec3 p) { 
    return sdCylinder(p, vec3(0, 0, -100), vec3(0, 0, 100), 1.0);
    // return sdAdd(sdCylinder(p, vec3(0, 0, -100), vec3(0, 0, 100), 0.5), sdCave(p, 2, 0.8));
    // return sdAdd(sdCave(p, 5, 0.8), sdPlane(p, vec4(n, w))); 
    }

#pragma glslify: export(sdFloor)
