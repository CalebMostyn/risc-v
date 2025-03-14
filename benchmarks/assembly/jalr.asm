# JALR (return) test -- uses JAL to store return address in ra, loads 0xAA into t2 for a checksum,
# then returns and loads 0xFA into t2

addi t0 zero 42
addi t1 zero 0xFF
jal ra test_jump_return
j end

test_jump_return: addi t2 zero 0xAA
jr ra # pseudo-instruction for jalr zero ra 0

end: addi t2 zero 0xFA
