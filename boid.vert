#version 430 compatibility

layout( std140, binding=4 ) buffer Pos
{
	vec4 Positions[ ];
};

layout( std140, binding=5 ) buffer Vel
{
	vec4 Velocities[ ];
};

out vec4	vColor;  // 
out float	vAngle;  // 

void 
main( )
{
	uint gid = gl_VertexID;

	float angle = -atan( Velocities[ gid ].x, Velocities[ gid ].y );

	vColor = vec4(
		1.0 - sin(angle + 1.0) - Velocities[ gid ].y,
		sin(angle) * cos(angle),
		Velocities[ gid ].x + cos(angle + 0.5),
		1.0
	);

	vAngle = -angle;

    gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}