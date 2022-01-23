precision mediump float;
#pragma glslify: sdBackBar = require('./back_bar.glsl')
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

vec3 rotateXBar(vec3 p){
    vec3 axis = vec3(-1.0, 0, 0);
    float angle = 3.1415 / 3.;
    vec4 rotQuat = makeQuatFromAxisAngle(axis, angle);
    return rotate3d(p, rotQuat);
}

vec3 rotateYBar(vec3 p, float dir){
    vec3 axis = vec3(0, 0, dir);
    float angle = 3.1415 / 6.;
    vec4 rotQuat = makeQuatFromAxisAngle(axis, angle);
    return rotate3d(p, rotQuat);
}

float sdBack(vec3 p){

    vec3 p_1 = p - vec3(0.2, 0.05, -0.3);
    p_1 = rotateXBar(p_1);
    p_1 = rotateYBar(p_1, -1.0);
    float d1 = sdBackBar(p_1);

    vec3 p_2 = p - vec3(0.15, 0.3, -0.2);
    p_2 = rotateXBar(p_2);
    p_2 = rotateYBar(p_2, -1.0);
    float d2 = sdBackBar(p_2);

    vec3 p_3 = p - vec3(-0.2, 0.05, -0.3);
    p_3 = rotateXBar(p_3);
    p_3 = rotateYBar(p_3, 1.0);
    float d3 = sdBackBar(p_3);

    vec3 p_4 = p - vec3(-0.15, 0.3, -0.2);
    p_4 = rotateXBar(p_4);
    p_4 = rotateYBar(p_4, 1.0);
    float d4 = sdBackBar(p_4);

    return sdAdd(sdAdd(sdAdd(d1, d2), d3), d4);
}

#pragma glslify: export(sdBack)