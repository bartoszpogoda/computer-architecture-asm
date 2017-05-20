main : main.o funcC.o funcAsm.o
	gcc -m32 -o main main.o funcC.o funcAsm.o
main.o : main.c
	gcc -m32 -c main.c
funcC.o : ../lab4.1/funcC.c
	gcc -m32 -c -o funcC.o ../lab4.1/funcC.c
funcAsm.o : ../lab4.1/funcAsm.s
	gcc -m32 -c -o funcAsm.o ../lab4.1/funcAsm.s
