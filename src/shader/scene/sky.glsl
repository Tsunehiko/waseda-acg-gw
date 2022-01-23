precision mediump float;

const vec3 color = vec3(0.9, 1.0, 1.0);

vec3 skyColor() { return color; }

#pragma glslify: export(skyColor)
