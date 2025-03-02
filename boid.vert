#version 330 compatibility

uniform float   uLightX, uLightY, uLightZ;

uniform float    uTwistX;
uniform float    uTwistY;
uniform float    uTwistZ;

out vec3    vN;     // normal vector
out vec3    vL;     // vector from point to light 
out vec3 	vE;     // vector from point to eye
out float	vZ;     // depth in Z from eye position
out vec2	vST;	// (s,t) texture coordinates
out vec3	vMC;	// model coordinates

vec3        LIGHTPOSITION = vec3( uLightX, uLightY, uLightZ );

vec3
RotateX( vec3 xyz, float radians )
{
	float c = cos(radians);
	float s = sin(radians);
	vec3 newxyz = xyz;
	newxyz.yz = vec2(
		dot( xyz.yz, vec2( c,-s) ),
		dot( xyz.yz, vec2( s, c) )
	);
	return newxyz;
}

vec3
RotateY( vec3 xyz, float radians )
{
	float c = cos(radians);
	float s = sin(radians);
	vec3 newxyz = xyz;
	newxyz.xz =vec2(
		dot( xyz.xz, vec2( c,s) ),
		dot( xyz.xz, vec2(-s,c) )
	);
	return newxyz;
}

vec3
RotateZ( vec3 xyz, float radians )
{
	float c = cos(radians);
	float s = sin(radians);
	vec3 newxyz = xyz;
	newxyz.xy = vec2(
		dot( xyz.xy, vec2( c,-s) ),
		dot( xyz.xy, vec2( s, c) )
	);
	return newxyz;
}

void 
main( )
{
	vST = gl_MultiTexCoord0.st;

    vN = gl_Normal;
    vec4 vert = gl_Vertex;
	
	// Twist about X
	float r = abs(vert.x);
	float sign = vert.x / abs(vert.x);
	vert.xyz = RotateX( vert.xyz, sign*r*uTwistX );

	// Twist about Y
	r = abs(vert.y);
	sign = vert.y / abs(vert.y);
	vert.xyz = RotateY( vert.xyz, sign*r*uTwistY ); 

	// Twist about Z
	r = abs(vert.z);
	sign = vert.z / abs(vert.z);
	vert.xyz = RotateZ( vert.xyz, sign*r*uTwistZ );

	vMC = vert.xyz;

    vec4 ECposition = gl_ModelViewMatrix * vert;
    vL = LIGHTPOSITION - ECposition.xyz;
    vE = vec3( 0., 0., 0. ) - ECposition.xyz;
    vZ = -ECposition.z;

    gl_Position = gl_ModelViewProjectionMatrix * vert;
}