/*
	This module uses 2to1 muxes to create a large 32to1 mux
	this module specifically takes one bit of every register 
	and the wanted address to get the correct value. This is
	copied 64 times for each bit in the regfile module so the 
	entire 64 bit value is output
*/
`timescale 1ns/10ps

module mux32to1 (datain, dataout, regselect);
	input logic [31:0] datain;
	input logic [4:0] regselect;
	output logic dataout;
	
	// internal wiring
	logic [15:0] data1;
	logic [7:0] data2;
	logic [3:0] data3;
	logic [1:0] data4;
	
	genvar i;
	genvar j;
	
	// each generate statement is a level of muxes to approach 1
	generate
		for(i=0; i<32; i=i+2) begin : eachMux1
			mux2to1 mux2a (datain[i], datain[i+1], regselect[0], data1[i/2]);
		end
	endgenerate
	
	generate
		for(i=0; i<16; i=i+2) begin : eachMux2
			mux2to1 mux2b (data1[i], data1[i+1], regselect[1], data2[i/2]);
		end
	endgenerate
	
	generate
		for(i=0; i<8; i=i+2) begin : eachMux3
			mux2to1 mux2c (data2[i], data2[i+1], regselect[2], data3[i/2]);
		end
	endgenerate
	
	generate
		for(i=0; i<4; i=i+2) begin : eachMux4
			mux2to1 mux2d (data3[i], data3[i+1], regselect[3], data4[i/2]);
		end
	endgenerate
	
	mux2to1 mux2e (data4[0], data4[1], regselect[4], dataout);
	
endmodule // mux32to1
	
	