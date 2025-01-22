`timescale 1ns/10ps

// returns true if the output of the ALU is 0

module zero (data, isZero);
	input logic [63:0] data;
	output logic isZero;
	
	logic [31:0] data1;
	logic [15:0] data2;
	logic [7:0] data3;
	logic [3:0] data4;
	logic [1:0] data5;
	
	logic isNotZero;
	
	genvar i;
	
	generate
		for(i=0; i<63; i=i+2) begin : eachOr1
			or #0.05 (data1[i/2], data[i], data[i+1]);
		end
	endgenerate
	
	generate
		for(i=0; i<31; i=i+2) begin : eachOr2
			or #0.05 (data2[i/2], data1[i], data1[i+1]);
		end
	endgenerate
	
	generate
		for(i=0; i<15; i=i+2) begin : eachOr3
			or #0.05 (data3[i/2], data2[i], data2[i+1]);
		end
	endgenerate
	
	generate
		for(i=0; i<7; i=i+2) begin : eachOr4
			or #0.05 (data4[i/2], data3[i], data3[i+1]);
		end
	endgenerate
	
	generate
		for(i=0; i<3; i=i+2) begin : eachOr5
			or #0.05 (data5[i/2], data4[i], data4[i+1]);
		end
	endgenerate
	
	or #0.05 (isNotZero, data5[0], data5[1]);

	not #0.05 (isZero, isNotZero);
	
endmodule 