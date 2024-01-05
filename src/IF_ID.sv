module IF_ID(
	input clk_i,
	input rst_i,
	input [31:0] pc_i,

	output reg [31:0] pc_o
);

always@(posedge clk_i) begin

	if(rst_i == 0) begin
      pc_o <= 32'b0;
  	end
  	else begin
    	pc_o <= pc_i;
  	end

end

endmodule
