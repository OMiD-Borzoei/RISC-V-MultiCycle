module ALU(
	input logic signed [31:0] A, B,
	input logic [3:0]  Op,
	output logic [31:0] result,
	output logic Zero, Sign
);
	always @(A, B, Op)
		case(Op)
			4'b0000 : result = A + B ;	//0
			4'b0001 : result = A - B ; 	//1
			4'b0101 : result = A < B ? 1 : 0 ; //5
			4'b0011 : result = A | B ; 	//3
			4'b0010 : result = A & B ;	//2
		/*XOR*/	4'b0100 : result = A ^ B ;	//4
		/*SLL*/	4'b0110 : result = A << B;	//6
		/*SLA*/ 4'b0111 : result = A <<< B;	//7
		/*SRL*/ 4'b1000 : result = A >> B;	//8
		/*SRA*/ 4'b1001 : result = A >>> B;	//9
		/*SLTU*/4'b1010 : result = $unsigned(A) < $unsigned(B) ? 1 : 0;
		/*bltu*/4'b1011 : result = $unsigned(A) < $unsigned(B) ? -1 : 0;
					// To control the sign signal
			default : result = 32'b0 ;
		endcase
	assign Zero = &(~result) ;
	assign Sign = result[31] ;		
endmodule 



