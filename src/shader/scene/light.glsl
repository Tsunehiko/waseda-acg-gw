precision mediump float;

#pragma glslify: sdSphere = require('../sdf/sphere.glsl')

float sdLight1(vec3 p) {
    const vec3 c = vec3(0, 0, -4);
    const float r = 1.0;
    return sdSphere(p - c, r);
}

#pragma glslify: export(sdLight1)
