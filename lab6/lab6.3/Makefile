main : main.o counter.o 
	gcc -m32 main.o counter.o -o main

main.o : main.c
	gcc -m32 -c -O3 main.c

counter.o : counter.s
	gcc -m32 -c counter.s
