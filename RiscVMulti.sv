module RiscVMulti(
			input logic clk, reset,
			input logic [31:0] ReadData,
			output logic [31:0] WriteData,
			Address, PC,
			
			//controller outputs:
			output logic Zero, Sign, AdrSrc, IRWrite, PCWrite, RegWrite, MemWrite,
			output logic [3:0] ImmSrc,
			output logic [1:0] ALUSrcA, ALUSrcB, ResultSrc,
			output logic [3:0] ALUControl,
			
			//Dp outputs:
			output logic [31:0] ALUResult, Result, x1, x2, x3, x4, x5, x7, x9, instr,
			output logic RegSrc, ImmIn,
			output logic [1:0] MemMode
		);

			controller Head(clk, reset, instr[6:0], instr[14:12], instr[30], Zero, Sign, ImmSrc, ALUSrcA, ALUSrcB,
					ResultSrc, AdrSrc, ALUControl, IRWrite, PCWrite, RegWrite, MemWrite, RegSrc, ImmIn, MemMode);
			
			DataPath Worker(clk, reset, PCWrite, AdrSrc, IRWrite, ResultSrc, ALUControl, ALUSrcB, ALUSrcA, ImmSrc,
					RegWrite, ImmIn, ReadData, Zero, Sign, PC, WriteData, Address, instr, x1, x2, x3, x4, x5, x7, x9,
					ALUResult, Result, RegSrc);

endmodule
