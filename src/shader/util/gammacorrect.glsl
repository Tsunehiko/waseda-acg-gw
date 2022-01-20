precision mediump float;

vec3 gammaCorrect(vec3 color) {
    return mix(1.055 * pow(color, vec3(1.0 / 2.4)) - 0.055, color * 12.92, step(color, vec3(0.0031308)));
}

#pragma glslify: export(gammaCorrect)
