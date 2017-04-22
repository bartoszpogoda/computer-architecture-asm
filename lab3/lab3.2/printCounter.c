#include <stdio.h>

// function defined in counter.s (asm)
unsigned long long int counter();

int main(){
	printf("Current counter value: %llu\n",counter());
	return 0;
}
