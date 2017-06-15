#include <stdio.h>
#include <stdlib.h>

// function defined in memOpTimeTest.s (asm)
unsigned int memOpTimeTest(int* address);

int main(){
	const int size = 100000000;
	int *tab = calloc(size, sizeof(int));

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
	int printResultsEnd = resultsSize - 400;

	// find average cycle per operation
	int average = 0;
	for(i = printResultsStart; i < printResultsEnd; i++){
		average += firstAccessResults[i];
	}
	average = average/(printResultsEnd-printResultsStart);

	// print results
	for(i = printResultsStart; i < printResultsEnd ; i++){
		printf("F: %d  S: %d (%p) %s\n",firstAccessResults[i], secondAccessResults[i], tab+i,
			(firstAccessResults[i]>(average*2) ?"<--":"  "));
	}

	free(tab);
	free(firstAccessResults);
	free(secondAccessResults);

	return 0;
}
