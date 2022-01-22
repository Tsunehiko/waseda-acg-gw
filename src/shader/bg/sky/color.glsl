precision mediump float;

const vec3 color = vec3(0.6, 0.5, 0.8);

vec3 skyColor() { return color; }

#pragma glslify: export(skyColor)
