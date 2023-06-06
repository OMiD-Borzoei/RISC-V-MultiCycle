module RegFile(
	input logic clk, WE3, 
	input logic [4:0] A1, A2, A3, 
	input logic [31:0] WD3,
	output logic [31:0] RD1, RD2,
	output logic [31:0] x1, x2, x3,
	 x4, x5, x7, x9
);
	reg [31:0] regs[31:0];
	
	// Zero register	
	initial regs[0] = 0 ; 

	always @(posedge clk)
		if(WE3)	regs[A3] <= WD3 ;
			
	assign RD1 = regs[A1] ;
	assign RD2 = regs[A2] ;
	
	// Monitored registers :
	assign x1 = regs[1] ;
	assign x2 = regs[2] ;
	assign x3 = regs[3] ;
	assign x4 = regs[4] ;
	assign x5 = regs[5] ;
	assign x7 = regs[7] ;
	assign x9 = regs[9] ;		
endmodule 

