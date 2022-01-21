precision mediump float;

vec3 rand3(vec3 seed)
{
	vec3 p = vec3(
        dot(seed, vec3(127.1, 311.7, 74.7)),
        dot(seed, vec3(269.5, 183.3, 246.1)),
        dot(seed, vec3(113.5, 271.9, 124.6))
    );

	return fract(sin(p) * 43758.5453123);
}

#pragma glslify: export(rand3)
