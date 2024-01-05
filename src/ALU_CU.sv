module ALU_CU(
    input [3:0] alu_op_i,
    input [2:0] funct_3_i,
    input [6:0] funct_7_i,

    output [3:0] alu_ctrl_o
);


assign alu_ctrl_o = (alu_op_i == 3'b000) ? (						//ADD, SUB
                    	(funct_3_i == 3'b000) ? (
		                    (funct_7_i == 7'b0000000) ? 4'b0000 :	//ADD
		                    (funct_7_i == 7'b0100000) ? 4'b0011 :	//SUB
		                    4'b0000
		                ) :
		                (funct_3_i == 3'b100) ? 4'b0100 :			//XOR
		                4'b0000
                	) :
		            (alu_op_i == 3'b001) ? 4'b0110 :				//LUI
		            (alu_op_i == 3'b010) ? (						//BLE, BNE
		                (funct_3_i ==3'b101) ? 4'b0111 :			//BLE
		                (funct_3_i == 3'b001) ? 4'b1000 :			//BNE
		                4'b0000
		            ) :
		            (alu_op_i == 3'b011) ? 4'b0101 :				//JAL, J, RET
		            (alu_op_i == 3'b100) ? 4'b0000 :				//AUIPC
					(alu_op_i == 3'b101) ? (						//ADDI, LI, MV, SLLI, SRAI
						(funct_3_i == 3'b000) ? 4'b0000 :			//ADDI, LI, MV
						(funct_3_i == 3'b001) ? 4'b0001 :			//SLLI
						(funct_3_i == 3'b101) ? 4'b0010 :			//SRAI
						4'b0000
					) :
					(alu_op_i == 3'b110) ? 4'b0000 :				//LW, SW
					4'b0000;


/*
always@(*)begin

  case(alu_op_i)

    3'b000 : begin
        case(funct_3_i)
            3'b000 : begin
                if(funct_7_i == 7'b0000000)
                    alu_ctrl_o = 4'b0000;//add
                else if (funct_7_i == 7'b0100000) begin
                    alu_ctrl_o = 4'b0011;//sub
                end
            end

            3'b100 : begin
                alu_ctrl_o = 4'b0100;//xor
            end

            default : begin
                alu_ctrl_o = 4'b0000;//default
            end
        endcase
    end

    3'b001 : begin
        alu_ctrl_o = 4'b0110;//lui
    end

    3'b010 : begin
        if(funct_3_i ==3'b101)
            alu_ctrl_o = 4'b0111;//ble
        else if (funct_3_i == 3'b001) begin
            alu_ctrl_o = 4'b1000;//bne
        end
    end

    3'b011 : begin
        alu_ctrl_o = 4'b0101;//jal, j, ret
    end

    3'b100 : begin
        alu_ctrl_o = 4'b0000;//auipc
    end

    3'b101 : begin
    	case(funct_3_i)
    		3'b000 : begin
                alu_ctrl_o = 4'b0000;//addi, li, mv
            end
    	
        	3'b001 : begin
                alu_ctrl_o = 4'b0001;//slli
            end

            3'b101 : begin
                alu_ctrl_o = 4'b0010;//srai
            end
        endcase
    end

    3'b110 : begin
        alu_ctrl_o = 4'b0000;//lw, sw
    end

    default : begin
        alu_ctrl_o = 4'b0000;//default
    end

    
  endcase

end
*/

endmodule
