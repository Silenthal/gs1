	.include "macros.inc"

.thumb_func_start SWI_CpuSet
	swi	0xb
	bx	lr
.func_end SWI_CpuSet

.thumb_func_start SWI_SoundBias_Down
	mov	r0, #0
	swi	0x19
	bx	lr
.func_end SWI_SoundBias_Down

.thumb_func_start SWI_SoundBias_Up
	mov	r0, #1
	swi	0x19
	bx	lr
.func_end SWI_SoundBias_Up
