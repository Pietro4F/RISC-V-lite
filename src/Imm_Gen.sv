module Imm_Gen(
    input [2:0] imm_select_i,
    input [24:0] data_i,
    
    output reg [31:0] data_o     
);



assign data_o = (imm_select_i == 3'b000) ? {{20{data_i[24]}},data_i[24:13]} :									//"I" immediate format
				(imm_select_i == 3'b001) ? {{25{data_i[24]}},data_i[24:18],data_i[4:0]} :						//"S" immediate format
				(imm_select_i == 3'b010) ? {{20{data_i[24]}},data_i[24],data_i[0],data_i[23:18],data_i[4:1]} :	//"SB" immediate format 
				(imm_select_i == 3'b011) ? {{data_i[24:5]},12'd0} :												//"U" immediate format
				(imm_select_i == 3'b100) ? {{12{data_i[24]}},data_i[24],data_i[12:5],data_i[13],data_i[23:14]}:	//"UJ" immediate format
				32'd0;


/*
always@(*)begin

  	case(imm_select_i)
  		3'b000 : begin //I
  			data_o = {{20{data_i[24]}},data_i[24:13]};
	  	end
	  	
	  	3'b001 : begin //S
  			data_o = {{25{data_i[24]}},data_i[24:18],data_i[4:0]};
	  	end
	  	
	  	3'b010 : begin //SB
  			//data_o = {{19{data_i[24]}},data_i[24],data_i[0],data_i[23:18],data_i[4:1],1'b0};
  			data_o = {{20{data_i[24]}},data_i[24],data_i[0],data_i[23:18],data_i[4:1]};
	  	end
	  	
	  	3'b011 : begin //U
  			data_o = {{data_i[24:5]},12'd0};
	  	end
	  	
	  	3'b100 : begin //UJ
	  		data_o = {{12{data_i[24]}},data_i[24],data_i[12:5],data_i[13],data_i[23:14]};
  			//data_o = {{11{data_i[24]}},data_i[24],data_i[12:5],data_i[13],data_i[23:14],1'b0};
	  	end
  
	endcase
end
*/

endmodule
