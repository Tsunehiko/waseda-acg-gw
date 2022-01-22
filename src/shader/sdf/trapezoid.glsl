precision mediump float;

float sdTrapezoid( vec3 p, vec2 h, float r)
{
    vec3 q = abs(p);
    return max(q.z-h.y,max((q.x*0.866025+q.y*0.5),q.y)-h.x*mix(r, 1.0, p.z-h.y));
}

#pragma glslify: export(sdTrapezoid)