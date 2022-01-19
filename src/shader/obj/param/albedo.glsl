precision mediump float;

#pragma glslify: objColor = require('./color.glsl')
#pragma glslify: objMetal = require('./metal.glsl')
#pragma glslify: calcAlbedo = require('../../util/albedo.glsl')

// HACK: 定数じゃないのでグローバル変数にはできない
vec3 objAlbedo() { return calcAlbedo(objColor, objMetal); }

#pragma glslify: export(objAlbedo)
