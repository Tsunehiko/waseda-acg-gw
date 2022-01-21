precision mediump float;

float rand (vec2 seed) {
    return fract(sin(dot(seed, vec2(12.9898,78.233))) * 43758.5453);
}

vec2 rand2 (vec2 seed) {
    return vec2(rand(seed), rand(seed + vec2(12.345, 67.89)));
}

#pragma glslify: export(rand2)
