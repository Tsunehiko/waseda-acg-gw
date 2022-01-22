precision mediump float;

#pragma glslify: sdBox = require('./box.glsl')
#pragma glslify: sdPyramid = require('./pyramid.glsl')
#pragma glslify: sdAdd = require('./add.glsl')

float sdBackBar(vec3 p){
    vec3 p_4 = p;
    float d4 = sdBox(p_4, vec3(0.075, 0.2, 0.075));

    vec3 p_5 = p - vec3(0, 0.2, 0);
    float d5 = sdPyramid(p_5, vec2(0.105));

    return sdAdd(d4, d5);
}

#pragma glslify: export(sdBackBar)