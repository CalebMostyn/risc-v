import sys
import random

# script to generate data_memory.mif with N-number of random numbers
def generate_mif(n, filename, width=32, depth=57600):
    if n > depth:
        print("Error: N cannot be greater than memory depth.")
        return
    
    with open(filename, "w") as f:
        # Writing the header
        f.write("-- Copyright (C) 2024  Intel Corporation. All rights reserved.\n")
        f.write("-- Your use of Intel Corporation's design tools, logic functions \n")
        f.write("-- and other software and tools, and any partner logic \n")
        f.write("-- functions, and any output files from any of the foregoing \n")
        f.write("-- (including device programming or simulation files), and any \n")
        f.write("-- associated documentation or information are expressly subject \n")
        f.write("-- to the terms and conditions of the Intel Program License \n")
        f.write("-- Subscription Agreement, the Intel Quartus Prime License Agreement,\n")
        f.write("-- the Intel FPGA IP License Agreement, or other applicable license\n")
        f.write("-- agreement, including, without limitation, that your use is for\n")
        f.write("-- the sole purpose of programming logic devices manufactured by\n")
        f.write("-- Intel and sold by Intel or its authorized distributors.  Please\n")
        f.write("-- refer to the applicable agreement for further details, at\n")
        f.write("-- https://fpgasoftware.intel.com/eula.\n\n")
        
        f.write("-- Quartus Prime generated Memory Initialization File (.mif)\n\n")
        
        # Writing the configuration
        f.write(f"WIDTH={width};\n")
        f.write(f"DEPTH={depth};\n\n")
        f.write("ADDRESS_RADIX=UNS;\n")
        f.write("DATA_RADIX=HEX;\n\n")
        f.write("CONTENT BEGIN\n")
        
        # Writing N random 32-bit integers
        for i in range(n):
            value = random.randint(0, 0xFFFFFFFF)
            f.write(f"    {i}  :   {value:08X};\n")
        
        # Initializing the rest of the memory to zero
        if n < depth:
            f.write(f"    [{n}..{depth-1}]  :   00000000;\n")
        
        f.write("END;\n")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python generate_mif.py <N> <output_file.mif>")
        sys.exit(1)
    
    N = int(sys.argv[1])
    output_file = sys.argv[2]
    generate_mif(N, output_file)
