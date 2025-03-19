call main
	ebreak
	.file	"prime.c"
	.option nopic
	.attribute arch, "rv32i2p1_m2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.globl	arr
	.bss
	.align	2
	.type	arr, @object
	.size	arr, 200
arr:
	.zero	200
	.text
	.align	2
	.globl	is_prime
	.type	is_prime, @function
is_prime:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	lw	a4,-36(s0)
	li	a5,1
	bgt	a4,a5,.L2
	li	a5,0
	j	.L3
.L2:
	li	a5,2
	sw	a5,-20(s0)
	j	.L4
.L6:
	lw	a4,-36(s0)
	lw	a5,-20(s0)
	rem	a5,a4,a5
	bne	a5,zero,.L5
	li	a5,0
	j	.L3
.L5:
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L4:
	lw	a5,-20(s0)
	mul	a5,a5,a5
	lw	a4,-36(s0)
	bge	a4,a5,.L6
	li	a5,1
.L3:
	mv	a0,a5
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	is_prime, .-is_prime
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	sw	zero,-20(s0)
	j	.L8
.L9:
	lw	a0,-20(s0)
	call	is_prime
	mv	a3,a0
	lui	a5,0
	addi	a4,a5,0
	lw	a5,-20(s0)
	slli	a5,a5,2
	add	a5,a4,a5
	sw	a3,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L8:
	lw	a4,-20(s0)
	li	a5,49
	ble	a4,a5,.L9
	li	a5,0
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	main, .-main
	.ident	"GCC: () 14.2.0"
	.section	.note.GNU-stack,"",@progbits
