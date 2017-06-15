showImage : showimage.o filter.o counter.o
	gcc -m32 showimage.o filter.o counter.o -lSDL-1.2 -lSDL_image-1.2 -o showimage

showimage.o : showimage.c
	gcc -m32 -c -I/usr/include/SDL showimage.c

filter.o : filter.s
	gcc -m32 -c filter.s

counter.o : ../lab3/lab3.2/counter.s
	gcc -m32 -c ../lab3/lab3.2/counter.s
