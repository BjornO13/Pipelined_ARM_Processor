/*
	This toplevel module ties together the 3 subsections of the 
	ARM 64 bit Register File. All registers can be written to except
	for register 31 which will always output 0. All registers can be 
	read. There are 2 read outputs which can be used at the same time
	to read different registers.
*/
`timescale 1ns/10ps

module regfile (clk, RegWrite, WriteRegister, WriteData, ReadRegister1, 
					  ReadRegister2, ReadData1, ReadData2);
					 
	input logic clk, RegWrite;
	input logic [4:0] WriteRegister, ReadRegister1, ReadRegister2;
	input logic [63:0] WriteData;
	output logic [63:0] ReadData1, ReadData2;
	
	logic [31:0] WriteEnable;
	logic [31:0][63:0] DataOut;
	logic [63:0][31:0] DataBit;
	
	// Decoding
	Decoder decoder (RegWrite, WriteRegister, WriteEnable);
	
	// Register logic
	genvar i;
	genvar l;
	
	generate 
		for(i=0; i<31; i++) begin : eachRegister
			Reg reg1 (clk, WriteEnable[i], WriteData, DataOut[i]);
		end
	endgenerate
	
	Reg reg31 (clk, 1, 64'b0, DataOut[31]);
	
	genvar r;
	genvar m;
	
	generate
		for(r=0; r<32; r++) begin : eachSwitch
			for(m=0; m<64; m++) begin :eachLoad
				assign DataBit[m][r] = DataOut[r][m];
			end
		end
	endgenerate
	
	// Output muxes
	genvar j;
	genvar k;

	generate
		for(j=0; j<64; j++) begin : eachMux
			mux32to1 mux1 (DataBit[j], ReadData1[j], ReadRegister1);
			mux32to1 mux2 (DataBit[j], ReadData2[j], ReadRegister2);
		end
	endgenerate
	
	
endmodule // regfile