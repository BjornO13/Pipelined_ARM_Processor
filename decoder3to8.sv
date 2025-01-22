`timescale 1ns/10ps

module decoder3to8 (regwrite, wraddr, wren);
	input logic regwrite;
	input logic [2:0] wraddr;
	output logic [7:0] wren;
	
	//internal inverted address
	logic [2:0] nwa;
	
	// inverter logic
	not #0.05 (nwa[0], wraddr[0]);
	not #0.05 (nwa[1], wraddr[1]);
	not #0.05 (nwa[2], wraddr[2]);
	
	// output logic
	and #0.05 (wren[0], nwa[2], nwa[1], nwa[0], regwrite);
	and #0.05 (wren[1], nwa[2], nwa[1], wraddr[0], regwrite);
	and #0.05 (wren[2], nwa[2], wraddr[1], nwa[0], regwrite);
	and #0.05 (wren[3], nwa[2], wraddr[1], wraddr[0], regwrite);
	and #0.05 (wren[4], wraddr[2], nwa[1], nwa[0], regwrite);
	and #0.05 (wren[5], wraddr[2], nwa[1], wraddr[0], regwrite);
	and #0.05 (wren[6], wraddr[2], wraddr[1], nwa[0], regwrite);
	and #0.05 (wren[7], wraddr[2], wraddr[1], wraddr[0], regwrite);
	
endmodule // decoder3to8