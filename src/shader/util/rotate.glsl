precision mediump float;

vec3 rotate(vec3 p, vec3 axis, float costheta) {
    float sintheta = sqrt(1.0 - costheta * costheta);
    mat3 R = mat3(0, axis.z, -axis.y, -axis.z, 0, axis.x, axis.y, -axis.x, 0);
    mat3 M = mat3(1, 0, 0, 0, 1, 0, 0, 0, 1) + sintheta * R + (1.0 - costheta) * R * R;
    return M * p;
}

#pragma glslify: export(rotate)
