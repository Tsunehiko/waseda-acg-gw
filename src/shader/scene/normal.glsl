precision mediump float;

#pragma glslify: scene = require('./sdf.glsl')

const vec2 e = vec2(0.0001, 0.0);

vec3 normal(vec3 p) {
    return normalize(
        vec3(
            scene(p + e.xyy) - scene(p - e.xyy),
            scene(p + e.yxy) - scene(p - e.yxy),
            scene(p + e.yyx) - scene(p - e.yyx)
        )
    );
}

#pragma glslify: export(normal)
