module forwarding_unit (clk, instruction, Rd, Rm, Rn, Rdrf, Rmrf, Rnrf, RdE, RmE, RnE, 
							   WARrn, WARrm, WARmulrn, WARmulrm);
	
	input logic clk;
	input logic [31:0] instruction;						
	input logic [4:0] Rd, Rm, Rn, Rdrf, Rmrf, Rnrf, RdE, RmE, RnE;
	output logic [1:0] WARrm, WARrn, WARmulrm, WARmulrn;
	
	logic [31:0] instructionE;
	
	// saves previous instruction
	always_ff @(posedge clk) begin
		instructionE <= instruction;
	end
	
	logic [1:0] zeroD;
	logic [20:16] zeroRm;
	logic [5:0] shamt;
	logic [4:0] codeLT;	
	logic [5:0] opcodeB;
	logic [7:0] opcodeCB;
	logic [9:0] opcodeI;
	logic [10:0] opcodeR;
	logic [10:0] opcodeD;
	
	logic [1:0] zeroDE;
	logic [20:16] zeroRmE;
	logic [5:0] shamtE;
	logic [4:0] codeLTE;	
	logic [5:0] opcodeBE;
	logic [7:0] opcodeCBE;
	logic [9:0] opcodeIE;
	logic [10:0] opcodeRE;
	logic [10:0] opcodeDE; 
	
	assign zeroD = instruction[11:10]; // set 0 for D-type (mem)
	assign zeroRm = instruction[20:16]; // set 0 for shift R-type
	assign shamt = instruction[15:10]; // set 0 for non-shift R-type. set shamt = h'1F for MUL.
	assign codeLT = instruction[4:0]; 
	assign opcodeB = instruction[31:26];
	assign opcodeCB = instruction[31:24];
	assign opcodeI = instruction[31:22];
	assign opcodeR = instruction[31:21];
	assign opcodeD = instruction[31:21];
	
	assign zeroDE = instructionE[11:10]; // set 0 for D-type (mem)
	assign zeroRmE = instructionE[20:16]; // set 0 for shift R-type
	assign shamtE = instructionE[15:10]; // set 0 for non-shift R-type. set shamt = h'1F for MUL.
	assign codeLTE = instructionE[4:0]; 
	assign opcodeBE = instructionE[31:26];
	assign opcodeCBE = instructionE[31:24];
	assign opcodeIE = instructionE[31:22];
	assign opcodeRE = instructionE[31:21];
	assign opcodeDE = instructionE[31:21];
	
	always_comb begin
	// ADDI
		if (opcodeI == 10'b1001000100) begin
		
			if ((Rdrf == 5'b11111 && Rn == 5'b11111) || (RdE == 5'b11111 && Rn == 5'b11111))
				WARrn = 2'b00;
			else if ((opcodeDE == 11'b11111000000) && (zeroDE == 2'b00)) begin
				if (RdE == Rn)
					WARrn = 2'b10;
				else 
					WARrn = 2'b00;
			end
			else begin
				if (Rdrf == Rn) begin
					if ((opcodeRE == 11'b11010011011) && (zeroRmE == 5'b00000) ||
						(opcodeRE == 11'b11010011010) && (zeroRmE == 5'b00000) || 
						(opcodeRE == 11'b10011011000) && (shamtE == 6'h1F)) 
						WARrn = 2'b11;
					else
						WARrn = 2'b01;
				end
				else if (RdE == Rn)
					WARrn = 2'b10;
				else
					WARrn = 2'b00;
			end
				
				
			if ((Rdrf == 5'b11111 && Rm == 5'b11111) || (RdE == 5'b11111 && Rm == 5'b11111))
				WARrm = 2'b00;
			else if ((opcodeDE == 11'b11111000000) && (zeroDE == 2'b00)) begin
				if (RdE == Rm)
					WARrm = 2'b10;
				else 
					WARrm = 2'b00;
			end
			else begin
				if (Rdrf == Rm) begin
					if ((opcodeRE == 11'b11010011011) && (zeroRmE == 5'b00000) ||
						(opcodeRE == 11'b11010011010) && (zeroRmE == 5'b00000) || 
						(opcodeRE == 11'b10011011000) && (shamtE == 6'h1F)) 
						WARrm = 2'b11;
					else
						WARrm = 2'b01;
				end
				else if (RdE == Rm)
					WARrm = 2'b10;
				else
					WARrm = 2'b00;
			end
			
		end
		
		// ADDS
		else if ((opcodeR == 11'b10101011000) && (shamt == 6'b000000)) begin
	
			if ((Rdrf == 5'b11111 && Rn == 5'b11111) || (RdE == 5'b11111 && Rn == 5'b11111))
				WARrn = 2'b00;
			else if ((opcodeDE == 11'b11111000000) && (zeroDE == 2'b00)) begin
				if (RdE == Rn)
					WARrn = 2'b10;
				else 
					WARrn = 2'b00;
			end
			else begin
				if (Rdrf == Rn) begin
					if ((opcodeRE == 11'b11010011011) && (zeroRmE == 5'b00000) ||
						(opcodeRE == 11'b11010011010) && (zeroRmE == 5'b00000) || 
						(opcodeRE == 11'b10011011000) && (shamtE == 6'h1F)) 
						WARrn = 2'b11;
					else
						WARrn = 2'b01;
				end
				else if (RdE == Rn)
					WARrn = 2'b10;
				else
					WARrn = 2'b00;
			end
				
				
			if ((Rdrf == 5'b11111 && Rm == 5'b11111) || (RdE == 5'b11111 && Rm == 5'b11111))
				WARrm = 2'b00;
			else if ((opcodeDE == 11'b11111000000) && (zeroDE == 2'b00)) begin
				if (RdE == Rm)
					WARrm = 2'b10;
				else 
					WARrm = 2'b00;
			end
			else begin
				if (Rdrf == Rm) begin
					if ((opcodeRE == 11'b11010011011) && (zeroRmE == 5'b00000) ||
						(opcodeRE == 11'b11010011010) && (zeroRmE == 5'b00000) || 
						(opcodeRE == 11'b10011011000) && (shamtE == 6'h1F)) 
						WARrm = 2'b11;
					else
						WARrm = 2'b01;
				end
				else if (RdE == Rm)
					WARrm = 2'b10;
				else
					WARrm = 2'b00;
			end
			
		end
		
		// B
		else if (opcodeB == 6'b000101) begin
			WARrn = 2'b00;
			WARrm = 2'b00;
		end
		
		// B.LT
		else if ((opcodeCB == 8'b01010100) && (codeLT == 5'b01011)) begin
			WARrn = 2'b00;
			WARrm = 2'b00;
		end
		
		// CBZ
		else if (opcodeCB == 8'b10110100) begin
			WARrn = 2'b00;
			if ((Rdrf == 5'b11111) && (Rd == 5'b11111))
				WARrm = 2'b00;
			else if (Rdrf == Rd) begin
				   if ((opcodeRE == 11'b11010011011) && (zeroRmE == 5'b00000) ||
						(opcodeRE == 11'b11010011010) && (zeroRmE == 5'b00000) || 
						(opcodeRE == 11'b10011011000) && (shamtE == 6'h1F)) 
						WARrm = 2'b11;
					else
						WARrm = 2'b01;
			end
			else if (RdE == Rd)
				WARrm = 2'b10;
			else
				WARrm = 2'b00;
				
		end
		
		// LDUR
		else if ((opcodeD == 11'b11111000010) && (zeroD == 2'b00)) begin
		
			if ((Rdrf == 5'b11111 && Rn == 5'b11111) || (RdE == 5'b11111 && Rn == 5'b11111))
				WARrn = 2'b00;
			else if ((opcodeDE == 11'b11111000000) && (zeroDE == 2'b00)) begin
				if (RdE == Rn)
					WARrn = 2'b10;
				else 
					WARrn = 2'b00;
			end
			else begin
				if (Rdrf == Rn) begin
					if ((opcodeRE == 11'b11010011011) && (zeroRmE == 5'b00000) ||
						(opcodeRE == 11'b11010011010) && (zeroRmE == 5'b00000) || 
						(opcodeRE == 11'b10011011000) && (shamtE == 6'h1F)) 
						WARrn = 2'b11;
					else
						WARrn = 2'b01;
				end
				else if (RdE == Rn)
					WARrn = 2'b10;
				else
					WARrn = 2'b00;
			end
				
				
			if ((Rdrf == 5'b11111 && Rd == 5'b11111) || (RdE == 5'b11111 && Rd == 5'b11111))
				WARrm = 2'b00;
			else if ((opcodeDE == 11'b11111000000) && (zeroDE == 2'b00)) begin
				if (RdE == Rd)
					WARrm = 2'b10;
				else 
					WARrm = 2'b00;
			end
			else begin
				if (Rdrf == Rd) begin
					if ((opcodeRE == 11'b11010011011) && (zeroRmE == 5'b00000) ||
						(opcodeRE == 11'b11010011010) && (zeroRmE == 5'b00000) || 
						(opcodeRE == 11'b10011011000) && (shamtE == 6'h1F)) 
						WARrm = 2'b11;
					else
						WARrm = 2'b01;
				end
				else if (RdE == Rd)
					WARrm = 2'b10;
				else
					WARrm = 2'b00;
			end
			
		end
		
		// LSL
		else if ((opcodeR == 11'b11010011011) && (zeroRm == 5'b00000)) begin
			
			if ((Rdrf == 5'b11111 && Rn == 5'b11111) || (RdE == 5'b11111 && Rn == 5'b11111))
				WARrn = 2'b00;
			else if ((opcodeDE == 11'b11111000000) && (zeroDE == 2'b00)) begin
				if (RdE == Rn)
					WARrn = 2'b10;
				else 
					WARrn = 2'b00;
			end
			else begin
				if (Rdrf == Rn) begin
					if ((opcodeRE == 11'b11010011011) && (zeroRmE == 5'b00000) ||
						(opcodeRE == 11'b11010011010) && (zeroRmE == 5'b00000) || 
						(opcodeRE == 11'b10011011000) && (shamtE == 6'h1F)) 
						WARrn = 2'b11;
					else
						WARrn = 2'b01;
				end
				else if (RdE == Rn)
					WARrn = 2'b10;
				else
					WARrn = 2'b00;
			end
				
				
			if ((Rdrf == 5'b11111 && Rm == 5'b11111) || (RdE == 5'b11111 && Rm == 5'b11111))
				WARrm = 2'b00;
			else if ((opcodeDE == 11'b11111000000) && (zeroDE == 2'b00)) begin
				if (RdE == Rm)
					WARrm = 2'b10;
				else 
					WARrm = 2'b00;
			end
			else begin
				if (Rdrf == Rm) begin
					if ((opcodeRE == 11'b11010011011) && (zeroRmE == 5'b00000) ||
						(opcodeRE == 11'b11010011010) && (zeroRmE == 5'b00000) || 
						(opcodeRE == 11'b10011011000) && (shamtE == 6'h1F)) 
						WARrm = 2'b11;
					else
						WARrm = 2'b01;
				end
				else if (RdE == Rm)
					WARrm = 2'b10;
				else
					WARrm = 2'b00;
			end
			
		end
		
		// LSR
		else if ((opcodeR == 11'b11010011010) && (zeroRm == 5'b00000)) begin
			
			if ((Rdrf == 5'b11111 && Rn == 5'b11111) || (RdE == 5'b11111 && Rn == 5'b11111))
				WARrn = 2'b00;
			else if ((opcodeDE == 11'b11111000000) && (zeroDE == 2'b00)) begin
				if (RdE == Rn)
					WARrn = 2'b10;
				else 
					WARrn = 2'b00;
			end
			else begin
				if (Rdrf == Rn) begin
					if ((opcodeRE == 11'b11010011011) && (zeroRmE == 5'b00000) ||
						(opcodeRE == 11'b11010011010) && (zeroRmE == 5'b00000) || 
						(opcodeRE == 11'b10011011000) && (shamtE == 6'h1F)) 
						WARrn = 2'b11;
					else
						WARrn = 2'b01;
				end
				else if (RdE == Rn)
					WARrn = 2'b10;
				else
					WARrn = 2'b00;
			end
				
				
			if ((Rdrf == 5'b11111 && Rm == 5'b11111) || (RdE == 5'b11111 && Rm == 5'b11111))
				WARrm = 2'b00;
			else if ((opcodeDE == 11'b11111000000) && (zeroDE == 2'b00)) begin
				if (RdE == Rm)
					WARrm = 2'b10;
				else 
					WARrm = 2'b00;
			end
			else begin
				if (Rdrf == Rm) begin
					if ((opcodeRE == 11'b11010011011) && (zeroRmE == 5'b00000) ||
						(opcodeRE == 11'b11010011010) && (zeroRmE == 5'b00000) || 
						(opcodeRE == 11'b10011011000) && (shamtE == 6'h1F)) 
						WARrm = 2'b11;
					else
						WARrm = 2'b01;
				end
				else if (RdE == Rm)
					WARrm = 2'b10;
				else
					WARrm = 2'b00;
			end
			
		end
		
		// MUL
		else if ((opcodeR == 11'b10011011000) && (shamt == 6'h1F)) begin
			if ((Rdrf == 5'b11111 && Rn == 5'b11111) || (RdE == 5'b11111 && Rn == 5'b11111))
				WARrn = 2'b00;
			else if ((opcodeDE == 11'b11111000000) && (zeroDE == 2'b00)) begin
				if (RdE == Rn)
					WARrn = 2'b10;
				else 
					WARrn = 2'b00;
			end
			else begin
				if (Rdrf == Rn) begin
					if ((opcodeRE == 11'b11010011011) && (zeroRmE == 5'b00000) ||
						(opcodeRE == 11'b11010011010) && (zeroRmE == 5'b00000) || 
						(opcodeRE == 11'b10011011000) && (shamtE == 6'h1F)) 
						WARrn = 2'b11;
					else
						WARrn = 2'b01;
				end
				else if (RdE == Rn)
					WARrn = 2'b10;
				else
					WARrn = 2'b00;
			end
				
				
			if ((Rdrf == 5'b11111 && Rm == 5'b11111) || (RdE == 5'b11111 && Rm == 5'b11111))
				WARrm = 2'b00;
			else if ((opcodeDE == 11'b11111000000) && (zeroDE == 2'b00)) begin
				if (RdE == Rm)
					WARrm = 2'b10;
				else 
					WARrm = 2'b00;
			end
			else begin
				if (Rdrf == Rm) begin
					if ((opcodeRE == 11'b11010011011) && (zeroRmE == 5'b00000) ||
						(opcodeRE == 11'b11010011010) && (zeroRmE == 5'b00000) || 
						(opcodeRE == 11'b10011011000) && (shamtE == 6'h1F)) 
						WARrm = 2'b11;
					else
						WARrm = 2'b01;
				end
				else if (RdE == Rm)
					WARrm = 2'b10;
				else
					WARrm = 2'b00;
			end
			
		end
		
		// STUR
		else if ((opcodeD == 11'b11111000000) && (zeroD == 2'b00)) begin
		
			if ((Rdrf == 5'b11111 && Rn == 5'b11111) || (RdE == 5'b11111 && Rn == 5'b11111))
				WARrn = 2'b00;
			else if ((opcodeDE == 11'b11111000000) && (zeroDE == 2'b00)) begin
				if (RdE == Rn)
					WARrn = 2'b10;
				else 
					WARrn = 2'b00;
			end
			else begin
				if (Rdrf == Rn) begin
					if ((opcodeRE == 11'b11010011011) && (zeroRmE == 5'b00000) ||
						(opcodeRE == 11'b11010011010) && (zeroRmE == 5'b00000) || 
						(opcodeRE == 11'b10011011000) && (shamtE == 6'h1F)) 
						WARrn = 2'b11;
					else
						WARrn = 2'b01;
				end
				else if (RdE == Rn)
					WARrn = 2'b10;
				else
					WARrn = 2'b00;
			end
				
				
			if ((Rdrf == 5'b11111 && Rd == 5'b11111) || (RdE == 5'b11111 && Rd == 5'b11111))
				WARrm = 2'b00;
			else if ((opcodeDE == 11'b11111000000) && (zeroDE == 2'b00)) begin
				if (RdE == Rd)
					WARrm = 2'b10;
				else 
					WARrm = 2'b00;
			end
			else begin
				if (Rdrf == Rd) begin
					if ((opcodeRE == 11'b11010011011) && (zeroRmE == 5'b00000) ||
						(opcodeRE == 11'b11010011010) && (zeroRmE == 5'b00000) || 
						(opcodeRE == 11'b10011011000) && (shamtE == 6'h1F)) 
						WARrm = 2'b11;
					else
						WARrm = 2'b01;
				end
				else if (RdE == Rd)
					WARrm = 2'b10;
				else
					WARrm = 2'b00;
			end
			
		end
		
		// SUBS
		else if ((opcodeR == 11'b11101011000) && (shamt == 6'b000000)) begin
			
			if ((Rdrf == 5'b11111 && Rn == 5'b11111) || (RdE == 5'b11111 && Rn == 5'b11111))
				WARrn = 2'b00;
			else if ((opcodeDE == 11'b11111000000) && (zeroDE == 2'b00)) begin
				if (RdE == Rn)
					WARrn = 2'b10;
				else 
					WARrn = 2'b00;
			end
			else begin
				if (Rdrf == Rn) begin
					if ((opcodeRE == 11'b11010011011) && (zeroRmE == 5'b00000) ||
						(opcodeRE == 11'b11010011010) && (zeroRmE == 5'b00000) || 
						(opcodeRE == 11'b10011011000) && (shamtE == 6'h1F)) 
						WARrn = 2'b11;
					else
						WARrn = 2'b01;
				end
				else if (RdE == Rn)
					WARrn = 2'b10;
				else
					WARrn = 2'b00;
			end
				
				
			if ((Rdrf == 5'b11111 && Rm == 5'b11111) || (RdE == 5'b11111 && Rm == 5'b11111))
				WARrm = 2'b00;
			else if ((opcodeDE == 11'b11111000000) && (zeroDE == 2'b00)) begin
				if (RdE == Rm)
					WARrm = 2'b10;
				else 
					WARrm = 2'b00;
			end
			else begin
				if (Rdrf == Rm) begin
					if ((opcodeRE == 11'b11010011011) && (zeroRmE == 5'b00000) ||
						(opcodeRE == 11'b11010011010) && (zeroRmE == 5'b00000) || 
						(opcodeRE == 11'b10011011000) && (shamtE == 6'h1F)) 
						WARrm = 2'b11;
					else
						WARrm = 2'b01;
				end
				else if (RdE == Rm)
					WARrm = 2'b10;
				else
					WARrm = 2'b00;
			end
		end
		
		else begin
			WARrn = 2'b00;
			WARrm = 2'b00;
		end
		
	end

endmodule
			