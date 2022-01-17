precision mediump float;

#pragma glslify: PI = require('../../const/pi.glsl')
#pragma glslify: fresnelSchlick = require('../../util/fresnelschlick.glsl')

float ndfGGX(vec3 n, vec3 m, float roughness) {
   float nm = dot(n, m);
   float ag2 = pow(roughness, 2.0);
   return step(0.0, nm) * ag2 / (PI * pow(1.0 + pow(nm, 2.0) * (ag2 - 1.0), 2.0));
}

vec3 lambdaGGX(vec3 v) { return (-1.0 + sqrt(1.0 + 1.0 / pow(v, vec3(2)))) * 0.5; }

vec3 maskingSmithGGX(vec3 v, vec3 m) { return step(0.0, dot(m, v)) / (1.0 + lambdaGGX(v)); }

vec3 brdfGGX(vec3 l, vec3 v, vec3 n, vec3 albedo, vec3 F0, float roughness) {
    vec3 h = normalize(l + v);
    vec3 fspec = (
        fresnelSchlick(n, l, F0)
        * maskingSmithGGX(v, h)
        * ndfGGX(n, h, roughness)
        / 4.0
        / abs(dot(n, l) * dot(n, v))
    );

    return albedo / PI + fspec;
}

#pragma glslify: export(brdfGGX)
