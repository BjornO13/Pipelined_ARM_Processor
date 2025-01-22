`timescale 1ns/10ps

module addOperation (a, b, sum, overflow, cout);
	input logic [63:0] a, b;
	output logic [63:0] sum;
	output logic overflow;
	output logic cout;
	
	logic [63:0] currCout;
	
	// for a0, b0
	fullAdder add0 (a[0], b[0], 0, currCout[0], sum[0]);
	
	genvar i;
	
	generate
		for(i=1; i<64; i=i+1) begin : addEachBit
			fullAdder add1 (a[i], b[i], currCout[i-1], currCout[i], sum[i]);
		end
	endgenerate
	
	// check for overflow
	overflow msbOverflow (currCout[62], currCout[63], overflow);
	
	// set cout equal to currCout[63]
	or #0.05 (cout, currCout[63], 1'b0);
	
endmodule
