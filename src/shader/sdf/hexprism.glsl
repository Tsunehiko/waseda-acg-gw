precision mediump float;

float sdHexPrism( vec3 p, vec2 h)
{
    vec3 q = abs(p);
    return max(q.y-h.y,max((q.x*0.866025+q.z*0.5),q.z)-h.x);
}

#pragma glslify: export(sdHexPrism)