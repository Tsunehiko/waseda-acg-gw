precision mediump float;

#pragma glslify: Camera = require('./struct.glsl')

const vec3 pos = vec3(0, 0, 0.32);
const vec3 dir = normalize(-pos);
const vec3 up = normalize(vec3(0, 1, 0));

Camera makeCamera() { return Camera(pos, dir, up, cross(dir, up)); }

#pragma glslify: export(makeCamera)
