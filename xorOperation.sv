`timescale 1ns/10ps

module xorOperation (a, b, result);
	input logic [63:0] a, b;
	output logic [63:0] result;
	
	genvar i;
	
	generate
		for (i=0; i<64; i++) begin : xorOp
			xor #0.05 (result[i], a[i], b[i]);
		end
	endgenerate
	
endmodule 