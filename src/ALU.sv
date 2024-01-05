module ALU 
(
	input [31:0] op1_i, op2_i, 
	input [3:0] alu_ctrl_i, 
	
	output [31:0] data_o,
	output Zero_o
);

wire [31:0] add_2, shift_1, barrel_1, barrel_2, barrel_3, barrel_4, barrel_5;
wire ext_bit;


//Selection of the second operand (op2_i or 4)
assign add_2 = 	(alu_ctrl_i == 4'b0000) ? op2_i :
				(alu_ctrl_i == 4'b0101) ? 32'd4 : 
				 32'd4;

//Inverion of the bits to execute SRAI (right shift)
assign shift_1 = (alu_ctrl_i == 4'b0001) ? op1_i :
				 (alu_ctrl_i == 4'b0010) ? {op1_i[0],op1_i[1],op1_i[2],op1_i[3],op1_i[4],op1_i[5],op1_i[6],op1_i[7],op1_i[8],op1_i[9],op1_i[10],op1_i[11],op1_i[12],op1_i[13],op1_i[14],op1_i[15],op1_i[16],op1_i[17],op1_i[18],op1_i[19],op1_i[20],op1_i[21],op1_i[22],op1_i[23],op1_i[24],op1_i[25],op1_i[26],op1_i[27],op1_i[28],op1_i[29],op1_i[30],op1_i[31]} :
				 op1_i;

//Bit to do sign extension (in case of right shift) or insertion of zeros (in case of left shift)
assign ext_bit = (alu_ctrl_i == 4'b0001) ? 1'b0 :
				 (alu_ctrl_i == 4'b0010) ? op1_i[31] :
				 1'b0;
				 
//Left shift by 1 position
assign barrel_1 = 	(op2_i[0]==1'b1) ? {shift_1[30:0],ext_bit} : 
					{shift_1};
					
//Left shift by 2 position
assign barrel_2 = 	(op2_i[1]==1'b1) ? {barrel_1[29:0],ext_bit,ext_bit} : 
					{barrel_1};
					
//Left shift by 4 position
assign barrel_3 = 	(op2_i[2]==1'b1) ? {barrel_2[27:0],ext_bit,ext_bit,ext_bit,ext_bit} : 
					{barrel_2};
					
//Left shift by 8 position
assign barrel_4 = 	(op2_i[3]==1'b1) ? {barrel_3[23:0],ext_bit,ext_bit,ext_bit,ext_bit,ext_bit,ext_bit,ext_bit,ext_bit} : 
					{barrel_3};
					
//Left shift by 16 position
assign barrel_5 = 	(op2_i[4]==1'b1) ? {barrel_4[15:0],ext_bit,ext_bit,ext_bit,ext_bit,ext_bit,ext_bit,ext_bit,ext_bit,ext_bit,ext_bit,ext_bit,ext_bit,ext_bit,ext_bit,ext_bit,ext_bit} : 
					{barrel_4};
		
//Calculation of the output (addition, left shift, right shift, subtraction, XOR, op2_1)
assign data_o = ((alu_ctrl_i == 4'b0000) || (alu_ctrl_i == 4'b0101)) ? (op1_i + add_2) :
				(alu_ctrl_i == 4'b0001) ? barrel_5 :
				(alu_ctrl_i == 4'b0010) ? {barrel_5[0],barrel_5[1],barrel_5[2],barrel_5[3],barrel_5[4],barrel_5[5],barrel_5[6],barrel_5[7],barrel_5[8],barrel_5[9],barrel_5[10],barrel_5[11],barrel_5[12],barrel_5[13],barrel_5[14],barrel_5[15],barrel_5[16],barrel_5[17],barrel_5[18],barrel_5[19],barrel_5[20],barrel_5[21],barrel_5[22],barrel_5[23],barrel_5[24],barrel_5[25],barrel_5[26],barrel_5[27],barrel_5[28],barrel_5[29],barrel_5[30],barrel_5[31]} :
				(alu_ctrl_i == 4'b0011) ? (op1_i - op2_i) :
				(alu_ctrl_i == 4'b0100) ? (op1_i ^ op2_i) :
				op2_i;

//Calculation of the "zero" bit (for operations: less or equal, not equal)				
assign Zero_o = ((alu_ctrl_i == 4'b0101) || ((alu_ctrl_i == 4'b0111) && (op2_i <= op1_i)) || ((alu_ctrl_i == 4'b1000) && (op1_i != op2_i))) ? 1'b1 :
				1'b0 ;



/*
integer i;
always @(*)begin

	Zero_o = 1'b0;
	
	case(alu_ctrl_i)

		4'b0000, 4'b0101 : begin	//addi, li, mv, add, jal, j, ret, lw, sw
			if(alu_ctrl_i == 4'b0000)
                add_2 = op2_i; 	//addi, li, mv, 
            else if (alu_ctrl_i == 4'b0101) begin
                add_2 = 32'd4;	//jal, j, ret
				Zero_o = 1'b1;
            end
			data_o = op1_i + add_2;
		end
	  
		4'b0001, 4'b0010 : begin	//slli, srai
			if (alu_ctrl_i == 4'b0001) begin
				shift_1 = op1_i; 	//slli
				ext_bit = 1'b0;
			end
			else if (alu_ctrl_i == 4'b0010) begin
				for (i=0; i < 32; i=i+1) begin : reverse
        			shift_1[i] = op1_i[31-i]; //srai, revers orders of bit 
    			end
    			ext_bit = {op1_i[31]};
    		end
    		
    		if(op2_i[0]==1'b1)	
				barrel_1 = {shift_1[30:0],ext_bit};
			else if (op2_i[0]==1'b0) begin
				barrel_1 = {shift_1};
			end

			if(op2_i[1]==1'b1)	
				barrel_2 = {barrel_1[29:0],ext_bit,ext_bit};
			else if (op2_i[1]==1'b0) begin
				barrel_2 = {barrel_1};
			end

			if(op2_i[2]==1'b1)	
				barrel_3 = {barrel_2[27:0],ext_bit,ext_bit,ext_bit,ext_bit};
			else if (op2_i[2]==1'b0) begin
				barrel_3 = {barrel_2};
			end

			if(op2_i[3]==1'b1)	
				barrel_4 = {barrel_3[23:0],ext_bit,ext_bit,ext_bit,ext_bit,ext_bit,ext_bit,ext_bit,ext_bit};
			else if (op2_i[3]==1'b0) begin
				barrel_4 = {barrel_3};
			end

			if(op2_i[4]==1'b1)	
				barrel_5 = {barrel_4[15:0],ext_bit,ext_bit,ext_bit,ext_bit,ext_bit,ext_bit,ext_bit,ext_bit,ext_bit,ext_bit,ext_bit,ext_bit,ext_bit,ext_bit,ext_bit,ext_bit};
			else if (op2_i[4]==1'b0) begin
				barrel_5 = {barrel_4};
			end
			
			if (alu_ctrl_i == 4'b0001) begin
				data_o = barrel_5; 	//slli
			end
			else if (alu_ctrl_i == 4'b0010) begin
				for (i=0; i < 32; i=i+1) begin : reverse2
        			data_o[i] = barrel_5[31-i]; //srai, revers orders of bit 
    			end
    		end
		
		end

		4'b0011 : begin	//sub 
			data_o = op1_i - op2_i;
		end

		4'b0100 : begin	//xor 
			data_o = op1_i ^ op2_i;
		end

		4'b0110 : begin	//lui
			data_o = op2_i;
		end

		4'b0111 : begin	//ble
			if(op2_i <= op1_i)begin
				Zero_o = 1'b1; // ble
			end
		end
		
		4'b1000 : begin	//bne
			if(op1_i != op2_i)begin
				Zero_o = 1'b1;
			end
		end
		
		
		default : begin
			data_o = op2_i;
			Zero_o = 1'b0;
		end
  
	endcase
  
end
*/ 
 
endmodule


