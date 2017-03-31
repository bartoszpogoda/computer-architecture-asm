# computer-architecture-asm
My assembly language programs for Computer Architecture 2 course

lab-1)
 A program that reads byte input of not specified size and processes it

 Processing: if read byte is within 'A' - 'Z' ascii range then it should
 be cesar-shifted with some predefined shift value and then redirected
 to standard output, otherwise just redirected to standard output
 
lab-2)
 A program that sums, substracts and multiplies two n-byte size operands

 Input format: [n][  numberA ][  numberB  ]
 Where:
  - n - 1-byte operands size (0-255 range)
  - numberA - n-byte NB number
  - numberB - n-byte NB number
  - LSB is to the left, MSB to the right

 Output format: [n][ sum ][ difference ][ B>A flag ][ product ]
 Where:
  - n - 1-byte operands size
  - sum - n+1-byte size addition result
  - difference - n-byte size numberA-numberB substraction result
  - followed by 1-byte B>A flag which indicates incorrect result
  - product - 2n-byte size numberA*numberB multiplication result
  - LSB is to the left, MSB to the right
