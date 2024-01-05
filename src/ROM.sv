module ROM(	
		input clk_i,
		input [31:0] addr_i,

		output reg [31:0] data_o
);


parameter RAM_CELLS = 16;
wire [31:0] data [RAM_CELLS-1:0] ;
reg [3:0] cell_addr;
reg [RAM_CELLS-1:0] cs;

genvar i;

generate
	for( i=0; i<RAM_CELLS; i++) begin : CELL
		sram_32_1024_freepdk45 CELL (.clk0(clk_i), .csb0(cs[i]), .web0(1'b1), .addr0(addr_i[11:2]), .din0(32'd0), .dout0(data[i]));
	end
endgenerate


always @(addr_i) begin		//Selection of the SRAM cell to read

	cs <= ~0;
	cs[addr_i[15:12]] <= 1'b0;

end


always @(posedge clk_i) begin	//Storing of the SRAM cell previously selected

	cell_addr <= addr_i[15:12];
	
end

assign data_o = data[cell_addr];	//Selection of the SRAM cell output


/*
always @(*) begin

	if(rst_i == 0) begin 
	
		data_o <= 32'd0;
		cell_addr <= 4'd0;
	
		
	end else begin
		//cs <= ~0;
	
		if(addr_i[31:16] == 16'h0040) begin
			//cs[addr_i[15:12]] <= 1'b0;
			cell_addr <= addr_i[15:12];
		end 
	
		data_o <= data[cell_addr];
	end

end
*/

endmodule

