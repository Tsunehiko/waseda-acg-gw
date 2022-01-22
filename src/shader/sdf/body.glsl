precision mediump float;
#pragma glslify: sdHexPyramid = require('./hexpyramid.glsl')
#pragma glslify: sdHexPrism = require('./hexprism.glsl')
#pragma glslify: sdTrapezoid = require('./trapezoid.glsl')
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

float sdBody(vec3 p){

    vec3 axis_body = vec3(0, 1.0, 0);
    float angle_body = 3.1415 / 6.;
    vec4 rotQuat_body = makeQuatFromAxisAngle(axis_body, angle_body);
    p = rotate3d(p, rotQuat_body);

    vec3 p_1 = p - vec3(0, 0.4, 0);
    float d1 = sdHexPyramid(p_1, vec2(0.2775, 0.3));

    vec3 p_2 = p - vec3(0, 0.1, 0);
    p_2 = p_2 / 1.0;
    vec3 axis_2 = vec3(1.0, 0, 0);
    float angle_2 = 3.1415 / 2.;
    vec4 rotQuat_2 = makeQuatFromAxisAngle(axis_2, angle_2);
    p_2 = rotate3d(p_2, rotQuat_2);
    float d2 = sdTrapezoid(p_2, vec2(0.4, 0.3), 0.75) * 1.0;

    vec3 p_3 = p - vec3(0, -0.23, 0);
    p_3 = p_3 / 1.0;
    vec3 axis_3 = vec3(-1.0, 0, 0);
    float angle_3 = 3.1415 / 2.;
    vec4 rotQuat_3 = makeQuatFromAxisAngle(axis_3, angle_3);
    p_3 = rotate3d(p_3, rotQuat_3);
    float d3 = sdTrapezoid(p_3, vec2(0.43, 0.03), 0.7) * 1.0;
    return sdAdd(sdAdd(d1, d2), d3);
}

#pragma glslify: export(sdBody)