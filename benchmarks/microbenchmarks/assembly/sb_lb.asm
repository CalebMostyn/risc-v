# Store/load byte test -- stores to each byte individually (ending with 0x0A0B0C0D)
# then loads them individually into another register

lui t1 0 # for RARS, 0x10040
li t0 0x0D
sb t0 3(t1)
li t0 0x0C
sb t0 2(t1)
li t0 0x0B
sb t0 1(t1)
li t0 0x0A
sb t0 0(t1)
lb t2 0(t1)
lb t2 1(t1)
lb t2 2(t1)
lb t2 3(t1)
