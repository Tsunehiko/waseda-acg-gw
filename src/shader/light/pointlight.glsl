precision mediump float;

#pragma glslify: PI = require('../const/pi.glsl')
#pragma glslify: nlPlus = require('../util/nlplus.glsl')

vec3 pointLight(vec3 n, vec3 l, vec3 brdfVal, vec3 clight) { return PI * brdfVal * clight * nlPlus(n, l); }

#pragma glslify: export(pointLight)
