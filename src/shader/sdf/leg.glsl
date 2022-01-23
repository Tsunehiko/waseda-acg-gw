precision mediump float;

#pragma glslify: sdHexPyramid = require('./hexpyramid.glsl')
#pragma glslify: sdHexPrism = require('./hexprism.glsl')
#pragma glslify: sdAdd = require('./add.glsl')

vec4 qConjugate(vec4 q) {
    return vec4(-q.x, -q.y, -q.z, q.w);
}

vec4 qMul(vec4 q1, vec4 q2) {
    vec3 qv1 = vec3(q1.x, q1.y, q1.z);
    vec3 qv2 = vec3(q2.x, q2.y, q2.z);
    return vec4(vec3(cross(qv1, qv2) + q2.w * qv1 + q1.w * qv2), q1.w * q2.w - dot(qv1, qv2));
}

vec3 rotate3d(vec3 v, vec4 q) {
    vec4 vq = vec4(v, 0.0);
    vec4 cq = qConjugate(q);
    vec4 qOut = qMul(qMul(cq, vq), q);
    return vec3(qOut.x, qOut.y, qOut.z);
}

vec4 makeQuatFromAxisAngle(vec3 axis, float angle) {
    vec4 quat = vec4(vec3(axis.x * sin(angle / 2.0), axis.y * sin(angle / 2.0), axis.z * sin(angle / 2.0)), cos(angle / 2.0));
    return normalize(quat);
}

vec3 rotateXLeg(vec3 p){
    vec3 axis = vec3(1.0, 0, 0);
    float angle = 3.1415;
    vec4 rotQuat = makeQuatFromAxisAngle(axis, angle);
    return rotate3d(p, rotQuat);
}

vec3 rotateYLeg(vec3 p){
    vec3 axis = vec3(0, 1.0, 0);
    float angle = 3.1415 / 6.;
    vec4 rotQuat = makeQuatFromAxisAngle(axis, angle);
    return rotate3d(p, rotQuat);
}

float sdLeg(vec3 p){
    vec3 p_1 = p - vec3(-0.2, -0.29, 0);
    p_1 = rotateYLeg(p_1);
    float d_1 = sdHexPrism(p_1, vec2(0.2, 0.03));

    vec3 p_2 = p - vec3(0.2, -0.29, 0);
    p_2 = rotateYLeg(p_2);
    float d_2 = sdHexPrism(p_2, vec2(0.2, 0.03));

    vec3 p_3 = p - vec3(-0.2, -0.3, 0);
    p_3 = rotateXLeg(p_3);
    float d_3 = sdHexPyramid(p_3, vec2(0.2, 0.2));

    vec3 p_4 = p - vec3(0.2, -0.3, 0);
    p_4 = rotateXLeg(p_4);
    float d_4 = sdHexPyramid(p_4, vec2(0.2, 0.2));

    return sdAdd(sdAdd(sdAdd(d_1, d_2), d_3), d_4);
}

#pragma glslify: export(sdLeg)