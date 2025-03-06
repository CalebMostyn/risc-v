module memory_renderer(
	input clk,
	input rst,
	input start, // start rendering
	input [17:0]start_addr, // starting address for render
	output [15:0]mem_addr, // memory in-addr
	input [31:0]mem_data, // memory output
	output reg ascii_write_en,
	output reg [31:0]ascii_input,
	output reg [12:0]ascii_write_address,
	output reg done // finished rendering
);

assign mem_addr = curr_addr >> 2;

reg [7:0]S;
reg [7:0]NS;

parameter START = 8'd0,
			WRITE_BG = 8'd1,
			BG_UPDATE = 8'd2,
			INIT = 8'd3,
			READ_ADDR = 8'd4,
			WRITE_ADDR = 8'd5,
			ADDR_UPDATE = 8'd6,
			ADJ_ASCII_ADDR = 8'd7,
			READ_VAL = 8'd8,
			WRITE_VAL = 8'd9,
			VAL_UPDATE = 8'd10,
			INCR = 8'd11,
			DONE = 8'hFE,
			ERR = 8'hFF;

parameter BG_STRING = "*********************************************************************************    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    **    0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX  0x----- XXXXXXXX    *********************************************************************************";
reg [12:0]bg_str_count;

reg [3:0]nibble;
wire [7:0]hex_ascii;
nibble_to_hex hex(nibble, hex_ascii);

reg [7:0]addr_count;
reg [7:0]val_count;
reg [7:0]mem_count;

reg [19:0]curr_addr;


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
				NS = INIT;
			else
				NS = BG_UPDATE;
		BG_UPDATE: NS = WRITE_BG;
		INIT: 
			if (mem_count >=232)
				NS = DONE;
			else
				NS = READ_ADDR;
		READ_ADDR: NS = WRITE_ADDR;
		WRITE_ADDR:
			if (addr_count <= 0)
				NS = ADJ_ASCII_ADDR;
			else
				NS = ADDR_UPDATE;
		ADDR_UPDATE: NS = READ_ADDR;
		ADJ_ASCII_ADDR: NS = READ_VAL;
		READ_VAL: NS = WRITE_VAL;
		WRITE_VAL:
			if (val_count <= 0)
				NS = INCR;
			else
				NS = VAL_UPDATE;
		VAL_UPDATE: NS = READ_VAL;
		INCR: NS = INIT;
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
		addr_count <= 8'd4;
		val_count <= 8'd7;
		mem_count <= 8'd0;
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
				addr_count <= 8'd4;
				val_count <= 8'd7;
				mem_count <= 8'd0;
			end
			WRITE_BG:
			begin
				ascii_write_en <= 1'd1;
				ascii_input <= {BG_STRING[bg_str_count * 8 +: 8], 24'hFFFFFF};
				ascii_write_address <= ascii_write_address + 1;
				bg_str_count <= bg_str_count - 1;
			end
			INIT:
			begin
				ascii_write_en <= 1'd0;
				val_count <= 8'd7;
				addr_count <= 8'd4;
				
				if (mem_count == 8'd0)
					curr_addr <= start_addr;
				else
					curr_addr <= curr_addr + 20'd4;
				
				if (mem_count == 8'd0)
					ascii_write_address <= 13'd86;
				else if (mem_count == 8'd58)
					ascii_write_address <= 13'd104;
				else if (mem_count == 8'd116)
					ascii_write_address <= 13'd122;
				else if (mem_count == 8'd174)
					ascii_write_address <= 13'd140;
				else
					ascii_write_address <= ascii_write_address + 66;
			end
			READ_ADDR:
			begin
				nibble <= curr_addr[addr_count * 4 +: 4];
			end
			WRITE_ADDR:
			begin
				ascii_write_en <= 1'd1;
				ascii_input <= {hex_ascii, 24'hFFFFFF};
				ascii_write_address <= ascii_write_address + 1;
				addr_count <= addr_count - 1;
			end
			ADJ_ASCII_ADDR:
			begin
				ascii_write_en <= 1'd0;
				ascii_write_address <= ascii_write_address + 1;
			end
			READ_VAL:
			begin
				nibble <= mem_data[val_count * 4 +: 4];
			end
			WRITE_VAL:
			begin
				ascii_write_en <= 1'd1;
				ascii_input <= {hex_ascii, 24'hFFFFFF};
				ascii_write_address <= ascii_write_address + 1;
				val_count <= val_count - 1;
			end
			INCR:
			begin
				mem_count <= mem_count + 1;
			end
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