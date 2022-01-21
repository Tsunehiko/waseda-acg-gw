precision mediump float;

#pragma glslify: PI = require('../const/pi.glsl')
#pragma glslify: Hit = require('../hit/struct.glsl')
#pragma glslify: brdf = require('../reflect/brdf.glsl')
#pragma glslify: nlPlus = require('../util/nlplus.glsl')

vec3 pointLight(vec3 l, vec3 v, vec3 clight, Hit hit) {
    vec3 n = hit.normal;
    return PI * brdf(l, v, n, hit.param.F0, hit.param.rg, hit.param.albedo) * clight * nlPlus(n, l);
}

#pragma glslify: export(pointLight)
