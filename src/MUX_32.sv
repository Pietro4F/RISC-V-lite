module MUX_32(
    input wire [31:0] data0_i, data1_i,
    input sel_i,
    
    output reg [31:0] data_o     
);

always @(*) begin

	if(sel_i == 1'b0)
		data_o <= data0_i;
	else
		data_o <= data1_i;
end

endmodule
