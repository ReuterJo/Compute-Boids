#version 430 compatibility
#extension GL_ARB_compute_shader:			        enable
#extension GL_ARB_shader_storage_buffer_object:		enable

layout( std140, binding=4 ) buffer Pos
{
	vec4 Positions[ ];
};

layout( local_size_x = 128, local_size_y = 1, local_size_z = 1 ) in;

layout( std140, binding=5 ) buffer Vel
{
	vec4 Velocities[ ];
};

layout( local_size_x = 128, local_size_y = 1, local_size_z = 1 ) in;

uniform int     uNumBoids;
uniform float   uXMax;
uniform float   uXMin;
uniform float   uYMax;
uniform float   uYMin;
uniform float   uDeltaT;
uniform float   uRule1Distance;
uniform float   uRule2Distance;
uniform float   uRule3Distance;
uniform float   uRule1Scale;
uniform float   uRule2Scale;
uniform float   uRule3Scale;

float
distance( vec2 pos1, vec2 pos2 )
{
    float dx = pos1.x - pos2.x;
    float dy = pos1.y - pos2.y;
    return sqrt( dx * dx + dy * dy );
}

float
clamp( float vel, float minVel, float maxVel )
{
    if( vel > maxVel )
    {
        return maxVel;
    }
    if( vel < minVel )
    {
        return minVel;
    }
    return vel;
}

float 
length( vec2 vel )
{
    return sqrt( vel.x * vel.x + vel.y * vel.y );
}

void
main( )
{
    uint gid = gl_GlobalInvocationID.x;	// the .y and .z are both 1 in this case

    vec2 vPos = Positions[ gid ].xy;
    vec2 vVel = Velocities[ gid ].xy;
    vec2 cMass = vec2( 0., 0. );
    vec2 cVel = vec2( 0., 0. );
    vec2 colVel = vec2( 0., 0. );
    int cMassCount;
    int cVelCount;
    vec2 pos;
    vec2 vel;

    for( int i = 0; i < uNumBoids; i++ )
    {
        if( i == gid )
        {
            continue;
        }

        pos = Positions[ i ].xy;
        vel = Velocities[ i ].xy;
        if( distance(pos, vPos) < uRule1Distance )
        {
            cMass += pos;
            cMassCount++;
        }
        if( distance(pos, vPos) < uRule2Distance )
        {
            colVel -= pos - vPos;
        }
        if( distance(pos, vPos) < uRule3Distance )
        {
            cVel += vel;
            cVelCount++;
        }
    }
    if( cMassCount > 0 )
    {
        cMass = ( cMass / vec2( float(cMassCount), float(cMassCount))) - vPos;
    }
    if( cVelCount > 0 )
    {
        cVel /= float(cVelCount);
    }
    vVel += (cMass * uRule1Scale) + (colVel * uRule2Scale) + (cVel * uRule3Scale);

    // clamp velocity for a more pleasing simulation
    vVel = normalize(vVel) * clamp(length(vVel), 0.0, 0.1);
    // kinematic update
    vPos = vPos + (vVel *uDeltaT);
    // Wrap around boundary
    if( vPos.x < uXMin ) 
    {
        vPos.x = uXMax;
    }
    if( vPos.x > uXMax )
    {
        vPos.x = uXMin;
    }
    if( vPos.y < uYMin )
    {
        vPos.y = uYMax;
    }
    if( vPos.y > uYMax )
    {
        vPos.y = uYMin;
    }
    // Write back
    Positions[ gid ] = vec4( vPos, 0., 1. );
    Velocities[ gid ] = vec4( vVel, 0., 1. );
}