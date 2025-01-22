`timescale 1ns/10ps

module decoder2to4 (regwrite, wraddr, wren);
	input logic regwrite;
	input logic [1:0] wraddr;
	output logic [3:0] wren;
	
	// internal wires
	logic [1:0] nwa;
	
	// inverter logic
	not #0.05 (nwa[0], wraddr[0]);
	not #0.05 (nwa[1], wraddr[1]);
	
	// 2to4 decoder where 2 bit address is converted 
	// to 4 bit value
	and #0.05 (wren[0], nwa[1], nwa[0], regwrite);
	and #0.05 (wren[1], nwa[1], wraddr[0], regwrite);
	and #0.05 (wren[2], wraddr[1], nwa[0], regwrite);
	and #0.05 (wren[3], wraddr[1], wraddr[0], regwrite);

endmodule // decoder 2to4