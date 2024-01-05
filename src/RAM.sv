module RAM(	
		input clk_i,
		input read_i,
		input write_i,
		input [31:0] addr_i,
		input [31:0] data_i,
		
		output reg [31:0] data_o
);

reg [1:0] cs;
wire [31:0] data [1:0];
reg cell_addr;

sram_32_1024_freepdk45 CELL_0 (						//Cell 0 of SRAM (address from 10010000 to 10010fff)
							.clk0(clk_i), 
							.csb0(cs[0]), 
							.web0(~write_i), 
							.addr0(addr_i[11:2]), 
							.din0(data_i), 
							.dout0(data[0]));
							
sram_32_1024_freepdk45 CELL_1 (						//Cell 1 of SRAM (address from 7fffe000 to 7fffefff)
							.clk0(clk_i), 
							.csb0(cs[1]), 
							.web0(~write_i), 
							.addr0(addr_i[11:2]), 
							.din0(data_i), 
							.dout0(data[1]));


always @(addr_i) begin

	cs <= ~0;											//Default values for the chip selects (no SRAM cell selected)
	
	if(read_i == 1'b1 || write_i == 1'b1) begin
		if(addr_i[31:12] == 20'h10010) begin 			//Selection of cell 0
			cs[0] <= 1'b0;
		end else if(addr_i[31:12] == 20'h7fffe) begin 	//Selection of cell 1
			cs[1] <= 1'b0;
		end
	end
end


always @(posedge clk_i) begin				//Flip flop to store the address of the SRAM cell previously selected

	if(addr_i[31:12] == 20'h10010) begin 	//Cell 0
		cell_addr <= 1'b0;
	end else if(addr_i[31:12] == 20'h7fffe) begin //Cell 1
		cell_addr <= 1'b1;
	end else begin
		cell_addr <= cell_addr;
	end
	
end


assign data_o = data[cell_addr];	//Selection of the SRAM cell output



/*
parameter RAM_CELLS = 2**10;
genvar i,j;
generate
		for( j=0; j<RAM_CELLS; j++) begin : CELL_1
			for( i=0; i<RAM_CELLS; i++) begin : CELL
				sram_32_1024_freepdk45 CELL (.clk0(clk_i), .csb0(1'b0), .web0(~write_i), .addr0(addr_i[11:2]), .din0(data_i), .dout0(data[i+j*RAM_CELLS]));
			end
		end
endgenerate
*/

endmodule


