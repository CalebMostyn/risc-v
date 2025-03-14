# Loop for testing store/load word -- increments an address and doubles the value each iteration,
# value is loaded into another register after being stored

li ra 42
li sp 0
start: sw ra 0(sp)
lw gp 0(sp)
addi sp sp 4
add ra ra ra
j start