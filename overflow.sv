`timescale 1ns/10ps

module overflow (cin, cout, isOverflow);
	input logic cin, cout;
	output logic isOverflow;
	
	xor #0.05 (isOverflow, cin, cout);

endmodule 