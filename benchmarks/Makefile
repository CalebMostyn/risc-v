CC = riscv32-unknown-elf-gcc
CFLAGS = -nostdlib -fno-stack-protector -fno-common -march=rv32im -mabi=ilp32

SRC = main.c
ASM = $(SRC:.c=.s)

all: $(ASM)

%.s: %.c
	$(CC) $(CFLAGS) -S $< -o $@

clean:
	rm -f *.s
