precision mediump float;

// constants for the camera tunnel
const vec2 cama=vec2(-2.6943,3.0483);
const vec2 camb=vec2(0.2516,0.1749);
const vec2 camc=vec2(-3.7902,2.4478);
const vec2 camd=vec2(0.0865,-0.1664);

const vec2 lighta=vec2(1.4301,4.0985);
const vec2 lightb=vec2(-0.1276,0.2347);
const vec2 lightc=vec2(-2.2655,1.5066);
const vec2 lightd=vec2(-0.1284,0.0731);

// calculates the position of a single tunnel
vec2 Position(float z, vec2 a, vec2 b, vec2 c, vec2 d)
{
	return sin(z*a)*b+cos(z*c)*d;
}

// calculates 3D positon of a tunnel for a given time
vec3 Position3D(float time, vec2 a, vec2 b, vec2 c, vec2 d)
{
	return vec3(Position(time,a,b,c,d),time);
}

// 2d distance field for a slice of a single tunnel
float Distance(vec3 p, vec2 a, vec2 b, vec2 c, vec2 d, vec2 e, float r)
{
	vec2 pos=Position(p.z,a,b,c,d);	
	float radius=max(5.0,r+sin(p.z*e.x)*e.y)/10000.0;
	return radius/dot(p.xy-pos,p.xy-pos);
}

// 2d distance field for a slice of the tunnel network
float sdCave(vec3 pos)
{
	float d=0.0;
	
	d+=Distance(pos,cama,camb,camc,camd,vec2(2.1913,15.4634),70.0000);
	d+=Distance(pos,lighta,lightb,lightc,lightd,vec2(0.3814,12.7206),17.0590);
	d+=Distance(pos,vec2(2.7377,-1.2462),vec2(-0.1914,-0.2339),vec2(-1.3698,-0.6855),vec2(0.1049,-0.1347),vec2(-1.1157,13.6200),27.3718);
	d+=Distance(pos,vec2(-2.3815,0.2382),vec2(-0.1528,-0.1475),vec2(0.9996,-2.1459),vec2(-0.0566,-0.0854),vec2(0.3287,12.1713),21.8130);
	d+=Distance(pos,vec2(-2.7424,4.8901),vec2(-0.1257,0.2561),vec2(-0.4138,2.6706),vec2(-0.1355,0.1648),vec2(2.8162,14.8847),32.2235);
	d+=Distance(pos,vec2(-2.2158,4.5260),vec2(0.2834,0.2319),vec2(4.2578,-2.5997),vec2(-0.0391,-0.2070),vec2(2.2086,13.0546),30.9920);
	d+=Distance(pos,vec2(0.9824,4.4131),vec2(0.2281,-0.2955),vec2(-0.6033,0.4780),vec2(-0.1544,0.1360),vec2(3.2020,12.2138),29.1169);
	d+=Distance(pos,vec2(1.2733,-2.4752),vec2(-0.2821,-0.1180),vec2(3.4862,-0.7046),vec2(0.0224,0.2024),vec2(-2.2714,9.7317),6.3008);
	d+=Distance(pos,vec2(2.6860,2.3608),vec2(-0.1486,0.2376),vec2(2.0568,1.5440),vec2(0.0367,0.1594),vec2(-2.0396,10.2225),25.5348);
	d+=Distance(pos,vec2(0.5009,0.9612),vec2(0.1818,-0.1669),vec2(0.0698,-2.0880),vec2(0.1424,0.1063),vec2(1.7980,11.2733),35.7880);
	
	return d;
}

#pragma glslify: export(sdCave)
