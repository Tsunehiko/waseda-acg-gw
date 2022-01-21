precision mediump float;

#pragma glslify: sdSphere = require('../sdf/sphere.glsl')

float sdObj(vec3 p) {
    const float r = 0.5;
    return sdSphere(p, r);
}

#pragma glslify: export(sdObj)
