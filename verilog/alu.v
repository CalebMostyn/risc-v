module alu(
	input [31:0]src_a,
	input [31:0]src_b,
	input [3:0]op,
	output reg [31:0]result
);

parameter ADD = 4'd0,
			SUB = 4'd1,
			AND = 4'd2,
			OR = 4'd3,
			XOR = 4'd4,
			LT = 4'd5,
			LT_U = 4'd6,
			SR = 4'd7,
			SR_A = 4'd8,
			SL = 4'd9,
			MUL = 4'd10,
			EQ = 4'd11;

always@(*)
begin
	case(op)
		ADD: result = src_a + src_b;
		SUB: result = src_a - src_b;
		AND: result = src_a & src_b;
		OR: result = src_a | src_b;
		XOR: result = src_a ^ src_b;
		LT: result = $signed(src_a) < $signed(src_b) ? 32'd1 : 32'd0;
		LT_U: result = src_a < src_b ? 32'd1 : 32'd0;
		SR: result = src_a >> src_b[4:0];
		SR_A: result = $signed(src_a) >>> src_b[4:0];
		SL: result = src_a << src_b[4:0];
		MUL: result = src_a * src_b;
		EQ: result = src_a == src_b ? 32'd1 : 32'd0;
		default: result = 32'd0;
	endcase
end			

endmodule