precision mediump float;

float sdAdd(float d1, float d2) { return min(d1, d2); }

#pragma glslify: export(sdAdd)
