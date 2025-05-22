	.include "macros.inc"
	.include "gba.inc"

.thumb_func_start umul3232H32
	adr	r2, .__umul3232H32
	bx	r2

	.align	2, 0
	.arm
.__umul3232H32:
	umull	r2, r3, r0, r1
	add	r0, r3, #0
	bx	lr
.func_end umul3232H32

.thumb_func_start SoundMain
	ldr	r0, .Lf965c	@ SOUND_INFO_PTR
	ldr	r0, [r0]
	ldr	r2, .Lf9660	@ 0x68736d53
	ldr	r3, [r0]
	cmp	r2, r3
	beq	.Lf95fe
	bx	lr
.Lf95fe:
	add	r3, #1
	str	r3, [r0]
	push	{r4, r5, r6, r7, lr}
	mov	r1, r8
	mov	r2, r9
	mov	r3, r10
	mov	r4, r11
	push	{r0, r1, r2, r3, r4}
	sub	sp, #0x18
	ldrb	r1, [r0, #0xc]
	cmp	r1, #0
	beq	.Lf9622
	ldr	r2, .Lf9668	@ REG_VCOUNT
	ldrb	r2, [r2]
	cmp	r2, #0xa0
	bcs	.Lf9620
	add	r2, #0xe4
.Lf9620:
	add	r1, r2
.Lf9622:
	str	r1, [sp, #0x14]
	ldr	r3, [r0, #0x20]
	cmp	r3, #0
	beq	.Lf9632
	ldr	r0, [r0, #0x24]
	bl	.Lf9a12
	ldr	r0, [sp, #0x18]
.Lf9632:
	ldr	r3, [r0, #0x28]
	bl	.Lf9a12
	ldr	r0, [sp, #0x18]
	ldr	r3, [r0, #0x10]
	mov	r8, r3
	ldr	r5, .Lf966c	@ 0x350
	add	r5, r0
	ldrb	r4, [r0, #4]
	sub	r7, r4, #1
	bls	.Lf9652
	ldrb	r1, [r0, #0xb]
	sub	r1, r7
	mov	r2, r8
	mul	r2, r1
	add	r5, r2
.Lf9652:
	str	r5, [sp, #8]
	ldr	r6, .Lf9670	@ 0x630
	ldr	r3, .Lf9664	@ iwram_7001
	bx	r3

	.align	2, 0
.Lf965c:
	.word	SOUND_INFO_PTR
.Lf9660:
	.word	0x68736d53
.Lf9664:
	.word	iwram_7001
.Lf9668:
	.word	REG_VCOUNT
.Lf966c:
	.word	0x350
.Lf9670:
	.word	0x630
.func_end SoundMain

.thumb_func_start SoundMainRAM
	ldrb	r3, [r0, #5]
	cmp	r3, #0
	beq	.Lf96d4
	adr	r1, .Lf9680
	bx	r1

	.align	2, 0
	.arm
.Lf9680:
	cmp	r4, #2
	addeq	r7, r0, #0x350
	addne	r7, r5, r8
	mov	r4, r8
.Lf9690:
	ldrsb	r0, [r5, r6]
	ldrsb	r1, [r5]
	add	r0, r1
	ldrsb	r1, [r7, r6]
	add	r0, r1
	ldrsb	r1, [r7], #1
	add	r0, r1
	mul	r1, r0, r3
	asr	r0, r1, #9
	tst	r0, #0x80
	addne	r0, #1
	strb	r0, [r5, r6]
	strb	r0, [r5], #1
	subs	r4, #1
	bgt	.Lf9690
	adr	r0, .Lf9702 + 1
	bx	r0

	.thumb
.Lf96d4:
	mov	r0, #0
	mov	r1, r8
	add	r6, r5
	lsr	r1, #3
	bcc	.Lf96e2
	stmia	r5!, {r0}
	stmia	r6!, {r0}
.Lf96e2:
	lsr	r1, #1
	bcc	.Lf96ee
	stmia	r5!, {r0}
	stmia	r6!, {r0}
	stmia	r5!, {r0}
	stmia	r6!, {r0}
.Lf96ee:
	stmia	r5!, {r0}
	stmia	r6!, {r0}
	stmia	r5!, {r0}
	stmia	r6!, {r0}
	stmia	r5!, {r0}
	stmia	r6!, {r0}
	stmia	r5!, {r0}
	stmia	r6!, {r0}
	sub	r1, #1
	bgt	.Lf96ee

.Lf9702:
	ldr	r4, [sp, #0x18]
	ldr	r0, [r4, #0x18]
	mov	r12, r0
	ldrb	r0, [r4, #6]
	add	r4, #0x50
.Lf970c:
	str	r0, [sp, #4]
	ldr	r3, [r4, #0x24]
	ldr	r0, [sp, #0x14]
	cmp	r0, #0
	beq	.Lf972c
	ldr	r1, =REG_VCOUNT
	ldrb	r1, [r1]
	cmp	r1, #0xa0
	bcs	.Lf9720
	add	r1, #0xe4
.Lf9720:
	cmp	r1, r0
	bcc	.Lf972c
	b	.Lf99fe

	.pool_aligned

.Lf972c:
	ldrb	r6, [r4]
	mov	r0, #0xc7
	tst	r0, r6
	bne	.Lf9736
	b	.Lf99f4
.Lf9736:
	mov	r0, #0x80
	tst	r0, r6
	beq	.Lf9766
	mov	r0, #0x40
	tst	r0, r6
	bne	.Lf9776
	mov	r6, #3
	strb	r6, [r4]
	mov	r0, r3
	add	r0, #0x10
	str	r0, [r4, #0x28]
	ldr	r0, [r3, #0xc]
	str	r0, [r4, #0x18]
	mov	r5, #0
	strb	r5, [r4, #9]
	str	r5, [r4, #0x1c]
	ldrb	r2, [r3, #3]
	mov	r0, #0xc0
	tst	r0, r2
	beq	.Lf97be
	mov	r0, #0x10
	orr	r6, r0
	strb	r6, [r4]
	b	.Lf97be
.Lf9766:
	ldrb	r5, [r4, #9]
	mov	r0, #4
	tst	r0, r6
	beq	.Lf977c
	ldrb	r0, [r4, #0xd]
	sub	r0, #1
	strb	r0, [r4, #0xd]
	bhi	.Lf97cc
.Lf9776:
	mov	r0, #0
	strb	r0, [r4]
	b	.Lf99f4
.Lf977c:
	mov	r0, #0x40
	tst	r0, r6
	beq	.Lf979c
	ldrb	r0, [r4, #7]
	mul	r5, r0
	lsr	r5, #8
	ldrb	r0, [r4, #0xc]
	cmp	r5, r0
	bhi	.Lf97cc
.Lf978e:
	ldrb	r5, [r4, #0xc]
	cmp	r5, #0
	beq	.Lf9776
	mov	r0, #4
	orr	r6, r0
	strb	r6, [r4]
	b	.Lf97cc
.Lf979c:
	mov	r2, #3
	and	r2, r6
	cmp	r2, #2
	bne	.Lf97ba
	ldrb	r0, [r4, #5]
	mul	r5, r0
	lsr	r5, #8
	ldrb	r0, [r4, #6]
	cmp	r5, r0
	bhi	.Lf97cc
	mov	r5, r0
	beq	.Lf978e
	sub	r6, #1
	strb	r6, [r4]
	b	.Lf97cc
.Lf97ba:
	cmp	r2, #3
	bne	.Lf97cc
.Lf97be:
	ldrb	r0, [r4, #4]
	add	r5, r0
	cmp	r5, #0xff
	bcc	.Lf97cc
	mov	r5, #0xff
	sub	r6, #1
	strb	r6, [r4]
.Lf97cc:
	strb	r5, [r4, #9]
	ldr	r0, [sp, #0x18]
	ldrb	r0, [r0, #7]
	add	r0, #1
	mul	r0, r5
	lsr	r5, r0, #4
	ldrb	r0, [r4, #2]
	mul	r0, r5
	lsr	r0, #8
	strb	r0, [r4, #0xa]
	ldrb	r0, [r4, #3]
	mul	r0, r5
	lsr	r0, #8
	strb	r0, [r4, #0xb]
	mov	r0, #0x10
	and	r0, r6
	str	r0, [sp, #0x10]
	beq	.Lf9800
	mov	r0, r3
	add	r0, #0x10
	ldr	r1, [r3, #8]
	add	r0, r1
	str	r0, [sp, #0xc]
	ldr	r0, [r3, #0xc]
	sub	r0, r1
	str	r0, [sp, #0x10]
.Lf9800:
	ldr	r5, [sp, #8]
	ldr	r2, [r4, #0x18]
	ldr	r3, [r4, #0x28]
	adr	r0, .Lf980c
	bx	r0

	.align	2, 0
	.arm
.Lf980c:
	str	r8, [sp]
	ldrb	r10, [r4, #0xa]
	ldrb	r11, [r4, #0xb]
	lsl	r10, #16
	lsl	r11, #16
	ldrb	r0, [r4, #1]
	tst	r0, #8
	beq	.Lf994c
.Lf982c:
	cmp	r2, #4
	ble	.Lf989c
	subs	r2, r8
	movgt	r14, #0
	bgt	.Lf9858
	mov	r14, r8
	add	r2, r8
	sub	r8, r2, #4
	sub	r14, r8
	ands	r2, #3
	moveq	r2, #4
.Lf9858:
	ldr	r6, [r5]
	ldr	r7, [r5, #0x630]
.Lf9860:
	ldrsb	r0, [r3], #1
	mul	r1, r10, r0
	bic	r1, #0xff0000
	add	r6, r1, r6, ror #8
	mul	r1, r11, r0
	bic	r1, #0xff0000
	add	r7, r1, r7, ror #8
	adds	r5, #0x40000000
	bcc	.Lf9860
	str	r7, [r5, #0x630]
	str	r6, [r5], #4
	subs	r8, #4
	bgt	.Lf9858
	adds	r8, r14
	beq	.Lf99e0
.Lf989c:
	ldr	r6, [r5]
	ldr	r7, [r5, #0x630]
.Lf98a4:
	ldrsb	r0, [r3], #1
	mul	r1, r10, r0
	bic	r1, #0xff0000
	add	r6, r1, r6, ror #8
	mul	r1, r11, r0
	bic	r1, #0xff0000
	add	r7, r1, r7, ror #8
	subs	r2, #1
	beq	.Lf9914
.Lf98c8:
	adds	r5, #0x40000000
	bcc	.Lf98a4
	str	r7, [r5, #0x630]
	str	r6, [r5], #4
	subs	r8, #4
	bgt	.Lf982c
	b	.Lf99e0
.Lf98e4:
	ldr	r0, [sp, #0x18]
	cmp	r0, #0
	beq	.Lf9908
	ldr	r3, [sp, #0x14]
	rsb	r9, r2, #0
.Lf98f8:
	adds	r2, r0, r2
	bgt	.Lf99b0
	sub	r9, r0
	b	.Lf98f8
.Lf9908:
	pop	{r4, r12}
	mov	r2, #0
	b	.Lf9924
.Lf9914:
	ldr	r2, [sp, #0x10]
	cmp	r2, #0
	ldrne	r3, [sp, #0xc]
	bne	.Lf98c8
.Lf9924:
	strb	r2, [r4]
	lsr	r0, r5, #30
	bic	r5, #0xc0000000
	rsb	r0, #3
	lsl	r0, #3
	ror	r6, r0
	ror	r7, r0
	str	r7, [r5, #0x630]
	str	r6, [r5], #4
	b	.Lf99e8
.Lf994c:
	push	{r4, r12}
	ldr	r14, [r4, #0x1c]
	ldr	r1, [r4, #0x20]
	mul	r4, r12, r1
	ldrsb	r0, [r3]
	ldrsb	r1, [r3, #1]!
	sub	r1, r0
.Lf9968:
	ldr	r6, [r5]
	ldr	r7, [r5, #0x630]
.Lf9970:
	mul	r9, r14, r1
	add	r9, r0, r9, asr #23
	mul	r12, r10, r9
	bic	r12, #0xff0000
	add	r6, r12, r6, ror #8
	mul	r12, r11, r9
	bic	r12, #0xff0000
	add	r7, r12, r7, ror #8
	add	r14, r4
	lsrs	r9, r14, #23
	beq	.Lf99bc
	bic	r14, #0x3f800000
	subs	r2, r9
	ble	.Lf98e4
	subs	r9, #1
	addeq	r0, r1
.Lf99b0:
	ldrnesb	r0, [r3, r9]!
	ldrsb	r1, [r3, #1]!
	sub	r1, r0
.Lf99bc:
	adds	r5, #0x40000000
	bcc	.Lf9970
	str	r7, [r5, #0x630]
	str	r6, [r5], #4
	subs	r8, #4
	bgt	.Lf9968
	sub	r3, #1
	pop	{r4, r12}
	str	r14, [r4, #0x1c]
.Lf99e0:
	str	r2, [r4, #0x18]
	str	r3, [r4, #0x28]
.Lf99e8:
	ldr	r8, [sp]
	add	r0, pc, #1
	bx	r0

	.thumb
.Lf99f4:
	ldr	r0, [sp, #4]
	sub	r0, #1
	ble	.Lf99fe
	add	r4, #0x40
	b	.Lf970c
.Lf99fe:
	ldr	r0, [sp, #0x18]
	ldr	r3, .Lf9a14	@ 0x68736d53
	str	r3, [r0]
	add	sp, #0x1c
	pop	{r0, r1, r2, r3, r4, r5, r6, r7}
	mov	r8, r0
	mov	r9, r1
	mov	r10, r2
	mov	r11, r3
	pop	{r3}

.Lf9a12:
	bx	r3

.Lf9a14:
	.word	0x68736d53
.func_end SoundMainRAM

.thumb_func_start SoundMainBTM
	mov	r12, r4
	mov	r1, #0
	mov	r2, #0
	mov	r3, #0
	mov	r4, #0
	stmia	r0!, {r1, r2, r3, r4}
	stmia	r0!, {r1, r2, r3, r4}
	stmia	r0!, {r1, r2, r3, r4}
	stmia	r0!, {r1, r2, r3, r4}
	mov	r4, r12
	bx	lr
.func_end SoundMainBTM

.thumb_func_start RealClearChain
	ldr	r3, [r0, #0x2c]
	cmp	r3, #0
	beq	.Lf9a4e
	ldr	r1, [r0, #0x34]
	ldr	r2, [r0, #0x30]
	cmp	r2, #0
	beq	.Lf9a42
	str	r1, [r2, #0x34]
	b	.Lf9a44
.Lf9a42:
	str	r1, [r3, #0x20]
.Lf9a44:
	cmp	r1, #0
	beq	.Lf9a4a
	str	r2, [r1, #0x30]
.Lf9a4a:
	mov	r1, #0
	str	r1, [r0, #0x2c]
.Lf9a4e:
	bx	lr
.func_end RealClearChain

.thumb_func_start ply_fine
	push	{r4, r5, lr}
	mov	r5, r1
	ldr	r4, [r5, #0x20]
	cmp	r4, #0
	beq	.Lf9a74
.Lf9a5a:
	ldrb	r1, [r4]
	mov	r0, #0xc7
	tst	r0, r1
	beq	.Lf9a68
	mov	r0, #0x40
	orr	r1, r0
	strb	r1, [r4]
.Lf9a68:
	mov	r0, r4
	bl	RealClearChain
	ldr	r4, [r4, #0x34]
	cmp	r4, #0
	bne	.Lf9a5a
.Lf9a74:
	mov	r0, #0
	strb	r0, [r5]
	pop	{r4, r5}
	pop	{r0}
	bx	r0
.func_end ply_fine

.thumb_func_start MPlayJumpTableCopy
	mov	r12, lr
	mov	r1, #0x24
	ldr	r2, .Lf9ab0	@ gMPlayJumpTableTemplate
.Lf9a86:
	ldr	r3, [r2]
	bl	.chk_adr_r2
	stmia	r0!, {r3}
	add	r2, #4
	sub	r1, #1
	bgt	.Lf9a86
	bx	r12
.func_end MPlayJumpTableCopy

.thumb_func_start ldrb_r3_r2
	ldrb	r3, [r2]
.chk_adr_r2:
	push	{r0}
	lsr	r0, r2, #25
	bne	.Lf9aac
	ldr	r0, .Lf9ab0	@ gMPlayJumpTableTemplate
	cmp	r2, r0
	bcc	.Lf9aaa
	lsr	r0, r2, #14
	beq	.Lf9aac
.Lf9aaa:
	mov	r3, #0
.Lf9aac:
	pop	{r0}
	bx	lr
.func_end ldrb_r3_r2

.Lf9ab0:
	.word	gMPlayJumpTableTemplate

.thumb_func_start ld_r3_tp_adr_i
	ldr	r2, [r1, #0x40]
.Lf9ab6:
	add	r3, r2, #1
	str	r3, [r1, #0x40]
	ldrb	r3, [r2]
	b	.chk_adr_r2
.func_end ld_r3_tp_adr_i

.thumb_func_start ply_goto
	push	{lr}
.ply_goto_1:
	ldr	r2, [r1, #0x40]
	ldrb	r0, [r2, #3]
	lsl	r0, #8
	ldrb	r3, [r2, #2]
	orr	r0, r3
	lsl	r0, #8
	ldrb	r3, [r2, #1]
	orr	r0, r3
	lsl	r0, #8
	bl	ldrb_r3_r2
	orr	r0, r3
	str	r0, [r1, #0x40]
	pop	{r0}
	bx	r0
.func_end ply_goto

.thumb_func_start ply_patt
	ldrb	r2, [r1, #2]
	cmp	r2, #3
	bcs	.Lf9af8
	lsl	r2, #2
	add	r3, r1, r2
	ldr	r2, [r1, #0x40]
	add	r2, #4
	str	r2, [r3, #0x44]
	ldrb	r2, [r1, #2]
	add	r2, #1
	strb	r2, [r1, #2]
	b	ply_goto
.Lf9af8:
	b	ply_fine
.func_end ply_patt

.thumb_func_start ply_pend
	ldrb	r2, [r1, #2]
	cmp	r2, #0
	beq	.Lf9b0e
	sub	r2, #1
	strb	r2, [r1, #2]
	lsl	r2, #2
	add	r3, r1, r2
	ldr	r2, [r3, #0x44]
	str	r2, [r1, #0x40]
.Lf9b0e:
	bx	lr
.func_end ply_pend

.thumb_func_start ply_rept
	push	{lr}
	ldr	r2, [r1, #0x40]
	ldrb	r3, [r2]
	cmp	r3, #0
	bne	.Lf9b20
	add	r2, #1
	str	r2, [r1, #0x40]
	b	.ply_goto_1
.Lf9b20:
	ldrb	r3, [r1, #3]
	add	r3, #1
	strb	r3, [r1, #3]
	mov	r12, r3
	bl	ld_r3_tp_adr_i
	cmp	r12, r3
	bcs	.Lf9b32
	b	.ply_goto_1
.Lf9b32:
	mov	r3, #0
	strb	r3, [r1, #3]
	add	r2, #5
	str	r2, [r1, #0x40]
	pop	{r0}
	bx	r0
.func_end ply_rept

.thumb_func_start ply_prio
	mov	r12, lr
	bl	ld_r3_tp_adr_i
	strb	r3, [r1, #0x1d]
	bx	r12
.func_end ply_prio

.thumb_func_start ply_tempo
	mov	r12, lr
	bl	ld_r3_tp_adr_i
	lsl	r3, #1
	strh	r3, [r0, #0x1c]
	ldrh	r2, [r0, #0x1e]
	mul	r3, r2
	lsr	r3, #8
	strh	r3, [r0, #0x20]
	bx	r12
.func_end ply_tempo

.thumb_func_start ply_keysh
	mov	r12, lr
	bl	ld_r3_tp_adr_i
	strb	r3, [r1, #0xa]
	ldrb	r3, [r1]
	mov	r2, #0xc
	orr	r3, r2
	strb	r3, [r1]
	bx	r12
.func_end ply_keysh

.thumb_func_start ply_voice
	mov	r12, lr
	ldr	r2, [r1, #0x40]
	ldrb	r3, [r2]
	add	r2, #1
	str	r2, [r1, #0x40]
	lsl	r2, r3, #1
	add	r2, r3
	lsl	r2, #2
	ldr	r3, [r0, #0x30]
	add	r2, r3
	ldr	r3, [r2]
	bl	.chk_adr_r2
	str	r3, [r1, #0x24]
	ldr	r3, [r2, #4]
	bl	.chk_adr_r2
	str	r3, [r1, #0x28]
	ldr	r3, [r2, #8]
	bl	.chk_adr_r2
	str	r3, [r1, #0x2c]
	bx	r12
.func_end ply_voice

.thumb_func_start ply_vol
	mov	r12, lr
	bl	ld_r3_tp_adr_i
	strb	r3, [r1, #0x12]
	ldrb	r3, [r1]
	mov	r2, #3
	orr	r3, r2
	strb	r3, [r1]
	bx	r12
.func_end ply_vol

.thumb_func_start ply_pan
	mov	r12, lr
	bl	ld_r3_tp_adr_i
	sub	r3, #0x40
	strb	r3, [r1, #0x14]
	ldrb	r3, [r1]
	mov	r2, #3
	orr	r3, r2
	strb	r3, [r1]
	bx	r12
.func_end ply_pan

.thumb_func_start ply_bend
	mov	r12, lr
	bl	ld_r3_tp_adr_i
	sub	r3, #0x40
	strb	r3, [r1, #0xe]
	ldrb	r3, [r1]
	mov	r2, #0xc
	orr	r3, r2
	strb	r3, [r1]
	bx	r12
.func_end ply_bend

.thumb_func_start ply_bendr
	mov	r12, lr
	bl	ld_r3_tp_adr_i
	strb	r3, [r1, #0xf]
	ldrb	r3, [r1]
	mov	r2, #0xc
	orr	r3, r2
	strb	r3, [r1]
	bx	r12
.func_end ply_bendr

.thumb_func_start ply_lfodl
	mov	r12, lr
	bl	ld_r3_tp_adr_i
	strb	r3, [r1, #0x1b]
	bx	r12
.func_end ply_lfodl

.thumb_func_start ply_modt
	mov	r12, lr
	bl	ld_r3_tp_adr_i
	ldrb	r0, [r1, #0x18]
	cmp	r0, r3
	beq	.Lf9c16
	strb	r3, [r1, #0x18]
	ldrb	r3, [r1]
	mov	r2, #0xf
	orr	r3, r2
	strb	r3, [r1]
.Lf9c16:
	bx	r12
.func_end ply_modt

.thumb_func_start ply_tune
	mov	r12, lr
	bl	ld_r3_tp_adr_i
	sub	r3, #0x40
	strb	r3, [r1, #0xc]
	ldrb	r3, [r1]
	mov	r2, #0xc
	orr	r3, r2
	strb	r3, [r1]
	bx	r12
.func_end ply_tune

.thumb_func_start ply_port
	mov	r12, lr
	ldr	r2, [r1, #0x40]
	ldrb	r3, [r2]
	add	r2, #1
	ldr	r0, =REG_SOUND1CNT_L
	add	r0, r3
	bl	.Lf9ab6
	strb	r3, [r0]
	bx	r12
.func_end ply_port

.thumb_func_start m4aSoundVSync
	ldr	r0, .Lf9ef0	@ SOUND_INFO_PTR
	ldr	r0, [r0]
	ldr	r2, .Lf9ef4	@ 0x68736d53
	ldr	r3, [r0]
	sub	r3, r2
	cmp	r3, #1
	bhi	.Lf9c84
	ldrb	r1, [r0, #4]
	sub	r1, #1
	strb	r1, [r0, #4]
	bgt	.Lf9c84
	ldrb	r1, [r0, #0xb]
	strb	r1, [r0, #4]
	ldr	r2, =REG_DMA1SAD
	ldr	r1, [r2, #8]
	lsl	r1, #7
	bcc	.Lf9c6a
	ldr	r1, =0x84400004
	str	r1, [r2, #8]
.Lf9c6a:
	ldr	r1, [r2, #0x14]
	lsl	r1, #7
	bcc	.Lf9c74
	ldr	r1, =0x84400004
	str	r1, [r2, #0x14]
.Lf9c74:
	mov	r1, #4
	lsl	r1, #8
	strh	r1, [r2, #0xa]
	strh	r1, [r2, #0x16]
	mov	r1, #0xb6
	lsl	r1, #8
	strh	r1, [r2, #0xa]
	strh	r1, [r2, #0x16]
.Lf9c84:
	bx	lr
.func_end m4aSoundVSync

.thumb_func_start MPlayMain
	ldr	r2, .Lf9ef4	@ 0x68736d53
	ldr	r3, [r0, #0x34]
	cmp	r2, r3
	beq	.Lf9c9a
	bx	lr
.Lf9c9a:
	add	r3, #1
	str	r3, [r0, #0x34]
	push	{r0, lr}
	ldr	r3, [r0, #0x38]
	cmp	r3, #0
	beq	.Lf9cac
	ldr	r0, [r0, #0x3c]
	bl	call_r3_f9ee8
.Lf9cac:
	pop	{r0}
	push	{r4, r5, r6, r7}
	mov	r4, r8
	mov	r5, r9
	mov	r6, r10
	mov	r7, r11
	push	{r4, r5, r6, r7}
	mov	r7, r0
	ldr	r0, [r7, #4]
	cmp	r0, #0
	bge	.Lf9cc4
	b	.Lf9ed8
.Lf9cc4:
	ldr	r0, .Lf9ef0	@ SOUND_INFO_PTR
	ldr	r0, [r0]
	mov	r8, r0
	mov	r0, r7
	bl	FadeOutBody
	ldr	r0, [r7, #4]
	cmp	r0, #0
	bge	.Lf9cd8
	b	.Lf9ed8
.Lf9cd8:
	ldrh	r0, [r7, #0x22]
	ldrh	r1, [r7, #0x20]
	add	r0, r1
	b	.Lf9e28
.Lf9ce0:
	ldrb	r6, [r7, #8]
	ldr	r5, [r7, #0x2c]
	mov	r3, #1
	mov	r4, #0
.Lf9ce8:
	ldrb	r0, [r5]
	mov	r1, #0x80
	tst	r1, r0
	bne	.Lf9cf2
	b	.Lf9e04
.Lf9cf2:
	mov	r10, r3
	orr	r4, r3
	mov	r11, r4
	ldr	r4, [r5, #0x20]
	cmp	r4, #0
	beq	.Lf9d26
.Lf9cfe:
	ldrb	r1, [r4]
	mov	r0, #0xc7
	tst	r0, r1
	beq	.Lf9d1a
	ldrb	r0, [r4, #0x10]
	cmp	r0, #0
	beq	.Lf9d20
	sub	r0, #1
	strb	r0, [r4, #0x10]
	bne	.Lf9d20
	mov	r0, #0x40
	orr	r1, r0
	strb	r1, [r4]
	b	.Lf9d20
.Lf9d1a:
	mov	r0, r4
	bl	ClearSoundChannelTracks
.Lf9d20:
	ldr	r4, [r4, #0x34]
	cmp	r4, #0
	bne	.Lf9cfe
.Lf9d26:
	ldrb	r3, [r5]
	mov	r0, #0x40
	tst	r0, r3
	beq	.Lf9da4
	mov	r0, r5
	bl	Clear64byte
	mov	r0, #0x80
	strb	r0, [r5]
	mov	r0, #2
	strb	r0, [r5, #0xf]
	mov	r0, #0x40
	strb	r0, [r5, #0x13]
	mov	r0, #0x16
	strb	r0, [r5, #0x19]
	mov	r0, #1
	add	r1, r5, #6
	strb	r0, [r1, #0x1e]
	b	.Lf9da4
.Lf9d4c:
	ldr	r2, [r5, #0x40]
	ldrb	r1, [r2]
	cmp	r1, #0x80
	bcs	.Lf9d58
	ldrb	r1, [r5, #7]
	b	.Lf9d62
.Lf9d58:
	add	r2, #1
	str	r2, [r5, #0x40]
	cmp	r1, #0xbd
	bcc	.Lf9d62
	strb	r1, [r5, #7]
.Lf9d62:
	cmp	r1, #0xcf
	bcc	.Lf9d78
	mov	r0, r8
	ldr	r3, [r0, #0x38]
	mov	r0, r1
	sub	r0, #0xcf
	mov	r1, r7
	mov	r2, r5
	bl	call_r3_f9ee8
	b	.Lf9da4
.Lf9d78:
	cmp	r1, #0xb0
	bls	.Lf9d9a
	mov	r0, r1
	sub	r0, #0xb1
	strb	r0, [r7, #0xa]
	mov	r3, r8
	ldr	r3, [r3, #0x34]
	lsl	r0, #2
	ldr	r3, [r3, r0]
	mov	r0, r7
	mov	r1, r5
	bl	call_r3_f9ee8
	ldrb	r0, [r5]
	cmp	r0, #0
	beq	.Lf9e00
	b	.Lf9da4
.Lf9d9a:
	ldr	r0, .Lf9eec	@ gClockTable
	sub	r1, #0x80
	add	r1, r0
	ldrb	r0, [r1]
	strb	r0, [r5, #1]
.Lf9da4:
	ldrb	r0, [r5, #1]
	cmp	r0, #0
	beq	.Lf9d4c
	sub	r0, #1
	strb	r0, [r5, #1]
	ldrb	r1, [r5, #0x19]
	cmp	r1, #0
	beq	.Lf9e00
	ldrb	r0, [r5, #0x17]
	cmp	r0, #0
	beq	.Lf9e00
	ldrb	r0, [r5, #0x1c]
	cmp	r0, #0
	beq	.Lf9dc6
	sub	r0, #1
	strb	r0, [r5, #0x1c]
	b	.Lf9e00
.Lf9dc6:
	ldrb	r0, [r5, #0x1a]
	add	r0, r1
	strb	r0, [r5, #0x1a]
	mov	r1, r0
	sub	r0, #0x40
	lsl	r0, #24
	bpl	.Lf9dda
	lsl	r2, r1, #24
	asr	r2, #24
	b	.Lf9dde
.Lf9dda:
	mov	r0, #0x80
	sub	r2, r0, r1
.Lf9dde:
	ldrb	r0, [r5, #0x17]
	mul	r0, r2
	asr	r2, r0, #6
	ldrb	r0, [r5, #0x16]
	eor	r0, r2
	lsl	r0, #24
	beq	.Lf9e00
	strb	r2, [r5, #0x16]
	ldrb	r0, [r5]
	ldrb	r1, [r5, #0x18]
	cmp	r1, #0
	bne	.Lf9dfa
	mov	r1, #0xc
	b	.Lf9dfc
.Lf9dfa:
	mov	r1, #3
.Lf9dfc:
	orr	r0, r1
	strb	r0, [r5]
.Lf9e00:
	mov	r3, r10
	mov	r4, r11
.Lf9e04:
	sub	r6, #1
	ble	.Lf9e10
	mov	r0, #0x50
	add	r5, r0
	lsl	r3, #1
	b	.Lf9ce8
.Lf9e10:
	ldr	r0, [r7, #0xc]
	add	r0, #1
	str	r0, [r7, #0xc]
	cmp	r4, #0
	bne	.Lf9e22
	mov	r0, #0x80
	lsl	r0, #24
	str	r0, [r7, #4]
	b	.Lf9ed8
.Lf9e22:
	str	r4, [r7, #4]
	ldrh	r0, [r7, #0x22]
	sub	r0, #0x96
.Lf9e28:
	strh	r0, [r7, #0x22]
	cmp	r0, #0x96
	bcc	.Lf9e30
	b	.Lf9ce0
.Lf9e30:
	ldrb	r2, [r7, #8]
	ldr	r5, [r7, #0x2c]
.Lf9e34:
	ldrb	r0, [r5]
	mov	r1, #0x80
	tst	r1, r0
	beq	.Lf9ece
	mov	r1, #0xf
	tst	r1, r0
	beq	.Lf9ece
	mov	r9, r2
	mov	r0, r7
	mov	r1, r5
	bl	TrkVolPitSet
	ldr	r4, [r5, #0x20]
	cmp	r4, #0
	beq	.Lf9ec4
.Lf9e52:
	ldrb	r1, [r4]
	mov	r0, #0xc7
	tst	r0, r1
	bne	.Lf9e62
	mov	r0, r4
	bl	ClearSoundChannelTracks
	b	.Lf9ebe
.Lf9e62:
	ldrb	r0, [r4, #1]
	mov	r6, #7
	and	r6, r0
	ldrb	r3, [r5]
	mov	r0, #3
	tst	r0, r3
	beq	.Lf9e80
	bl	ChnVolSetAsm
	cmp	r6, #0
	beq	.Lf9e80
	ldrb	r0, [r4, #0x1d]
	mov	r1, #1
	orr	r0, r1
	strb	r0, [r4, #0x1d]
.Lf9e80:
	ldrb	r3, [r5]
	mov	r0, #0xc
	tst	r0, r3
	beq	.Lf9ebe
	ldrb	r1, [r4, #8]
	mov	r0, #8
	ldrsb	r0, [r5, r0]
	add	r2, r1, r0
	bpl	.Lf9e94
	mov	r2, #0
.Lf9e94:
	cmp	r6, #0
	beq	.Lf9eb2
	mov	r0, r8
	ldr	r3, [r0, #0x30]
	mov	r1, r2
	ldrb	r2, [r5, #9]
	mov	r0, r6
	bl	call_r3_f9ee8
	str	r0, [r4, #0x20]
	ldrb	r0, [r4, #0x1d]
	mov	r1, #2
	orr	r0, r1
	strb	r0, [r4, #0x1d]
	b	.Lf9ebe
.Lf9eb2:
	mov	r1, r2
	ldrb	r2, [r5, #9]
	ldr	r0, [r4, #0x24]
	bl	MidiKeyToFreq
	str	r0, [r4, #0x20]
.Lf9ebe:
	ldr	r4, [r4, #0x34]
	cmp	r4, #0
	bne	.Lf9e52
.Lf9ec4:
	ldrb	r0, [r5]
	mov	r1, #0xf0
	and	r0, r1
	strb	r0, [r5]
	mov	r2, r9
.Lf9ece:
	sub	r2, #1
	ble	.Lf9ed8
	mov	r0, #0x50
	add	r5, r0
	bgt	.Lf9e34
.Lf9ed8:
	ldr	r0, .Lf9ef4	@ 0x68736d53
	str	r0, [r7, #0x34]
	pop	{r0, r1, r2, r3, r4, r5, r6, r7}
	mov	r8, r0
	mov	r9, r1
	mov	r10, r2
	mov	r11, r3
	pop	{r3}
.func_end MPlayMain

.thumb_func_start call_r3_f9ee8
	bx	r3
.func_end call_r3_f9ee8

.Lf9eec:
	.word	gClockTable
.Lf9ef0:
	.word	SOUND_INFO_PTR
.Lf9ef4:
	.word	0x68736d53

	.section .rodata


global_label gMPlayJumpTableTemplate
    .word ply_fine
    .word ply_goto
    .word ply_patt
    .word ply_pend
    .word ply_rept
    .word ply_fine
    .word ply_fine
    .word ply_fine
    .word ply_fine
    .word ply_prio
    .word ply_tempo
    .word ply_keysh
    .word ply_voice
    .word ply_vol
    .word ply_pan
    .word ply_bend
    .word ply_bendr
    .word ply_lfos
    .word ply_lfodl
    .word ply_mod
    .word ply_modt
    .word ply_fine
    .word ply_fine
    .word ply_tune
    .word ply_fine
    .word ply_fine
    .word ply_fine
    .word ply_port
    .word ply_fine
    .word ply_endtie
    .word SampleFreqSet
    .word TrackStop
    .word FadeOutBody
    .word TrkVolPitSet
    .word RealClearChain
    .word SoundMainBTM
