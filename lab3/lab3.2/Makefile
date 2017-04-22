printCounter : counter.o printCounter.o
	gcc -m32 -o printCounter printCounter.o counter.o
counter.o : counter.s
	gcc -m32 -c counter.s
printCounter.o : printCounter.c
	gcc -m32 -c -O3 printCounter.c
