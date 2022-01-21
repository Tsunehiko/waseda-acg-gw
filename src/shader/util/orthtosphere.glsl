precision mediump float;

#pragma glslify: twoSign = require('./twosign.glsl')

vec3 orthToSphere(vec3 p) {
    float r = length(p);
    float theta = acos(p.z / r);
    float phi = twoSign(p.y) * acos(p.x / length(p.xy));
    return vec3(r, theta, phi);
}

#pragma glslify: export(orthToSphere)
