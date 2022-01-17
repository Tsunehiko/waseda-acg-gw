precision mediump float;

#pragma glslify: Ray = require('./struct.glsl')

vec3 end(Ray ray, float t) { return ray.origin + t * ray.dir; }

#pragma glslify: export(end)
