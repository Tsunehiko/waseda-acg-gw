precision mediump float;

#pragma glslify: sdRegiceNoEye = require('../../sdf/regicenoeye.glsl')

float sdBody(vec3 p) { 
    p = p / 0.2;
    return sdRegiceNoEye(p) * 0.2; 
    }

#pragma glslify: export(sdBody)
