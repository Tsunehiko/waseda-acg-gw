precision mediump float;

#pragma glslify: Param = require('./struct.glsl')

Param makeLightParam(vec3 clight) { return Param(vec3(0), vec3(0), 0.0, true, clight); }

#pragma glslify: export(makeLightParam)
