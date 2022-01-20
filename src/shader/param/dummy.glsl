precision mediump float;

#pragma glslify: Param = require('./struct.glsl')

const Param dummyParam = Param(vec3(0), vec3(0), 0.0);

#pragma glslify: export(dummyParam)
