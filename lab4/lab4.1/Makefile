main : main.o funcC.o funcAsm.o
	gcc -m32 -o main main.o funcC.o funcAsm.o

main.o : main.c
	gcc -m32 -c main.c

funcC.o : funcC.c
	gcc -m32 -c funcC.c

funcAsm.o : funcAsm.s
	gcc -m32 -c funcAsm.s
