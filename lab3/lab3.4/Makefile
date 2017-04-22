timeTest : timeTest.o memOpTimeTest.o counter.o
	gcc -m32 -o timeTest timeTest.o memOpTimeTest.o counter.o
timeTest.o : timeTest.c
	gcc -m32 -c timeTest.c
memOpTimeTest.o : memOpTimeTest.s
	gcc -m32 -c memOpTimeTest.s
counter.o : ../lab3.2/counter.s
	gcc -m32 -c ../lab3.2/counter.s
