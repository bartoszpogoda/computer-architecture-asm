.align 32

.data
  msgNum:
    .string "Enter num: "
  msgChar:
    .string "Enter char: "
  msgStr:
    .string "Enter str: "

  formatNumOut:
    .string "Your num: %d\n"
  formatCharOut:
    .string "Your char: %c\n"
  formatStrOut:
    .string "Your str: %s\n"

  formatNumIn:
    .string "%d"
  formatCharIn:
    .string " %c" # space skips optional whitespace
  formatStrIn:
    .string " %55[0-9a-zA-Z ]"
.text
  .global main

main:
  push %ebp
  mov %esp, %ebp

  sub $64, %esp
  #   STACK:
  #   -4(%ebp) - number
  #   -8(%ebp) - character
  #   -64(%ebp) - 56-byte string (ended with 00)

  # ---------------- NUMBER

  # input invitation
  pushl $msgNum
  call printf

  # input read
  lea -4(%ebp), %eax
  pushl %eax
  pushl $formatNumIn
  call scanf

  # input print
  pushl -4(%ebp)
  pushl $formatNumOut
  call printf

  # ---------------- CHARACTER

  # input invitation
  pushl $msgChar
  call printf

  # input readD
  lea -8(%ebp), %eax
  pushl %eax
  pushl $formatCharIn
  call scanf

  # input print
  pushl -8(%ebp)
  pushl $formatCharOut
  call printf

  # ------------------ STRING

  # input invitation
  pushl $msgStr
  call printf

  # input read
  lea -64(%ebp), %eax
  pushl %eax
  pushl $formatStrIn
  call scanf

  # input print
  lea -64(%ebp), %eax
  pushl %eax
  pushl $formatStrOut
  call printf


  mov %ebp, %esp
  pop %ebp
  ret
