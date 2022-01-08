#version 300 es
precision mediump float;
out vec4 colorOut;
uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;


/***
 *
 * macro
 *
 */
float nlPlus(vec3 n, vec3 l) { return max(dot(n, l), 0.0); }

vec3 NToF0(vec3 N) { return pow((N - 1.0) / (N + 1.0), vec3(2)); }

vec3 F0ToN(vec3 F0) { return (1.0 - F0) / (1.0 + F0 + 2.0 * sqrt(F0)); }


/***
 *
 * const
 *
 */
const float PI = 3.14159265358979324;
const vec3 ICE_F0 = vec3(0.018);
const vec3 SILVER_F0 = vec3(0.972, 0.960, 0.915);
const vec3 ICE_TO_SILVER_F0 = vec3(0.963, 0.948, 0.890);
const vec3 STONE_F0 = vec3(0.045);


/***
 *
 * parameters
 *
 */
// camera
const vec3 cameraPos = vec3(0.6);
const vec3 cameraDir = normalize(vec3(-1));
const vec3 cameraUp = normalize(vec3(-1, 1, -1));
const float cameraTargetDepth = 0.9;  // カメラのズーム倍率？

// sky
const vec3 skyColor1 = vec3(0.0, 0.5, 0.8);

// floor
const vec3 floorColor1 = vec3(0.2);
const vec3 floorColor2 = vec3(0.8);
const float floorFreq = 10.0;
const vec3 floorShapeN3 = normalize(vec3(0, 1, 0));
const float floorShapeW = 0.5;
const vec3 floorF0 = STONE_F0;
const float floorRoughness = 0.5;

// object
const vec3 objShapeB = vec3(0.5, 0.3, 0.3);
const float objShapeR = 0.08;
const float objExternalThickness = 0.1;
const vec3 objF0 = ICE_F0;
const vec3 objInternalF0 = ICE_TO_SILVER_F0;
const float objRoughness = 0.0;
const float objInternalRoughness = 0.0;
const vec3 objColor = vec3(0, 0.3, 0.7);
const vec3 objInternalColor = vec3(0.0);
const vec3 objExtinct = vec3(0);
const float objCoverage = 0.0;

// raymarch
const float nearLen = 0.0;
const float farLen = 5.0;
const int maxStep = 256;
const float eps = 0.000001;

// light
const vec3 lightPos = vec3(1, 1, 1);
const vec3 lightColor = vec3(1);


/***
 *
 * camera
 *
 */
struct Camera {
    vec3 pos;
    vec3 dir;
    vec3 up;
    vec3 side;
};

Camera makeCamera() {
    return Camera(cameraPos, cameraDir, cameraUp, cross(cameraDir, cameraUp));
}


/***
 *
 * ray
 *
 */
struct Ray {
    vec3 origin;
    vec3 dir;
};

vec3 end(Ray ray, float t) { return ray.origin + t * ray.dir; }


/***
 *
 * BRDF
 *
 */
vec3 fresnelSchlick(vec3 n, vec3 l, vec3 F0) { return F0 + (1.0 - F0) * pow(1.0 - nlPlus(n, l), 5.0); }

float ndfGGX(vec3 n, vec3 m, float roughness) {
   float nm = dot(n, m);
   float ag2 = pow(roughness, 2.0);
   return step(0.0, nm) * ag2 / (PI * pow(1.0 + pow(nm, 2.0) * (ag2 - 1.0), 2.0));
}

vec3 lambdaGGX(vec3 v) { return (-1.0 + sqrt(1.0 + 1.0 / pow(v, vec3(2)))) * 0.5; }

vec3 maskingSmithGGX(vec3 v, vec3 m) { return step(0.0, dot(m, v)) / (1.0 + lambdaGGX(v)); }

vec3 brdf(vec3 l, vec3 v, vec3 n, vec3 albedo, vec3 F0, float roughness) {
    vec3 h = normalize(l + v);
    vec3 fspec = (
        fresnelSchlick(n, l, F0)
        * maskingSmithGGX(v, h)
        * ndfGGX(n, h, roughness)
        / 4.0
        / abs(dot(n, l) * dot(n, v))
    );

    return albedo / PI + fspec;
}


/***
 *
 * sdf
 *
 */
float sdAdd(float d1, float d2) { return min(d1, d2); }

float sdRound(float d, float r) { return d - r; }

float sdPlane(vec3 p, vec4 n) { return dot(p, n.xyz) + n.w; }

float sdBox(vec3 p, vec3 b)
{
    vec3 q = abs(p) - b;
    return length(max(q, 0.0)) + min(max(q.x, max(q.y, q.z)), 0.0);
}

float sdObj(vec3 p) { return sdRound(sdBox(p, objShapeB), objShapeR); }

float sdObjInternal(vec3 p) { return sdRound(sdBox(p, objShapeB - vec3(objExternalThickness)), objShapeR); }

float sdBg(vec3 p) { return sdPlane(p, vec4(floorShapeN3, floorShapeW)); }

float scene(vec3 p) { return sdAdd(sdObj(p), sdBg(p)); }

vec3 normal(vec3 p) {
    const vec2 e = vec2(0.0001, 0.0);
    return normalize(
        vec3(
            scene(p + e.xyy) - scene(p - e.xyy),
            scene(p + e.yxy) - scene(p - e.yxy),
            scene(p + e.yyx) - scene(p - e.yyx)
        )
    );
}

vec3 normalInternal(vec3 p) {
    const vec2 e = vec2(0.0001, 0.0);
    return normalize(
        vec3(
            sdObjInternal(p + e.xyy) - sdObjInternal(p - e.xyy),
            sdObjInternal(p + e.yxy) - sdObjInternal(p - e.yxy),
            sdObjInternal(p + e.yyx) - sdObjInternal(p - e.yyx)
        )
    );
}

vec3 normalBg(vec3 p) {
    const vec2 e = vec2(0.0001, 0.0);
    return normalize(
        vec3(
            sdBg(p + e.xyy) - sdBg(p - e.xyy),
            sdBg(p + e.yxy) - sdBg(p - e.yxy),
            sdBg(p + e.yyx) - sdBg(p - e.yyx)
        )
    );
}


/***
 *
 * color
 *
 */
vec3 skyColor() { return skyColor1; }

vec3 floorColor(vec3 p) {
    vec2 xz = floor(p.xz * floorFreq);
    return mod(xz[0] + xz[1], 2.0) == 0.0 ? floorColor1 : floorColor2;
}

vec3 bgColor(vec3 p) { return floorColor(p); }

vec3 transmittanceVector(vec3 extinct, float d) { return exp(-extinct * d); }

vec3 translucentColor(vec3 cs, vec3 cb, vec3 extinct, float d, float coverage) {
    return mix(cb, cs + transmittanceVector(extinct, d) * cb, coverage);
}

vec3 pointLight(vec3 l, vec3 v, vec3 n, vec3 clight, vec3 albedo, vec3 F0, float roughness) {
    return PI * brdf(l, v, n, albedo, F0, roughness) * clight * nlPlus(n, l);
}

vec3 calcReflectColor(vec3 l, vec3 v, vec3 n, vec3 clight, vec3 albedo, vec3 F0, float roughness) {
    return pointLight(l, v, n, clight, albedo, F0, roughness);
}

vec3 calcRefractColor(
    vec3 n, vec3 reflectDir, vec3 clight, vec3 albedo, vec3 F0, vec3 extinct, float d, float coverage
) {
    vec3 F = fresnelSchlick(n, reflectDir, F0);
    vec3 energyCoef = (1.0 - F) / pow(F0ToN(F0), vec3(2));
    return energyCoef * translucentColor(albedo, clight, extinct, d, coverage);
}

vec3 calcBgOrSkyColor(Ray ray) {
    float t = nearLen;
    float h;
    bool isSky = true;
    for (int i = 0; i < maxStep; i++, t += h) {
        // 遠点まで光線がヒットせず
        if (t > farLen) break;

        // 光線の終点とそこでの符号距離を求める
        vec3 rayEnd = end(ray, t);
        h = sdBg(rayEnd);

        // 光線が背景にヒット
        if (abs(h) < eps) {
            isSky = false;
            break;
        }
    }

    // 光線がヒットしなかったので空と判定
    if (isSky) return skyColor();

    // 光線がヒットした点の背景の色を求める
    // カメラ->背景->光源のみ考慮
    vec3 rayEnd = end(ray, t);
    vec3 l = normalize(lightPos - rayEnd);
    vec3 v = -ray.dir;
    vec3 n = normalBg(rayEnd);
    return calcReflectColor(l, v, n, lightColor, bgColor(rayEnd), floorF0, floorRoughness);
}


/***
 *
 * main
 *
 */
vec3 raymarch(Ray ray) {
    float t = nearLen;
    float h;
    for (int i = 0; i < maxStep; i++, t += h) {
        // 遠点まで光線がヒットせず
        if (t > farLen) break;

        // 光線の終点とそこでの符号距離を求める
        vec3 rayEnd = end(ray, t);
        h = scene(rayEnd);

        // 光線がヒットしなかったら光線を伸ばして次へ
        if (abs(h) > eps) continue;

        vec3 l = normalize(lightPos - rayEnd);
        vec3 v = -ray.dir;
        vec3 n = normal(rayEnd);

        // 光線が背景にヒット
        // カメラ->背景->光源のみ考慮
        if (abs(sdBg(rayEnd)) < eps) {
            return calcReflectColor(l, v, n, lightColor, bgColor(rayEnd), floorF0, floorRoughness);
        }

        // 光線がオブジェクトにヒット後，反射
        // カメラ->オブジェクト->光源のみ考慮
        // NOTE: 添字の1は反射を表す（2は屈折）
        vec3 c1 = calcReflectColor(l, v, n, lightColor, objColor, objF0, objRoughness);

        // 光線がオブジェクトにヒット後，屈折
        // 屈折光はそのままオブジェクト外に出す
        // 半透明効果は無視する（d=0）
        // とりあえず青のF0値のみ使う
        vec3 reflectDir = reflect(ray.dir, n);
        vec3 refractDir = refract(ray.dir, n, F0ToN(objF0).b);
        Ray ray2 = Ray(rayEnd, refractDir);
        vec3 c2 = calcRefractColor(
            n, reflectDir, calcBgOrSkyColor(ray2), objColor, objF0, objExtinct, 0.0, objCoverage
        );

        return c1 + c2;
    }

    // 光線がヒットしなかったので空と判定
    return skyColor();
}

void main() {
    vec2 p2 = 2.0 * gl_FragCoord.xy / resolution - 1.0;
    Camera camera = makeCamera();
    Ray ray = Ray(camera.pos, normalize(camera.side * p2.x + camera.up * p2.y + camera.dir * cameraTargetDepth));

    vec3 color = raymarch(ray);
    colorOut = vec4(color, 1);
}
