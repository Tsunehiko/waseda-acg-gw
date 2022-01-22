precision mediump float;

const float eps = 0.0001;

float G1GGX(vec3 V, vec3 n, vec3 m, float ag2) {
    float Vm = dot(V, m);
    float Vn = dot(V, n);
    float tanThetaV = sqrt(1.0 / (Vn * Vn + eps) - 1.0);

    return step(0.0, Vm / Vn) * 2.0 / (1.0 + sqrt(1.0 + ag2 * ag2 * tanThetaV * tanThetaV));
}

#pragma glslify: export(G1GGX)
