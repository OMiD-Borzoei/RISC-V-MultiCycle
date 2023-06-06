module ALU_test();
	logic [31:0] A, B;
	logic [3:0]  Op;
	logic [31:0] result;
	logic Zero, Sign;


	ALU dut(A, B, Op, result, Zero, Sign);


	initial begin

	A = -10;
	B = 2;
	Op = 9;



	end
endmodule
