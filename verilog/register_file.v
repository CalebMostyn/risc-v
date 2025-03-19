module register_file(
	input clk,
	input rst,
	input [4:0]read_addr_0,
	input [4:0]read_addr_1,
	input [4:0]write_addr,
	input write_en,
	input [31:0]write_data,
	output [31:0]read_data_0,
	output [31:0]read_data_1
);

reg [31:0] data [0:31]; // 32, 32-bit registers

always@(posedge clk or negedge rst)
begin
	if (rst == 1'b0)
	begin
		data[0] <= 32'd0;
		data[1] <= 32'd0;
		data[2] <= 32'h000383FC;
		data[3] <= 32'd0;
		data[4] <= 32'd0;
		data[5] <= 32'd0;
		data[6] <= 32'd0;
		data[7] <= 32'd0;
		data[8] <= 32'd0;
		data[9] <= 32'd0;
		data[10] <= 32'd0;
		data[11] <= 32'd0;
		data[12] <= 32'd0;
		data[13] <= 32'd0;
		data[14] <= 32'd0;
		data[15] <= 32'd0;
		data[16] <= 32'd0;
		data[17] <= 32'd0;
		data[18] <= 32'd0;
		data[19] <= 32'd0;
		data[20] <= 32'd0;
		data[21] <= 32'd0;
		data[22] <= 32'd0;
		data[23] <= 32'd0;
		data[24] <= 32'd0;
		data[25] <= 32'd0;
		data[26] <= 32'd0;
		data[27] <= 32'd0;
		data[28] <= 32'd0;
		data[29] <= 32'd0;
		data[30] <= 32'd0;
		data[31] <= 32'd0;
	end
	else
	begin
		if (write_en && (write_addr != 5'd0))
		begin
			data[write_addr] <= write_data;
		end
	end
end

assign read_data_0 = data[read_addr_0];
assign read_data_1 = data[read_addr_1];

endmodule