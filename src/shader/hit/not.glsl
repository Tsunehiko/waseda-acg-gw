precision mediump float;

#pragma glslify: Hit = require('./struct.glsl')
#pragma glslify: dummyParam = require('../param/dummy.glsl')

const Hit notHit = Hit(false, vec3(0), vec3(0), dummyParam);

#pragma glslify: export(notHit)
