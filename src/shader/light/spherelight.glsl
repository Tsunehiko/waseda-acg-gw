precision mediump float;

#pragma glslify: pointLight = require('./pointlight.glsl')

const float radius = 0.5;

vec3 sphereLight(vec3 l, vec3 v, vec3 clight, Hit hit) {
    vec3 r = reflect(v, n);
    vec3 pcr = dot(l, r) * r - l;
    vec3 pcs = l + pcr * min(1.0, radius / length(pcr));
    return pointLight(normalize(pcs), v, clight, hit);
}

#pragma glslify: export(sphereLight)
