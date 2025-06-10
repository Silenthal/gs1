	.include "macros.inc"
	.include "gba.inc"

.thumb_func_start Func_49a8
	bx	lr
.func_end Func_49a8


@@ Initializes the matrix stack and sets the active matrix to the identity.
.thumb_func_start InitMatrixStack
	push	{r5, lr}
	mov	r1, #0x30
	mov	r0, #2
	ldr	r5, =iwram_1d2c
	bl	AllocEwramAtIndex
	ldr	r2, =iwram_1cc4
	mov	r3, #0
	str	r3, [r2]
	str	r0, [r5]
	ldr	r3, =gMatrix
	mov	r0, r3
	mov	r1, #0x80
	mov	r2, #0
	mov	r3, #0
	mov	r4, #0
	lsl	r1, #9
	stmia	r0!, {r1, r2, r3, r4}
	stmia	r0!, {r1, r2, r3, r4}
	stmia	r0!, {r1, r2, r3, r4}
	pop	{r5}
	pop	{r0}
	bx	r0
.func_end InitMatrixStack


@@ Saves the active matrix to the stack.
.thumb_func_start MatrixPush
	push	{r5, lr}
	ldr	r5, =iwram_1cc4
	ldr	r3, [r5]
	cmp	r3, #0
	bgt	.L4a0c
	ldr	r4, =iwram_1d2c
	ldr	r3, =REG_DMA3SAD
	ldr	r0, =gMatrix
	ldr	r1, [r4]
	ldr	r2, =0x8400000c
	stmia	r3!, {r0, r1, r2}
	sub	r3, #0xc
	ldr	r3, [r5]
	add	r3, #1
	str	r3, [r5]
	ldr	r3, [r4]
	add	r3, #0x30
	str	r3, [r4]
.L4a0c:
	pop	{r5}
	pop	{r0}
	bx	r0
.func_end MatrixPush


@@ Gets the active matrix.
@@ In:
@@ r0 - Matrix4x3* outMat - A pointer that will hold a copy of the active matrix.
.thumb_func_start MatrixGet
	mov	r1, r0
	ldr	r3, =REG_DMA3SAD
	ldr	r0, =gMatrix
	ldr	r2, =0x8400000c
	stmia	r3!, {r0, r1, r2}
	sub	r3, #0xc
	bx	lr
.func_end MatrixGet


@@ Sets the active matrix to the given value.
@@ In:
@@ r0 - Matrix4x3* inMat - A pointer to the matrix.
.thumb_func_start MatrixSet
	ldr	r3, =REG_DMA3SAD
	ldr	r1, =gMatrix
	ldr	r2, =0x8400000c
	stmia	r3!, {r0, r1, r2}
	sub	r3, #0xc
	bx	lr
.func_end MatrixSet


@@ Pops the saved matrix to the active matrix.
.thumb_func_start MatrixPop
	push	{lr}
	ldr	r2, =iwram_1cc4
	ldr	r3, [r2]
	cmp	r3, #0
	ble	.L4a7c
	sub	r3, #1
	str	r3, [r2]
	ldr	r3, =iwram_1d2c
	ldr	r0, [r3]
	sub	r0, #0x30
	str	r0, [r3]
	ldr	r1, =gMatrix
	ldr	r3, =REG_DMA3SAD
	ldr	r2, =0x8400000c
	stmia	r3!, {r0, r1, r2}
	sub	r3, #0xc
.L4a7c:
	pop	{r0}
	bx	r0
.func_end MatrixPop


@@ Sets the active matrix to the identity.
.thumb_func_start MatrixReset
	ldr	r3, =gMatrix
	mov	r0, r3
	mov	r1, #0x80
	mov	r2, #0
	mov	r3, #0
	mov	r4, #0
	lsl	r1, #9
	stmia	r0!, {r1, r2, r3, r4}
	stmia	r0!, {r1, r2, r3, r4}
	stmia	r0!, {r1, r2, r3, r4}
	bx	lr
.func_end MatrixReset


@@ Rotates the active matrix by given X, Y, and Z angles.
@@ In:
@@ r0 - Vector3* vec - The vector containing the three angles to rotate by.
@@
@@ Notes:
@@ vec = [a, b, y]
@@ sa = sin(a), sb = sin(b), sy = sin(y)
@@ ca = cos(a), cb = cos(b), cy = cos(y)
@@
@@ mat = |  cb * cy | sa * sb * cy - ca * sy | ca * sb * cy + sa * sy | 0
@@       |  cb * sy | sa * sb * sy + ca * cy | ca * sb * sy - sa * cy | 0
@@       | -sb      | sa * cb                | ca * cb                | 0
.thumb_func_start MatrixRotate
	push	{r5, r6, lr}
	mov	r6, r11
	mov	r5, r10
	push	{r5, r6}
	mov	r6, r9
	mov	r5, r8
	push	{r5, r6}
	mov	r5, r0
	ldr	r0, [r5]
	sub	sp, #0x30
	bl	Sin
	mov	r10, r0
	ldr	r0, [r5]
	bl	Cos
	mov	r9, r0
	ldr	r0, [r5, #4]
	bl	Sin
	mov	r8, r0
	ldr	r0, [r5, #4]
	bl	Cos
	mov	r11, r0
	ldr	r0, [r5, #8]
	bl	Sin
	mov	r6, r0
	ldr	r0, [r5, #8]
	bl	Cos
	mov	r14, r0
	ldr	r3, =Func_888
	mov	r0, r11
	mov	r1, r14
	.call_via r3
	mov	r5, sp
	str	r0, [r5]
	mov	r1, r6
	mov	r0, r11
	.call_via r3
	mov	r1, r8
	neg	r2, r1
	str	r0, [r5, #4]
	str	r2, [r5, #8]
	mov	r0, r10
	.call_via r3
	mov	r1, r14
	.call_via r3
	mov	r4, r0
	mov	r1, r6
	mov	r0, r9
	.call_via r3
	sub	r4, r0
	str	r4, [r5, #0xc]
	mov	r0, r10
	mov	r1, r8
	.call_via r3
	mov	r1, r6
	.call_via r3
	mov	r4, r0
	mov	r1, r14
	mov	r0, r9
	.call_via r3
	add	r4, r0
	str	r4, [r5, #0x10]
	mov	r0, r10
	mov	r1, r11
	.call_via r3
	str	r0, [r5, #0x14]
	mov	r1, r8
	mov	r0, r9
	.call_via r3
	mov	r1, r14
	.call_via r3
	mov	r4, r0
	mov	r1, r6
	mov	r0, r10
	.call_via r3
	add	r4, r0
	str	r4, [r5, #0x18]
	mov	r0, r9
	mov	r1, r8
	.call_via r3
	mov	r1, r6
	.call_via r3
	mov	r4, r0
	mov	r1, r14
	mov	r0, r10
	.call_via r3
	sub	r4, r0
	str	r4, [r5, #0x1c]
	mov	r0, r9
	mov	r1, r11
	.call_via r3
	mov	r3, #0
	str	r0, [r5, #0x20]
	str	r3, [r5, #0x24]
	str	r3, [r5, #0x28]
	str	r3, [r5, #0x2c]
	mov	r0, r5
	ldr	r3, =MatrixMultiply
	bl	_call_via_r3
	add	sp, #0x30
	pop	{r3, r5, r6}
	mov	r8, r3
	mov	r9, r5
	mov	r10, r6
	pop	{r3}
	mov	r11, r3
	pop	{r5, r6}
	pop	{r0}
	bx	r0
.func_end MatrixRotate


@@ Rotates the active matrix around the X axis by the given angle
@@ In:
@@ r0 - FIXED angle - The angle to rotate by.
@@
@@ Notes:
@@ angle = a
@@ s = sin(a)
@@ c = cos(a)
@@
@@ mat = | 1 | 0 |  0 | 0
@@       | 0 | c | -s | 0
@@       | 0 | s |  c | 0
.thumb_func_start MatrixRotateX
	push	{r5, r6, lr}
	sub	sp, #0x30
	mov	r5, r0
	bl	Sin
	mov	r6, r0
	mov	r0, r5
	bl	Cos
	mov	r12, r0
	mov	r5, sp
	mov	r0, r5
	mov	r1, #0x80
	mov	r2, #0
	mov	r3, #0
	mov	r4, #0
	lsl	r1, #9
	stmia	r0!, {r1, r2, r3, r4}
	stmia	r0!, {r1, r2, r3, r4}
	stmia	r0!, {r1, r2, r3, r4}
	mov	r3, r12
	str	r6, [r5, #0x14]
	neg	r6, r6
	str	r3, [r5, #0x10]
	str	r3, [r5, #0x20]
	str	r6, [r5, #0x1c]
	ldr	r3, =MatrixMultiply
	mov	r0, r5
	bl	_call_via_r3
	add	sp, #0x30
	pop	{r5, r6}
	pop	{r0}
	bx	r0
.func_end MatrixRotateX


@@ Rotates the active matrix around the Y axis by the given angle
@@ In:
@@ r0 - FIXED angle - The angle to rotate by.
@@
@@ Notes:
@@ angle = a
@@ s = sin(a)
@@ c = cos(a)
@@
@@ mat = |  c | 0 | s | 0
@@       |  0 | 1 | 0 | 0
@@       | -s | 0 | c | 0
.thumb_func_start MatrixRotateY
	push	{r5, r6, lr}
	mov	r6, r8
	push	{r6}
	sub	sp, #0x30
	mov	r5, r0
	bl	Sin
	mov	r8, r0
	mov	r0, r5
	bl	Cos
	mov	r6, r0
	mov	r5, sp
	mov	r0, r5
	mov	r1, #0x80
	mov	r2, #0
	mov	r3, #0
	mov	r4, #0
	lsl	r1, #9
	stmia	r0!, {r1, r2, r3, r4}
	stmia	r0!, {r1, r2, r3, r4}
	stmia	r0!, {r1, r2, r3, r4}
	mov	r2, r8
	neg	r3, r2
	str	r3, [r5, #8]
	str	r6, [r5]
	str	r2, [r5, #0x18]
	str	r6, [r5, #0x20]
	ldr	r3, =MatrixMultiply
	mov	r0, r5
	bl	_call_via_r3
	add	sp, #0x30
	pop	{r3}
	mov	r8, r3
	pop	{r5, r6}
	pop	{r0}
	bx	r0
.func_end MatrixRotateY


@@ Rotates the active matrix around the Z axis by the given angle
@@ In:
@@ r0 - FIXED angle - The angle to rotate by.
@@
@@ Notes:
@@ angle = a
@@ s = sin(a)
@@ c = cos(a)
@@
@@ mat = | c | -s | 0 | 0
@@       | s |  c | 0 | 0
@@       | 0 |  0 | 1 | 0
.thumb_func_start MatrixRotateZ
	push	{r5, r6, lr}
	sub	sp, #0x30
	mov	r5, r0
	bl	Sin
	mov	r6, r0
	mov	r0, r5
	bl	Cos
	mov	r12, r0
	mov	r5, sp
	mov	r0, r5
	mov	r1, #0x80
	mov	r2, #0
	mov	r3, #0
	mov	r4, #0
	lsl	r1, #9
	stmia	r0!, {r1, r2, r3, r4}
	stmia	r0!, {r1, r2, r3, r4}
	stmia	r0!, {r1, r2, r3, r4}
	mov	r3, r12
	str	r6, [r5, #4]
	neg	r6, r6
	str	r3, [r5]
	str	r3, [r5, #0x10]
	str	r6, [r5, #0xc]
	ldr	r3, =MatrixMultiply
	mov	r0, r5
	bl	_call_via_r3
	add	sp, #0x30
	pop	{r5, r6}
	pop	{r0}
	bx	r0
.func_end MatrixRotateZ


@@ Translates the active matrix by the given X, Y, and Z offsets.
@@ In:
@@ r0 - Vector3* vec - The units the matrix is to be scaled in the X, Y, and Z axis.
@@
@@ Notes:
@@ vec = [x, y, z]
@@
@@ mat = | 1 | 0 | 0 | x
@@       | 0 | 1 | 0 | y
@@       | 0 | 0 | 1 | z
.thumb_func_start MatrixTranslateV
	push	{r5, r6, lr}
	sub	sp, #0x30
	mov	r6, r0
	mov	r5, sp
	mov	r0, r5
	mov	r1, #0x80
	mov	r2, #0
	mov	r3, #0
	mov	r4, #0
	lsl	r1, #9
	stmia	r0!, {r1, r2, r3, r4}
	stmia	r0!, {r1, r2, r3, r4}
	stmia	r0!, {r1, r2, r3, r4}
	ldr	r3, [r6]
	str	r3, [r5, #0x24]
	ldr	r3, [r6, #4]
	str	r3, [r5, #0x28]
	ldr	r3, [r6, #8]
	mov	r0, r5
	str	r3, [r5, #0x2c]
	ldr	r3, =MatrixMultiply
	bl	_call_via_r3
	add	sp, #0x30
	pop	{r5, r6}
	pop	{r0}
	bx	r0
.func_end MatrixTranslateV


@@ Scales the active matrix by the given X, Y, and Z amounts.
@@ In:
@@ r0 - Vector3* vec - The amount to scale in the X, Y, and Z axis.
@@
@@ Notes:
@@ vec = [x, y, z]
@@
@@ mat = | x | 0 | 0 | 0
@@       | 0 | y | 0 | 0
@@       | 0 | 0 | z | 0
.thumb_func_start MatrixScaleV
	push	{r5, r6, lr}
	sub	sp, #0x30
	mov	r6, r0
	mov	r5, sp
	mov	r0, r5
	mov	r1, #0x80
	mov	r2, #0
	mov	r3, #0
	mov	r4, #0
	lsl	r1, #9
	stmia	r0!, {r1, r2, r3, r4}
	stmia	r0!, {r1, r2, r3, r4}
	stmia	r0!, {r1, r2, r3, r4}
	ldr	r3, [r6]
	str	r3, [r5]
	ldr	r3, [r6, #4]
	str	r3, [r5, #0x10]
	ldr	r3, [r6, #8]
	mov	r0, r5
	str	r3, [r5, #0x20]
	ldr	r3, =MatrixMultiply
	bl	_call_via_r3
	add	sp, #0x30
	pop	{r5, r6}
	pop	{r0}
	bx	r0
.func_end MatrixScaleV


@@ Rotates and translates the active matrix by given X, Y, and Z angles.
@@ In:
@@ r0 - Vector3* rot - The vector containing the three angles to rotate by.
@@ r1 - Vector3* trans - The units the matrix is to be scaled in the X, Y, and Z axis.
@@
@@ Notes:
@@ rot = [a, b, y]
@@ trans = [x, y, z]
@@ sa = sin(a), sb = sin(b), sy = sin(y)
@@ ca = cos(a), cb = cos(b), cy = cos(y)
@@
@@ mat = |  cb * cy | sa * sb * cy - ca * sy | ca * sb * cy + sa * sy | x
@@       |  cb * sy | sa * sb * sy + ca * cy | ca * sb * sy - sa * cy | y
@@       | -sb      | sa * cb                | ca * cb                | z
.thumb_func_start MatrixRotateTrans
	push	{r5, r6, r7, lr}
	mov	r7, r11
	mov	r6, r10
	mov	r5, r9
	push	{r5, r6, r7}
	mov	r7, r8
	push	{r7}
	mov	r5, r0
	ldr	r0, [r5]
	mov	r7, r1
	sub	sp, #0x30
	bl	Sin
	mov	r10, r0
	ldr	r0, [r5]
	bl	Cos
	mov	r9, r0
	ldr	r0, [r5, #4]
	bl	Sin
	mov	r8, r0
	ldr	r0, [r5, #4]
	bl	Cos
	mov	r11, r0
	ldr	r0, [r5, #8]
	bl	Sin
	mov	r6, r0
	ldr	r0, [r5, #8]
	bl	Cos
	mov	r14, r0
	ldr	r3, =Func_888
	mov	r0, r11
	mov	r1, r14
	.call_via r3
	mov	r5, sp
	str	r0, [r5]
	mov	r1, r6
	mov	r0, r11
	.call_via r3
	mov	r1, r8
	neg	r2, r1
	str	r0, [r5, #4]
	str	r2, [r5, #8]
	mov	r0, r10
	.call_via r3
	mov	r1, r14
	.call_via r3
	mov	r4, r0
	mov	r1, r6
	mov	r0, r9
	.call_via r3
	sub	r4, r0
	str	r4, [r5, #0xc]
	mov	r0, r10
	mov	r1, r8
	.call_via r3
	mov	r1, r6
	.call_via r3
	mov	r4, r0
	mov	r1, r14
	mov	r0, r9
	.call_via r3
	add	r4, r0
	str	r4, [r5, #0x10]
	mov	r0, r10
	mov	r1, r11
	.call_via r3
	str	r0, [r5, #0x14]
	mov	r1, r8
	mov	r0, r9
	.call_via r3
	mov	r1, r14
	.call_via r3
	mov	r4, r0
	mov	r1, r6
	mov	r0, r10
	.call_via r3
	add	r4, r0
	str	r4, [r5, #0x18]
	mov	r0, r9
	mov	r1, r8
	.call_via r3
	mov	r1, r6
	.call_via r3
	mov	r4, r0
	mov	r1, r14
	mov	r0, r10
	.call_via r3
	sub	r4, r0
	str	r4, [r5, #0x1c]
	mov	r0, r9
	mov	r1, r11
	.call_via r3
	str	r0, [r5, #0x20]
	ldr	r3, [r7]
	str	r3, [r5, #0x24]
	ldr	r3, [r7, #4]
	str	r3, [r5, #0x28]
	ldr	r3, [r7, #8]
	mov	r0, r5
	str	r3, [r5, #0x2c]
	ldr	r3, =MatrixMultiply
	bl	_call_via_r3
	add	sp, #0x30
	pop	{r3, r5, r6, r7}
	mov	r8, r3
	mov	r9, r5
	mov	r10, r6
	mov	r11, r7
	pop	{r5, r6, r7}
	pop	{r0}
	bx	r0
.func_end MatrixRotateTrans


@@ Applies rotation, translation, and scaling to the active matrix.
@@ In:
@@ r0 - Vector3* rot - The vector containing the three angles to rotate by.
@@ r1 - Vector3* trans - The units the matrix is to be scaled in the X, Y, and Z axis.
@@ r2 - Vector3* scale - The amount to scale in the X, Y, and Z axis.
.thumb_func_start MatrixRotateTransScale
	push	{r5, r6, r7, lr}
	mov	r7, r11
	mov	r6, r10
	mov	r5, r9
	push	{r5, r6, r7}
	mov	r7, r8
	push	{r7}
	sub	sp, #0x38
	str	r1, [sp, #4]
	str	r2, [sp]
	mov	r5, r0
	ldr	r0, [r5]
	bl	Sin
	mov	r10, r0
	ldr	r0, [r5]
	bl	Cos
	mov	r9, r0
	ldr	r0, [r5, #4]
	bl	Sin
	mov	r8, r0
	ldr	r0, [r5, #4]
	bl	Cos
	mov	r11, r0
	ldr	r0, [r5, #8]
	bl	Sin
	mov	r6, r0
	ldr	r0, [r5, #8]
	bl	Cos
	ldr	r2, [sp]
	mov	r14, r0
	ldr	r7, [r2]
	ldr	r3, =Func_888
	mov	r0, r11
	mov	r1, r14
	.call_via r3
	mov	r1, r0
	mov	r0, r7
	.call_via r3
	add	r5, sp, #8
	str	r0, [r5]
	mov	r1, r6
	mov	r0, r11
	.call_via r3
	mov	r1, r0
	mov	r0, r7
	.call_via r3
	mov	r2, r8
	str	r0, [r5, #4]
	neg	r1, r2
	mov	r0, r7
	.call_via r3
	str	r0, [r5, #8]
	ldr	r2, [sp]
	mov	r0, r10
	ldr	r7, [r2, #4]
	mov	r1, r8
	.call_via r3
	mov	r1, r14
	.call_via r3
	mov	r4, r0
	mov	r1, r6
	mov	r0, r9
	.call_via r3
	sub	r4, r0
	mov	r1, r4
	mov	r0, r7
	.call_via r3
	str	r0, [r5, #0xc]
	mov	r1, r8
	mov	r0, r10
	.call_via r3
	mov	r1, r6
	.call_via r3
	mov	r4, r0
	mov	r1, r14
	mov	r0, r9
	.call_via r3
	add	r4, r0
	mov	r1, r4
	mov	r0, r7
	.call_via r3
	str	r0, [r5, #0x10]
	mov	r1, r11
	mov	r0, r10
	.call_via r3
	mov	r1, r0
	mov	r0, r7
	.call_via r3
	str	r0, [r5, #0x14]
	ldr	r2, [sp]
	mov	r0, r9
	ldr	r7, [r2, #8]
	mov	r1, r8
	.call_via r3
	mov	r1, r14
	.call_via r3
	mov	r4, r0
	mov	r1, r6
	mov	r0, r10
	.call_via r3
	add	r4, r0
	mov	r1, r4
	mov	r0, r7
	.call_via r3
	str	r0, [r5, #0x18]
	mov	r1, r8
	mov	r0, r9
	.call_via r3
	mov	r1, r6
	.call_via r3
	mov	r4, r0
	mov	r1, r14
	mov	r0, r10
	.call_via r3
	sub	r4, r0
	mov	r1, r4
	mov	r0, r7
	.call_via r3
	str	r0, [r5, #0x1c]
	mov	r1, r11
	mov	r0, r9
	.call_via r3
	mov	r1, r0
	mov	r0, r7
	.call_via r3
	str	r0, [r5, #0x20]
	ldr	r2, [sp, #4]
	ldr	r3, [r2]
	str	r3, [r5, #0x24]
	ldr	r3, [r2, #4]
	str	r3, [r5, #0x28]
	ldr	r3, [r2, #8]
	mov	r0, r5
	str	r3, [r5, #0x2c]
	ldr	r3, =MatrixMultiply
	bl	_call_via_r3
	add	sp, #0x38
	pop	{r3, r5, r6, r7}
	mov	r8, r3
	mov	r9, r5
	mov	r10, r6
	mov	r11, r7
	pop	{r5, r6, r7}
	pop	{r0}
	bx	r0
.func_end MatrixRotateTransScale

.thumb_func_start Func_4fe4
	push	{r5, r6, r7, lr}
	mov	r7, r11
	mov	r6, r10
	mov	r5, r9
	push	{r5, r6, r7}
	mov	r7, r8
	push	{r7}
	sub	sp, #0x40
	str	r0, [sp, #0x20]
	mov	r0, sp
	add	r0, #0x24
	str	r0, [sp, #0xc]
	mov	r4, r1
	mov	r9, r2
	ldr	r3, =REG_DMA3SAD
	ldr	r0, =.L7994
	ldr	r1, [sp, #0xc]
	ldr	r2, =0x84000007
	stmia	r3!, {r0, r1, r2}
	sub	r3, #0xc
	ldr	r1, [sp, #0x20]
	ldr	r2, [r4]
	ldr	r3, [r1]
	sub	r2, r3
	str	r2, [sp, #0x1c]
	ldr	r3, [r1, #4]
	ldr	r2, [r4, #4]
	sub	r2, r3
	str	r2, [sp, #0x18]
	ldr	r3, [r1, #8]
	ldr	r2, [r4, #8]
	sub	r2, r3
	str	r2, [sp, #0x14]
	ldr	r4, [sp, #0x18]
	ldr	r2, [sp, #0x1c]
	ldr	r0, [sp, #0x14]
	asr	r1, r2, #8
	asr	r3, r4, #8
	asr	r2, r0, #8
	str	r2, [sp]
	str	r2, [sp, #4]
	ldr	r4, [sp, #0xc]
	mov	r2, r3
	mov	r0, r1
	bl	_call_via_r4
	ldr	r3, =Func_948
	bl	_call_via_r3
	mov	r1, r0
	ldr	r0, =udiv
	mov	r11, r0
	mov	r0, #0x80
	lsl	r0, #24
	bl	_call_via_r11
	lsr	r3, r0, #15
	neg	r3, r3
	ldr	r5, =Func_888
	ldr	r0, [sp, #0x1c]
	mov	r1, r3
	.call_via r5
	str	r0, [sp, #0x1c]
	mov	r1, r3
	ldr	r0, [sp, #0x18]
	.call_via r5
	str	r0, [sp, #0x18]
	mov	r1, r3
	ldr	r0, [sp, #0x14]
	.call_via r5
	ldr	r1, [sp, #0x1c]
	neg	r1, r1
	mov	r8, r1
	str	r0, [sp, #0x14]
	ldr	r0, [sp, #0x18]
	mov	r1, r0
	.call_via r5
	mov	r3, #0x80
	lsl	r3, #9
	sub	r0, r3, r0
	cmp	r0, #0
	ble	.L50a6
	bl	Func_45d4
	mov	r1, r0
	mov	r0, #0x80
	lsl	r0, #24
	bl	_call_via_r11
	lsl	r3, r0, #1
.L50a6:
	ldr	r0, [sp, #0x14]
	mov	r1, r3
	.call_via r5
	str	r0, [sp, #0x10]
	mov	r1, r3
	mov	r0, r8
	.call_via r5
	mov	r8, r0
	mov	r1, r8
	ldr	r0, [sp, #0x18]
	.call_via r5
	mov	r10, r0
	ldr	r1, [sp, #0x10]
	ldr	r0, [sp, #0x14]
	.call_via r5
	mov	r3, r0
	mov	r1, r8
	ldr	r0, [sp, #0x1c]
	.call_via r5
	sub	r6, r3, r0
	ldr	r1, [sp, #0x10]
	ldr	r0, [sp, #0x18]
	.call_via r5
	neg	r7, r0
	mov	r3, r6
	str	r7, [sp]
	str	r7, [sp, #4]
	mov	r1, r10
	mov	r2, r6
	ldr	r4, [sp, #0xc]
	mov	r0, r10
	bl	_call_via_r4
	bl	Func_45d4
	mov	r1, r0
	mov	r0, #0x80
	lsl	r0, #24
	bl	_call_via_r11
	lsl	r3, r0, #1
	mov	r1, r3
	mov	r0, r10
	.call_via r5
	mov	r10, r0
	mov	r1, r3
	mov	r0, r6
	.call_via r5
	mov	r6, r0
	mov	r1, r3
	mov	r0, r7
	.call_via r5
	ldr	r1, [sp, #0x20]
	mov	r7, r0
	ldr	r1, [r1, #4]
	ldr	r0, [sp, #0x20]
	ldr	r2, [sp, #0x20]
	ldr	r0, [r0]
	str	r1, [sp, #8]
	ldr	r3, [sp, #0x10]
	ldr	r5, [r2, #8]
	mov	r11, r0
	mov	r4, r9
	mov	r0, #0
	mov	r1, r8
	str	r3, [r4]
	str	r0, [r4, #0xc]
	str	r1, [r4, #0x18]
	ldr	r1, [sp, #0x10]
	str	r0, [sp]
	str	r0, [sp, #4]
	ldr	r4, [sp, #0xc]
	mov	r2, r5
	mov	r3, r8
	mov	r0, r11
	bl	_call_via_r4
	mov	r1, r9
	mov	r2, r10
	neg	r0, r0
	str	r0, [r1, #0x24]
	str	r6, [r1, #0x10]
	str	r7, [r1, #0x1c]
	str	r2, [r1, #4]
	ldr	r2, [sp, #8]
	str	r5, [sp]
	str	r7, [sp, #4]
	ldr	r4, [sp, #0xc]
	mov	r1, r10
	mov	r3, r6
	mov	r0, r11
	bl	_call_via_r4
	mov	r1, r9
	neg	r0, r0
	str	r0, [r1, #0x28]
	ldr	r2, [sp, #0x1c]
	str	r2, [r1, #8]
	ldr	r3, [sp, #0x18]
	str	r3, [r1, #0x14]
	ldr	r4, [sp, #0x14]
	str	r4, [r1, #0x20]
	ldr	r1, [sp, #0x1c]
	str	r5, [sp]
	str	r4, [sp, #4]
	ldr	r2, [sp, #8]
	ldr	r3, [sp, #0x18]
	ldr	r4, [sp, #0xc]
	mov	r0, r11
	bl	_call_via_r4
	mov	r1, r9
	neg	r0, r0
	str	r0, [r1, #0x2c]
	add	sp, #0x40
	pop	{r3, r5, r6, r7}
	mov	r8, r3
	mov	r9, r5
	mov	r10, r6
	mov	r11, r7
	pop	{r5, r6, r7}
	pop	{r0}
	bx	r0
.func_end Func_4fe4

.thumb_func_start Func_51d8
	push	{lr}
	ldr	r2, =gMatrix
	bl	Func_4fe4
	pop	{r0}
	bx	r0
.func_end Func_51d8

.thumb_func_start Func_51e8
	push	{r5, lr}
	sub	sp, #0x30
	mov	r5, sp
	mov	r2, r5
	bl	Func_4fe4
	ldr	r3, =MatrixMultiply
	mov	r0, r5
	bl	_call_via_r3
	add	sp, #0x30
	pop	{r5}
	pop	{r0}
	bx	r0
.func_end Func_51e8

	.section .rodata

.L7994:
	.incrom 0x7994, 0x79b0
