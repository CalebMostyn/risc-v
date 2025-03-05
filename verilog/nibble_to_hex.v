module nibble_to_hex(input [3:0]num, output reg [7:0]ascii);

always@(*)
begin
	case(num)
		4'd0: ascii = "0";
		4'd1: ascii = "1";
		4'd2: ascii = "2";
		4'd3: ascii = "3";
		4'd4: ascii = "4";
		4'd5: ascii = "5";
		4'd6: ascii = "6";
		4'd7: ascii = "7";
		4'd8: ascii = "8";
		4'd9: ascii = "9";
		4'hA: ascii = "A";
		4'hB: ascii = "B";
		4'hC: ascii = "C";
		4'hD: ascii = "D";
		4'hE: ascii = "E";
		4'hF: ascii = "F";
		default: ascii = "?";
	endcase
end

endmodule