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

reg vga_write_en;
reg [31:0]vga_input_data;
reg [12:0]vga_write_address;

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

reg [4:0]rf_r_addr_0;
wire [31:0]rf_r_data_0;
wire [4:0]rf_r_addr_1;
wire [31:0]rf_r_data_1;
reg [4:0]rf_w_addr;
reg [31:0]rf_w_data;
reg rf_w_en;

register_file rf(
	.clk(CLOCK_50),
	.rst(rst),
	.read_addr_0(rf_r_addr_0),
	.read_addr_1(rf_r_addr_1),
	.write_addr(rf_w_addr),
	.write_en(rf_w_en),
	.write_data(rf_w_data),
	.read_data_0(rf_r_data_0),
	.read_data_1(rf_r_data_1)
);

reg [31:0]alu_src_a;
reg [31:0]alu_src_b;
wire [31:0]alu_result;
reg [3:0]alu_op;

alu alu_0(
	.src_a(alu_src_a),
	.src_b(alu_src_b),
	.op(alu_op),
	.result(alu_result)
);

reg [15:0]dm_addr;
wire [3:0]dm_byte_en;
wire [31:0]dm_w_data;
wire dm_w_en;
wire [31:0]dm_r_data;

data_memory dm(
	.address(dm_addr),
	.byteena(dm_byte_en),
	.clock(CLOCK_50),
	.data(dm_w_data),
	.wren(1'b0),
	.q(dm_r_data)
);

reg [13:0]im_addr;
wire [31:0]im_r_data;

instruction_memory im(
	.address(im_addr),
	.clock(CLOCK_50),
	.q(im_r_data)
);

reg mr_start;
wire mr_done;
reg mr_rst;
wire [15:0]mr_addr;
reg [31:0]mr_data;
reg [19:0]curr_rend_mem_addr;
wire mr_vga_write_en;
wire [31:0]mr_vga_input_data;
wire [12:0]mr_vga_write_address;

memory_renderer mr(
	.clk(CLOCK_50),
	.rst(mr_rst),
	.start(mr_start), // start rendering
	.start_addr(curr_rend_mem_addr),
	.mem_addr(mr_addr), // register file in-addr
	.mem_data(mr_data), // register file output
	.ascii_write_en(mr_vga_write_en),
	.ascii_input(mr_vga_input_data),
	.ascii_write_address(mr_vga_write_address),
	.done(mr_done) // finished rendering
);

reg rr_start;
wire rr_done;
reg rr_rst;
wire [4:0]rr_addr;
wire rr_vga_write_en;
wire [31:0]rr_vga_input_data;
wire [12:0]rr_vga_write_address;
register_renderer rr(
	.clk(CLOCK_50),
	.rst(rr_rst),
	.start(rr_start), // start rendering
	.rf_addr(rr_addr), // register file in-addr
	.rf_data(rf_r_data_0), // register file output
	.ascii_write_en(rr_vga_write_en),
	.ascii_input(rr_vga_input_data),
	.ascii_write_address(rr_vga_write_address),
	.done(rr_done) // finished rendering
);

reg render_start;
reg render_done;
wire render_rst;
reg reset_render;
assign render_rst = (reset_render && rst);
wire [1:0]render_select;
assign render_select = SW[1:0];

parameter REGISTER_FILE_RENDER = 2'd0,
			DATA_MEMORY_RENDER = 2'd1,
			INSTRUCTION_MEMORY_RENDER = 2'd2;

// Muxing for render signals
always@(*)
begin
	if (S == RENDER_START || S == RENDER_WAIT || S == RENDER_DONE)
	begin
		case(render_select)
			REGISTER_FILE_RENDER:
			begin
				rr_start = render_start;
				mr_start = 1'b0;
				rr_rst = render_rst;
				mr_rst = 1'b1;
				render_done = rr_done;
				dm_addr = 16'd0;
				im_addr = 16'd0;
				mr_data = 32'd0;
				vga_write_en = rr_vga_write_en;
				vga_input_data = rr_vga_input_data;
				vga_write_address = rr_vga_write_address;
				rf_r_addr_0 = rr_addr;
			end
			DATA_MEMORY_RENDER:
			begin
				rr_start = 1'b0;
				mr_start = render_start;
				rr_rst = 1'b1;
				mr_rst = render_rst;
				render_done = mr_done;
				dm_addr = mr_addr;
				im_addr = 16'd0;
				mr_data = dm_r_data;
				vga_write_en = mr_vga_write_en;
				vga_input_data = mr_vga_input_data;
				vga_write_address = mr_vga_write_address;
				rf_r_addr_0 = 5'd0;
			end
			INSTRUCTION_MEMORY_RENDER:
			begin
				rr_start = 1'b0;
				mr_start = render_start;
				rr_rst = 1'b1;
				mr_rst = render_rst;
				render_done = mr_done;
				dm_addr = 16'd0;
				im_addr = mr_addr;
				mr_data = im_r_data;
				vga_write_en = mr_vga_write_en;
				vga_input_data = mr_vga_input_data;
				vga_write_address = mr_vga_write_address;
				rf_r_addr_0 = 5'd0;
			end
			default:
			begin
				rr_start = 1'b0;
				mr_start = 1'b0;
				rr_rst = 1'b0;
				mr_rst = 1'b0;
				render_done = 1'b1; // hangs on default state if 0
				dm_addr = 16'd0;
				im_addr = 16'd0;
				mr_data = 32'd0;
				vga_write_en = 0;
				vga_input_data = 0;
				vga_write_address = 0;
				rf_r_addr_0 = 5'd0;
			end
		endcase
	end
	else
	begin
		rr_start = 1'b0;
		mr_start = 1'b0; 
		rr_rst = 1'b0; //dc
		mr_rst = 1'b0; //dc
		render_done = 1'b1;
		dm_addr = data_memory_addr;
		im_addr = instruction_memory_addr;
		mr_data = 32'd0; //dc
		vga_write_en = 0; // might need to change these for std I/O
		vga_input_data = 0;
		vga_write_address = 0;
		rf_r_addr_0 = register_file_read_addr_0;
	end
end

reg [7:0]S;
assign LEDR = S;
reg [7:0]NS;

reg [31:0]pc;
reg [31:0]inst;
reg [15:0]instruction_memory_addr; // for use by execution
reg [15:0]data_memory_addr;
reg [4:0]register_file_read_addr_0;
reg [4:0]register_file_read_addr_1;
assign rf_r_addr_1 = register_file_read_addr_1;

reg [6:0]opcode;
reg [4:0]rs1;
reg [4:0]rs2;
reg [4:0]rd;
reg [9:0]func;
reg [31:0]imm;
reg branch_flag;
reg reverse_operator;

parameter START = 8'd0,
			RELEASE = 8'd1, 
			FETCH = 8'd2,
			FETCH_INST_MEM = 8'd3,
			WAIT_INST_MEM = 8'd4,
			DECODE = 8'd5,
			EXECUTE = 8'd6,
			WAIT_DATA_MEM = 8'd7,
			WRITEBACK = 8'd8,
			RENDER_START = 8'd9,
			RENDER_WAIT = 8'd10,
			RENDER_DONE = 8'd11,
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
		START: 
			if (~KEY[0])
				NS = RELEASE;
			else
				NS = START;
		RELEASE:
			if (KEY[0])
				NS = FETCH;
			else
				NS = RELEASE;
		FETCH: NS = FETCH_INST_MEM;
		FETCH_INST_MEM: NS = WAIT_INST_MEM;
		WAIT_INST_MEM: NS = DECODE;
		DECODE: NS = EXECUTE;
		EXECUTE: NS = WRITEBACK;
		WRITEBACK: NS = RENDER_START;
		RENDER_START: NS = RENDER_WAIT;
		RENDER_WAIT:
			if (render_done)
				NS = RENDER_DONE;
			else
				NS = RENDER_WAIT;
		RENDER_DONE: NS = START;
		default: NS = ERR;
	endcase
end

always@(posedge clk or negedge rst)
begin
	if (rst == 1'b0)
	begin
		render_start <= 1'b0;
		reset_render <= 1'b1;
		curr_rend_mem_addr <= 20'd0;
		pc <= 32'd0;
		inst <= 32'd0;
		opcode <= 7'd0;
		rs1 <= 5'd0;
		rs2 <= 5'd0;
		rd <= 5'd0;
		func <= 10'd0;
		imm <= 32'd0;
		branch_flag <= 1'b0;
	end
	else
	begin
		case(S)
			START:
			begin
				render_start <= 1'b0;
				reset_render <= 1'b1;
			end
			FETCH:
			begin
				instruction_memory_addr <= pc >> 2;
			end
			DECODE:
			begin
				inst <= im_r_data;
				opcode <= im_r_data[6:0];
				case(im_r_data[6:0])
					R_TYPE:
					begin
						rs1 <= im_r_data[19:15]; //rs1
						rs2 <= im_r_data[24:20]; // rs2
						rd <= im_r_data[11:7]; // rd
						func <= {im_r_data[31:25], im_r_data[14:12]}; // func
					end
					I_TYPE_I_IMM:
					begin
						rs1 <= im_r_data[19:15];
						rd <= im_r_data[11:7];
						func <= im_r_data[14:12];
						imm <= {{21{im_r_data[31]}}, im_r_data[30:20]};
					end
					LUI:
					begin
						rd <= im_r_data[11:7];
						imm <= im_r_data[31:12] << 12;
					end
					AUIPC:
					begin
						rd <= im_r_data[11:7];
						imm <= im_r_data[31:12] << 12;
					end
					JAL:
					begin
						rd <= im_r_data[11:7];
						imm <= {{12{im_r_data[31]}}, im_r_data[19:12], im_r_data[20], im_r_data[30:25], im_r_data[24:21], 1'b0};
					end
					JALR:
					begin
						rs1 <= im_r_data[19:15];
						rd <= im_r_data[11:7];
						imm <= {{21{im_r_data[31]}}, im_r_data[30:20]};
					end
					BRANCH:
					begin
						rs1 <= im_r_data[19:15];
						rs2 <= im_r_data[24:20];
						func <= im_r_data[14:12];
						imm <= {{20{im_r_data[31]}}, im_r_data[7], im_r_data[30:25], im_r_data[11:8], 1'b0};
					end
				endcase
			end
			EXECUTE:
			begin
				if (opcode == BRANCH)
					branch_flag <= alu_result[0] ^ reverse_operator;
			end
			WRITEBACK:
			begin
				case(opcode)
					JAL: pc <= pc + imm;
					JALR: pc <= (rf_r_data_0 + imm) & 32'hFFFFFFFE;
					BRANCH:
						if (branch_flag)
							pc <= pc + imm;
						else
							pc <= pc + 32'd4;
					default: pc <= pc + 32'd4;
				endcase
			end
			RENDER_START: render_start <= 1'b1;
			RENDER_DONE: reset_render <= 1'b0;
		endcase
	end
end

always@(*)
begin
	if (S == EXECUTE)
	begin
	case(opcode)
		R_TYPE:
		begin
			register_file_read_addr_0 = rs1;
			register_file_read_addr_1 = rs2;
			alu_src_a = rf_r_data_0;
			alu_src_b = rf_r_data_1;
			rf_w_addr = rd;
			rf_w_data = alu_result;
			rf_w_en = 1'b1;
			reverse_operator = 1'b0;
			case(func)
				R_ADD: alu_op = ALU_ADD;
				R_SUB: alu_op = ALU_SUB;
				R_AND: alu_op = ALU_AND;
				R_OR: alu_op = ALU_OR;
				R_XOR: alu_op = ALU_XOR;
				R_SLT: alu_op = ALU_LT;
				R_SLTU: alu_op = ALU_LT_U;
				R_SRA: alu_op = ALU_SR_A;
				R_SRL: alu_op = ALU_SR;
				R_SLL: alu_op = ALU_SL;
				R_MUL: alu_op = ALU_MUL;
				default: alu_op = 4'hF;
			endcase
		end
		I_TYPE_I_IMM:
		begin
			register_file_read_addr_0 = rs1;
			register_file_read_addr_1 = 5'd0;
			alu_src_a = rf_r_data_0;
			alu_src_b = imm;
			rf_w_addr = rd;
			rf_w_data = alu_result;
			rf_w_en = 1'b1;
			reverse_operator = 1'b0;
			case(func[2:0])
				I_I_IMM_ADDI: alu_op = ALU_ADD;
				I_I_IMM_ANDI: alu_op = ALU_AND;
				I_I_IMM_ORI: alu_op = ALU_OR;
				I_I_IMM_XORI: alu_op = ALU_XOR;
				I_I_IMM_SLTI: alu_op = ALU_LT;
				I_I_IMM_SLTIU: alu_op = ALU_LT_U;
				I_I_IMM_SRI:
					if (inst[30])
						alu_op = ALU_SR_A; //sra
					else
						alu_op = ALU_SR; //srl
				I_I_IMM_SLLI: alu_op = ALU_SL;
				default: alu_op = 4'hF;
			endcase
		end
		LUI:
		begin
			register_file_read_addr_0 = 5'd0;
			register_file_read_addr_1 = 5'd0;
			alu_src_a = 32'd0;
			alu_src_b = 32'd0;
			rf_w_addr = rd;
			rf_w_data = imm;
			rf_w_en = 1'b1;
			alu_op = 4'hF;
			reverse_operator = 1'b0;
		end
		AUIPC:
		begin
			register_file_read_addr_0 = 5'd0;
			register_file_read_addr_1 = 5'd0;
			alu_src_a = pc;
			alu_src_b = imm;
			rf_w_addr = rd;
			rf_w_data = alu_result;
			rf_w_en = 1'b1;
			alu_op = ALU_ADD;
			reverse_operator = 1'b0;
		end
		JAL:
		begin
			register_file_read_addr_0 = 5'd0;
			register_file_read_addr_1 = 5'd0;
			alu_src_a = pc;
			alu_src_b = 32'd4;
			rf_w_addr = rd;
			rf_w_data = alu_result;
			rf_w_en = 1'b1;
			alu_op = ALU_ADD;
			reverse_operator = 1'b0;
		end
		JALR:
		begin
			register_file_read_addr_0 = rs1;
			register_file_read_addr_1 = 5'd0;
			alu_src_a = pc;
			alu_src_b = 32'd4;
			rf_w_addr = rd;
			rf_w_data = alu_result;
			rf_w_en = 1'b1;
			alu_op = ALU_ADD;
			reverse_operator = 1'b0;
		end
		BRANCH:
		begin
			register_file_read_addr_0 = rs1;
			register_file_read_addr_1 = rs2;
			alu_src_a = rf_r_data_0;
			alu_src_b = rf_r_data_1;
			rf_w_addr = 5'd0;
			rf_w_data = 32'd0;
			rf_w_en = 1'b0;
			case(func[2:0])
				BEQ:
				begin
					alu_op = ALU_EQ;
					reverse_operator = 1'b0;
				end
				BNE:
				begin
					alu_op = ALU_EQ;
					reverse_operator = 1'b1;
				end
				BLT:
				begin
					alu_op = ALU_LT;
					reverse_operator = 1'b0;
				end
				BGE:
				begin
					alu_op = ALU_LT;
					reverse_operator = 1'b1;
				end
				BLTU:
				begin
					alu_op = ALU_LT_U;
					reverse_operator = 1'b0;
				end
				BGEU:
				begin
					alu_op = ALU_LT_U;
					reverse_operator = 1'b1;
				end
				default:
				begin
					alu_op = 4'hF;
					reverse_operator = 1'b0;
				end
			endcase
		end
		default:
		begin
			register_file_read_addr_0 = 5'd0;
			register_file_read_addr_1 = 5'd0;
			alu_src_a = 32'd0;
			alu_src_b = 32'd0;
			rf_w_addr = 5'd0;
			rf_w_data = 32'd0;
			rf_w_en = 1'b0;
			alu_op = 4'hF;
			reverse_operator = 1'b0;
		end
	endcase
	end
	else
	begin
		register_file_read_addr_0 = 5'd0;
		register_file_read_addr_1 = 5'd0;
		alu_src_a = 32'd0;
		alu_src_b = 32'd0;
		rf_w_addr = 5'd0;
		rf_w_data = 32'd0;
		rf_w_en = 1'b0;
		alu_op = 4'hF;
		reverse_operator = 1'b0;
	end
end

// opcodes
parameter R_TYPE = 7'b0110011,
			I_TYPE_I_IMM = 7'b0010011,
			LUI = 7'b0110111, // I Type, U-Imm
			AUIPC = 7'b0010111, // I Type, U-Imm
			LOAD_MEM = 7'b0000011, // I Type, I-Imm
			STORE_MEM = 7'b0100011, // S Type, S-Imm
			JAL = 7'b1101111,
			JALR = 7'b1100111,
			BRANCH = 7'b1100011;

// func codes	
parameter R_ADD = 10'b0000000000,
			R_SUB = 10'b0100000000,
			R_AND = 10'b0000000111,
			R_OR = 10'b0000000110,
			R_XOR = 10'b0000000100,
			R_SLT = 10'b0000000010,
			R_SLTU = 10'b0000000011,
			R_SRA = 10'b0100000101,
			R_SRL = 10'b0000000101,
			R_SLL = 10'b0000000001,
			R_MUL = 10'b0000001000;
			
parameter I_I_IMM_ADDI = 3'b000,
			I_I_IMM_ANDI = 3'b111,
			I_I_IMM_ORI = 3'b110,
			I_I_IMM_XORI = 3'b100,
			I_I_IMM_SLTI = 3'b010,
			I_I_IMM_SLTIU = 3'b011,
			I_I_IMM_SRI = 3'b101, // SRAI inst[30] == 1, SRLI inst[30] == 0
			I_I_IMM_SLLI = 3'b001;
			
parameter MEM_WORD = 3'b010, MEM_BYTE = 3'b000;

parameter BEQ = 3'b000,
			BNE = 3'b001,
			BLT = 3'b100,
			BGE = 3'b101,
			BLTU = 3'b110,
			BGEU = 3'b111;

// alu_op codes			
parameter ALU_ADD = 4'd0,
			ALU_SUB = 4'd1,
			ALU_AND = 4'd2,
			ALU_OR = 4'd3,
			ALU_XOR = 4'd4,
			ALU_LT = 4'd5,
			ALU_LT_U = 4'd6,
			ALU_SR = 4'd7,
			ALU_SR_A = 4'd8,
			ALU_SL = 4'd9,
			ALU_MUL = 4'd10,
			ALU_EQ = 4'd11;
			
endmodule