#------------------------------------------------------------------------
# A program that reads byte input of not specified size and processes it
#
# Processing: if read byte is within 'A' - 'Z' ascii range then it should
# be cesar-shifted with some predefined shift value and then redirected
# to standard output, otherwise just redirected to standard output
#-------------------------------------------------------------------------

SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4

STDIN = 0
STDOUT = 1

SYSCALL = 0x80
EXIT_SUCCESS = 0

BUFFOR_SIZE = 1
CESAR_SHIFT = 13

A_ASCII = 0x41
Z_ASCII = 0x5A
AZ_DIFF = Z_ASCII - A_ASCII + 1

.align 32

.data
	currentByte: .byte 0x00

.text

.global _start

# main loop start - load 1 byte into currentByte
_start:
	mov $SYSREAD, %eax
	mov $STDIN, %ebx
	mov $currentByte, %ecx
	mov $BUFFOR_SIZE, %edx
	int $SYSCALL

	##if there is 0 in accumulator - end, jump to loop end
	cmp $0, %eax
	je end

	# check if currentByte is within A-Z range
	cmpb $A_ASCII, currentByte
	jl writeByte
	cmpb $Z_ASCII, currentByte
	jg writeByte

	# A-Z processing
	addb $CESAR_SHIFT, currentByte

	cmpb $Z_ASCII, currentByte
	jle writeByte

	subb $AZ_DIFF, currentByte
	# end of A-Z processing

# write single byte to the standard output
writeByte:
	mov $SYSWRITE, %eax
	mov $STDOUT, %ebx
	mov $currentByte, %ecx
	mov $BUFFOR_SIZE, %edx
	int $SYSCALL

	# jump to main loop start
	jmp _start

end:
	mov $SYSEXIT, %eax
	mov $EXIT_SUCCESS, %ebx
	int $SYSCALL
