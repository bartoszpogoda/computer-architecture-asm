#include <stdio.h>

extern void modifyControlWord(int bit, int value);
extern char* getControlWordString();
extern char* doubleToBinaryString(double);


/* Single Precision (24-Bits) 00B
Reserved 01B
Double Precision (53-Bits) 10B
Double Extended Precision (64-Bits) 11B */

/* 9-8 precision control bits */

int main(){
	//double a = 1.23;
	double a = 2;
	double b = 4.38;
	double c;

	printf("a = %s \n", doubleToBinaryString(a));
	printf("b = %s \n", doubleToBinaryString(b));
	printf("c = a + b \n");

	// double extended precision
	modifyControlWord(9,1);
	modifyControlWord(8,1);

	printf("\nDouble extended precision: \n");
	printf("Control word: %s \n", getControlWordString());

	c = a+b;

	printf("c = %s \n", doubleToBinaryString(c));

	// single precision
	modifyControlWord(9,0);
	modifyControlWord(8,0);
	printf("\nSingle precision: \n");
	printf("Control word: %s \n", getControlWordString());

	c = a+b;

	printf("c = %s \n", doubleToBinaryString(c));
}
