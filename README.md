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