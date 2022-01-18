precision mediump float;

#pragma glslify: PI = require('../../const/pi.glsl')
#pragma glslify: halfVec = require('../../util/halfvec.glsl')

vec3 brdfDiffHammon(vec3 l, vec3 v, vec3 n, vec3 F0, float rg, vec3 albedo) {
    // 参考：教科書p.355 式9.68
    float ag = pow(rg, 2.0);

    vec3 h = halfVec(l, v);

    float nl = dot(n, l);
    float nv = dot(n, v);
    float nh = dot(n, h);
    float lv = dot(l, v);

    float fmulti = 0.3641 * ag;
    float kfacing = 0.5 + 0.5 * lv;
    vec3 frough = vec3(kfacing * (0.9 - 0.4 * kfacing) * (0.5 + nh) / nh);
    vec3 fsmooth = 21.0 / 20.0 * (1.0 - F0) * (1.0 - pow(1.0 - nl, 5.0)) * (1.0 - pow(1.0 - nv, 5.0));

    return step(0.0, nl) * step(0.0, nv) * albedo / PI * (mix(fsmooth, frough, ag) + albedo * fmulti);
}

#pragma glslify: export(brdfDiffHammon)
