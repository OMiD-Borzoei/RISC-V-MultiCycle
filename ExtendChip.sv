module ExtendChip(
	input logic [31:0] in,
	input logic [3:0]  ImmSrc,
	output logic [31:0] ImmExt
);				
	always @(in, ImmSrc)
		case(ImmSrc)
		   4'b0000 : ImmExt = {{20{in[31]}}, in[31:20]} ; // I-type
		   4'b0001 : ImmExt = {{20{in[31]}}, in[31:25], in[11:7]} ; // S-type
		   4'b0010 : ImmExt = {{20{in[31]}}, in[7], in[30:25], in[11:8], 1'b0} ; //B-type
		   4'b0011 : ImmExt = {{12{in[31]}}, in[19:12], in[20], in[30:21], 1'b0} ; // J-type
		   4'b0100 : ImmExt = {27'b0, in[24:20]} ; // I-type (Shift Instructions)
		   4'b0101 : ImmExt = {in[31:12], 12'b0} ; // U-type
		   4'b0110 : ImmExt = {16'b0, in[15:0]};  //lhu
		   4'b0111 : ImmExt = {24'b0, in[7:0]};   //lbu
		   4'b1000 : ImmExt = {{16{in[15]}}, in[15:0]}; //lh
		   4'b1001 : ImmExt = {{24{in[7]}}, in[7:0]}; //lb
		   default : ImmExt = in; //lw
		endcase				
endmodule




  