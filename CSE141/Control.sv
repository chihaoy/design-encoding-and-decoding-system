// control decoder
module Control #(parameter opwidth = 6, mcodebits = 6)(
  input [mcodebits-1:0] instr,    // subset of machine code (any width you need)
  output logic Branch, 
     MemWrite, RegWrite,//delete ALUsrc here since there is duplicate
	  absj,
  output	logic[1:0] ALUSrc,				// ALUsrc is a 2 bits number 0: use datB; 1: use immediate; 2: use $k
							MemtoReg,			
  output logic[opwidth-1:0] ALUOp);	   // for up to 8 ALU operations

always_comb begin
// defaults
  Branch 	=   'b0;   // 1: branch (jump)
  MemWrite  =	'b0;   // 1: store to memory
  ALUSrc 	=	2'b00;   //0: use datB; 1: use immediate; 2: use $k
  RegWrite  =	'b0;   // 0: for store or no op  1: most other operations 
  MemtoReg  =	'b0;   // 1: load -- route memory instead of ALU to reg_file data in
  absj = 'b0;
  ALUOp	    =   instr; // y = a+0;
// sample values only -- use what you need
case(instr[5:3])    // override defaults with exceptions
  'b000: begin //sh
		Branch 	=   'b0;   
		MemWrite  =	'b0;   
		ALUSrc 	=	2'b01;   
		RegWrite  =	'b1;   
		MemtoReg  =	'b0;   
		ALUOp = {3'b000,instr[2],2'b00};
	end
  'b001: begin //op
		Branch 	=   'b0;   
		MemWrite  =	'b0;   
		ALUSrc 	=	2'b10;//use $k   
		RegWrite  =	'b1;   
		MemtoReg  =	'b0;   
		ALUOp = instr;
	end
	'b010: begin //li
		Branch 	=   'b0;   
		MemWrite  =	'b0;   
		ALUSrc 	=	2'b01;  //decide muxB 
		RegWrite  =	'b1; //put it into data_mem to decide whether to write or not  and it is write_en
		MemtoReg  =	2'b10;   
		ALUOp = 6'b1111;
	end
	'b011: begin //b
		case (instr[2:0]) 
			3'b000:absj = 'b1;
			3'b001:absj = 'b1;
			3'b010:absj = 'b0;
			3'b011:absj = 'b0;
			3'b100:absj = 'b1;
			3'b101:absj = 'b0;
			3'b110:absj = 'b0;
		endcase
		
		Branch 	=   'b1;   
		MemWrite  =	'b0;   
		ALUSrc 	=	2'b10;   
		RegWrite  =	'b0;   
		MemtoReg  =	2'b00;   
		ALUOp = instr;
	end
	'b100: begin //mov
		Branch 	=   'b0;   
		MemWrite  =	'b0;   
		ALUSrc 	=	2'b00;   
		RegWrite  =	'b1;   
		MemtoReg  =	2'b10;   
		ALUOp = 6'b111111;
	end
	'b101: begin //lb
		Branch 	=   'b0;   
		MemWrite  =	'b0;   
		ALUSrc 	=	2'b00;   
		RegWrite  =	'b1;   
		MemtoReg  =	2'b01;   
		ALUOp = 6'b111111;
	end
	'b110: begin //sb
		Branch 	=   'b0;   
		MemWrite  =	'b1;   
		ALUSrc 	=	2'b00;   
		RegWrite  =	'b0;   
		MemtoReg  =	2'b00;   
		ALUOp = 6'b111111;
	end
	'b111: begin //par
		Branch 	=   'b0;   
		MemWrite  =	'b0;   
		ALUSrc 	=	2'b00;   
		RegWrite  =	'b1;   
		MemtoReg  =	2'b00;   
		ALUOp = 6'b111000;
	end
	default:;
endcase

end
	
endmodule