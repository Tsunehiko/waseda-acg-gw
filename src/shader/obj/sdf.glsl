precision mediump float;

#pragma glslify: sdBox = require('../sdf/box.glsl')
#pragma glslify: sdRound = require('../sdf/round.glsl')
#pragma glslify: sdSphere = require('../sdf/sphere.glsl')

const vec3 b = vec3(0.5, 0.3, 0.3);
const float r = 0.08;

// make a double ball here
//float sdObj(vec3 p) { return sdSphere(p, 0.3); }
float sdObj(vec3 p) { 
    float h1 = sdSphere(vec3(p.x-0.18,p.y+0.12, p.z), 0.3);
    float h2 = sdSphere(vec3(p.x+0.18,p.y+0.12, p.z), 0.3);
    float h3 = sdSphere(vec3(p.x, p.y-0.20, p.z), 0.3);
    float h = min(h1,h2);
    h = min(h, h3);
    return h;
}

#pragma glslify: export(sdObj)
