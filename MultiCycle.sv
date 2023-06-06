module MultiCycle(
			input logic clk, reset,
			output logic [31:0] ReadData,
			WriteData, Address, PC,
			output logic MemWrite
			);
			
			//controller outputs:
			logic Zero, Sign, AdrSrc, IRWrite, PCWrite, RegWrite;
			logic [3:0] ImmSrc;
			logic [1:0] ALUSrcA, ALUSrcB, ResultSrc;
			logic [3:0] ALUControl;
			
			//Dp outputs:
			logic [31:0] ALUResult, Result, x1, x2, x3, x4, x5, x7, x9, instr;
			logic RegSrc, ImmIn;
			logic [1:0] MemMode;
			
			RiscVMulti CPU(clk, reset, ReadData, WriteData, Address, PC, Zero, Sign, AdrSrc, IRWrite,	
				   PCWrite, RegWrite, MemWrite, ImmSrc, ALUSrcA, ALUSrcB, ResultSrc, ALUControl,
				   ALUResult, Result, x1, x2, x3, x4, x5, x7, x9, instr, RegSrc, ImmIn, MemMode);
			
			mem Mem(clk, MemWrite, Address, WriteData, ReadData, MemMode);

endmodule 