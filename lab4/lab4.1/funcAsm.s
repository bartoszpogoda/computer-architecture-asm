.align 32

.text
  .global getControlWord, setControlWord, getStatusWord

# --------------------------------
# short getControlWord()
# --------------------------------
getControlWord:
  push %ebp
  mov %esp, %ebp
  push $0

  FSTCW -4(%ebp)

  pop %eax

  mov %ebp, %esp
  pop %ebp
  ret

# --------------------------------
# void setControlWord(short word)
# 8(%ebp) - word
# --------------------------------
setControlWord:
  push %ebp
  mov %esp, %ebp

  FLDCW 8(%ebp)

  pop %ebp
  ret

# --------------------------------
# short getStatusWord()
# --------------------------------
getStatusWord:
  push %ebp
  mov %esp, %ebp
  push $0

  FSTSW -4(%ebp)

  pop %eax

  mov %ebp, %esp
  pop %ebp
  ret
