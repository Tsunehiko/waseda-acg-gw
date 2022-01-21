precision mediump float;

vec3 sphereToOrth(vec3 p) {
    float r = p[0];
    float theta = p[1];
    float phi = p[2];

    float ct = cos(theta);
    float st = sin(theta);
    float cp = cos(phi);
    float sp = sin(phi);

    float x = r * st * cp;
    float y = r * st * sp;
    float z = r * ct;
    return vec3(x, y, z);
}

#pragma glslify: export(sphereToOrth)
