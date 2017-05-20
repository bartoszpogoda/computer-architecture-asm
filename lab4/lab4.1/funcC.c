#include <stdio.h>
#include <string.h>

extern short getControlWord();
extern short getStatusWord();
extern void setControlWord(short word);


const char *shortToBinaryString(int x)
{
    static char b[17];
    b[0] = '\0';

    int z;
    for (z = 32768; z > 0; z >>= 1)
    {
        strcat(b, ((x & z) == z) ? "1" : "0");
    }

    return b;
}

const char* getControlWordString(){
  return shortToBinaryString(getControlWord());
}

const char* getStatusWordString(){
  return shortToBinaryString(getStatusWord());
}

void modifyControlWord(int bit, int value){
	short word = getControlWord();

	short mask = 1 << bit;

	if(value == 0)
		word &= ~(mask);
	else
		word |= mask;


	setControlWord(word);
}
