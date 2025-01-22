`timescale 1ns/10ps

module alu(A, B, cntrl, result, negative, zero, overflow, carry_out);
	input logic [63:0] A, B;
	input logic [2:0] cntrl;
	output logic [63:0] result;
	output logic negative, zero, overflow, carry_out;
	
	logic [63:0] addresult;
	logic [63:0] subresult;
	logic [63:0] andresult;
	logic [63:0] orresult;
	logic [63:0] xorresult;
	logic [63:0] bresult;
	logic addover, subover;
	logic addcout, subcout;
	
	logic x1, x2;
	
	addOperation add (A, B, addresult, addover, addcout);
	subOperation sub (A, B, subresult, subover, subcout);
	andOperation aNd (A, B, andresult);
	orOperation oR (A, B, orresult);
	xorOperation xOr (A, B, xorresult);
	
	genvar j;
	
	generate
		for(j=0; j<64; j++) begin : eachBuf
			buf #0.05 (bresult[j], B[j]);
		end
	endgenerate
	
	
	genvar i;
	
	generate
		for(i=0; i<64; i++) begin : eachComp
			mux8to1 mux1 (bresult[i], x1, addresult[i], subresult[i], 
							  andresult[i], orresult[i], xorresult[i], x2, 
							  cntrl, result[i]);
		end
	endgenerate
	
	zero z1 (result, zero);
	
	assign negative = result[63];
	
	mux2to1 mux2 (addover, subover, cntrl[0], overflow);
	mux2to1 mux3 (addcout, subcout, cntrl[0], carry_out);
	
endmodule 