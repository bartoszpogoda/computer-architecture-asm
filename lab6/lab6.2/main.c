#include <stdio.h>
#include <stdlib.h>
// function defined in memOpTimeTest.s (asm)
unsigned int memOpTimeTest(char* address);

// goes through block twice!
void analyse(int blockSize, char* address, int average, int lineSize){
	int op_total = 0, op_miss = 0, i=0, it=0;

	printf("%d block: ", blockSize);

	for(it=0 ; it < 10 ; it++){
		for(i=0; i<blockSize; i += lineSize){
			if(memOpTimeTest(address+i) > average*3){
				op_miss++;
			}
			op_total++;
		}
	}

	printf("Miss ratio: %f\n",(float)op_miss/op_total);


}

int main(){
	const int size = 100000000;
	char *tab = calloc(size, sizeof(char));

	// structures to keep track of access times
	int resultsSize = 10000;
	int *firstAccessResults = calloc(resultsSize, sizeof(int));
	int *secondAccessResults = calloc(resultsSize, sizeof(int));

	// execution
	int i;
	for(i = 0; i < resultsSize ; i++){
		firstAccessResults[i] = memOpTimeTest(tab + i);
		secondAccessResults[i] = memOpTimeTest(tab + i);
	}

	// results data printed to screen
	int printResultsStart = resultsSize - 500;
	int printResultsEnd = resultsSize - 200;

	// find average cycle per operation
	int average = 0;
	for(i = printResultsStart; i < printResultsEnd; i++){
		average += firstAccessResults[i];
	}
	average = average/(printResultsEnd-printResultsStart);
	printf("Average is: %d cycles\n", average);
	// TIME > average*1.1  = miss
	// TIME <= average*1.1 = hit

	for(i = 100000 ; ; i *= 2){

		const int sz = 100000000;
		char *tabsz = calloc(sz, sizeof(char));
		int j = 0;
		for(j = 0; j < sz ; j++){
			tabsz[j] = tabsz[j] + 1;
		}

		char* tab = malloc(i*sizeof(char));
		analyse(i,tab,average,64);
		free(tab);
	}
}
