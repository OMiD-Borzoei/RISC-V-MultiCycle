module testbench2();

  logic        clk;
  logic        reset;
  
  logic  [6:0] op;
  logic [2:0] funct3;
  logic       funct7b5;
  logic       Zero;


  logic [1:0] ImmSrc;
  logic [1:0] ALUSrcA, ALUSrcB;
  logic [1:0] ResultSrc;
  logic       AdrSrc;
  logic [2:0] ALUControl;
  logic       IRWrite, PCWrite;
  logic       RegWrite, MemWrite;
  


  // instantiate device to be tested
  controller uut(clk, reset, op, funct3, funct7b5, Zero,
                 ImmSrc, ALUSrcA, ALUSrcB, ResultSrc, AdrSrc, ALUControl, IRWrite, PCWrite, RegWrite, MemWrite);
  
  // generate clock
  always 
    begin
      clk = 1; #5; clk = 0; #5;
    end

	initial begin
		reset = 1;
		#20;
		reset = 0;

		op = 7'b0000011;
		#50;
		op = 7'b0110011;
		funct3 = 3'b000;	
		funct7b5 = 1'b0;
		#50;
		funct7b5 = 1'b1;
		#50;
		funct3 = 3'b010;	




	end
endmodule