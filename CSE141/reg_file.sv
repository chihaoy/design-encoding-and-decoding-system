// cache memory/register file
// default address pointer width = 3, for 8 registars
module reg_file #(parameter pw=2)( 
  input[7:0] dat_in,
  input      clk,
  input      wr_en,           // write enable
  input[pw:0] wr_addr,		  // write address pointer      //which registar to write???
              rd_addrA,		  // read address pointers
			  rd_addrB,
			  
  output logic[7:0] datA_out, // read data
                    datB_out,
						  k,b);

  logic[7:0] core[2**(pw+1)];    // 2-dim array  8 wide  16 deep   //core store the value of each registar

// reads are combinational
  assign datA_out = core[rd_addrA];
  assign datB_out = core[rd_addrB];
  assign k = core[3'b000];
  assign b = core[3'b001];

// writes are sequential (clocked)
  always_ff @(posedge clk)
    if(wr_en)				   // anything but stores or no ops
      core[wr_addr] = dat_in; 
//datA_out = core[rd_addrA] and core[wr_addr] = dat_in conflict
endmodule
/*
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
*/