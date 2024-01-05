module ID_EX(
	input clk_i,
	input rst_i,
	input [24:0] inst_i,
	input [31:0] pc_i,
	input [31:0] rs1_data_i, rs2_data_i,
	input [31:0] sign_extended_i,
	input [3:0] alu_op_i,
	input alu_src_i,
	input reg_write_i,
	input mem_to_reg_i, mem_read_i, mem_write_i,
	input add_sum_reg_i,
	input alu_pc_i,
	input branch_i,
	
	output reg [24:0] inst_o,
    output reg [31:0] pc_o,
	output reg [31:0] rs1_data_o, rs2_data_o,
	output reg [31:0] sign_extended_o,
	output reg [3:0] alu_op_o,
	output reg alu_src_o, 
	output reg reg_write_o,
	output reg mem_to_reg_o, mem_read_o, mem_write_o,
	output reg add_sum_reg_o,
	output reg alu_pc_o,
	output reg branch_o
);

always@(posedge clk_i) begin

	if(rst_i == 0) begin
	
		inst_o <= 25'b0;
		pc_o <= 32'b0;
		rs1_data_o <= 32'b0;
		rs2_data_o <= 32'b0;
		sign_extended_o <= 32'b0;
		reg_write_o <= 1'b0;
		mem_to_reg_o <= 1'b0;
		mem_read_o <= 1'b0;
		mem_write_o <= 1'b0;
		alu_op_o <= 4'b0;
		alu_src_o <= 1'b0;
		add_sum_reg_o <= 1'b0;
		alu_pc_o <= 1'b0;
		branch_o <= 1'b0;
		
  	end
  	else begin
		
		inst_o <= inst_i;
		pc_o <= pc_i;
		rs1_data_o <= rs1_data_i;
		rs2_data_o <= rs2_data_i;
		sign_extended_o <= sign_extended_i;
		reg_write_o <= reg_write_i;
		mem_to_reg_o <= mem_to_reg_i;
		mem_read_o <= mem_read_i;
		mem_write_o <= mem_write_i;
		alu_op_o <= alu_op_i;
		alu_src_o <= alu_src_i;
		add_sum_reg_o <= add_sum_reg_i;
		alu_pc_o <= alu_pc_i;
		branch_o <= branch_i;
		
  	end

end

endmodule
