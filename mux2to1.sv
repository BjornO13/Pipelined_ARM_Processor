`timescale 1ns/10ps

module mux2to1 (data1, data2, readreg, dataout);
	input logic data1, data2;
	input logic readreg;
	output dataout;
	
	// internal wiring
	logic notreadreg;
	logic a, b;
	
	// internal 2to1 mux structure
	not #0.05 (notreadreg, readreg);
	and #0.05 (a, notreadreg, data1);
	and #0.05 (b, readreg, data2);
	or #0.05 (dataout, a, b);

endmodule // mux2to1