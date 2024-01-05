module Registers
(
    input clk_i,
    input rst_i,
    input [4:0] rs1_addr_i, rs2_addr_i,
    input [31:0] data_i,
    input [4:0] write_addr_i,
    input reg_write_i,
    
	output reg [31:0] rs1_data_o, rs2_data_o
);


reg [31:0] registers [0:31];
integer i;

   
assign  rs1_data_o = registers[rs1_addr_i];		//Output for RS1 value
assign  rs2_data_o = registers[rs2_addr_i];		//Output for RS2 value


always@(negedge clk_i)begin
    if(rst_i == 0) begin
        for(i=0;i<32;i=i+1)registers[i] <= 32'd0;	//Reset of all the registers
		registers[2] <= 32'h7FFFEFFC;				//Reset of the stack pointer
		registers[3] <= 32'h10008000;				//Reset of the global pointer
    end  

    else  begin
        if(reg_write_i == 1 && write_addr_i > 5'd0)begin	//Writing in the registers (register 0 is read only)
            registers[write_addr_i] <= data_i;

        end
    end
end
   
endmodule 
