precision mediump float;

#pragma glslify: calcAlbedo = require('../../util/albedo.glsl')

const vec3 color1 = vec3(0.2);
const vec3 color2 = vec3(0.8);
const float freq = 10.0;
const float metal = 0.0;

vec3 floorAlbedo(vec3 p) {
    vec2 xz = floor(p.xz * freq);
    vec3 color = mod(xz[0] + xz[1], 2.0) == 0.0 ? color1 : color2;
    return calcAlbedo(color, metal);
}

#pragma glslify: export(floorAlbedo)
