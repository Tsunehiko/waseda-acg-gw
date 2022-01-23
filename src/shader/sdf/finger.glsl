precision mediump float;

#pragma glslify: sdBox = require('./box.glsl')
#pragma glslify: sdPyramid = require('./pyramid.glsl')
#pragma glslify: sdAdd = require('./add.glsl')

float sdFinger(vec3 p){
    float d_b = sdBox(p, vec3(0.04, 0.08, 0.04));

    vec3 p_p = p - vec3(0, 0.08, 0);
    float d_p = sdPyramid(p_p, vec2(0.056));

    return sdAdd(d_b, d_p);
}

#pragma glslify: export(sdFinger)