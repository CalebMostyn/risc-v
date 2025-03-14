# Branch Greater Than or Equal (signed) test -- first branch will evaluate true, jumping to branch_true,
# the second will evaluate false, jumping back to the start

start:
addi s0 s0 1
addi s1 s1 1
bge s0 s1 branch_true
j start

branch_true:
addi ra ra 0xAA # checksum that the branch evaluated true
addi s0 zero 0
bge s0 s1 branch_true
j start