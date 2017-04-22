#include <stdio.h>

extern int asmNumber;

int main(){

  printf("Number defined in assembly: %d\n", asmNumber);
  return 0;
}
