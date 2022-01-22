precision mediump float;

#pragma glslify: sdScene = require('../scene/sdf.glsl')

// distance fielf ambient occlusion
float DFAO(vec3 p, vec3 n, float AO_INTENSITY, float AO_STEP_SIZE, int AO_MAX_ITER){
    float STEP_f = float(AO_STEP_SIZE);
    float ao = 0.0;
    float dist;
    for (int i = 0; i < AO_MAX_ITER; i++){
        float i_f = float(i);
        dist = STEP_f * i_f;
        vec3 checkpoint = p + n*dist;
        ao += max(
                (dist - sdScene(checkpoint)) / dist,
                0.0
                );
    }
    return clamp(1.0 - ao*AO_INTENSITY, 0.0, 1.0);
}

#pragma glslify: export(DFAO)
