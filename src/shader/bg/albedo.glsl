precision mediump float;

#pragma glslify: floorAlbedo = require('./floor/albedo.glsl')
#pragma glslify: sdFloor = require('./floor/sdf.glsl')
#pragma glslify: skyColor = require('./sky/color.glsl')

vec3 bgAlbedo(vec3 p, float eps) {
    if (sdFloor(p) < eps) return floorAlbedo(p);

    return skyColor();
}

#pragma glslify: export(bgAlbedo)
