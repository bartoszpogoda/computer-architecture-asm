.align 32

.text

	.global memOpTimeTest
# -----------------------------------
# Function: memOpTimeTest
#
# it returns aproximate number of cycles taken by single memory operation
# rarely it produces easy to detect arbitrary result (when there is change on
# 33-th bit of TSC during measurment)
# -----------------------------------
memOpTimeTest:
	push %ebx

	xor %eax, %eax
	cpuid						# force processor to fnish current operations
	rdtsc						# read processor's time-stamp counter (64b) to [%edx:%eax]
	mov %eax, %ebx	# measured operation - store younger 32b of TSC in %eax
	rdtsc						# read processor's time-stamp counter (64b) to [%edx:%eax]
	sub %ebx, %eax

	pop %ebx
	ret
