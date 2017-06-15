main : main.o memOpTimeTest.o 
	gcc -m32 main.o memOpTimeTest.o -o main

main.o : main.c
	gcc -m32 -c -O3 main.c

memOpTimeTest.o : memOpTimeTest.s
	gcc -m32 -c memOpTimeTest.s
