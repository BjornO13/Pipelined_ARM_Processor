module mux4to1 (A, B, C, D, select, out);
	
	input logic A, B, C, D;
	input logic [1:0] select;
	output logic out;
	
	logic out1, out2;
	
	mux2to1 mux1 (A, B, select[0], out1);
	mux2to1 mux2 (C, D, select[0], out2);
	
	mux2to1 mux3 (out1, out2, select[1], out);

endmodule 