#version 330 compatibility

// lighting uniform variables -- these can be set once and left alone:
uniform float   uKa, uKd, uKs;	 // coefficients of each type of lighting -- make sum to 1.0
uniform float   uShininess;	 // specular exponent

// ChromaDepth uniform variables
uniform float uRedDepth, uBlueDepth;

// Hatching varaibles
uniform float uP;
uniform float uWidth;
uniform float uTol;

in vec3 		vN;     // normal vector
in vec3 		vL;     // vector from point to light 
in vec3 		vE;     // vector from point to eye
in float		vZ;     // depth in Z from eye position
in vec2                 vST;    // (s,t) texture coordinates
in vec3                 vMC;    // model coordinates

// color variables
const vec3 OBJECTCOLOR		= vec3( 0.8, 0.2, 0.8 );
const vec3 SPECULARCOLOR 	= vec3( 1., 1., 1. );
const vec3 WHITE                = vec3( 1., 1., 1. );

vec3
Rainbow( float t )
{
        t = clamp( t, 0., 1. );         // 0.00 is red, 0.33 is green, 0.67 is blue

        float r = 1.;
        float g = 0.0;
        float b = 1.  -  6. * ( t - (5./6.) );

        if( t <= (5./6.) )
        {
                r = 6. * ( t - (4./6.) );
                g = 0.;
                b = 1.;
        }

        if( t <= (4./6.) )
        {
                r = 0.;
                g = 1.  -  6. * ( t - (3./6.) );
                b = 1.;
        }

        if( t <= (3./6.) )
        {
                r = 0.;
                g = 1.;
                b = 6. * ( t - (2./6.) );
        }

        if( t <= (2./6.) )
        {
                r = 1.  -  6. * ( t - (1./6.) );
                g = 1.;
                b = 0.;
        }

        if( t <= (1./6.) )
        {
                r = 1.;
                g = 6. * t;
        }

        return vec3( r, g, b );
}

float
SmoothPulse( float left, float right,   float value, float tol )
{
	float t =	smoothstep( left-tol,  left+tol,  value )  -
			smoothstep( right-tol, right+tol, value );
	return t;
}

void 
main( )
{


	// Default enable ChromaDepth
	float t = (2./3.) * ( abs(vZ) - uRedDepth ) / ( uBlueDepth - uRedDepth );
	t = clamp( t, 0., 2./3. );
	vec3 myColor = Rainbow( t );

        // Add hatching pattern
        float numins = int( vST.s / uWidth );
        float sC = numins * uWidth + ( uWidth / 2. );
        float sNorm = (vST.s - sC) / ( uWidth / 2. );
        float tp = SmoothPulse( 0.5-uP, 0.5+uP, sNorm, uTol );

        myColor = mix( WHITE, myColor, tp );
	
	// apply the per-fragmewnt lighting to myColor:
	vec3 Normal = normalize(gl_NormalMatrix * vN);
	vec3 Light  = normalize(vL);
	vec3 Eye    = normalize(vE);

	vec3 ambient = uKa * myColor;

	float dd = max( dot(Normal,Light), 0. );       // only do diffuse if the light can see the point
	vec3 diffuse = uKd * dd * myColor;

	float s = 0.;
	if( dd > 0. )	      // only do specular if the light can see the point
	{
		vec3 ref = normalize(  reflect( -Light, Normal )  );
		float cosphi = dot( Eye, ref );
		if ( cosphi > 0. )
			s = pow( max( cosphi, 0. ), uShininess );
	}
	vec3 specular = uKs * s * SPECULARCOLOR;
	gl_FragColor = vec4( ambient + diffuse + specular,  1. );
}