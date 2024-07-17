module RegDataIn_mux #(parameter D=8)(
  input       [ D-1:0] ALU_rslt,	   
					Mem_rslt,
					immed,
  input			[1:0] MemtoReg,
  output logic[D-1:0] dat_in
			);

 

  always_comb case(MemtoReg)
    2'b00: dat_in = ALU_rslt;   // Using ALU_rslt as data_in
	2'b01: dat_in = Mem_rslt;   // Using Mem_rslt as data_in
	2'b10: dat_in = immed;
	default: dat_in = ALU_rslt;  
  endcase
endmodule