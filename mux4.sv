module mux4(
	input logic [31:0] c0, c1, c2, c3,
	input logic [1:0] cntrl,
	output logic [31:0] chosen
);		
assign chosen = cntrl[1] ? (cntrl[0] ? c3 : c2) : (cntrl[0] ? c1 : c0);		
endmodule
