# RISC-V
FPGA RISC-V Processor

# Specs
- 32-bit
- 32 General Purpose Registers
- 250 KiB of Data Memory (64.000, 32-bit words, byte addressable)
    - Addressable from 0x00000 (maybe 0x00004 to prevent null pointer from being addressable) to 0x3E7FC
- 125 KiB of Instruction Memory (32.000, 32-bit words)
    - Addressable from 0x00000 to 0x1F3FC

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