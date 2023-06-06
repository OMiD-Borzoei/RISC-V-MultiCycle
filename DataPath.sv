module DataPath(input logic clk, reset,
			// controls signals :
			input logic PCWrite, AdrSrc, IRWrite, 
			input logic [1:0] ResultSrc,
			input logic [3:0] ALUControl,
			input logic [1:0] ALUSrcB, ALUSrcA,
			input logic [3:0] ImmSrc,
			input logic RegWrite, ImmIn,
					
			//memRead is either instr or Data:
			input logic [31:0] ReadData, 
					
			//outputs :
			output logic Zero, Sign,
			output logic [31:0] PC, WD, Adr, instr,
			output logic [31:0] x1, x2, x3, x4, x5, x7, x9,
			output logic [31:0] ALUResult,
			output logic [31:0] Result,
			input logic RegSrc
		);
					
					
			logic [31:0] PCNext;
			assign PCNext = Result;
			
				
			logic [31:0] OldPC, RD1, RD2, ImmExt, A, B,
				     SrcA, SrcB, ALUOut, Data, WD3;
			logic [31:0] DataExt, ExtendIn;
			assign DataExt = ImmExt;
				
			assign WD = B ;
				

				//Pink
/*Register with Enable Pin*/	EnReg PCHolder(clk, reset, PCWrite, PCNext, PC);
				mux2  AdrDeterminer(PC, Result, AdrSrc, Adr);
				
				//Blue
				EnReg instrHolder(clk, reset, IRWrite, ReadData, instr);
				EnReg OldPCHolder(clk, reset, IRWrite, PC, OldPC);
/*Register without EN pin*/	Register DataHolder(clk, reset, ReadData, Data);
				mux2 RegWriteDeterminer(Result, PC, RegSrc, WD3);
				RegFile rf(clk, RegWrite, instr[19:15], instr[24:20], instr[11:7], WD3,
					   RD1, RD2, x1, x2, x3, x4, x5, x7, x9);
				mux2 EXtendInDeterminer(instr, Data, ImmIn, ExtendIn);
				ExtendChip ex(ExtendIn, ImmSrc, ImmExt);
				
				//Green
				Register AHolder(clk, reset, RD1, A);
				Register BHolder(clk, reset, RD2, B);
				mux3 SrcADeterminer(PC, OldPC, A, ALUSrcA, SrcA);
				mux3 srcBDeterminer(B, ImmExt, 32'd4, ALUSrcB, SrcB);
				ALU alu(SrcA, SrcB, ALUControl, ALUResult, Zero, Sign);
				
				//Yellow
				Register ALUOutHolder(clk, reset, ALUResult, ALUOut);
				mux4 res(ALUOut, DataExt, ALUResult, SrcB, ResultSrc, Result);
endmodule 
