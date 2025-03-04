#version 430 compatibility

in vec4         tesColor;  // color vector

void 
main( )
{

        gl_FragColor = tesColor;
}