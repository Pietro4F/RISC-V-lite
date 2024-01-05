module MEM_WB(
	input clk_i,
	input rst_i,
	input [31:0] read_data_i, alu_result_i,
	input reg_write_i,
	input [4:0] rd_addr_i,
	input mem_to_reg_i,
	
	output reg [31:0] read_data_o, alu_result_o,
	output reg reg_write_o,
	output reg [4:0] rd_addr_o,
	output reg mem_to_reg_o
);


always@(posedge clk_i) begin

	if(rst_i == 0) begin
	
		read_data_o <= 32'b0;
		alu_result_o <= 32'b0;
		rd_addr_o <= 5'b0;
		reg_write_o <= 1'b0;
		mem_to_reg_o <= 1'b0;
		
  	end
  	else begin
		
		read_data_o <= read_data_i;
		alu_result_o <= alu_result_i;
		rd_addr_o <= rd_addr_i;
		reg_write_o <= reg_write_i;
		mem_to_reg_o <= mem_to_reg_i;
		
  	end

end

endmodule






