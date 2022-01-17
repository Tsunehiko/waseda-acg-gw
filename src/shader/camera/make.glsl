precision mediump float;

#pragma glslify: Camera = require('./struct.glsl')

const vec3 pos = vec3(0.6);
const vec3 dir = normalize(vec3(-1));
const vec3 up = normalize(vec3(-1, 1, -1));

Camera makeCamera() { return Camera(pos, dir, up, cross(dir, up)); }

#pragma glslify: export(makeCamera)
