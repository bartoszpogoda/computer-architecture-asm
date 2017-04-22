main : main.o cDef.o
	gcc -m32 -o main main.o cDef.o
main.o : main.s
	gcc -m32 -c main.s
cDef.o : cDef.c
	gcc -m32 -c cDef.c
