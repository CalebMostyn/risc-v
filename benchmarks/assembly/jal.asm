# Infinite loop -- 1 added to gp once, 2 added to sp over and over

addi gp gp 1
jump_point: addi sp sp 2
jal ra jump_point # 0000000C in ra, jump to pc == 00000004 