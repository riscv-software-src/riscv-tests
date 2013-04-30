	.file	1 "syscalls.c"
	.section .mdebug.abi64
	.previous
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
$LC0:
	.ascii	"0123456789abcdef\000"
	.text
	.align	2
	.ent	printnum
	.type	printnum, @function
printnum:
	.frame	x30,64,x1		# vars= 0, regs= 7/0, args= 0
	.mask	0x03f00002,-8
	.fmask	0x00000000,0
	add	x30,x30,-64
	sd	x22,32(x30)
	sll	x22,x7,32
	srl	x22,x22,32
	sd	x24,48(x30)
	sd	x23,40(x30)
	sd	x21,24(x30)
	sd	x20,16(x30)
	sd	x25,56(x30)
	sd	x1,8(x30)
	move	x23,x6
	move	x20,x4
	move	x21,x5
	move	x24,x9
	bleu	x22,x6,$L2
	addw	x8,x8,-1
	move	x25,x8
	ble	x8,x0,$L4
$L6:
	addw	x25,x25,-1
	move	x4,x24
	move	x5,x21
	jalr	x20
	bne	x25,x0,$L6
$L4:
	lui	x2,%hi($LC0)
	add	x2,x2,%lo($LC0)
	remu	x22,x23,x22
	add	x22,x22,x2
	lb	x4,0(x22)
	move	x5,x21
	move	x19,x20
	ld	x25,56(x30)
	ld	x24,48(x30)
	ld	x23,40(x30)
	ld	x22,32(x30)
	ld	x21,24(x30)
	ld	x20,16(x30)
	ld	x1,8(x30)
	add	x30,x30,64
	jr	x19
$L2:
	addw	x8,x8,-1
	divu	x6,x6,x22
	jal	printnum
	j	$L4
	.end	printnum
	.size	printnum, .-printnum
	.align	2
	.ent	getuint
	.type	getuint, @function
getuint:
	.frame	x30,0,x1		# vars= 0, regs= 0/0, args= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	slt	x2,x5,2
	bne	x2,x0,$L10
$L13:
	ld	x2,0(x4)
	add	x3,x2,8
	sd	x3,0(x4)
	ld	x2,0(x2)
	ret
$L10:
	bne	x5,x0,$L13
	ld	x3,0(x4)
	lwu	x2,0(x3)
	add	x3,x3,8
	sd	x3,0(x4)
	ret
	.end	getuint
	.size	getuint, .-getuint
	.align	2
	.globl	putchar
	.ent	putchar
	.type	putchar, @function
putchar:
	.frame	x30,64,x1		# vars= 64, regs= 0/0, args= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	li	x2,-1			# 0xffffffffffffffff
	add	x30,x30,-64
	lui	x3,%hi(buflen.1596)
	beq	x4,x2,$L21
	lw	x5,%lo(buflen.1596)(x3)
	lui	x2,%hi(buf.1595)
	add	x2,x2,%lo(buf.1595)
	add	x6,x2,x5
	sb	x4,0(x6)
	addw	x5,x5,1
	li	x4,64			# 0x40
	sw	x5,%lo(buflen.1596)(x3)
	beq	x5,x4,$L15
	move	x2,x0
	add	x30,x30,64
	j	x1
$L21:
	lui	x2,%hi(buf.1595)
	add	x2,x2,%lo(buf.1595)
$L15:
	lw	x4,%lo(buflen.1596)(x3)
	li	x5,4			# 0x4
	sd	x0,0(x30)
	sd	x0,8(x30)
	sd	x0,16(x30)
	sd	x0,24(x30)
	sd	x0,32(x30)
	sd	x0,40(x30)
	sd	x0,48(x30)
	sd	x0,56(x30)
	sd	x5,0(x30)
	li	x5,1			# 0x1
	sd	x5,8(x30)
	sd	x2,16(x30)
	sd	x4,24(x30)
	fence
 #APP
 # 45 "syscalls.c" 1
	mtpcr x2,x30,cr30
 # 0 "" 2
 #NO_APP
$L17:
 #APP
 # 46 "syscalls.c" 1
	mfpcr x2,cr31
 # 0 "" 2
 #NO_APP
	beq	x2,x0,$L17
	move	x2,x0
	sw	x0,%lo(buflen.1596)(x3)
	add	x30,x30,64
	j	x1
	.end	putchar
	.size	putchar, .-putchar
	.align	2
	.globl	exit
	.ent	exit
	.type	exit, @function
exit:
	.frame	x30,64,x1		# vars= 64, regs= 0/0, args= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	add	x30,x30,-64
	li	x2,1			# 0x1
	sd	x0,0(x30)
	sd	x0,8(x30)
	sd	x0,16(x30)
	sd	x0,24(x30)
	sd	x0,32(x30)
	sd	x0,40(x30)
	sd	x0,48(x30)
	sd	x0,56(x30)
	sd	x2,0(x30)
	sd	x4,8(x30)
	fence
 #APP
 # 12 "syscalls.c" 1
	mtpcr x2,x30,cr30
 # 0 "" 2
 #NO_APP
$L23:
	j	$L23
	.end	exit
	.size	exit, .-exit
	.align	2
	.globl	printstr
	.ent	printstr
	.type	printstr, @function
printstr:
	.frame	x30,80,x1		# vars= 64, regs= 1/0, args= 0
	.mask	0x00000002,-8
	.fmask	0x00000000,0
	add	x30,x30,-80
	li	x3,4			# 0x4
	sd	x0,0(x30)
	sd	x0,8(x30)
	sd	x0,16(x30)
	sd	x0,24(x30)
	sd	x0,32(x30)
	sd	x0,40(x30)
	sd	x0,48(x30)
	sd	x0,56(x30)
	sd	x3,0(x30)
	li	x3,1			# 0x1
	sd	x3,8(x30)
	sd	x1,72(x30)
	sd	x4,16(x30)
	jal	strlen
	sd	x2,24(x30)
	fence
 #APP
 # 24 "syscalls.c" 1
	mtpcr x2,x30,cr30
 # 0 "" 2
 #NO_APP
$L25:
 #APP
 # 25 "syscalls.c" 1
	mfpcr x2,cr31
 # 0 "" 2
 #NO_APP
	beq	x2,x0,$L25
	ld	x1,72(x30)
	add	x30,x30,80
	j	x1
	.end	printstr
	.size	printstr, .-printstr
	.align	2
	.globl	printhex
	.ent	printhex
	.type	printhex, @function
printhex:
	.frame	x30,48,x1		# vars= 32, regs= 1/0, args= 0
	.mask	0x00000002,-8
	.fmask	0x00000000,0
	add	x30,x30,-48
	sd	x1,40(x30)
	add	x2,x30,15
	add	x7,x30,-1
$L29:
	and	x3,x4,15
	sltu	x6,x3,10
	li	x5,87			# 0x57
	beq	x6,x0,$L28
	li	x5,48			# 0x30
$L28:
	add	x3,x5,x3
	sb	x3,0(x2)
	add	x2,x2,-1
	srl	x4,x4,4
	bne	x2,x7,$L29
	move	x4,x30
	sb	x0,16(x30)
	jal	printstr
	ld	x1,40(x30)
	add	x30,x30,48
	j	x1
	.end	printhex
	.size	printhex, .-printhex
	.section	.rodata.str1.8
	.align	3
$LC1:
	.ascii	"(null)\000"
	.text
	.align	2
	.globl	vprintfmt
	.ent	vprintfmt
	.type	vprintfmt, @function
vprintfmt:
	.frame	x30,112,x1		# vars= 32, regs= 10/0, args= 0
	.mask	0x2ff00002,-8
	.fmask	0x00000000,0
	add	x30,x30,-112
	sd	x25,80(x30)
	lui	x25,%hi($L53)
	sd	x26,88(x30)
	sd	x24,72(x30)
	sd	x23,64(x30)
	sd	x22,56(x30)
	sd	x21,48(x30)
	sd	x20,40(x30)
	sd	x29,104(x30)
	sd	x27,96(x30)
	sd	x1,32(x30)
	move	x21,x4
	move	x20,x5
	move	x23,x6
	sd	x7,0(x30)
	li	x22,37			# 0x25
	add	x25,x25,%lo($L53)
	li	x24,-1			# 0xffffffffffffffff
	lui	x26,%hi($LC1)
	j	$L84
$L35:
	beq	x2,x0,$L32
	move	x5,x20
	add	x23,x23,1
	jalr	x21
$L84:
	lbu	x4,0(x23)
	move	x2,x4
	bne	x4,x22,$L35
	ld	x2,0(x30)
	add	x6,x23,1
	move	x7,x6
	li	x27,32			# 0x20
	sd	x0,8(x30)
	li	x3,-1			# 0xffffffffffffffff
	li	x29,-1			# 0xffffffffffffffff
	move	x5,x0
$L85:
	lbu	x4,0(x7)
	add	x23,x7,1
	addw	x8,x4,-35
	and	x9,x8,0xff
	sltu	x9,x9,86
	bne	x9,x0,$L90
$L38:
	li	x4,37			# 0x25
	move	x5,x20
	sd	x2,0(x30)
	move	x23,x6
	jalr	x21
	j	$L84
$L32:
	ld	x1,32(x30)
	ld	x29,104(x30)
	ld	x27,96(x30)
	ld	x26,88(x30)
	ld	x25,80(x30)
	ld	x24,72(x30)
	ld	x23,64(x30)
	ld	x22,56(x30)
	ld	x21,48(x30)
	ld	x20,40(x30)
	add	x30,x30,112
	j	x1
$L90:
	and	x8,x8,0xff
	sll	x8,x8,3
	add	x8,x25,x8
	ld	x8,0(x8)
	j	x8
	.section	.rodata
	.align	3
	.align	2
$L53:
	.dword	$L39
	.dword	$L38
	.dword	$L40
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L41
	.dword	$L38
	.dword	$L38
	.dword	$L42
	.dword	$L43
	.dword	$L38
	.dword	$L74
	.dword	$L44
	.dword	$L44
	.dword	$L44
	.dword	$L44
	.dword	$L44
	.dword	$L44
	.dword	$L44
	.dword	$L44
	.dword	$L44
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L45
	.dword	$L46
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L38
	.dword	$L47
	.dword	$L38
	.dword	$L38
	.dword	$L48
	.dword	$L49
	.dword	$L38
	.dword	$L38
	.dword	$L50
	.dword	$L38
	.dword	$L51
	.dword	$L38
	.dword	$L38
	.dword	$L52
	.text
$L52:
	move	x4,x30
	sd	x2,0(x30)
	jal	getuint
	move	x6,x2
	li	x7,16			# 0x10
$L73:
	move	x4,x21
	move	x5,x20
	move	x8,x29
	move	x9,x27
	jal	printnum
	j	$L84
$L39:
	li	x4,1			# 0x1
	move	x7,x23
	sd	x4,8(x30)
	j	$L85
$L40:
	move	x5,x20
	sd	x2,0(x30)
	jalr	x21
	j	$L84
$L41:
	lw	x3,0(x2)
	move	x7,x23
	add	x2,x2,8
$L54:
	bge	x29,x0,$L85
	move	x29,x3
	li	x3,-1			# 0xffffffffffffffff
	j	$L85
$L42:
	move	x7,x23
	li	x27,45			# 0x2d
	j	$L85
$L43:
	blt	x29,x0,$L91
	move	x7,x23
	j	$L85
$L74:
	move	x7,x23
	li	x27,48			# 0x30
	j	$L85
$L44:
	lb	x8,1(x7)
	addw	x3,x4,-48
	move	x7,x23
	addw	x4,x8,-48
	sltu	x4,x4,10
	beq	x4,x0,$L54
$L55:
	add	x7,x7,1
	lb	x4,0(x7)
	sllw	x9,x3,1
	sllw	x3,x3,3
	addw	x3,x9,x3
	addw	x9,x4,-48
	addw	x3,x3,x8
	sltu	x9,x9,10
	addw	x3,x3,-48
	move	x8,x4
	bne	x9,x0,$L55
	j	$L54
$L45:
	lw	x4,0(x2)
	add	x2,x2,8
	move	x5,x20
	sd	x2,0(x30)
	jalr	x21
	j	$L84
$L46:
	slt	x3,x5,2
	bne	x3,x0,$L69
$L88:
	add	x3,x2,8
	sd	x3,0(x30)
	ld	x6,0(x2)
	blt	x6,x0,$L72
$L89:
	li	x7,10			# 0xa
	j	$L73
$L47:
	addw	x5,x5,1
	move	x7,x23
	j	$L85
$L48:
	move	x4,x30
	sd	x2,0(x30)
	jal	getuint
	move	x6,x2
	li	x7,8			# 0x8
	j	$L73
$L49:
	sd	x2,0(x30)
	li	x4,48			# 0x30
	move	x5,x20
	jalr	x21
	li	x4,120			# 0x78
	move	x5,x20
	jalr	x21
	ld	x2,0(x30)
	li	x7,16			# 0x10
	add	x3,x2,8
	sd	x3,0(x30)
	ld	x6,0(x2)
	j	$L73
$L50:
	add	x4,x2,8
	sd	x4,0(x30)
	ld	x2,0(x2)
	sd	x2,16(x30)
	beq	x2,x0,$L92
$L58:
	ble	x29,x0,$L59
	li	x2,45			# 0x2d
	beq	x27,x2,$L59
	ld	x4,16(x30)
	move	x5,x3
	sd	x3,24(x30)
	jal	strnlen
	sllw	x2,x2,0
	subw	x2,x29,x2
	move	x29,x2
	ld	x3,24(x30)
	ble	x2,x0,$L59
	move	x29,x2
$L60:
	sd	x3,24(x30)
	move	x4,x27
	move	x5,x20
	addw	x29,x29,-1
	jalr	x21
	ld	x3,24(x30)
	bne	x29,x0,$L60
$L59:
	ld	x2,16(x30)
	lb	x4,0(x2)
	add	x27,x2,1
	beq	x4,x0,$L62
$L80:
	blt	x3,x0,$L67
	addw	x2,x3,-1
	move	x3,x2
	beq	x2,x24,$L62
$L67:
	ld	x2,8(x30)
	beq	x2,x0,$L63
	addw	x2,x4,-32
	sltu	x2,x2,95
	beq	x2,x0,$L93
$L63:
	sd	x3,24(x30)
	move	x5,x20
	jalr	x21
	ld	x3,24(x30)
$L64:
	lb	x4,0(x27)
	addw	x29,x29,-1
	add	x27,x27,1
	bne	x4,x0,$L80
$L62:
	ble	x29,x0,$L84
$L79:
	addw	x29,x29,-1
	li	x4,32			# 0x20
	move	x5,x20
	jalr	x21
	bne	x29,x0,$L79
	j	$L84
$L51:
	move	x4,x30
	sd	x2,0(x30)
	jal	getuint
	move	x6,x2
	li	x7,10			# 0xa
	j	$L73
$L93:
	sd	x3,24(x30)
	li	x4,63			# 0x3f
	move	x5,x20
	jalr	x21
	ld	x3,24(x30)
	j	$L64
$L91:
	move	x7,x23
	move	x29,x0
	j	$L85
$L92:
	add	x2,x26,%lo($LC1)
	sd	x2,16(x30)
	j	$L58
$L72:
	sd	x6,24(x30)
	li	x4,45			# 0x2d
	move	x5,x20
	jalr	x21
	ld	x6,24(x30)
	li	x7,10			# 0xa
	sub	x6,zero,x6
	j	$L73
$L69:
	bne	x5,x0,$L88
	lw	x6,0(x2)
	add	x2,x2,8
	sd	x2,0(x30)
	bge	x6,x0,$L89
	j	$L72
	.end	vprintfmt
	.size	vprintfmt, .-vprintfmt
	.align	2
	.globl	printf
	.ent	printf
	.type	printf, @function
printf:
	.frame	x30,96,x1		# vars= 16, regs= 1/0, args= 0
	.mask	0x00000002,-72
	.fmask	0x00000000,0
	add	x30,x30,-96
	add	x2,x30,40
	move	x3,x4
	lui	x4,%hi(putchar)
	sd	x5,40(x30)
	sd	x6,48(x30)
	sd	x7,56(x30)
	add	x4,x4,%lo(putchar)
	move	x5,x0
	move	x6,x3
	move	x7,x2
	sd	x1,24(x30)
	sd	x8,64(x30)
	sd	x9,72(x30)
	sd	x10,80(x30)
	sd	x11,88(x30)
	sd	x2,0(x30)
	jal	vprintfmt
	li	x4,-1			# 0xffffffffffffffff
	jal	putchar
	ld	x1,24(x30)
	move	x2,x0
	add	x30,x30,96
	j	x1
	.end	printf
	.size	printf, .-printf
	.local	buflen.1596
	.comm	buflen.1596,4,4
	.local	buf.1595
	.comm	buf.1595,64,8
	.ident	"GCC: (GNU) 4.6.1"
