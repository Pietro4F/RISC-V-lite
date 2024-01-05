module MUX_32_4to1(
    input [31:0] data0_i, data1_i, data2_i, data3_i,
    input sel_i,
    input [1:0] sel_f_i,
    
    output reg [31:0] data_o     
);

assign data_o = (sel_i == 1'b0) ? (			//If operand from register file is selected
					(sel_f_i == 2'b00) ?
						data0_i :			//Operand from the register file
					(sel_f_i == 2'b01) ?
						data1_i :			//Forwarding from EX-MEM register
					(sel_f_i == 2'b10) ?
						data2_i :			//Forwarding from MEM-WB register
						32'd0
					) :
				(sel_i == 1'b1) ?			//If operand is not from register file
					data3_i :				//Selection of operand
					32'd0;
					
					
/*
always @(*) begin

	if(sel_i == 1'b0) begin
		if (sel_f_i == 2'b00)begin
			data_o <= data0_i;
		end else if (sel_f_i == 2'b01)begin
			data_o <= data1_i;
		end else if (sel_f_i == 2'b10) begin
			data_o <= data2_i;
		end
	end else if(sel_i == 1'b1) begin
		data_o <= data3_i;
	end
end
*/

endmodule
