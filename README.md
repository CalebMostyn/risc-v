# RISC-V
FPGA RISC-V Processor

# Specs
- 32-bit Word Length
- 32 General Purpose Registers
- 225 KiB of Data Memory (57.600, 32-bit words, byte addressable)
    - Addressable from 0x00000 to 0x383FC
- 62.5 KiB of Instruction Memory (16.000, 32-bit words)
    - Addressable from 0x00000 to 0x0F9FC
    - ROM
- 80 character by 60 row ASCII Character VGA Output 
- `sp` is initalized to the last addressable word of Data Memory
- `gp` is left to be initialized by the program if needed

# ISA
- TinyRV2
    - ADD, ADDI, SUB, MUL
    - AND, ANDI, OR, ORI, XOR, XORI
    - SLT, SLTI, SLTU, SLTIU
    - SRA, SRAI, SRL, SRLI, SLL, SLLI
    - LUI, AUIPC
    - LW, SW
    - JAL, JALR
    - BEQ, BNE, BLT, BGE, BLTU, BGEU
- Extensions of TinyRV2
    - LH, SH, LB, SB
- Omissions from TinyRV2
    - CSRR, CSRW

# Build
Programs written in languages supported by GCC can be compiled and ran on this CPU, as long as they fit within the constraints of the defined ISA. Programs with syscalls or division/modulus operations are able to be ran, but their behavior is indeterminate.

The Makefile can be ran as 
```
make SRC=file.c RARS="java -jar /path/to/rars.jar" STATIC_MAPPINGS="<static_variable_name>=<mem_location>..."
```
to compile the given file with the [RISC-V GCC toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain). 

The default is to build all (`.s`, `.bin`, `.mif`) but these can be done individually. 

To more easily run in the bare-metal environment, assembling is handled by RARS. With some slight modifications to the RARS assembled binary, the program is turned into a `.mif` file and is ready to be ran on the FPGA.

Memory locations for static variables can be mapped with `STATIC_MAPPINGS`, although this is currently limited to memory locations that can fit in `addi` immediate value. Static mappings can be left up to RARS, but this may result in addresses outside of the valid adresses of the data memory (although very unlikely).

The generated assembly has a call to main inserted at the beginning and an `ebreak`, a RARS instruction for a program breakpoint. If running through RARS, you can leave as ease to pause execution at the end of the program, but when generating the binary files this is replaced with 0x00000000 such that execution falls off and ends.

# Components
For Tiny RISC-V:
- [X] ALU
- [X] Register File (with visualization)
- [X] Data Memory (with visualization)
- [X] Instruction Memory (with visualization)
- [X] FSM for Instruction Execution

Stretch Goals
- [ ] Simple Syscall Implementations
- [ ] Standard I/O