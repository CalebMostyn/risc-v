CC = riscv32-unknown-elf-gcc
CFLAGS = -nostdlib -fno-stack-protector -fno-common -march=rv32im -mabi=ilp32

RARS = java -jar rars.jar  # Change this to the correct path
PYTHON_SCRIPT = python3 ../python/bin_to_mif.py

SRC = factorial/factorial.c
ASM = $(SRC:.c=.s)
BIN = $(SRC:.c=.bin)
MIF = $(SRC:.c=.mif)

all: $(ASM) $(BIN) $(MIF)

%.s: %.c
	$(CC) $(CFLAGS) -S $< -o $@
	echo "call main\n\tebreak" | cat - $@ > temp.s
	sed -E 's/%hi\([^)]*\)/0/g; s/%lo\([^)]*\)/0/g' temp.s > $@
	rm temp.s

%.bin: %.s
	$(RARS) a dump .text BinaryText $@ $<
	sed -i 's/00000000000100000000000001110011/00000000000000000000000000000000/g' $@

%.mif: %.bin
	$(PYTHON_SCRIPT) $(dir $<)  # Pass the directory of the .bin file

clean:
	rm -f $(ASM) $(BIN) $(MIF)
