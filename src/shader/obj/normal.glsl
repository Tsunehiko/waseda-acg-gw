precision mediump float;

#pragma glslify: sdObj = require('./sdf.glsl')

const vec2 e = vec2(0.0001, 0.0);

vec3 normalObj(vec3 p) {
    return normalize(
        vec3(
            sdObj(p + e.xyy) - sdObj(p - e.xyy),
            sdObj(p + e.yxy) - sdObj(p - e.yxy),
            sdObj(p + e.yyx) - sdObj(p - e.yyx)
        )
    );
}

#pragma glslify: export(normalObj)
