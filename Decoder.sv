/* 
	This module uses 1 2to4 and 4 3to8 decoders to create a 
	5to32 bit decoder. The 2to4 uses the 2 most significant
	bits to select which 3to8 decoder to use, then the 3to8
	will output the corresponding 8 bit value with concatenated
	0s on each side for a 32 bit final value
*/
`timescale 1ns/10ps

module Decoder (regwrite, wraddr, wren);
	input logic regwrite;
	input logic [4:0] wraddr;
	output logic [31:0] wren;
	
	logic [3:0] enables;
	
	// selector decoder for most significant bits
	decoder2to4 dec1 (regwrite, wraddr[4:3], enables);
	
	// section decoders for each 8 potential output write enables
	decoder3to8 findec1 (enables[0], wraddr[2:0], wren[7:0]);
	decoder3to8 findec2 (enables[1], wraddr[2:0], wren[15:8]);
	decoder3to8 findec3 (enables[2], wraddr[2:0], wren[23:16]);
	decoder3to8 findec4 (enables[3], wraddr[2:0], wren[31:24]);
	
endmodule // Decoder
	
	
	
	
	
	