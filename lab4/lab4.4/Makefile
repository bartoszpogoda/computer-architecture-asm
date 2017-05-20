main : main.o doubleToBinaryString.o funcC.o funcAsm.o
	gcc -m32 -o main main.o doubleToBinaryString.o funcC.o funcAsm.o
main.o : main.c
	gcc -m32 -c main.c
doubleToBinaryString.o : ../lab4.3/doubleToBinaryString.c
	gcc -m32 -c -o doubleToBinaryString.o ../lab4.3/doubleToBinaryString.c
funcC.o : ../lab4.1/funcC.c
	gcc -m32 -c -o funcC.o ../lab4.1/funcC.c
funcAsm.o : ../lab4.1/funcAsm.s
	gcc -m32 -c -o funcAsm.o ../lab4.1/funcAsm.s
