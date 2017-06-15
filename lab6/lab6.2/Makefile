main : main.o memOpTimeTest.o
	gcc -m32 main.o memOpTimeTest.o -o main

main.o : main.c
	gcc -m32 -c -O3 main.c

memOpTimeTest.o : ../lab6.1/memOpTimeTest.s
	gcc -m32 -c ../lab6.1/memOpTimeTest.s
