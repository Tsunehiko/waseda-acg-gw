precision mediump float;

#pragma glslify: sdSphere = require('./sphere.glsl')
#pragma glslify: sdAdd = require('./add.glsl')

float sdEye(vec3 p){
    vec3 p_1 = p - vec3(0, 0.325, 0.275);
    float d1 = sdSphere(p_1, 0.0225);
    vec3 p_2 = p - vec3(0, 0.265, 0.283);
    float d2 = sdSphere(p_2, 0.0225);
    vec3 p_3 = p - vec3(0, 0.205, 0.291);
    float d3 = sdSphere(p_3, 0.0225);
    vec3 p_4 = p - vec3(0.06, 0.265, 0.25);
    float d4 = sdSphere(p_4, 0.0225);
    vec3 p_5 = p - vec3(0.12, 0.265, 0.221);
    float d5 = sdSphere(p_5, 0.0225);
    vec3 p_6 = p - vec3(-0.06, 0.265, 0.25);
    float d6 = sdSphere(p_6, 0.0225);
    vec3 p_7 = p - vec3(-0.12, 0.265, 0.221);
    float d7 = sdSphere(p_7, 0.0225);
    return sdAdd(sdAdd(sdAdd(sdAdd(sdAdd(sdAdd(d1, d2), d3), d4), d5), d6), d7);
}

#pragma glslify: export(sdEye)