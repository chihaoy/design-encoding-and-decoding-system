//module Middle_mux #(parameter D=8)(
//  input       [ D-1:0] datB,	 //  
//					k,//
//					immed
//  input			ALUsrc,
//  output logic[D-1:0] out);
//
// 
//
//  always_comb case(immed)
//    0: out = datB;   // go back 5 spaces
//	1: out = immed;   //abs jump value
//	2: out = k;   //abs jump value
//	default: target = 'b0;  // hold PC  
//  endcase
//endmodule


/*
2：1 mux, decides the target of PC
*/