# Store/load halfword test -- stores to each halfword individually (ending with 0xAB42CD42)
# then loads them individually into another register

lui t1 0
li t0 0xAB42
sh t0 2(t1)
li t0 0xCD42
sh t0 0(t1)
lh t2 0(t1)
lh s0 2(t1)
