#include <stdlib.h>

// (1/11/52)
char* doubleToBinaryString(double x){
	char* bytePointer = (char*) &x;
	int size = sizeof(double);

	char* result = malloc((8*size+3) * sizeof(char));

	int i,j,resultIterator = 0;
	for(i = size - 1 ; i >= 0 ; i--){
		for(j = 7 ; j >= 0 ; j--){
			result[resultIterator] = (((1 << j) & bytePointer[i]) ? '1' : '0');

			resultIterator++;
			if(resultIterator == 1 || resultIterator == 12){
				result[resultIterator] = ' ';
				resultIterator++;
			}
		}
	}

	result[resultIterator] = '\0';

	return result;
}
