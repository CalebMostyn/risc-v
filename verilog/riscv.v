module riscv(
	//////////// ADC //////////
	//output		          		ADC_CONVST,
	//output		          		ADC_DIN,
	//input 		          		ADC_DOUT,
	//output		          		ADC_SCLK,

	//////////// Audio //////////
	//input 		          		AUD_ADCDAT,
	//inout 		          		AUD_ADCLRCK,
	//inout 		          		AUD_BCLK,
	//output		          		AUD_DACDAT,
	//inout 		          		AUD_DACLRCK,
	//output		          		AUD_XCK,

	//////////// CLOCK //////////
	//input 		          		CLOCK2_50,
	//input 		          		CLOCK3_50,
	//input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// SDRAM //////////
	//output		    [12:0]		DRAM_ADDR,
	//output		     [1:0]		DRAM_BA,
	//output		          		DRAM_CAS_N,
	//output		          		DRAM_CKE,
	//output		          		DRAM_CLK,
	//output		          		DRAM_CS_N,
	//inout 		    [15:0]		DRAM_DQ,
	//output		          		DRAM_LDQM,
	//output		          		DRAM_RAS_N,
	//output		          		DRAM_UDQM,
	//output		          		DRAM_WE_N,

	//////////// I2C for Audio and Video-In //////////
	//output		          		FPGA_I2C_SCLK,
	//inout 		          		FPGA_I2C_SDAT,

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,

	//////////// IR //////////
	//input 		          		IRDA_RXD,
	//output		          		IRDA_TXD,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// PS2 //////////
	//inout 		          		PS2_CLK,
	//inout 		          		PS2_CLK2,
	//inout 		          		PS2_DAT,
	//inout 		          		PS2_DAT2,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// Video-In //////////
	//input 		          		TD_CLK27,
	//input 		     [7:0]		TD_DATA,
	//input 		          		TD_HS,
	//output		          		TD_RESET_N,
	//input 		          		TD_VS,

	//////////// VGA //////////
	output		          		VGA_BLANK_N,
	output		     [7:0]		VGA_B,
	output		          		VGA_CLK,
	output		     [7:0]		VGA_G,
	output		          		VGA_HS,
	output		     [7:0]		VGA_R,
	output		          		VGA_SYNC_N,
	output		          		VGA_VS

	//////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
	//inout 		    [35:0]		GPIO_0,

	//////////// GPIO_1, GPIO_1 connect to GPIO Default //////////
	//inout 		    [35:0]		GPIO_1
);

assign clk = CLOCK_50;
assign rst = KEY[3];

parameter UPDATE_SPEED = 30'd1; // Times a second there is an update

wire vga_write_en;
wire [31:0]vga_input_data;
wire [12:0]vga_write_address;

ascii_master_controller controller (
		.clk(CLOCK_50),
		.rst(rst),
		.ascii_write_en(vga_write_en),
		.ascii_input(vga_input_data),
		.ascii_write_address(vga_write_address),
		.vga_blank(VGA_BLANK_N),
		.vga_b(VGA_B),
		.vga_r(VGA_R),
		.vga_g(VGA_G),
		.vga_clk(VGA_CLK),
		.vga_hs(VGA_HS),
		.vga_vs(VGA_VS),
		.vga_sync(VGA_SYNC_N)
);

wire [4:0]rf_r_addr_0;
wire [31:0]rf_r_data_0;
wire [4:0]rf_r_addr_1;
wire [31:0]rf_r_data_1;
reg [4:0]rf_w_addr;
reg [31:0]rf_w_data;
reg rf_w_en;

register_file rf(
	.clk(clk),
	.rst(rst),
	.read_addr_0(rf_r_addr_0),
	.read_addr_1(rf_r_addr_1),
	.write_addr(rf_w_addr),
	.write_en(rf_w_en),
	.write_data(rf_w_data),
	.read_data_0(rf_r_data_0),
	.read_data_1(rf_r_data_1)
);

wire [15:0]dm_addr;
wire [3:0]dm_byte_en;
wire [31:0]dm_w_data;
wire dm_w_en;
wire [31:0]dm_r_data;

data_memory dm(
	.address(16'd0),
	.byteena(4'b1010),
	.clock(clk),
	.data(32'hFFFFFFFF),
	.wren(1'b1),
	.q(dm_r_data)
);

reg rr_start;
wire rr_done;
wire rr_rst;
assign rr_rst = (reset_renderer && rst);

reg reset_renderer;
reg [19:0]curr_rend_mem_addr;


memory_renderer rr(
	.clk(clk),
	.rst(rr_rst),
	.start(rr_start), // start rendering
	.start_addr(curr_rend_mem_addr),
	.mem_addr(dm_addr), // register file in-addr
	.mem_data(dm_r_data), // register file output
	.ascii_write_en(vga_write_en),
	.ascii_input(vga_input_data),
	.ascii_write_address(vga_write_address),
	.done(rr_done) // finished rendering
);
/*
register_renderer rr(
	.clk(clk),
	.rst(rr_rst),
	.start(rr_start), // start rendering
	.rf_addr(rf_r_addr_0), // register file in-addr
	.rf_data(rf_r_data_0), // register file output
	.ascii_write_en(vga_write_en),
	.ascii_input(vga_input_data),
	.ascii_write_address(vga_write_address),
	.done(rr_done) // finished rendering
);*/

reg [7:0]S;
assign LEDR = S;
reg [7:0]NS;

reg [29:0]counter;

parameter START = 8'd0,
			START_RENDER = 8'd7,
			WAIT_RENDER = 8'd8,
			RENDER_DONE = 8'd9,
			WAIT_INPUT = 8'd10,
			INCR = 8'd11,
			DECR = 8'd12,
			WAIT_INCR = 8'd13,
			WAIT_DECR = 8'd14,
			ERR = 8'hFF;
			
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
		/*WAIT_A:
			if (~KEY[0])
				NS = READ_A;
			else
				NS = WAIT_A;
		READ_A: 
			if (~KEY[0])
				NS = READ_A;
			else
				NS = WAIT_B;
		WAIT_B:
			if (~KEY[0])
				NS = READ_B;
			else
				NS = WAIT_B;
		READ_B:
			if (~KEY[0])
				NS = READ_B;
			else
				NS = WAIT_OP;
		WAIT_OP:
			if (~KEY[0])
				NS = READ_OP;
			else
				NS = WAIT_OP;
		READ_OP:
			if (~KEY[0])
				NS = READ_OP;
			else
				NS = WRITE_DATA;
		WRITE_DATA: NS = START_RENDER;*/
		START: NS = START_RENDER;
		START_RENDER: NS = WAIT_RENDER;
		WAIT_RENDER:
			if (rr_done)
				NS = RENDER_DONE;
			else
				NS = WAIT_RENDER;
		RENDER_DONE: NS = WAIT_INPUT;
		WAIT_INPUT:
			if (~KEY[0])
				NS = INCR;
			else if (~KEY[1])
				NS = DECR;
			else
				NS = WAIT_INPUT;
		INCR: NS = WAIT_INCR;
		WAIT_INCR:
			if (KEY[0])
				NS = START_RENDER;
			else
				NS = WAIT_INCR;
		DECR: NS = WAIT_DECR;
		WAIT_DECR:
			if (KEY[1])
				NS = START_RENDER;
			else
				NS = WAIT_DECR;
		default: NS = ERR;
	endcase
end

always@(posedge clk or negedge rst)
begin
	if (rst == 1'b0)
	begin
		reset_renderer <= 1'b1;
		rr_start <= 1'b0;
		rf_w_addr <= 5'd0;
		rf_w_data <= 32'd0;
		rf_w_en <= 1'b0;
		
		src_a <= 32'd0;
		src_b <= 32'd0;
		op <= 4'd0;
		curr_rend_mem_addr <= 20'd0;
	end
	else
	begin
		case(S)
			/*WAIT_A:*/
			START:
			begin
				reset_renderer <= 1'b1;
				rr_start <= 1'b0;
				rf_w_addr <= 5'd0;
				rf_w_data <= 32'd0;
				rf_w_en <= 1'b0;
				
				src_a <= 32'd0;
				src_b <= 32'd0;
				op <= 4'd0;
				curr_rend_mem_addr <= 20'd0;
			end
			/*
			READ_A: src_a <= SW[9] ? {22'hFFFFFF, SW[9:0]} : {22'd0, SW[9:0]};
			READ_B: src_b <= SW[9] ? {22'hFFFFFF, SW[9:0]} : {22'd0, SW[9:0]};
			READ_OP: op <= SW[3:0];
			WRITE_DATA:
			begin
				rf_w_addr <= 5'd1;
				rf_w_data <= alu_result;
				rf_w_en <= 1'b1;
			end*/
			START_RENDER:
			begin
				rr_start <= 1'b1;
				reset_renderer <= 1'b1;
			end
			WAIT_RENDER: rr_start <= 1'b0;
			RENDER_DONE: reset_renderer <= 1'b0;
			INCR: curr_rend_mem_addr <= curr_rend_mem_addr + (232 * 4);
			DECR: curr_rend_mem_addr <= curr_rend_mem_addr - (232 * 4);
		endcase
	end
end

reg [31:0]src_a;
reg [31:0]src_b;
wire [31:0]alu_result;
reg [3:0]op;

alu alu_0(
	.src_a(src_a),
	.src_b(src_b),
	.op(op),
	.result(alu_result)
);

endmodule