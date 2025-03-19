CC = riscv32-unknown-elf-gcc
CFLAGS = -nostdlib -fno-stack-protector -fno-common -march=rv32im -mabi=ilp32

RARS = java -jar rars.jar  # Change this to the correct path
PYTHON_SCRIPT = python3 ../python/bin_to_mif.py

SRC = factorial/factorial.c
ASM = $(SRC:.c=.s)
BIN = $(SRC:.c=.bin)
MIF = $(SRC:.c=.mif)

STATIC_MAPPINGS = arr=4

all: $(ASM) $(BIN) $(MIF)

%.s: %.c
	$(CC) $(CFLAGS) -S $< -o $@
	echo "\tcall main\n\tebreak" | cat - $@ > temp.s

	# Generate sed script dynamically
	rm -f static_mappings.sed
	touch static_mappings.sed
	@for pair in $(STATIC_MAPPINGS); do \
		TARGET=$$(echo $$pair | cut -d= -f1); \
		VALUE=$$(echo $$pair | cut -d= -f2); \
		echo "s/%hi(\\($$TARGET\\))/0/g" >> static_mappings.sed; \
		echo "s/%lo(\\($$TARGET\\))/$$VALUE/g" >> static_mappings.sed; \
	done

	# Apply replacements using the generated sed script
	sed -f static_mappings.sed temp.s > $@
	rm temp.s static_mappings.sed

%.bin: %.s
	$(RARS) a dump .text BinaryText $@ $<
	sed -i 's/00000000000100000000000001110011/00000000000000000000000000000000/g' $@

%.mif: %.bin
	$(PYTHON_SCRIPT) $(dir $<)  # Pass the directory of the .bin file

clean:
	rm -f $(ASM) $(BIN) $(MIF)
