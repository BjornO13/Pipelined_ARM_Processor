`timescale 1ns/10ps

module cpustim ();

	logic clk, reset;
	
	parameter CLK_DELAY = 5000;
	
	initial $timeformat(-9, 2, " ns", 10);
	
	cpu dut (clk, reset);

	initial begin // Set up the clock
		clk <= 0;
		forever #(CLK_DELAY/2) clk <= ~clk;
	end
	
	initial begin 
	
	reset <= 1; @(posedge clk);
	reset <= 0; @(posedge clk);
	repeat(1000) @(posedge clk);
	
	
	
	$stop;

	end
	
endmodule

