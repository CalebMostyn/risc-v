# Sequence of arithmetic operations to test each R-type instruction

addi ra zero 1
add t1 ra t1 # 1
add t1 ra t1 # 2
add t1 ra t1 # 3
mul t2 t1 t1 # 9
sub s0 t2 t1 # 6
and s1 s0 t1 # 2
or a0 s0 t1 # 7
xor a1 s0 t1 # 5
sub a2 a2 ra # -1
slt a3 a2 t2 # 1
sltu a3 a2 t2 # 0
add a3 a0 ra # 8
add a3 a0 a3 # 15
xor a4 a2 a3 # FFFFFFF0
sra a5 a4 ra # FFFFFFF8
srl a6 a4 ra # 7FFFFFF8
sll a7 a4 ra # FFFFFFE0
