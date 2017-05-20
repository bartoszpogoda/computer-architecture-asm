#include <stdio.h>

extern void modifyControlWord(int bit, int value);
extern char* getControlWordString();
extern char* doubleToBinaryString(double);


/* Round tonearest (even) 00B
(toward −∞ ) 01B
(toward +∞ ) 10B
zero (Truncate) 11B . */

/* 11-10 precision control bits */

int main(){
	//double a = 1.23;
	double a = 2.76;
	double b = 2.12;
	double c;

	printf("a = %s \n", doubleToBinaryString(a));
	printf("b = %s \n", doubleToBinaryString(b));
	printf("c = a + b \n");

	// double extended precision
	modifyControlWord(9,1);
	modifyControlWord(8,1);

	c = a+b;
	printf("c = %s \n", doubleToBinaryString(c));


	// set single precision
	modifyControlWord(9,0);
	modifyControlWord(8,0);

	// set round toward +inf
	modifyControlWord(11,1);
	modifyControlWord(10,0);
	printf("\nRound toward +oo: \n");
	printf("Control word: %s \n", getControlWordString());

	c = a+b;

	printf("c = %s \n", doubleToBinaryString(c));

	// set round toward -inf
	modifyControlWord(11,0);
	modifyControlWord(10,1);
	printf("\nRound toward -oo: \n");
	printf("Control word: %s \n", getControlWordString());

	c = a+b;

	printf("c = %s \n", doubleToBinaryString(c));


}
