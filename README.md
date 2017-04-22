# Computer Architecture II - Assembly Programs
My assembly language programs for Computer Architecture 2 course

## Lab classes 1
 A program that **reads** byte input of not specified size and **processes** it
#### Details:
 **Processing:** if read byte is within 'A' - 'Z' ascii range then it should
 be cesar-shifted with some predefined shift value and then redirected
 to standard output, otherwise just redirected to standard output
 
## Lab classes 2
 A program that **sums**, **substracts** and **multiplies** two n-byte size operands
#### Details:
Input format: `[n][  numberA ][  numberB  ]`

Where:
  * **n** - 1-byte operands size (0-255 range)
  * **numberA** - n-byte NB number
  * **numberB** - n-byte NB number
  * LSB is to the left, MSB to the right

Output format: `[n][ sum ][ difference ][ B>A flag ][ product ]`
 
Where:
  - **n** - 1-byte operands size
  - **sum** - n+1-byte size addition result
  - **difference** - n-byte size numberA-numberB substraction result
  - followed by 1-byte **B>A flag** which indicates incorrect result
  - **product** - 2n-byte size numberA*numberB multiplication result
  - LSB is to the left, MSB to the right

## Lab classes 3
 C and assembly cross-language programs - working with Application Binary Interface.
### Task 1
 An assembly program that uses C functions - scanf and printf. Scanf and printf are tested for 3 types of arguments - number, character and string.
#### Details:
* function is `main` to make it GCC compatible
* it follows ABI rules
* gcc includes needed libraries on its own
### Task 2
 A C program that calls function defined in assembly. The assembly function returns processor's TSC (Time Stamp Counter) value.
#### Details:
* the cpuid instruction before TSC read is to guarantee that the processor will finish all instructions being executed
* according to ABI, 64-bit values can be returned in [%edx,%eax] set of 32-bit registers.
### Task 3
 Cross-language variable (memory) access.
#### Details:
1. define memory block in assembly and then use it in C
2. define variable in C and then use it in assemly
### Task 4
 Time measurments for write, printf C-functions using function implemented in **Task 2**. Also measurments of MOV memory operation time.
#### Details:
* times are given in processor cycles
