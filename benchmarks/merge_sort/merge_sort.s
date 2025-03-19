	call main
	ebreak
	.file	"merge_sort.c"
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
	.globl	merge
	.type	merge, @function
merge:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	sw	a2,-44(s0)
	sw	a3,-48(s0)
	lw	a5,-40(s0)
	sw	a5,-20(s0)
	lw	a5,-44(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
	j	.L2
.L7:
	lw	a5,-20(s0)
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a5,a4,a5
	lw	a4,0(a5)
	lw	a5,-24(s0)
	slli	a5,a5,2
	lw	a3,-36(s0)
	add	a5,a3,a5
	lw	a5,0(a5)
	bgt	a4,a5,.L3
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
	j	.L2
.L3:
	lw	a5,-24(s0)
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a5,a4,a5
	lw	a5,0(a5)
	sw	a5,-32(s0)
	lw	a5,-24(s0)
	sw	a5,-28(s0)
	j	.L4
.L5:
	lw	a4,-28(s0)
	li	a5,1073741824
	addi	a5,a5,-1
	add	a5,a4,a5
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a4,a4,a5
	lw	a5,-28(s0)
	slli	a5,a5,2
	lw	a3,-36(s0)
	add	a5,a3,a5
	lw	a4,0(a4)
	sw	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,-1
	sw	a5,-28(s0)
.L4:
	lw	a4,-28(s0)
	lw	a5,-20(s0)
	bgt	a4,a5,.L5
	lw	a5,-20(s0)
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a5,a4,a5
	lw	a4,-32(s0)
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
	lw	a5,-44(s0)
	addi	a5,a5,1
	sw	a5,-44(s0)
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L2:
	lw	a4,-20(s0)
	lw	a5,-44(s0)
	bgt	a4,a5,.L8
	lw	a4,-24(s0)
	lw	a5,-48(s0)
	ble	a4,a5,.L7
.L8:
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	merge, .-merge
	.align	2
	.globl	merge_sort
	.type	merge_sort, @function
merge_sort:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	sw	a2,-44(s0)
	lw	a4,-40(s0)
	lw	a5,-44(s0)
	bge	a4,a5,.L11
	lw	a4,-44(s0)
	lw	a5,-40(s0)
	sub	a5,a4,a5
	srli	a4,a5,31
	add	a5,a4,a5
	srai	a5,a5,1
	mv	a4,a5
	lw	a5,-40(s0)
	add	a5,a5,a4
	sw	a5,-20(s0)
	lw	a2,-20(s0)
	lw	a1,-40(s0)
	lw	a0,-36(s0)
	call	merge_sort
	lw	a5,-20(s0)
	addi	a5,a5,1
	lw	a2,-44(s0)
	mv	a1,a5
	lw	a0,-36(s0)
	call	merge_sort
	lw	a3,-44(s0)
	lw	a2,-20(s0)
	lw	a1,-40(s0)
	lw	a0,-36(s0)
	call	merge
.L11:
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	merge_sort, .-merge_sort
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	addi	s0,sp,16
	li	a2,49
	li	a1,0
	lui	a5,0
	addi	a0,a5,0
	call	merge_sort
	li	a5,0
	mv	a0,a5
	lw	ra,12(sp)
	lw	s0,8(sp)
	addi	sp,sp,16
	jr	ra
	.size	main, .-main
	.ident	"GCC: () 14.2.0"
	.section	.note.GNU-stack,"",@progbits
