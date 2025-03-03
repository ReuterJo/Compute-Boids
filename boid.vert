#version 430 compatibility

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

out vec4	vColor;  // 

void 
main( )
{
	uint gid = gl_InstanceID;

	vec4 vert = gl_Vertex;

	float angle = -atan( Velocities[ gid ].x, Velocities[ gid ].y );
	vec2 pos = vec2(
		(vert.x * cos(angle)) - (vert.y * sin(angle)),
		(vert.x * sin(angle)) + (vert.y * cos(angle))
  	);

	//vert = vec4( pos + Positions[ gid ].xy, 0.0, 1.0 );
	vColor = vec4(
    	1.0 - sin(angle + 1.0) - Velocities[ gid ].y,
    	pos.x * 100.0 - Velocities[ gid ].y + 0.1,
    	Velocities[ gid ].x + cos(angle + 0.5),
    	1.0
	);

    gl_Position = gl_ModelViewProjectionMatrix * vert;
}