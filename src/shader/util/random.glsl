precision mediump float;

uvec3 pcg3d(uvec3 v)
{
    v = v * 1664525u + 1013904223u;
    v.x += v.y*v.z;
    v.y += v.z*v.x;
    v.z += v.x*v.y;
    v ^= (v>>16u);
    v.x += v.y*v.z;
    v.y += v.z*v.x;
    v.z += v.x*v.y;
    return v;
}

float toFloat(uint x) {
    x &= 0x007FFFFFu;
    x |= 0x3F800000u;
    return uintBitsToFloat(x) - 1.0;
}

vec3 toFloat(uvec3 v) { return vec3(toFloat(v.x), toFloat(v.y), toFloat(v.z)); }

uint xorShift32(uint x) {
    x ^= x << 13u;
    x ^= x >> 17u;
    x ^= x << 5u;
    return x;
}

vec3 random3(inout uint s0) {
    uint s1 = xorShift32(s0);
    uint s2 = xorShift32(s1);
    uint s3 = xorShift32(s2);
    s0 = s3;
    return toFloat(pcg3d(uvec3(s1, s2, s3)));
}

#pragma glslify: export(random3)
