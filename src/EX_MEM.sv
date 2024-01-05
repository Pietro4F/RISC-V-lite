module EX_MEM(
	input clk_i,
	input rst_i,
	input [31:0] alu_result_i, jmp_addr_i,
	input zero_i,
	input [4:0] rd_addr_i,
	input reg_write_i,
	input mem_to_reg_i, branch_i,
	
	output reg [31:0] alu_result_o, jmp_addr_o,
	output reg zero_o,
	output reg [4:0] rd_addr_o,
	output reg reg_write_o,
	output reg mem_to_reg_o, branch_o
	
);

always@(posedge clk_i) begin

	if(rst_i == 0) begin
	
		alu_result_o <= 32'b0;
		zero_o <= 1'b0;
		rd_addr_o <= 5'b0;
		reg_write_o <= 1'b0;
		mem_to_reg_o <= 1'b0;
		jmp_addr_o <= 32'b0;
		branch_o <= 1'b0;
		
  	end
  	else begin
		
		alu_result_o <= alu_result_i;
		zero_o <= zero_i;
		rd_addr_o <= rd_addr_i;
		reg_write_o <= reg_write_i;
		mem_to_reg_o <= mem_to_reg_i;
		jmp_addr_o <= jmp_addr_i;
		branch_o <= branch_i;
		
  	end

end

endmodule
