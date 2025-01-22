/*
	This module defines a register where a mux is used
	to determine if the 64 bit value in the register
	should be saved or overwritten
*/
`timescale 1ns/10ps

module Reg (clk, wren, datain, dataout);
	input logic clk;
	input logic wren;
	input logic [63:0] datain;
	output logic [63:0] dataout;
	
	// internal wiring
	logic nwr;
	logic [63:0] datanew, dataold, datafinal;
	
	// logic to stabilize wren and inverter for mux
	not #0.05 (nwr, wren);
	
	genvar i;
	
	// each flip flop storing all 64 bits in each register
	generate 
		for(i=0; i<64; i++) begin : eachdata
			and #0.05 (datanew[i], datain[i], wren);
			and #0.05 (dataold[i], dataout[i], nwr);
			or #0.05 (datafinal[i], datanew[i], dataold[i]);
			D_FF dff_thing (dataout[i], datafinal[i], 1'b0, clk);
		end
	endgenerate
			
endmodule // Reg
	
	
	
	
	
	