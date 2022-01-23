precision mediump float;

#pragma glslify: Camera = require('./struct.glsl')

//const vec3 pos = vec3(0.6);
// const vec3 pos = vec3(0, 0, 1);
//const vec3 dir = normalize(vec3(-1));
// const vec3 dir = normalize(vec3(0, 0, -1));
//const vec3 up = normalize(vec3(-1, 1, -1));
const vec3 up = normalize(vec3(0, 1, 0));

Camera makeCamera(float time) {
    float r = 0.8
    vec3 pos = vec3(cos(time*0.2)*r, 0, sin(time*0.2)*r);
    vec3 dir = -pos;
    return Camera(pos, dir, up, cross(dir, up)); }

#pragma glslify: export(makeCamera)
