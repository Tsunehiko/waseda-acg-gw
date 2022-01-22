precision mediump float;

#pragma glslify: PI = require('../../const/pi.glsl')
#pragma glslify: rand3 = require('../../util/rand3.glsl')

vec3 sampleGGXVNDF(vec3 V_, float alpha_x, float alpha_y, float U1, float U2)
{
    // stretch view
    vec3 V = normalize(vec3(alpha_x * V_.x, alpha_y * V_.y, V_.z));

    // orthonormal basis
    vec3 T1 = (V.z < 0.9999) ? normalize(cross(V, vec3(0,0,1))) : vec3(1,0,0);
    vec3 T2 = cross(T1, V);

    // sample point with polar coordinates (r, phi)
    float a = 1.0 / (1.0 + V.z);
    float r = sqrt(U1);
    float phi = (U2<a) ? U2/a * PI : PI + (U2-a)/(1.0-a) * PI;
    float P1 = r*cos(phi);
    float P2 = r*sin(phi)*((U2<a) ? 1.0 : V.z);

    // compute normal
    vec3 N = P1*T1 + P2*T2 + sqrt(max(0.0, 1.0 - P1*P1 - P2*P2))*V;

    // unstretch
    N = normalize(vec3(alpha_x*N.x, alpha_y*N.y, max(0.0, N.z)));
    return N;
}

vec3 sampleMGGX(vec3 n, vec3 seed) {
    vec3 random = rand3(seed);
    float u1 = (random[0] + random[1]) / 2.0;
    float u2 = random[2];

    return sampleGGXVNDF(n, 1.0, 1.0, u1, u2);
}

#pragma glslify: export(sampleMGGX)
