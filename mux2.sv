module mux2(
	input logic [31:0] c0, c1,
	input logic cntrl, 
	output logic [31:0] chosen
);
	assign chosen = cntrl ? c1 : c0 ;
endmodule 

