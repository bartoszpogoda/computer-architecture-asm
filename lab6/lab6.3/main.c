#include <stdio.h>
#include <stdlib.h>

// function defined in counter.s (lab 3.2)
extern unsigned long long int counter();

const int MATRIX_SIZE = 1000;

int main(){
	unsigned long long int currentCounter = 0;
	int i,j,it;

	int *matrix = (int*)calloc(MATRIX_SIZE*MATRIX_SIZE,sizeof(int));

	int iterations = 5;

	printf("Operations on: %d x %d matrix of %d-byte elements\n", MATRIX_SIZE, MATRIX_SIZE, sizeof(matrix[0]));
	printf("Total size: %d bytes\n\n", MATRIX_SIZE*MATRIX_SIZE*sizeof(matrix[0]));

	printf("Row after row iteration:  \n");

	for(it=0; it<iterations; it++){
		currentCounter = counter();

		for(i = 0; i < MATRIX_SIZE ; i++){
			for(j = 0; j < MATRIX_SIZE ; j++){
				matrix[i*MATRIX_SIZE+j] += 1;
			}
		}

		currentCounter = counter() - currentCounter;

		printf("Iteration: %d | Result: %llu cycles | Avg cycles per operation: %.2f\n"
					,it+1, currentCounter, (float)currentCounter/MATRIX_SIZE/MATRIX_SIZE);
	}

	printf("\nColumn after column iteration:  \n");

	for(it=0; it<iterations; it++){
		currentCounter = counter();

		for(i = 0; i < MATRIX_SIZE ; i++){
			for(j = 0; j < MATRIX_SIZE ; j++){
				matrix[j*MATRIX_SIZE+i] += 1;
			}
		}

		currentCounter = counter() - currentCounter;

		printf("Iteration: %d | Result: %llu cycles | Avg cycles per operation: %.2f\n"
					,it+1, currentCounter, (float)currentCounter/MATRIX_SIZE/MATRIX_SIZE);
	}

	free(matrix);

	return 0;
}
