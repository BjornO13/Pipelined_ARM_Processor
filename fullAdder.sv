`timescale 1ns/10ps

module fullAdder (a, b, cin, cout, sum);
	input logic a, b, cin;
	output logic cout, sum;
	
	logic acin;
	logic bcin;
	logic ab;
	
	and (acin, a, cin);
	and (bcin, b, cin);
	and (ab, a, b);
	or #0.05 (cout, acin, bcin, ab);
	
	xor #0.05 (sum, a, b, cin);

endmodule 
	