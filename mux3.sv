module mux3(
	input logic [31:0] c0, c1, c2,
	input logic [1:0] cntrl,
	output logic [31:0] chosen
);		
assign chosen = cntrl[1] ? c2 : cntrl[0] ? c1 : c0 ;		
endmodule

 