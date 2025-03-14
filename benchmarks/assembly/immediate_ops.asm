# Sequence of instructions to test all the immediate arithmetic instructions    

addi ra zero 1
addi sp zero 15
andi gp sp 21 # 5
ori tp ra 6 # 7
xori t0 sp 7 # 8
slti t1 sp -1 # 0
sltiu t2 sp -1 # 1
addi s0 zero -1
srai s1 s0 1 # FFFFFFFF
srli a0 s0 1 # 7FFFFFFF
slli a1 s0 1 # FFFFFFFE
