module CPU
(
    input clk_i,
    input rst_i
);


//********** IF **********

wire pc_src;
wire [31:0] inst_addr, pc_p4, pc_i, jmp_addr_mem;
wire rst_bubble;

wire [31:0] inst_id, inst_addr_id;

MUX_32 MUX32_PC(			//Multiplexer for selection of input for the program counter
	.data0_i(pc_p4),
	.data1_i(jmp_addr_mem),
	.sel_i(pc_src),
	
	.data_o(pc_i)
);

PC PC(						//Program counter
    .clk_i(clk_i),
    .rst_i(rst_i),
    .pc_i(pc_i),
    
    .pc_o(inst_addr)
);

Adder Adder_PC(				//Adder for the increment of the program counter
	.op1_i(inst_addr),
	.op2_i(32'd4),
	
	.data_o(pc_p4)
);

assign rst_bubble = (~pc_src) & rst_i;	//Signal to reset in case of external reset or jumps

reg rst_bubble_old;						//Flip-Flop to save the previous state of the reset signal
always@(posedge clk_i) begin
	rst_bubble_old <= rst_bubble;
end

ROM INST_MEM(				//Intruction memory
	.clk_i(clk_i),
	.addr_i(inst_addr),
	
	.data_o(inst_id)
);

IF_ID IF_ID(				//IF-ID pipeline register
	.clk_i(clk_i),
	.rst_i(rst_i),
	.pc_i(inst_addr),
	
	.pc_o(inst_addr_id)
);


//********** ID **********

wire reg_write_wb;
wire [31:0] reg_data_i;
wire [4:0] rd_addr_wb;

wire [31:0] rs1_data, rs2_data, immediate;
wire reg_write, alu_pc, alu_src, mem_read, mem_write, mem_to_reg, branch;
wire [2:0] imm_select;
wire [3:0] alu_op;

wire [31:7] inst_ex;
wire [31:0] immediate_ex, inst_addr_ex, rs1_data_ex, rs2_data_ex;
wire alu_pc_ex, alu_src_ex, reg_write_ex, mem_to_reg_ex, mem_read_ex, mem_write_ex, add_sum_reg, add_sum_reg_ex, branch_ex;
wire [3:0] alu_op_ex;

Registers Registers(		//Register file
	.clk_i(clk_i),
	.rst_i(rst_i),
	.rs1_addr_i(inst_id[19:15]),
	.rs2_addr_i(inst_id[24:20]),
	.write_addr_i(rd_addr_wb),
	.data_i(reg_data_i),
	.reg_write_i(reg_write_wb),
	
	.rs1_data_o(rs1_data),
	.rs2_data_o(rs2_data)
);

CU CU(						//Control unit
    .op_i(inst_id[6:0]),
    
    .alu_op_o(alu_op),
    .alu_src_o(alu_src),
    .reg_write_o(reg_write),
    .mem_rd_o(mem_read),
    .mem_wr_o(mem_write),
    .mem_to_reg_o(mem_to_reg),
    .imm_select_o(imm_select),
    .branch_o(branch),
    .add_sum_reg_o(add_sum_reg),
    .alu_pc_o(alu_pc)
);

Imm_Gen Imm_Gen(			//Selector for the bits that form the immediate value
    .imm_select_i(imm_select),
    .data_i(inst_id[31:7]),
    
    .data_o(immediate)     
);

ID_EX ID_EX(				//IX-EX pipeline register
	.clk_i(clk_i),
	.rst_i(rst_bubble & rst_bubble_old),
	.inst_i(inst_id[31:7]), 
	.pc_i(inst_addr_id),
	.rs1_data_i(rs1_data), 
	.rs2_data_i(rs2_data),
	.sign_extended_i(immediate),
	.alu_op_i(alu_op),
	.alu_src_i(alu_src),
	.reg_write_i(reg_write),
	.mem_to_reg_i(mem_to_reg), 
	.mem_read_i(mem_read), 
	.mem_write_i(mem_write),
	.add_sum_reg_i(add_sum_reg),
	.alu_pc_i(alu_pc),
	.branch_i(branch),
	
    .inst_o(inst_ex), 
    .pc_o(inst_addr_ex),
	.rs1_data_o(rs1_data_ex), 
	.rs2_data_o(rs2_data_ex),
	.sign_extended_o(immediate_ex),
	.alu_op_o(alu_op_ex),
	.alu_src_o(alu_src_ex),
	.reg_write_o(reg_write_ex),
	.mem_to_reg_o(mem_to_reg_ex), 
	.mem_read_o(mem_read_ex), 
	.mem_write_o(mem_write_ex),
	.add_sum_reg_o(add_sum_reg_ex),
	.alu_pc_o(alu_pc_ex),
	.branch_o(branch_ex)
);


//********** EX **********

wire [31:0] op1_add_sum, op1_alu, op2_alu, alu_result, jmp_addr;
wire [3:0] alu_ctrl;
wire zero;
wire [1:0] forward_a, forward_b;

wire [31:0] alu_result_mem, inst_addr_mem;
wire [4:0] rd_addr_mem;
wire zero_mem, reg_write_mem, mem_to_reg_mem, branch_mem;

MUX_32 MUX32_sum(			//Multiplexer to select the input of the adder for the target address of a jump
	.data0_i(inst_addr_ex),
	.data1_i(rs1_data_ex),
	.sel_i(add_sum_reg_ex),
	
	.data_o(op1_add_sum)
);

Adder Adder_sum(			//Adder to calculate the target address of a jump
	.op1_i(op1_add_sum),
	.op2_i({immediate_ex[30:0], 1'b0}),
	
	.data_o(jmp_addr)
);

MUX_32_4to1 MUX32_alu_pc(	//Multiplexer to select the operant 1 of the ALU
	.data0_i(rs1_data_ex),
	.data1_i(alu_result_mem),
	.data2_i(reg_data_i),
	.data3_i(inst_addr_ex),
	.sel_i(alu_pc_ex),
	.sel_f_i(forward_a),
	
	.data_o(op1_alu)
);

MUX_32_4to1 MUX32_alu_imm(	//Multiplexer to select the operant 2 of the ALU
	.data0_i(rs2_data_ex),
	.data1_i(alu_result_mem),
	.data2_i(reg_data_i),
	.data3_i(immediate_ex),
	.sel_i(alu_src_ex),
	.sel_f_i(forward_b),
	
	.data_o(op2_alu)
);

ALU ALU(					//Arithmetic logic unit
	.op1_i(op1_alu), 
	.op2_i(op2_alu), 
	.alu_ctrl_i(alu_ctrl), 
	
	.data_o(alu_result),
	.Zero_o(zero)
);

ALU_CU ALU_CU(				//Control unit for the ALU
	.alu_op_i(alu_op_ex),
	.funct_3_i(inst_ex[14:12]),
	.funct_7_i(inst_ex[31:25]),
	
	.alu_ctrl_o(alu_ctrl)
);

EX_MEM EX_MEM(				//EX-MEM pipeline register
	.clk_i(clk_i),
	.rst_i(rst_bubble),
	.jmp_addr_i(jmp_addr),
	.alu_result_i(alu_result),
	.zero_i(zero),
	.rd_addr_i(inst_ex[11:7]),
	.reg_write_i(reg_write_ex),
	.mem_to_reg_i(mem_to_reg_ex), 
	.branch_i(branch_ex),
	
	.jmp_addr_o(jmp_addr_mem), 
	.alu_result_o(alu_result_mem),
	.zero_o(zero_mem),
	.rd_addr_o(rd_addr_mem),
	.reg_write_o(reg_write_mem),
	.mem_to_reg_o(mem_to_reg_mem), 
	.branch_o(branch_mem)
);



Forwarding_Unit Forwarding_Unit(	//Forwarding unit
	.reg_write_mem_i(reg_write_mem),
	.reg_write_wb_i(reg_write_wb),
	.rs_1_ex_i(inst_ex[19:15]),
	.rs_2_ex_i(inst_ex[24:20]),
	.rd_mem_i(rd_addr_mem), 
	.rd_wb_i(rd_addr_wb),
	
	.forward_a_o(forward_a), 
	.forward_b_o(forward_b)
);
 
 
//********** MEM **********

wire [31:0] data_mem_o;

wire [31:0] data_mem_o_wb, alu_result_wb;
wire mem_to_reg_wb;

RAM DATA_MEM(				//Data memory
	.clk_i(clk_i),
	.read_i(mem_read_ex),
	.write_i(mem_write_ex),
	.addr_i(alu_result),
	.data_i(rs2_data_ex),
	
	.data_o(data_mem_o)
);

assign pc_src = branch_mem & zero_mem;	//Signal to select the imput of the program counter

MEM_WB MEM_WB(				//MEM-WB pipeline register
	.clk_i(clk_i),
	.rst_i(rst_i),
	.read_data_i(data_mem_o), 
	.alu_result_i(alu_result_mem),
	.reg_write_i(reg_write_mem),
	.rd_addr_i(rd_addr_mem),
	.mem_to_reg_i(mem_to_reg_mem),
	
	.read_data_o(data_mem_o_wb), 
	.alu_result_o(alu_result_wb),
	.reg_write_o(reg_write_wb),
	.rd_addr_o(rd_addr_wb),
	.mem_to_reg_o(mem_to_reg_wb)
);



//********** WB **********

MUX_32 MUX32_mem(			//Multiplexer to select the input of the register file write port
	.data0_i(alu_result_wb),
	.data1_i(data_mem_o_wb),
	.sel_i(mem_to_reg_wb),
	
	.data_o(reg_data_i)
);
    
endmodule
