module mux8to1 (data0, data1, data2, data3, data4, data5,
					 data6, data7, select, out);

	input logic data0, data1, data2, data3, data4, data5, data6, data7;
	input logic [2:0] select;
	output logic out;
	
	logic data10, data11, data12, data13;
	logic data20, data21;
	
	mux2to1 mux10 (data0, data1, select[0], data10);
	mux2to1 mux11 (data2, data3, select[0], data11);
	mux2to1 mux12 (data4, data5, select[0], data12);
	mux2to1 mux13 (data6, data7, select[0], data13);
	
	mux2to1 mux20 (data10, data11, select[1], data20);
	mux2to1 mux21 (data12, data13, select[1], data21);
	
	mux2to1 mux3 (data20, data21, select[2], out);

endmodule
