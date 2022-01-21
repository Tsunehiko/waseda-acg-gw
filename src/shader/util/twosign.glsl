precision mediump float;

float twoSign(float x) { return (x >= 0.0) ? 1.0 : -1.0; }

#pragma glslify: export(twoSign)
