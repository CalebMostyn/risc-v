# RISC-V
FPGA RISC-V Processor

# Specs
- 32-bit Word Length
- 32 General Purpose Registers
- 225 KiB of Data Memory (57.600, 32-bit words, byte addressable)
    - Addressable from 0x00000 (maybe 0x00004 to prevent null pointer from being addressable) to 0x383FC
- 62.5 KiB of Instruction Memory (16.000, 32-bit words)
    - Addressable from 0x00000 to 0x0F9FC
    - ROM
- 80 character by 60 row ASCII Character VGA Output 

# ISA
- TinyRV2
    - [X] ADD
    - [X] ADDI
    - [X] SUB
    - [X] MUL
    - [X] AND
    - [X] ANDI
    - [X] OR
    - [X] ORI
    - [X] XOR
    - [X] XORI
    - [X] SLT
    - [X] SLTI
    - [X] SLTU
    - [X] SLTIU
    - [X] SRA
    - [X] SRAI
    - [X] SRL
    - [X] SRLI
    - [X] SLL
    - [X] SLLI
    - [X] LUI
    - [ ] AUIPC
    - [ ] LW
    - [ ] SW
    - [ ] JAL
    - [ ] JALR
    - [ ] BEQ
    - [ ] BNE
    - [ ] BLT
    - [ ] BGE
    - [ ] BLTU
    - [ ] BGEU

# Components
For Tiny RISC-V:
- [X] ALU
- [X] Register File (with visualization)
- [X] Data Memory (with visualization)
- [X] Instruction Memory (with visualization)
- [ ] FSM for Instruction Execution

Possible Stretch Goals
- [ ] Simple Syscall Implementations
- [ ] Standard I/O