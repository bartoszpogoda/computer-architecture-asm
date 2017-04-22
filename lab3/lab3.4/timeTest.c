#include <stdio.h>
#include <unistd.h>

// function defined in counter.s (asm)
unsigned long long int counter();
// function defined in memOpTimeTest.s (asm)
unsigned long long int memOpTimeTest();

int main(){
	unsigned long long int currentCounter = 0;
	int iterations = 10, i = 0;
	char c = ' ';

	printf("Measurments of 'space' chracter display:\n\n");

	for(i=0; i<iterations; i++){
		currentCounter = counter();
		write(1,&c,1);
		currentCounter = counter() - currentCounter;
		printf("write: Result in %d. iteration: %llu\n", i+1, currentCounter);
	}

	printf("\n");

	for(i=0; i<iterations; i++){
		currentCounter = counter();
		printf("%c",c);
		currentCounter = counter() - currentCounter;
		printf("printf: Result in %d. iteration: %llu\n", i+1, currentCounter);
	}

	printf("\n");

	printf("Measurments of memory operations:\n\n");

	for(i=0; i<iterations; i++){
		unsigned int memResult = memOpTimeTest();
		printf(" memory: Result in %d. iteration: %zu\n", i+1, memResult);
	}

	return 0;
}
