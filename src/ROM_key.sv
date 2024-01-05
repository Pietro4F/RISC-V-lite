module ROM_key(
		input clk_i,
		input [3:0] addr_i,

		output [31:0] data_o
);

wire [31:0] data;
wire [9:0] addr;

assign addr = {6'd0 ,addr_i};


sram_32_1024_freepdk45 CELL (.clk0(clk_i), .csb0(1'b0), .web0(1'b1), .addr0(addr), .din0(32'd0), .dout0(data));


assign data_o = data;


endmodule
