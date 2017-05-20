#include <stdio.h>

extern char* getStatusWordString();
extern char* getControlWordString();
extern void modifyControlWord(int bit, int value);

int main(){
	printf("Status word: %s \n", getStatusWordString());
	printf("Control word: %s \n", getControlWordString());

	// clear LSB
	modifyControlWord(0,0);
	printf("\nAfter clearing LSB: \n");
	printf("Control word: %s \n", getControlWordString());

	// set LSB
	modifyControlWord(0,1);
	printf("\nAfter setting LSB: \n");
	printf("Control word: %s \n", getControlWordString());
}
