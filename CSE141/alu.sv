// combinational -- no clock
// sample -- change as desired
module alu(
  input[5:0] alu_cmd,    // ALU instructions
  input[7:0] inA, inB,	 // 8-bit wide data path
  
  input      sc_i,       // shift_carry in
  output logic[7:0] rslt,
  output logic sc_o,     // shift_carry out
               pari,     // reduction XOR (output)
			   jump_flag      // NOR (output) //zeros = 1 means jump 
);

always_comb begin 
  rslt = 'b0;            
  sc_o = 'b0;    
  jump_flag = 'b0;
  pari = ^rslt;
  
  case(alu_cmd)
    6'b000000: // left shift
      //inB is two bit represents the number of shifts
		
		case(inB)//{rslt[7:7-inB],rslt[6-cons:0]} = {'0,inA[7:cons+1]};
		   
			8'b00000000:{rslt[7:1],rslt[0]} = {inA[6:0],'0};
			8'b00000001:begin
				rslt[7:2] = inA[5:0];
				rslt[1:0] = 2'b0;
				//{rslt[7:2],rslt[1:0]} = {inA[5:0],'0};
			end
			8'b00000010:
			begin
				rslt[7:3] = inA[4:0];
				rslt[2:0] = '0;
			end
				//{rslt[7:3],rslt[2:0]} = {inA[4:0],'0};
			default:
			begin
			rslt[7:4] = inA[3:0];
			rslt[3:0] = '0;
			end
			//{rslt[7:4],rslt[3:0]} = {inA[3:0],'0};
		endcase
		
			
			

	  6'b000100: // right shift
      //inB is two bit represents the number of shifts rslt[7:5
		case(inB)//{rslt[7:7-inB],rslt[6-cons:0]} = {'0,inA[7:cons+1]};
			8'b00000100:{rslt[7:7],rslt[6:0]} = {'0,inA[7:1]};
			8'b00000101:begin
			rslt[7:7-1] = '0;
			rslt[6-1:0] = inA[7:1+1];
			end
			//{rslt[7:7-1],rslt[6-1:0]} = {'0,inA[7:1+1]};
			8'b00000110:
			begin
				rslt[7:7-2] = '0;
				rslt[6-2:0] = inA[7:1+2];
			end
			//{rslt[7:7-2],rslt[6-2:0]} = {'0,inA[7:1+2]};
			default: begin
			rslt[7:4] = '0;
			rslt[3:0] = inA[7:4];
			end
			//{rslt[7:7-3],rslt[6-3:0]} = {'0,inA[7:1+3]};
		endcase
		 
	6'b001000: begin// xor
	  rslt = inA ^ inB;
	  jump_flag = rslt;
	end
    6'b001001: // and
	  rslt = inA & inB;
    6'b001010: //add
	  rslt = inA + inB;
	6'b001011: // sub
	  rslt = inA - inB;
	6'b011000: begin// eq using exclusive or and using zero
	  rslt = inA ^ inB;
	  jump_flag = !rslt;
	end
	6'b011010: begin// eq using exclusive or and using zero
	  rslt = inA ^ inB;
	  jump_flag = !rslt;
	end
	6'b011001: begin // lt if less than then rslt = 1 otherwise zero
	  rslt = (inA < inB)?1:0;
	  jump_flag = rslt;
   end
	6'b011011: begin// lt if less than then rslt = 1 otherwise zero
	  rslt = (inA < inB)?1:0;
	  jump_flag = rslt;
	end
	6'b011100:begin	//not equal means at least one bit in rslt will be 1,  zero = 1 otherwise zeros = 0
	   rslt = inA ^ inB;
		jump_flag = !rslt;
		jump_flag = ~jump_flag;
	end
	6'b011101: begin //not equal means at least one bit in rslt will be 1,  zero = 1 otherwise zeros = 0
	   rslt = inA ^ inB;
		jump_flag = !rslt;
		jump_flag = ~jump_flag;
	end
		//zero = !rslt;
	6'b011110: begin //not equal means at least one bit in rslt will be 1,  zero = 1 otherwise zeros = 0
	   rslt = inA ^ inB;
		jump_flag = !rslt;
		jump_flag = ~jump_flag;
	end
	6'b111000: begin //not used
	   rslt = {7'b0000000,^inA};
	end
	default:
		rslt = 8'b00000000;//need to change
  endcase
end
   
endmodule