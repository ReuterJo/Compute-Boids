#version 330 compatibility

// layout(location = 0) in vec4 Positions;
// layout(location = 4) in vec4 Velocities;

out vec4	vColor;  // 

void 
main( )
{
	// uint gid = gl_GlobalInvocationID.x;	// the .y and .z are both 1 in this case

	vec4 vert = gl_Vertex;

	//float angle = -atan2( Velocities[ gid ].x, Velocities[ gid ].y );
	//vec2 pos = vec2(
	//	(vert.x * cos(angle)) - (vert.y * sin(angle)),
	//	(vert.x * sin(angle)) + (vert.y * cos(angle))
  	//);

	//vert = vec4( pos + Positions[ gid ], 0.0, 1.0 );
	//vColor = vec4(
    //	1.0 - sin(angle + 1.0) - Velocities[ gid ].y,
    //	pos.x * 100.0 - Velocities[ gid ].y + 0.1,
    //	Velocities[ gid ].x + cos(angle + 0.5),
    //	1.0
	//);

	vColor = vec4( 1., 1., 1., 1. );

    gl_Position = gl_ModelViewProjectionMatrix * vert;
}