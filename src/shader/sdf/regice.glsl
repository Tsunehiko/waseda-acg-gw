precision mediump float;

#pragma glslify: sdArm = require('./arm.glsl')
#pragma glslify: sdBody = require('./body.glsl')
#pragma glslify: sdBack = require('./back.glsl')
#pragma glslify: sdLeg = require('./leg.glsl')
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

float sdRegice (vec3 p){

    vec3 p_arm_r = p - vec3(0.45, 0.1, 0);
    vec3 axis_arm_r = vec3(0, 0, 1.0);
    float angle_arm_r = 3.1415 / 3.;
    vec4 rotQuat_arm_r = makeQuatFromAxisAngle(axis_arm_r, angle_arm_r);
    p_arm_r = rotate3d(p_arm_r, rotQuat_arm_r);
    float d_arm_r = sdArm(p_arm_r);

    vec3 p_arm_l = p - vec3(-0.45, 0.1, 0);
    vec3 axis_arm_l = vec3(0, 0, -1.0);
    float angle_arm_l = 3.1415 / 3.;
    vec4 rotQuat_arm_l = makeQuatFromAxisAngle(axis_arm_l, angle_arm_l);
    p_arm_l = rotate3d(p_arm_l, rotQuat_arm_l);
    float d_arm_l = sdArm(p_arm_l);

    float d_body = sdBody(p);
    
    float d_leg = sdLeg(p);

    float d_back = sdBack(p);

    return sdAdd(sdAdd(sdAdd(sdAdd(d_arm_l, d_arm_r), d_body), d_back), d_leg);
}

#pragma glslify: export(sdRegice)