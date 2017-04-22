.align 32

.data
  formatNumOut:
    .string "Number defined in C: %d\n"
.text
  .global main

main:
  push %ebp
  mov %esp, %ebp

  # print in-C-defined number
  pushl cNumber
  pushl $formatNumOut
  call printf

  mov %ebp, %esp
  pop %ebp
  ret
