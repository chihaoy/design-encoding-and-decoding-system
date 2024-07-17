module Target_mux #(parameter D=12)(
  input       [ D-1:0] offset_target,	 //directly from $b  
					entry_target,//get from lookup table
  input			absjump_en,
  output logic[D-1:0] target);

 

  always_comb case(absjump_en)
    0: target = offset_target;   // go back 5 spaces
	1: target = entry_target;   //abs jump value
	
	default: target = 'b0;  // hold PC  
  endcase
endmodule


/*
2：1 mux, decides the target of PC
*/