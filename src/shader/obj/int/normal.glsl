precision mediump float;

#pragma glslify: sdObjInt = require('./sdf.glsl')

const vec2 e = vec2(0.0001, 0.0);

vec3 normalObjInt(vec3 p) {
    return normalize(
        vec3(
            sdObjInt(p + e.xyy) - sdObjInt(p - e.xyy),
            sdObjInt(p + e.yxy) - sdObjInt(p - e.yxy),
            sdObjInt(p + e.yyx) - sdObjInt(p - e.yyx)
        )
    );
}

#pragma glslify: export(normalObjInt)
