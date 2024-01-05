module CU(
    input [6:0] op_i,
    
    output reg [3:0] alu_op_o,
    output reg [2:0] imm_select_o,
    output reg alu_src_o, alu_pc_o, add_sum_reg_o, reg_write_o,
    output reg mem_rd_o, mem_wr_o, mem_to_reg_o, branch_o
);

always@(*)begin

  case(op_i)

	7'b0010011 : begin 		//addi, li, mv, slli, srai
  	alu_op_o = 3'b101;
  	alu_src_o = 1'b1;
	alu_pc_o = 1'b0;
	add_sum_reg_o=1'b0;
  	reg_write_o = 1'b1;
  	mem_rd_o = 1'b0;
  	mem_wr_o = 1'b0;
  	mem_to_reg_o = 1'b0;
  	imm_select_o = 3'b000; 	//"I" immediate format
  	branch_o = 1'b0;
  	end
  	
  	7'b0110011 : begin 		//add, xor, sub
  	alu_op_o = 3'b000;
  	alu_src_o = 1'b0;
	alu_pc_o = 1'b0;
	add_sum_reg_o=1'b0;
  	reg_write_o = 1'b1;
  	mem_rd_o = 1'b0;
  	mem_wr_o = 1'b0;
  	mem_to_reg_o = 1'b0;
  	imm_select_o = 3'b000; 	//"R" immediate format (no immediate value)
  	branch_o = 1'b0;
  	end
  	
  	7'b0110111 : begin 		//lui
  	alu_op_o = 3'b001;
  	alu_src_o = 1'b1;
	alu_pc_o = 1'b0;
	add_sum_reg_o=1'b0;
  	reg_write_o = 1'b1;
  	mem_rd_o = 1'b0;
  	mem_wr_o = 1'b0;
  	mem_to_reg_o = 1'b0;
  	imm_select_o = 3'b011; 	//"U" immediate format
  	branch_o = 1'b0;
  	end
  	
  	7'b0100011 : begin 		//sw
  	alu_op_o = 3'b110;
  	alu_src_o = 1'b1;
	alu_pc_o = 1'b0;
	add_sum_reg_o=1'b0;
  	reg_write_o = 1'b0;
  	mem_rd_o = 1'b0;
  	mem_wr_o = 1'b1;
  	mem_to_reg_o = 1'b0;
  	imm_select_o = 3'b001; 	//"S" immediate format
  	branch_o = 1'b0;
  	end
  	
  	7'b0000011 : begin 		//lw
  	alu_op_o = 3'b110;
  	alu_src_o = 1'b1;
	alu_pc_o = 1'b0;
	add_sum_reg_o=1'b0;
  	reg_write_o = 1'b1;
  	mem_rd_o = 1'b1;
  	mem_wr_o = 1'b0;
  	mem_to_reg_o = 1'b1;
  	imm_select_o = 3'b000; 	//"I"  immediate format
  	branch_o = 1'b0;
  	end
  	
  	7'b1100011 : begin 		//ble, bne
  	alu_op_o = 3'b010;
  	alu_src_o = 1'b0;
	alu_pc_o = 1'b0;
	add_sum_reg_o=1'b0;
  	reg_write_o = 1'b0;
  	mem_rd_o = 1'b0;
  	mem_wr_o = 1'b0;
  	mem_to_reg_o = 1'b0;
  	imm_select_o = 3'b010; 	//"SB" immediate format 
  	branch_o = 1'b1;
  	end

	7'b0010111 : begin 		//auipc
  	alu_op_o = 3'b100;
  	alu_src_o = 1'b1;
	alu_pc_o = 1'b1;
	add_sum_reg_o=1'b0;
  	reg_write_o = 1'b1;
  	mem_rd_o = 1'b0;
  	mem_wr_o = 1'b0;
  	mem_to_reg_o = 1'b0;
  	imm_select_o = 3'b011; 	//"U" immediate format
  	branch_o = 1'b0;
  	end

	7'b1101111 : begin 		//jal, j
  	alu_op_o = 3'b011;
  	alu_src_o = 1'b0;
	alu_pc_o = 1'b1;
	add_sum_reg_o=1'b0;
  	reg_write_o = 1'b1;
  	mem_rd_o = 1'b0;
  	mem_wr_o = 1'b0;
  	mem_to_reg_o = 1'b0;
  	imm_select_o = 3'b100; 	//"UJ" immediate format
  	branch_o = 1'b1;
  	end

	7'b1100111 : begin 		//jalr, ret
  	alu_op_o = 3'b011;
  	alu_src_o = 1'b0;
	alu_pc_o = 1'b1;
	add_sum_reg_o=1'b1;
  	reg_write_o = 1'b0;
  	mem_rd_o = 1'b0;
  	mem_wr_o = 1'b0;
  	mem_to_reg_o = 1'b0;
  	imm_select_o = 3'b000; 	//"I" immediate format
  	branch_o = 1'b1;
  	end

	7'b0000000 : begin		//nop
	alu_op_o = 3'b000;
  	alu_src_o = 1'b0;
	alu_pc_o = 1'b0;
	add_sum_reg_o=1'b0;
  	reg_write_o = 1'b0;
  	mem_rd_o = 1'b0;
  	mem_wr_o = 1'b0;
  	mem_to_reg_o = 1'b0;
  	imm_select_o = 3'b000; 	//"I" immediate format
  	branch_o = 1'b0;
	end

	default : begin			//nop
	alu_op_o = 3'b000;
  	alu_src_o = 1'b0;
	alu_pc_o = 1'b0;
	add_sum_reg_o=1'b0;
  	reg_write_o = 1'b0;
  	mem_rd_o = 1'b0;
  	mem_wr_o = 1'b0;
  	mem_to_reg_o = 1'b0;
  	imm_select_o = 3'b000; 	//"I" immediate format
  	branch_o = 1'b0;
	end
	endcase
end


endmodule
