main : main.o asmDef.o
	gcc -m32 -o main main.o asmDef.o
main.o : main.c
	gcc -m32 -c main.c
asmDef.o : asmDef.s
	gcc -m32 -c asmDef.s
