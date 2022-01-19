precision mediump float;

#pragma glslify: objColor = require('./color.glsl')
#pragma glslify: objMetal = require('./metal.glsl')
#pragma glslify: ICE_F0 = require('../../const/icef0.glsl')
#pragma glslify: F0 = require('../../util/f0.glsl')

// HACK: 定数じゃないのでグローバル変数にはできない
vec3 objF0() { return F0(ICE_F0, objColor, objMetal); }

#pragma glslify: export(objF0)
