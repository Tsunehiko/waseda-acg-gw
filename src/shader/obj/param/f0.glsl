precision mediump float;

#pragma glslify: objColor = require('./color.glsl')
#pragma glslify: objMetal = require('./metal.glsl')
#pragma glslify: ICE_F0 = require('../../const/icef0.glsl')

// 参考：教科書p.324
const vec3 objF0 = mix(ICE_F0, objColor, objMetal);

#pragma glslify: export(objF0)
