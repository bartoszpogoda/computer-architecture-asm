.align 32

.text

	.global memOpTimeTest
# -----------------------------------
# Function: memOpTimeTest
#
# 8(%ebp) - memory address
#
# it returns aproximate number of cycles taken by single memory operation
# rarely it produces easy to detect arbitrary result (when there is change on
# 33-th bit of TSC during measurment)
# -----------------------------------
memOpTimeTest:
	push %ebp
	mov %esp, %ebp
	push %ebx
	push %edi
	
	mov 8(%ebp), %edi

	xor %eax, %eax
	cpuid						
	rdtsc					
	mov %eax, (%edi)
	xor %eax, %eax
	cpuid 			
	rdtsc					
	mov (%edi), %ebx
	sub %ebx, %eax

	pop %edi
	pop %ebx
	mov %ebp, %esp
	pop %ebp
	ret
