module register_renderer(
	input clk,
	input rst,
	input start, // start rendering
	output [4:0]rf_addr, // register file in-addr
	input [31:0]rf_data, // register file output
	output reg ascii_write_en,
	output reg [31:0]ascii_input,
	output reg [12:0]ascii_write_address,
	output reg done // finished rendering
);

reg [7:0]S;
reg [7:0]NS;

parameter START = 8'd0,
			WRITE_BG = 8'd1,
			BG_UPDATE = 8'd2,
			INIT_REG = 8'd3,
			READ_NUM = 8'd4,
			WRITE_REG = 8'd5,
			REG_UPDATE = 8'd6,
			INCR_REG_COUNT = 8'd7,
			DONE = 8'hFE,
			ERR = 8'hFF;

parameter BG_STRING = "*********************************************************************************                                                                              **                                                                              **                                                                              **                                                                              **                                                                              **                                                                              **                                                                              **                                                                              **                                                                              **                                                                              **                                                                              **                ----------------------------------------------                **                | x00 $0   : XXXXXXXX || x16 $a6  : XXXXXXXX |                **                |                                            |                **                | x01 $ra  : XXXXXXXX || x17 $a7  : XXXXXXXX |                **                |                                            |                **                | x02 $sp  : XXXXXXXX || x18 $s2  : XXXXXXXX |                **                |                                            |                **                | x03 $gp  : XXXXXXXX || x19 $s3  : XXXXXXXX |                **                |                                            |                **                | x04 $tp  : XXXXXXXX || x20 $s4  : XXXXXXXX |                **                |                                            |                **                | x05 $t0  : XXXXXXXX || x21 $s5  : XXXXXXXX |                **                |                                            |                **                | x06 $t1  : XXXXXXXX || x22 $s6  : XXXXXXXX |                **                |                                            |                **                | x07 $t2  : XXXXXXXX || x23 $s7  : XXXXXXXX |                **                |                                            |                **                | x08 $s0  : XXXXXXXX || x24 $s8  : XXXXXXXX |                **                |                                            |                **                | x09 $s1  : XXXXXXXX || x25 $s9  : XXXXXXXX |                **                |                                            |                **                | x10 $a0  : XXXXXXXX || x26 $s10 : XXXXXXXX |                **                |                                            |                **                | x11 $a1  : XXXXXXXX || x27 $s11 : XXXXXXXX |                **                |                                            |                **                | x12 $a2  : XXXXXXXX || x28 $t3  : XXXXXXXX |                **                |                                            |                **                | x13 $a3  : XXXXXXXX || x29 $t4  : XXXXXXXX |                **                |                                            |                **                | x14 $a4  : XXXXXXXX || x30 $t5  : XXXXXXXX |                **                |                                            |                **                | x15 $a5  : XXXXXXXX || x31 $t6  : XXXXXXXX |                **                ----------------------------------------------                **                                                                              **                                                                              **                                                                              **                                                                              **                                                                              **                                                                              **                                                                              **                                                                              **                                                                              **                                                                              **                                                                              **                                                                              **                                                                              **                                                                              *********************************************************************************";
reg [12:0]bg_str_count;

reg [3:0]reg_num;
wire [7:0]hex_ascii;
nibble_to_hex hex(reg_num, hex_ascii);

reg [7:0]num_count;
reg [7:0]reg_count;
assign rf_addr = reg_count[4:0];
			
assign LEDR = S;

always@(posedge clk or negedge rst)
begin
	if (rst == 1'b0)
		S <= START;
	else
		S <= NS;
end

always@(*)
begin
	case(S)
		START:
			if (start)
				NS = WRITE_BG;
			else
				NS = START;
		WRITE_BG:
			if (bg_str_count <= 0)
				NS = INIT_REG;
			else
				NS = BG_UPDATE;
		BG_UPDATE: NS = WRITE_BG;
		INIT_REG: 
			if (reg_count > 31)
				NS = DONE;
			else
				NS = READ_NUM;
		READ_NUM: NS = WRITE_REG;
		WRITE_REG:
			if (num_count <= 0)
				NS = INCR_REG_COUNT;
			else
				NS = REG_UPDATE;
		REG_UPDATE: NS = READ_NUM;
		INCR_REG_COUNT: NS = INIT_REG;
		DONE: NS = DONE;
		default: NS = ERR;
	endcase
end

always@(posedge clk or negedge rst)
begin
	if (rst == 1'b0)
	begin
		ascii_write_en <= 1'd0;
		ascii_input <= 32'd0;
		ascii_write_address <= 13'd0;
		done <= 1'd0;
		
		bg_str_count <= 13'd4779;
		num_count <= 8'd7;
		reg_count <= 8'd0;
	end
	else
	begin
		case(S)
			START:
			begin
				ascii_write_en <= 1'd0;
				ascii_input <= 32'd0;
				ascii_write_address <= 13'b1111111111111;
				done <= 1'd0;
				bg_str_count <= 13'd4799;
				num_count <= 8'd7;
				reg_count <= 8'd0;
			end
			WRITE_BG:
			begin
				ascii_write_en <= 1'd1;
				ascii_input <= {BG_STRING[bg_str_count * 8 +: 8], 24'hFFFFFF};
				ascii_write_address <= ascii_write_address + 1;
				bg_str_count <= bg_str_count - 1;
			end
			INIT_REG:
			begin
				ascii_write_en <= 1'd0;
				num_count <= 8'd7;
				if (reg_count == 8'd0)
					ascii_write_address <= 13'd1069;
				else if (reg_count == 8'd16)
					ascii_write_address <= 13'd1092;
				else
					ascii_write_address <= ascii_write_address + 152;
			end
			READ_NUM:
			begin
				reg_num <= rf_data[num_count * 4 +: 4];
			end
			WRITE_REG:
			begin
				ascii_write_en <= 1'd1;
				ascii_input <= {hex_ascii, 24'hFFFFFF};
				ascii_write_address <= ascii_write_address + 1;
				num_count <= num_count - 1;
			end
			INCR_REG_COUNT: reg_count <= reg_count + 1;
			DONE:
			begin
				ascii_write_en <= 1'd0;
				ascii_input <= 32'd0;
				ascii_write_address <= 13'd0;
				done <= 1'd1;
			end
		endcase
	end
end

endmodule