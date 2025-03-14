# Simple script to convert the RISC-V binaries into to .mif files for the FPGA

import os
import sys

def convert_to_mif(instructions: str, depth=16000):
    lines = [line.strip() for line in instructions.strip().split('\n') if line.strip()]

    mif = []
    mif.append('-- Copyright (C) 2024  Intel Corporation. All rights reserved.')
    mif.append('-- Your use of Intel Corporation\'s design tools, logic functions')
    mif.append('-- and other software and tools, and any partner logic')
    mif.append('-- functions, and any output files from any of the foregoing')
    mif.append('-- (including device programming or simulation files), and any')
    mif.append('-- associated documentation or information are expressly subject')
    mif.append('-- to the terms and conditions of the Intel Program License')
    mif.append('-- Subscription Agreement, the Intel Quartus Prime License Agreement,')
    mif.append('-- the Intel FPGA IP License Agreement, or other applicable license')
    mif.append('-- agreement, including, without limitation, that your use is for')
    mif.append('-- the sole purpose of programming logic devices manufactured by')
    mif.append('-- Intel and sold by Intel or its authorized distributors.  Please')
    mif.append('-- refer to the applicable agreement for further details, at')
    mif.append('-- https://fpgasoftware.intel.com/eula.\n')
    mif.append('-- Quartus Prime generated Memory Initialization File (.mif)\n')
    mif.append('WIDTH=32;')
    mif.append(f'DEPTH={depth};\n')
    mif.append('ADDRESS_RADIX=UNS;')
    mif.append('DATA_RADIX=BIN;\n')
    mif.append('CONTENT BEGIN')

    for i, line in enumerate(lines):
        mif.append(f'    {i} : {line};')

    if len(lines) < depth:
        mif.append(f'    [{len(lines)}..{depth-1}]  :   00000000000000000000000000000000;')

    mif.append('END;')
    return '\n'.join(mif)

def process_bin_files(directory, depth=16000):
    for filename in os.listdir(directory):
        if filename.endswith(".bin"):
            bin_path = os.path.join(directory, filename)
            mif_path = os.path.splitext(bin_path)[0] + ".mif"
            
            with open(bin_path, 'r') as bin_file:
                instructions = bin_file.read()
            
            mif_content = convert_to_mif(instructions, depth)
            
            with open(mif_path, 'w') as mif_file:
                mif_file.write(mif_content)
            
            print(f"Converted {filename} to {os.path.basename(mif_path)}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: bin_to_mif.py <directory>")
        sys.exit(1)
    
    directory = sys.argv[1]
    if not os.path.isdir(directory):
        print("Error: Specified directory does not exist.")
        sys.exit(1)
    
    process_bin_files(directory)
