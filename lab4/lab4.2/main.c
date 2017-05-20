#include <stdio.h>

extern char* getStatusWordString();

int main(){
	printf("Before operations\n");
	printf("Status word: %s \n", getStatusWordString());
	printf("\nTrying to divide by zero\n");

	double a = 32.12312;
	a = a/0;

	printf("After first operation\n");
	printf("Status word: %s \n", getStatusWordString());

	printf("\nTrying to cause overflow\n");

	double b = 1.23*2;
	int i = 1000;
	while(i--){
		b *= 2;
	}

	b = b * b;

	printf("After second operation\n");
	printf("Status word: %s \n", getStatusWordString());
}
