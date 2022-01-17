precision mediump float;

#pragma glslify: sdFloor = require('./sdf.glsl')

const vec2 e = vec2(0.0001, 0.0);

vec3 normalFloor(vec3 p) {
    return normalize(
        vec3(
            sdFloor(p + e.xyy) - sdFloor(p - e.xyy),
            sdFloor(p + e.yxy) - sdFloor(p - e.yxy),
            sdFloor(p + e.yyx) - sdFloor(p - e.yyx)
        )
    );
}

#pragma glslify: export(normalFloor)
