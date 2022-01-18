precision mediump float;

#pragma glslify: objColor = require('./color.glsl')
#pragma glslify: objMetal = require('./metal.glsl')

// 参考：教科書p.324
const vec3 objAlbedo = mix(objColor, vec3(0), objMetal);

#pragma glslify: export(objAlbedo)
