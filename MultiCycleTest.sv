module MultiCycleTest();

			logic clk, reset;
			logic [31:0] ReadData,
			WriteData, Address, PC;
			logic MemWrite;
			
			//controller outputs:
			/*logic Zero, Sign, AdrSrc, IRWrite, PCWrite, RegWrite, MemWrite;
			logic [1:0] ALUSrcA, ALUSrcB, ResultSrc;
			logic [3:0] ImmSrc;
			logic [3:0] ALUControl;
			
			
			//Dp outputs:
			logic [31:0] ALUResult, Result, x1, x2, x3, x4, x5, x7, x9, instr;
			logic RegSrc, ImmIn;*/

			MultiCycle dut(clk, reset, ReadData, WriteData, Address, PC, MemWrite);

			initial begin
				clk = 0;
				reset = 1;
				#10;
				reset = 0;
			end



			always #5 clk = ~clk ;




endmodule 

			
			

