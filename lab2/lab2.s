#-------------------------------------------------------------------------------
# A program that sums, substracts and multiplies two n-byte size operands
#
# Input format: [n][numberA][numberB]
#	n - 1-byte operands size (0-255 range)
# numberA - n-byte NB number
# numberB - n-byte NB number
# LSB is to the left
#
# Output format: [n][sum][difference][B>A flag][product]
# n - 1-byte operands size
# sum - n+1-byte size addition result
# difference - n-byte size numberA-numberB substraction result
# followed by 1-byte B>A flag which indicates incorrect result
# product - 2n-byte size numberA*numberB multiplication result
# LSB is to the left
#-------------------------------------------------------------------------------

SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4

STDIN = 0
STDOUT = 1

SYSCALL = 0x80
EXIT_SUCCESS = 0

MAX_INPUT_SIZE = 0xFF

.align 32

.data
	dataSize: .byte 0x00
	lastDataIndex: .byte 0x00	# for faster access in multiplication algorithm
	readingCounter: .byte 0x00
	readingAflag: .byte 0x01	# flag that indicates A-reading
	outputBuffer: .byte 0x00

.bss
	.lcomm numberA, MAX_INPUT_SIZE
	.lcomm numberB, MAX_INPUT_SIZE
	.lcomm multiplied, MAX_INPUT_SIZE*2

.text
	.global _start
_start:
	# dbg adresses controll for memory view
	mov $0, %rax
	mov $dataSize, %eax
	mov $numberA, %eax
	mov $numberB, %eax
	mov $multiplied, %eax

	# read first stdin byte to dataSize
	mov $SYSREAD, %eax
	mov $STDIN, %ebx
	mov $dataSize, %ecx
	mov $1, %edx
	int $SYSCALL

	# set up for numberA read
	movb dataSize, %al
	movb %al, readingCounter
	mov $numberA, %ecx

loadingLoop:
	cmpb $0, (readingCounter)
	je afterLoadingLoop

	# read one stdin byte to current number
	mov $SYSREAD, %eax
	mov $STDIN, %ebx
	mov $1, %edx
	int $SYSCALL

	decb (readingCounter)
	add $1, %ecx
	jmp loadingLoop

afterLoadingLoop:
	# check if both A and B numbers were loaded
	cmpb $0, (readingAflag)
	je dataProcessing

	# set up for numberB read
	decb (readingAflag)
	mov (dataSize), %al
	mov %al, (readingCounter)
	mov $numberB, %ecx
	jmp loadingLoop

dataProcessing:
	# print data size to STDOUT
	mov $SYSWRITE, %eax
	mov $STDOUT, %ebx
	mov $dataSize, %ecx
	mov $1, %edx
	int $SYSCALL

	# ------------------------------- ADDITION -----------------------------------
	# set up for addition operation
	clc
	pushf
	mov $0, %ecx
additionLoop:
	cmpb (dataSize), %cl
	je afterAdditionLoop

	movb numberA(,%ecx,1), %al
	popf
	adcb numberB(,%ecx,1), %al
	pushf
	movb %al, (outputBuffer)

	push %rcx	# save adressing index

	mov $SYSWRITE, %eax
	mov $STDOUT, %ebx
	mov $outputBuffer, %ecx
	mov $1, %edx
	int $SYSCALL

	pop %rcx # restore adressing index
	inc %ecx

	jmp additionLoop
afterAdditionLoop:
	# handle n -> n+1 addition carry
	movb $0, %al
	popf
	adcb $0, %al
	movb %al, (outputBuffer)

	mov $SYSWRITE, %eax
	mov $STDOUT, %ebx
	mov $outputBuffer, %ecx
	mov $1, %edx
	int $SYSCALL

	# ------------------------------- SUBSTRACTION -------------------------------
	# set up for substraction operation
	clc
	pushf
	mov $0, %ecx
substractionLoop:
	cmpb (dataSize), %cl
	je afterSubstractionLoop

	movb numberA(,%ecx,1), %al
	popf
	sbbb numberB(,%ecx,1), %al
	pushf
	movb %al, (outputBuffer)

	push %rcx	# save adressing index

	mov $SYSWRITE, %eax
	mov $STDOUT, %ebx
	mov $outputBuffer, %ecx
	mov $1, %edx
	int $SYSCALL

	pop %rcx # restore adressing index
	inc %ecx

	jmp substractionLoop
afterSubstractionLoop:
	# handle n -> n+1 borrow (B>A flag)
	movb $0, %al
	popf
	adcb $0, %al
	movb %al, (outputBuffer)

	mov $SYSWRITE, %eax
	mov $STDOUT, %ebx
	mov $outputBuffer, %ecx
	mov $1, %edx
	int $SYSCALL

	# ------------------------------- MULTIPLICATION -----------------------------
	# set up for multiplication operation
	movb (dataSize), %al
	subb $1, %al
	movb %al, (lastDataIndex)
	mov $0, %ecx
	mov $0, %ebx
	mov $0, %edx
	# outer loop - %bl 0,1,..,lastDataIndex	- loop through byte weights
	movb $0, %bl
multiplicationOuterLoop:
	cmpb (lastDataIndex), %bl
	jg writeProduct

	# in inner loop - %dl 0,1,..,%bl - loop through pairs on given weight
	movb $0, %dl
multiplicationInnerLoop:
	cmpb %bl, %dl
	jg afterMultiplicationInnerLoop

	# ------------- FROM THE LEFT ------------------------------------------------
	# multiply numberA[%dl] and numberB[%bl-%dl]
	movb %dl, %cl
	movb numberA(,%ecx,1), %al
	movb %bl, %cl
	subb %dl, %cl
	mulb numberB(,%ecx,1)

	# save %ax to product[%bl]
	mov $0, %ecx
	clc
	adcw %ax, multiplied(%ebx, %ecx, 2)
	jnc afterCarryPropagationLoop
	# handle carry propagation
carryPropagationLoop:
	inc %ecx
	adcw $0, multiplied(%ebx, %ecx, 2)
	jc carryPropagationLoop
afterCarryPropagationLoop:

	cmpb (lastDataIndex), %bl
	je afterMirror

	# ------------- FROM THE RIGHT (MIRROR) --------------------------------------
	# mirror multiply numberA[lastDataIndex-%dl] and numberB[lastDataIndex-%bl+%dl]
	movb (lastDataIndex), %cl
	subb %dl, %cl
	movb numberA(,%ecx,1), %al
	movb (lastDataIndex), %cl
	subb %bl, %cl
	addb %dl, %cl
	mulb numberB(,%ecx,1)

	push %rdx
	mov $0, %edx
	# save %ax to product[lastDataIndex*2 - %bl]
	movb (lastDataIndex), %dl
	sal %edx
	sub %ebx, %edx
	mov $0, %ecx
	clc
	adcw %ax, multiplied(%edx, %ecx, 2)
	jnc afterCarryPropagationLoopMir
	# handle carry propagation
carryPropagationLopMir:
	inc %ecx
	adcw $0, multiplied(%edx, %ecx, 2)
	jc carryPropagationLopMir
afterCarryPropagationLoopMir:
	pop %rdx

afterMirror:
	incb %dl
	jmp multiplicationInnerLoop

afterMultiplicationInnerLoop:
	incb %bl
	jmp multiplicationOuterLoop

writeProduct:
	mov $SYSWRITE, %eax
	mov $STDOUT, %ebx
	mov $multiplied, %ecx
	mov $0, %edx
	movb (dataSize), %dl
	sal %edx
	int $SYSCALL

end:
	mov $SYSEXIT, %eax
	mov $EXIT_SUCCESS, %ebx
	int $SYSCALL

	# ----------------------------------------------------------------------------
  #    Multiplication note: Vertical levels of byte weights
	#    with same number of operands are added within one inner loop iteration
	#    "mirrored" one is one on the right.
	#
  #     o    o    o
  #     o    o    o   *
  #    ---------
  #    [o]  |o|   o
  #         |o|   o  |o|
  #               o  |o|  [o]
