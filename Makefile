boid:		boid.cpp
		g++   -o boid   boid.cpp  -lGL -lGLU -lglut -lGLEW  -lm


save:
		cp boid.cpp boid.save.cpp
