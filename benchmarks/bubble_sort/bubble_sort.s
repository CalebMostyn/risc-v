	call main
	ebreak
	.file	"bubble_sort.c"
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
	.globl	swap
	.type	swap, @function
swap:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	sw	a2,-44(s0)
	lw	a5,-40(s0)
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a5,a4,a5
	lw	a5,0(a5)
	sw	a5,-20(s0)
	lw	a5,-44(s0)
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a4,a4,a5
	lw	a5,-40(s0)
	slli	a5,a5,2
	lw	a3,-36(s0)
	add	a5,a3,a5
	lw	a4,0(a4)
	sw	a4,0(a5)
	lw	a5,-44(s0)
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a5,a4,a5
	lw	a4,-20(s0)
	sw	a4,0(a5)
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	swap, .-swap
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	sw	zero,-20(s0)
	j	.L3
.L7:
	sw	zero,-24(s0)
	j	.L4
.L6:
	lui	a5,0
	addi	a4,a5,0
	lw	a5,-24(s0)
	slli	a5,a5,2
	add	a5,a4,a5
	lw	a4,0(a5)
	lw	a5,-24(s0)
	addi	a5,a5,1
	lui	a3,0
	addi	a3,a3,0
	slli	a5,a5,2
	add	a5,a3,a5
	lw	a5,0(a5)
	ble	a4,a5,.L5
	lw	a5,-24(s0)
	addi	a5,a5,1
	mv	a2,a5
	lw	a1,-24(s0)
	lui	a5,0
	addi	a0,a5,0
	call	swap
.L5:
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L4:
	li	a4,49
	lw	a5,-20(s0)
	sub	a5,a4,a5
	lw	a4,-24(s0)
	blt	a4,a5,.L6
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L3:
	lw	a4,-20(s0)
	li	a5,48
	ble	a4,a5,.L7
	nop
	nop
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	main, .-main
	.ident	"GCC: () 14.2.0"
	.section	.note.GNU-stack,"",@progbits
