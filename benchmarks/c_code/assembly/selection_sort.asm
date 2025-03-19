main:
	lui t2 0# 0x10040 in RARS
	li t1 50 # arr size, assuming random 50 numbers already present in data memory
	li t0 0 # i
for_cond_0:	
	bge t0 t1 for_exit_0 # i < 50
	mv t5 t0 # smallest_index = i
	mv t3 t0 # j
for_cond_1:
	bge t3 t1 for_exit_1
if_cond_0:
	li t4 4
	mul s0 t3 t4
	add s0 t2 s0
	lw s1 0 (s0)
	li t4 4
	mul s0 t5 t4
	add s0 t2 s0
	lw s2 0 (s0)
	bltu s2 s1 if_exit_0 # if (arr[j] < arr[smallest_index])
	mv t5 t3 # smallest_index = j
if_exit_0:
	addi t3 t3 1 # j++
	j for_cond_1
for_exit_1:
	mv a0 t2 #arr
	mv a1 t0 # i
	mv a2 t5 # smallest_index
	addi sp sp -32
	sw t0 0(sp)
	sw t1 4(sp)
	sw t2 8(sp)
	sw t3 12(sp)
	sw t4 16(sp)
	sw t5 20(sp)
	jal ra swap
	lw t0 0(sp)
	lw t1 4(sp)
	lw t2 8(sp)
	lw t3 12(sp)
	lw t4 16(sp)
	lw t5 20(sp)
	addi sp sp 32
	addi t0 t0 1 # i++
	j for_cond_0
for_exit_0:
	nop # replace with 0x00000000 for program to drop off execution
	
swap:
	li t4 4	# swap(arr, i, smallest_index);
	mul s0 a1 t4
	add s0 a0 s0
	lw s1 0(s0)
	mul s3 a2 t4
	add s3 a0 s3
	lw s2 0(s3)
	sw s1 0(s3)
	sw s2 0(s0)
	jr ra
