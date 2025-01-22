`timescale 1ns/10ps

module subOperation (a, b, sum, overflow, cout);
	input logic [63:0] a, b;
	output logic [63:0] sum;
	output logic overflow;
	output logic cout;
	
	logic [63:0] currCout;
	logic [63:0] bInverted;
	
	genvar j;
	
	generate 
		for(j=0; j<64; j++) begin : eachInvert
			not #0.05 (bInverted[j], b[j]);
		end
	endgenerate
	
	fullAdder add0 (a[0], bInverted[0], 1, currCout[0], sum[0]);
	
	genvar i;
	
	generate
		for(i=1; i<64; i=i+1) begin : addEachBit
			fullAdder add1 (a[i], bInverted[i], currCout[i-1], currCout[i], sum[i]);
		end
	endgenerate
	
	// check for overflow
	overflow msbOverflow (currCout[62], currCout[63], overflow);
	
	// set cout equal to currCout[63]
	or #0.05 (cout, currCout[63], 1'b0);
	
endmodule 