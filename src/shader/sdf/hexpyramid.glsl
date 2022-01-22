precision mediump float;

float dot2( in vec3 v ) { return dot(v,v); }

float udTriangle( in vec3 v1, in vec3 v2, in vec3 v3, in vec3 p )
{
    vec3 v21 = v2 - v1; vec3 p1 = p - v1;
    vec3 v32 = v3 - v2; vec3 p2 = p - v2;
    vec3 v13 = v1 - v3; vec3 p3 = p - v3;
    vec3 nor = cross( v21, v13 );

    return sqrt( (sign(dot(cross(v21,nor),p1)) + 
                  sign(dot(cross(v32,nor),p2)) + 
                  sign(dot(cross(v13,nor),p3))<2.0) 
                  ?
                  min( min( 
                  dot2(v21*clamp(dot(v21,p1)/dot2(v21),0.0,1.0)-p1), 
                  dot2(v32*clamp(dot(v32,p2)/dot2(v32),0.0,1.0)-p2) ), 
                  dot2(v13*clamp(dot(v13,p3)/dot2(v13),0.0,1.0)-p3) )
                  :
                  dot(nor,p1)*dot(nor,p1)/dot2(nor) );
}

vec3 rotateY(vec3 center, vec3 p, float rot ){
    vec3 cp = p - center;
    return vec3(
            cp.x*cos(rot)-cp.z*sin(rot),
            cp.y*1.,
            cp.x*sin(rot)+cp.z*cos(rot)
        ) + center;
}

float sdHexPyramid (vec3 p, vec2 h){
    vec3 tr = vec3(0, 0, 0);

    // scale and translate
    vec3 A = normalize(vec3(0.1, 0, 0)) * h.x + tr;
    vec3 C = normalize(vec3(0, 1.2, 0)) * h.y + tr;
    vec3 D = normalize(vec3(0.5, 0, 0.866)) * h.x + tr;

    float d = 100.;
    for (float i = 0.; i <= 2.*3.1415; i+=3.1415/3.){
        float ADC = udTriangle(rotateY(tr,A,i), rotateY(tr,D,i), C, p);
        d = min(d, ADC);
    }
    
    return d;
}

#pragma glslify: export(sdHexPyramid)