module mem(
		input logic clk, we,
		input logic [31:0] Adr, WD,
		output logic [31:0] RD,
		input logic [1:0] Mode
		);
		
  logic [31:0] RAM[63:0];
  
  initial
	//$readmemh("riscvtest.txt",RAM);
	//$readmemh("NewInstrucitons.txt",RAM);
	//$readmemh("Shift_Instructions_Assembly.txt",RAM);
	//$readmemh("jalr_instruciton.txt",RAM);
	//$readmemh("LUI_instructions.txt",RAM);
	//$readmemh("Unsigned_Vol1.txt",RAM);
	//$readmemh("lb-instructions.txt",RAM);
	  $readmemh("sb.txt",RAM);

	

  assign RD = RAM[Adr[31:2]]; // word aligned

  always_ff @(posedge clk)
    //if(we) RAM[Adr[31:2]] <= WD; 
    if (we) case(Mode)
		2'b01: if(Adr[1]==0) RAM[Adr[31:2]][15:0] <= WD[15:0]; //half
		       else	     RAM[Adr[31:2]][31:16]<= WD[15:0]; 
		2'b10: case(Adr[1:0])
			2'b00: RAM[Adr[31:2]][7:0] <= WD[7:0]; //byte
			2'b01: RAM[Adr[31:2]][15:8] <= WD[7:0];
			2'b10: RAM[Adr[31:2]][23:16] <= WD[7:0];
			2'b11: RAM[Adr[31:2]][31:24] <= WD[7:0];
			endcase
		default: RAM[Adr[31:2]] <= WD;
		endcase
	
endmodule 