// sample top level design
module top_level(
  input        clk,  req,//treat req as reset
  output logic done);
  parameter D = 12,             // program counter width
    A = 6;             		  // ALU command bit width
  wire[D-1:0] target, 			  // jump 
              prog_ctr,
				  entry_target;
  wire        RegWrite;
  logic[7:0]   datA,datB,		  // from RegFile
              muxB, 
				  ALU_rslt,               // alu output
              immed,
				  b,
				  k,
				  dat_in,
				  mem_rslt;
  logic sc_in,   				  // shift/carry out from/to ALU
   		pariQ,              	  // registered parity flag from ALU
		zeroQ;                    // registered zero flag from ALU 
  wire  branch;                     // from control to PC; relative jump enable
  wire  pari,
        jump_flag,
		sc_clr,
		sc_en,
        MemWrite;		              // immediate switch
  wire[1:0] MemtoReg;
  wire[1:0] ALUSrc;
  wire[5:0] ALUOp;
  wire[A-1:0] alu_cmd;
  wire[8:0]   mach_code;          // machine code
  wire[2:0] rd_addrA, rd_addrB;    // address pointers to reg_file
  assign rd_addrB = mach_code[2:0];
  assign rd_addrA = mach_code[5:3];
  assign alu_cmd  = {mach_code[8:6],mach_code[2:0]};
  assign immed   = {5'b00000, mach_code[2:0]};
			
// fetch subassembly
  PC #(.D(D)) 					  // D sets program counter width
     pc1 ( .reset(req),          
         .clk              ,
			.branch(branch),
			.jump_flag(jump_flag),
		 .absjump_en (absj),
		 .target(target)           ,
		 .prog_ctr(prog_ctr)          );

// lookup table to facilitate jumps/branches
  PC_LUT #(.D(D))
    pl1 (.addr  (b),
         .target(entry_target)          );   
			
// PC target source control
  Target_mux #(.D(12))//something I change but not sure of
    pl2 (.offset_target ({4'b0000,b}),
         .entry_target(entry_target),
			.absjump_en(absj),
			.target(target));   


// contains machine code
  instr_ROM ir1(.prog_ctr,
               .mach_code);

// control decoder
	
  Control ctl1(.instr({mach_code[8:6],mach_code[2:0]}), 
  .Branch  	(branch)  , 
  .MemWrite , 
  .ALUSrc(ALUSrc)   , 
  .RegWrite   ,     
  .MemtoReg	(MemtoReg),
  .ALUOp,
  .absj		(absj));

  	
  RegDataIn_mux MemToReg_mux(.ALU_rslt(ALU_rslt),
  .Mem_rslt  (mem_rslt), 
  .immed		 (muxB),
  .MemtoReg  (MemtoReg)  , 
  .dat_in	 (dat_in) );
  
  
  reg_file #(.pw(2)) rf1(.dat_in(dat_in),	   // loads, most ops
              .clk         ,
              .wr_en   (RegWrite),
              .rd_addrA(rd_addrA),
              .rd_addrB(rd_addrB),
              .wr_addr (rd_addrA),      // in place operation//change rd_addA to rd_addB?
              .datA_out(datA),//output
              .datB_out(datB),
				  .b(b),
				  .k(k)); 
  always_comb begin
		if(ALUSrc == 2'b00)
			muxB = datB;
		else if (ALUSrc == 2'b01)
			muxB = immed;
		else
			muxB = k;
  end

			
//  Middle_mux middle_mux(.datB(ALU_rslt),
//  .k  		(mem_rslt), 
//  .immed  	(MemtoReg)  , 
//  .ALUsrc	(dat_in) ,
//  .out		());			
			
			

  alu alu1(.alu_cmd(ALUOp),
         .inA    (datA),//input
		 .inB    (muxB),
		 .sc_i   (sc),   // output from sc register
		 .rslt(ALU_rslt)      ,
		 .sc_o   (sc_o), // input to sc register
		 .pari ,
		 .jump_flag(jump_flag) );  

  dat_mem dm1(.dat_in(datA)  ,  // from reg_file
             .clk           ,
			 .wr_en  (MemWrite), // stores
			 .addr   (datB),//input
             .dat_out(mem_rslt));

// registered flags from ALU
  always_ff @(posedge clk) begin
    pariQ <= pari;
	zeroQ <= jump_flag;
    if(sc_clr)
	  sc_in <= 'b0;
    else if(sc_en)
      sc_in <= sc_o;
  end

  assign done = prog_ctr == 450;
 
endmodule