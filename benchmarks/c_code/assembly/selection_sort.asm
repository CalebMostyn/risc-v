main:
	lui t2 0x10040
	li t0 0 # i
	li t1 50 # arr size
for_cond_0:	
	bge t0 t1 for_exit_0
	li t3 4
	mul s0 t0 t3
	add s0 t2 s0
	sub s1 t1 t0
	sw s1 0(s0)
	addi t0 t0 1
	j for_cond_0
for_exit_0:
	li t0 0 # i
for_cond_1:	
	bge t0 t1 for_exit_1 # i < 50
	mv s9 t0 # smallest_index = i
	mv t3 t0 # j
for_cond_2:
	bge t3 t1 for_exit_2
if_cond_0:
	li t4 4
	mul s0 t3 t4
	add s0 t2 s0
	lw s1 0 (s0)
	li t4 4
	mul s0 s9 t4
	add s0 t2 s0
	lw s2 0 (s0)
	blt s2 s1 if_exit_0 # if (arr[j] < arr[smallest_index])
	mv s9 t3 # smallest_index = j
if_exit_0:
	addi t3 t3 1 # j++
	j for_cond_2
for_exit_2:
	li t4 4	# swap(arr, i, smallest_index);
	mul s0 t0 t4
	add s0 t2 s0
	lw s1 0(s0)
	mul s3 s9 t4
	add s3 t2 s3
	lw s2 0(s3)
	sw s1 0(s3)
	sw s2 0(s0)
	addi t0 t0 1 # i++
	j for_cond_1
for_exit_1:
	nop