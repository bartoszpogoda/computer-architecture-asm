.align 32

.text
	.global counter
# -----------------------------------
# Function: counter
#
# it returns processor's TSC (Time Stamp Counter)
# value (64b) in [%edx:%eax] registers
# -----------------------------------
counter:
	push %ebx				# ebx must be preserved across the function and it is used by cpuid

	xor %eax, %eax
	cpuid						# force processor to fnish current operations
	rdtsc						# read processor's time-stamp counter (64b) to [%edx:%eax]

	pop %ebx
	ret
