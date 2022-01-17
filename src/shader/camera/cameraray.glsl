precision mediump float;

#pragma glslify: Camera = require('./struct.glsl')
#pragma glslify: Ray = require('../ray/struct.glsl')

const float targetDepth = 0.9;  // カメラのズーム倍率？

Ray cameraRay(Camera camera, vec2 p) {
    return Ray(camera.pos, normalize(camera.side * p.x + camera.up * p.y + camera.dir * targetDepth));
}

#pragma glslify: export(cameraRay)
