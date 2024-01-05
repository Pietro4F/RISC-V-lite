module Adder
(
    input [31:0] op1_i, op2_i,
    
    output [31:0] data_o
);


assign data_o = op1_i + op2_i;

endmodule
