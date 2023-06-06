module EnReg #(parameter N=32)(
	input logic clk, reset, en,
	input logic [N:1] d,
	output logic [N:1] q
);			
	always_ff @(posedge clk)
		if(reset)	q<=0;
		else if(en) 	q<=d;
endmodule 

