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

reg rr_start;
wire rr_done;
wire rr_rst;
assign rr_rst = (reset_renderer && rst);

reg reset_renderer;

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
);

reg [7:0]S;
assign LEDR = S;
reg [7:0]NS;

parameter WAIT_ADDR = 8'd0,
			READ_ADDR = 8'd1,
			WAIT_DATA = 8'd2,
			READ_DATA = 8'd3,
			WRITE_DATA = 8'd4,
			START_RENDER = 8'd5,
			WAIT_RENDER = 8'd6,
			RENDER_DONE = 8'd7,
			ERR = 8'hFF;
			
always@(posedge clk or negedge rst)
begin
	if (rst == 1'b0)
		S <= WAIT_ADDR;
	else
		S <= NS;
end

always@(*)
begin
	case(S)
		WAIT_ADDR:
			if (~KEY[0])
				NS = READ_ADDR;
			else
				NS = WAIT_ADDR;
		READ_ADDR: 
			if (~KEY[0])
				NS = READ_ADDR;
			else
				NS = WAIT_DATA;
		WAIT_DATA:
			if (~KEY[0])
				NS = READ_DATA;
			else
				NS = WAIT_DATA;
		READ_DATA:
			if (~KEY[0])
				NS = READ_DATA;
			else
				NS = WRITE_DATA;
		WRITE_DATA: NS = START_RENDER;
		START_RENDER: NS = WAIT_RENDER;
		WAIT_RENDER:
			if (rr_done)
				NS = RENDER_DONE;
			else
				NS = WAIT_RENDER;
		RENDER_DONE: NS = WAIT_ADDR;
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
	end
	else
	begin
		case(S)
			WAIT_ADDR:
			begin
				reset_renderer <= 1'b1;
				rr_start <= 1'b0;
				rf_w_addr <= 5'd0;
				rf_w_data <= 32'd0;
				rf_w_en <= 1'b0;
			end
			READ_ADDR: rf_w_addr <= SW[4:0];
			READ_DATA: rf_w_data <= {22'd0, SW[9:0]};
			WRITE_DATA: rf_w_en <= 1'b1;
			START_RENDER: rr_start <= 1'b1;
			RENDER_DONE: reset_renderer <= 1'b0;
		endcase
	end
end

endmodule