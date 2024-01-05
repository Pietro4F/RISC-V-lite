module Forwarding_Unit(
	input reg_write_mem_i, reg_write_wb_i,
	input [4:0] rs_1_ex_i, rs_2_ex_i, rd_mem_i, rd_wb_i,
	
	output reg [1:0] forward_a_o, forward_b_o
);

always@(*)begin

    forward_a_o = 2'b00;							//Default output, no forwarding of op1

    if(reg_write_mem_i && 
    (rd_mem_i != 5'b00000) && 
    (rd_mem_i == rs_1_ex_i)) forward_a_o = 2'b01;	//Forwarding of op1 from EX-MEM register

    else if(reg_write_wb_i &&
    (rd_wb_i != 5'b00000) &&
    rd_wb_i == rs_1_ex_i)  forward_a_o = 2'b10;		//Forwarding of op1 from MEM-WB register


    forward_b_o = 2'b00;							//Default output, no forwarding of op2

    if(reg_write_mem_i && 
    (rd_mem_i != 5'b00000) && 
    (rd_mem_i == rs_2_ex_i)) forward_b_o = 2'b01;	//Forwarding of op2 from EX-MEM register

    else if(reg_write_wb_i &&
    (rd_wb_i != 5'b00000) &&
    rd_wb_i == rs_2_ex_i)  forward_b_o = 2'b10;		//Forwarding of op2 from MEM-WB register

end

endmodule
