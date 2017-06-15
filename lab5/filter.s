
PIXEL_DISTANCE = 50

.align 32

.data
	# AND mask to fix result of quadword right shift (x2) to be
	# result of each quadword's bytes right shift (x2)
	postShiftMask: .byte 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f

.text
	.global FilterASM

# --------------------------------
# void Filter(unsigned char * buf, int width,int height)
# 8(%ebp) - pixel buffor
# 12(%ebp) - image width
# 16(%ebp) - image height
# --------------------------------
FilterASM:
	push %ebp
	mov %esp, %ebp

	# calculate number of (full) 8 pixel packs
	mov 16(%ebp), %eax	# height to %eax
	mull 12(%ebp)				# height * width to %eax
	mov $8, %ecx
	divl %ecx
	# number of pixel packs in %eax
	# number of pixels not in packs in %edx
	# which can be ignored because they dont
	# "combine" with any existing pixels anyway

	movq postShiftMask, %mm3
	mov 8(%ebp), %edx			# %edx - pixel buffor address

	# init loop
	mov $0,	%ecx
loop:
	# load pixels to change (to %mm0)
	MOVQ (%edx, %ecx, 8), %mm0

	# load displaced pixels (to %mm1)
	MOVQ PIXEL_DISTANCE(%edx, %ecx, 8), %mm1

	# OPERATIONS:	buf = buf/4 * 3 + displacedBuf / 4

	# buf = buf / 4
	PSRLQ $2, %mm0
	PAND %mm3, %mm0

	# buf = buf * 3 = buf + buf + buf
	MOVQ %mm0, %mm4
	PADDB %mm0, %mm0
	PADDB %mm4, %mm0

	# displacedBuf = displacedBuf / 4
	PSRLQ $2, %mm1
	PAND %mm3, %mm1

	#buf = buf + displacedBuf
	PADDB %mm1, %mm0

	# save changed pixels back to memory
	MOVQ %mm0, (%edx, %ecx, 8)

	# loop logic
	inc %ecx
	cmp %ecx, %eax
	jne loop

	mov %ebp, %esp
	pop %ebp
	ret
