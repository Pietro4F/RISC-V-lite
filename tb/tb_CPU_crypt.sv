//`timescale  1ns/1ps

module tb_CPU ();

parameter CLOCK = 20;
reg clk, rst;

CPU DUT(
	.clk_i(clk),
    .rst_i(rst)
);


always begin		//Generation of the clock signal
	#(CLOCK/2)
	clk = ~clk;
end


int fd, fd2, fd3;	//Definition of the file descriptors
int write;			//Flag to signal if output to file is needed


initial begin

	//Opening the files
	fd = $fopen("./print/pc_crypt.txt", "w");
	fd2 = $fopen("./print/rf_crypt.txt", "w");
	fd3 = $fopen("./print/ram_crypt.txt", "w");
	write = 1;

	rst <= 1'b0;
	clk <= 1'b0;
	
	$readmemh("key.mem", DUT.K_MEM.CELL.mem);				//Loading of the encryption keys in the memory
	$readmemh("enc.mem", DUT.INST_MEM.CELL[0].CELL.mem);	//Loading of the instructions in the memory
	$readmemh("data.mem", DUT.DATA_MEM.CELL_0.mem);			//Loading of the data in the memory


	#(CLOCK*5)
	
	rst <= 1'b1;
		
	#(CLOCK*145)	//Waiting the end of the execution
	
	//Writing the values stored in register file and data memory at the end of the simulation
	$fdisplay(fd2, "%p", DUT.Registers.registers);
	$fdisplay(fd3, "%p", DUT.DATA_MEM.CELL_0.mem);
	$fdisplay(fd3, "%p", DUT.DATA_MEM.CELL_1.mem);
	
	//Closing the files
	$fclose(fd);
	$fclose(fd2);	
	$fclose(fd3);
	write = 0;		//Stop of the output to file
	
end

always @(posedge clk) begin	//Writing the value of the program counter at each clock cycle
	if (write == 1) begin
		$fdisplay(fd, "%h", DUT.inst_addr);
	end
end

endmodule
