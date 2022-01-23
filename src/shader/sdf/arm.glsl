precision mediump float;
#pragma glslify: sdHexPyramid = require('./hexpyramid.glsl')
#pragma glslify: sdHexPrism = require('./hexprism.glsl')
#pragma glslify: sdFinger = require('./finger.glsl')
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

float sdArm(vec3 p){

    vec3 axis_arm = vec3(0, 1.0, 0);
    float angle_arm = 3.1415 / 6.;
    vec4 rotQuat_arm = makeQuatFromAxisAngle(axis_arm, angle_arm);
    p = rotate3d(p, rotQuat_arm);

    vec3 p_1 = p - vec3(0, 0.15, 0);
    float d1 = sdHexPyramid(p_1, vec2(0.1725, 0.15));

    float d2 = sdHexPrism(p, vec2(0.15, 0.15));

    vec3 p_3 = p - vec3(0, -0.15, 0);
    vec3 axis_3 = vec3(1.0, 0, 0);
    float angle_3 = 3.1415 / 1.;
    vec4 rotQuat_3 = makeQuatFromAxisAngle(axis_3, angle_3);
    p_3 = rotate3d(p_3, rotQuat_3);
    float d3 = sdHexPyramid(p_3, vec2(0.1725, 0.175));

    vec3 p_4 = p - vec3(0, -0.25, 0.135);
    vec3 axis_4_x = vec3(1.0, 0, 0);
    float angle_4_x = 3.1415 / 1.15;
    vec4 rotQuat_4_x = makeQuatFromAxisAngle(axis_4_x, angle_4_x);
    p_4 = rotate3d(p_4, rotQuat_4_x);
    vec3 axis_4_y = vec3(0, 1.0, 0);
    float angle_4_y = 3.1415 / 6.;
    vec4 rotQuat_4_y = makeQuatFromAxisAngle(axis_4_y, angle_4_y);
    p_4 = rotate3d(p_4, rotQuat_4_y);
    float d4 = sdFinger(p_4);

    vec3 p_5 = p - vec3(0.12, -0.25, -0.065);
    vec3 axis_5_y = vec3(0, 1.0, 0);
    float angle_5_y = 3.1415 / 1.5;
    vec4 rotQuat_5_y = makeQuatFromAxisAngle(axis_5_y, angle_5_y);
    p_5 = rotate3d(p_5, rotQuat_5_y);
    vec3 axis_5_x = vec3(1.0, 0, 0);
    float angle_5_x = 3.1415 / 1.15;
    vec4 rotQuat_5_x = makeQuatFromAxisAngle(axis_5_x, angle_5_x);
    p_5 = rotate3d(p_5, rotQuat_5_x);
    float d5 = sdFinger(p_5);

    vec3 p_6 = p - vec3(-0.12, -0.25, -0.065);
    vec3 axis_6_y = vec3(0, -1.0, 0);
    float angle_6_y = 3.1415 / 1.5;
    vec4 rotQuat_6_y = makeQuatFromAxisAngle(axis_6_y, angle_6_y);
    p_6 = rotate3d(p_6, rotQuat_6_y);
    vec3 axis_6_x = vec3(1.0, 0, 0);
    float angle_6_x = 3.1415 / 1.15;
    vec4 rotQuat_6_x = makeQuatFromAxisAngle(axis_6_x, angle_6_x);
    p_6 = rotate3d(p_6, rotQuat_6_x);
    float d6 = sdFinger(p_6);

    float d_fingers = sdAdd(sdAdd(d4, d5), d6);

    return sdAdd(sdAdd(sdAdd(d1, d2), d3), d_fingers);
}

#pragma glslify: export(sdArm)