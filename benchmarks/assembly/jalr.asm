# JALR (return) test -- uses JAL to store return address in ra, loads 0xAA into t2 for a checksum,
# then returns and loads 0xFA into t2

addi t0 zero 42
addi t1 zero 0xFF
jal ra test_jump_return
j end

test_jump_return: addi t2 zero 0xAA
jalr ra ra 0 # equivalent to jr ra

end: addi t2 zero 0xFA