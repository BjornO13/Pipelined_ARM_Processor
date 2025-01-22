`timescale 1ns/10ps

module control (clk, instruction, Reg2Loc, ALUSrc, MemtoRegMem, RegWriteWr, MemWriteMem, BrTaken, UncondBr, ValSelect, ALUOpEx, ShiftSelectEx, WhichtoRegMem, DirectionEx, negative, overflow, zero, carryout, cbzZ);
	input logic clk;
	input logic [31:0] instruction;
	logic [31:0] instructionS;
	input logic negative, overflow, zero, carryout, cbzZ;
	output logic  BrTaken, UncondBr;
	output logic Reg2Loc, ValSelect, ALUSrc;
	logic MemToReg, RegWrite, MemWrite, ShiftSelect, WhichToReg, Direction;
	logic [3:0] ALUOp;
	
	logic newNegative, newOverflow, newZero, newCarryout;
	
	logic CondDelay, CondDelayD;
	
	logic [1:0] zeroD;
	logic [20:16] zeroRm;
	logic [5:0] shamt;
	logic [4:0] codeLT;	
	logic [5:0] opcodeB;
	logic [7:0] opcodeCB;
	logic [9:0] opcodeI;
	logic [10:0] opcodeR;
	logic [10:0] opcodeD;
	
	logic [10:0] opcodeRS;
	logic [5:0] shamtS;
	
	assign opcodeRS = instructionS[31:21];
	assign shamtS = instructionS[15:10]; 
	
	assign zeroD = instruction[11:10]; // set 0 for D-type (mem)
	assign zeroRm = instruction[20:16]; // set 0 for shift R-type
	assign shamt = instruction[15:10]; // set 0 for non-shift R-type. set shamt = h'1F for MUL.
	assign codeLT = instruction[4:0]; 
	assign opcodeB = instruction[31:26];
	assign opcodeCB = instruction[31:24];
	assign opcodeI = instruction[31:22];
	assign opcodeR = instruction[31:21];
	assign opcodeD = instruction[31:21];
	
	always_comb begin
	
		CondDelay = 1'b0;
		Reg2Loc = 1'b0;
		ALUSrc = 1'bx;
		MemToReg = 1'bx;
		RegWrite = 1'b0;
		MemWrite = 1'b0;
		BrTaken = 1'b0;
		UncondBr = 1'b0;
		ValSelect = 1'bx;
		ShiftSelect = 1'bx;
		WhichToReg = 1'bx;
		Direction = 1'bx;
		ALUOp = 3'bxxx;
		
		// ADDI
		if (opcodeI == 10'b1001000100) begin
			// Reg2Loc = x;
			ALUSrc = 1;
			MemToReg = 0;
			RegWrite = 1; 
			MemWrite = 0;
			BrTaken = 0;
			// UncondBr = x;
			ValSelect = 1;
			// ShiftSelect = x;
			WhichToReg = 0;
			// Direction = x;
			ALUOp = 3'b010;
		end
		
		// ADDS
		else if ((opcodeR == 11'b10101011000) && (shamt == 6'b000000)) begin
			CondDelay = 1;
			Reg2Loc = 1;
			ALUSrc = 0;
			MemToReg = 0;
			RegWrite = 1;
			MemWrite = 0;
			BrTaken = 0;
			// UncondBr = x;
			// ValSelect = x;
			// ShiftSelect = x;
			WhichToReg = 0;
			// Direction = x;
			ALUOp = 3'b010;
		end
		
		// B
		else if (opcodeB == 6'b000101) begin
			// Reg2Loc = x;
			// ALUSrc = x;
			// MemToReg = x;
			RegWrite = 0;
			MemWrite = 0;
			BrTaken = 1;
			UncondBr = 1;
			// ValSelect = x;
			// ShiftSelect = x;
			// WhichToReg = x;
			// Direction = x;
			ALUOp = 3'b000;
		end
		
		// B.LT
		else if ((opcodeCB == 8'b01010100) && (codeLT == 5'b01011)) begin
			Reg2Loc = 0;
			ALUSrc = 0;
			// MemToReg = x;
			RegWrite = 0;
			MemWrite = 0;
			BrTaken = CondDelayD ? (negative != overflow) : (newNegative != newOverflow);
			UncondBr = 0;
			// ValSelect = x;
			// ShiftSelect = x;
			// WhichToReg = x;
			// Direction = x;
			ALUOp = 3'b000;
		end
		
		// CBZ
		else if (opcodeCB == 8'b10110100) begin
			Reg2Loc = 0;
			ALUSrc = 0;
			// MemToReg = x;
			RegWrite = 0;
			MemWrite = 0;
			BrTaken = cbzZ;
			UncondBr = 0;
			// ValSelect = x;
			// ShiftSelect = x;
			// WhichToReg = x;
			// Direction = x;
			ALUOp = 3'b000;
		end
		
		// LDUR
		else if ((opcodeD == 11'b11111000010) && (zeroD == 2'b00)) begin
			// Reg2Loc = x;
			ALUSrc = 1;
			MemToReg = 1;
			RegWrite = 1;
			MemWrite = 0;
			BrTaken = 0;
			// UncondBr = x;
			ValSelect = 0;
			// ShiftSelect = x;
			WhichToReg = 0;
			// Direction = x;
			ALUOp = 3'b010;
		end
		
		// LSL
		else if ((opcodeR == 11'b11010011011) && (zeroRm == 5'b00000)) begin
			// Reg2Loc = x;
			// ALUSrc = x;
			// MemToReg = x;
			RegWrite = 1;
			MemWrite = 0;
			BrTaken = 0;
			// UncondBr = x;
			// ValSelect = x;
			ShiftSelect = 1;
			WhichToReg = 1;
			Direction = 0;
			ALUOp = 3'b000;
		end
		
		// LSR
		else if ((opcodeR == 11'b11010011010) && (zeroRm == 5'b00000)) begin
			// Reg2Loc = x;
			// ALUSrc = x;
			// MemToReg = x;
			RegWrite = 1;
			MemWrite = 0;
			BrTaken = 0;
			// UncondBr = x;
			// ValSelect = x;
			ShiftSelect = 1;
			WhichToReg = 1;
			Direction = 1;
			ALUOp = 3'b000;
		end
		
		// MUL
		else if ((opcodeR == 11'b10011011000) && (shamt == 6'h1F)) begin
			Reg2Loc = 1;
			// ALUSrc = x;
			// MemToReg = x;
			RegWrite = 1;
			MemWrite = 0;
			BrTaken = 0;
			// UncondBr = x;
			// ValSelect = x;
			ShiftSelect = 0;
			WhichToReg = 1;
			// Direction = x;
			ALUOp = 3'b000;
		end
		
		// STUR
		else if ((opcodeD == 11'b11111000000) && (zeroD == 2'b00)) begin
			Reg2Loc = 0;
			ALUSrc = 1;
			MemToReg = 1;
			RegWrite = 0;
			MemWrite = 1;
			BrTaken = 0;
			// UncondBr = x;
			ValSelect = 0;
			// ShiftSelect = x;
			WhichToReg = 0;
			// Direction = x;
			ALUOp = 3'b010;
		end
		
		// SUBS
		else if ((opcodeR == 11'b11101011000) && (shamt == 6'b000000)) begin
			CondDelay = 1;
			Reg2Loc = 1;
			ALUSrc = 0;
			MemToReg = 0;
			RegWrite = 1;
			MemWrite = 0;
			BrTaken = 0;
			// UncondBr = x;
			// ValSelect = x;
			// ShiftSelect = x;
			WhichToReg = 0;
			// Direction = x;
			ALUOp = 3'b011;
		end
		
		else begin
			CondDelay = 1'b0;
			Reg2Loc = 1'bx;
			ALUSrc = 1'bx;
			MemToReg = 1'bx;
			RegWrite = 1'b0;
			MemWrite = 1'b0;
			BrTaken = 1'b0;
			UncondBr = 1'b0;
			ValSelect = 1'bx;
		   ShiftSelect = 1'bx;
			WhichToReg = 1'bx;
			Direction = 1'bx;
			ALUOp = 3'bxxx;
		end
	end
	
	always_ff @(posedge clk) begin
		instructionS <= instruction;
	end
	
	always_ff @(posedge clk) begin
		CondDelayD <= CondDelay;
	end
		
	always_ff @(posedge clk) begin
		if (((opcodeRS == 11'b10101011000) || (opcodeRS == 11'b11101011000)) && (shamtS == 6'b000000)) begin
			newNegative <= negative;
			newOverflow <= overflow;
			newZero <= zero;
			newCarryout <= carryout;
		end
		else begin
			newNegative <= newNegative;
			newOverflow <= newOverflow;
			newZero <= newZero;
			newCarryout <= newCarryout;
		end
	end
	
	logic MemtoRegEx, RegWriteEx, MemWriteEx,
	WhichtoRegEx;
	
	output logic [3:0] ALUOpEx;
	output logic DirectionEx, ShiftSelectEx;
	
	always_ff @(posedge clk) begin
		MemtoRegEx <= MemToReg;
		RegWriteEx <= RegWrite;
		MemWriteEx <= MemWrite;
		ALUOpEx <= ALUOp;
		ShiftSelectEx <= ShiftSelect;
		WhichtoRegEx <= WhichToReg;
		DirectionEx <= Direction;
	end
	
	output logic MemtoRegMem, MemWriteMem, WhichtoRegMem;
	logic RegWriteMem;
	
	always_ff @(posedge clk) begin
		MemtoRegMem <= MemtoRegEx;
		RegWriteMem <= RegWriteEx;
		MemWriteMem <= MemWriteEx;
		WhichtoRegMem <= WhichtoRegEx;
	end
	
	output logic RegWriteWr;
	
	always_ff @(posedge clk) begin
		RegWriteWr <= RegWriteMem;
	end
	
	
endmodule
