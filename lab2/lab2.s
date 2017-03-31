#-------------------------------------------------------------------------
# A program that sums, substracts and multiplies two n-byte size operands
#
# Input format: [n][numberA][numberB]
#	n - 1-byte operands size (0-255 range)
# numberA - n-byte NB number
# numberB - n-byte NB number
#
# Output format: [n][sum][difference][product]
# n - 1-byte operands size
# sum - n+1-byte size addition result
# difference - n-byte size numberA-numberB substraction result
# followed by 1-byte B>A flag which indicates incorrect result
# TODO: product
#-------------------------------------------------------------------------

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
	readingCounter: .byte 0x00
	readingAflag: .byte 0x01	# flag that indicates A-reading
	outputBuffer: .byte 0x00

.bss
	.lcomm numberA, MAX_INPUT_SIZE
	.lcomm numberB, MAX_INPUT_SIZE

.text

.global _start

_start:
	# dbg adresses controll for memory view=======================
	mov $0, %rax
	mov $dataSize, %eax
	mov $numberA, %eax
	mov $numberB, %eax
	# ============================================================

	# read first stdin byte to dataSize
	mov $SYSREAD, %eax
	mov $STDIN, %ebx
	mov $dataSize, %ecx
	mov $1, %edx
	int $SYSCALL

	# set up registers for numberA read
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

	# set up registers for numberB read
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

end:
	mov $SYSEXIT, %eax
	mov $EXIT_SUCCESS, %ebx

	int $SYSCALL
