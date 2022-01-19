precision mediump float;

#pragma glslify: objColor = require('./color.glsl')
#pragma glslify: objMetal = require('./metal.glsl')
#pragma glslify: albedo = require('../../util/albedo.glsl')

// HACK: 定数じゃないのでグローバル変数にはできない
vec3 getObjAlbedo() { return albedo(objColor, objMetal); }

#pragma glslify: export(getObjAlbedo)
