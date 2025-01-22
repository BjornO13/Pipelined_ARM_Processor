/*
	This toplevel datapath creates a 5 cycle ARM CPU
	that can run these instructions: ADDI, ADDS, SUBS,
	B.LT, CBZ, B, LDUR, STUR, LSL, LSR, MUL.
	
	This project was completed by: Bjorn Olsen, Tanya Prihar
	
*/

`timescale 1ns/10ps

module cpu (clk, reset);
	input clk, reset;
	
	logic RegWrite;
	logic [4:0] WriteRegister, ReadRegister1, ReadRegister2;
	logic [63:0] WriteData, ReadData1, ReadData2;
	logic [63:0] A, B;
	logic [2:0] ALUOp;
	logic [63:0] result;
	logic negative, zero, overflow, carry_out;
	logic MemWrite;
	logic [63:0] read_data;
	logic [31:0] instruction;
	
	logic [63:0] PC, PC1, PC2, PC3;
	logic [63:0] PCBr;
	logic dontcare1, dontcare2, dontcare3, dontcare4;
	
	logic [18:0] CondAddr19;
	logic [25:0] BrAddr26; 
	
	logic [63:0] SE19, SE26;
	logic [63:0] CondOut;
	logic [63:0] ReadData2rf;
	logic [63:0] ReadData1rf;
	
	logic UncondBr;
	logic BrTaken;
	
	logic [63:0] BranchAdd;
	
	logic [63:0] mulLowE;
	logic [63:0] shiftResultE;
	logic [63:0] resultE;
	logic [63:0] ReadData2E;
	
	logic [31:0] instructionFF;
	logic [63:0] Aout;
	logic [63:0] Bout;
	logic [63:0] Brf;
	logic [63:0] Arf;
	logic [63:0] Amul;
	logic [63:0] Bmul;
	logic [63:0] mulSelectOut;
	
	logic [63:0] WriteDataMem;
	
	logic [1:0] WARrm, WARrn;
	
	
	
	
	// PC + 4
	addOperation add (PC, 64'd4, PC1, dontcare1, dontcare2);
	
	// Sign Extend 
	assign SE19 = { {45{CondAddr19[18]}}, CondAddr19 };
	assign SE26 = { {38{BrAddr26[25]}}, BrAddr26 };
	
	genvar i1;
	
	// Mux to choose which extend
	generate
		for (i1=0; i1<64; i1++) begin : eachCondmux
			mux2to1 mux2 (SE19[i1], SE26[i1], UncondBr, CondOut[i1]);
		end
	endgenerate
	
	// multiply by 4
	shifter sh1 (CondOut, 1'b0, 6'd2, BranchAdd);
	
	genvar i18;
	
	// save PC for branching
	generate 
		for (i18=0; i18<64; i18++) begin : eachPCbranch
			D_FF PCFF (PCBr[i18], PC[i18], reset, clk);
		end
	endgenerate
	
	// add to branch value to PC count
	addOperation add1 (PCBr, BranchAdd, PC2, dontcare3, dontcare4);
	
	genvar i2;
	
	// Mux to choose branch or no branch
	generate
		for (i2=0; i2<64; i2++) begin : eachBranchmux
			mux2to1 mux3 (PC1[i2], PC2[i2], BrTaken, PC3[i2]);
		end
	endgenerate
	
	genvar i3;
	
	// PC becomes PC3
	generate
		for (i3=0; i3<64; i3++) begin : eachDff
			D_FF flipflop (PC[i3], PC3[i3], reset, clk);
		end
	endgenerate
	
	//instruction memory instance
	instructmem imem (PC, instruction, clk);
	
	genvar i10;
	
	// Instruct fetch stage
	generate
		for (i10=0; i10<32; i10++) begin : eachInstruction
			D_FF dffI (instructionFF[i10], instruction[i10], reset, clk);
		end
	endgenerate
	
	// address logic for register
	logic [4:0] Rd, Rm, Rn;
	logic [4:0] RdMem;
	logic Reg2Loc;
	
	genvar i4;
	
	// mux to select Rd or Rm for Ab
	generate
		for (i4=0; i4<5; i4++) begin : eachAddr
			mux2to1 mux4 (Rd[i4], Rm[i4], Reg2Loc, ReadRegister2[i4]);
		end
	endgenerate
	
	assign WriteRegister = Rd;
	
	assign ReadRegister1 = Rn;
	
	// Register instance
	regfile register (~clk, RegWrite, RdMem, WriteDataMem, ReadRegister1, 
					  ReadRegister2, ReadData1, ReadData2);
	
	genvar i17;
	
	//forwarding mux for regular operations
	generate
		for (i17=0; i17<64; i17++) begin : eachRFforward
			mux4to1 mux17A (ReadData1[i17], result[i17], WriteData[i17], mulSelectOut[i17], WARrn, A[i17]);
			mux4to1 mux17B (ReadData2[i17], result[i17], WriteData[i17], mulSelectOut[i17], WARrm, B[i17]);
		end
	endgenerate
	
	logic cbzZ;
	//zero flag for cbz
	zero cbzflag (B, cbzZ);
	
	// immediate values
	logic [8:0] DAddr9;
	logic [11:0] Imm12;
	
	logic [63:0] SE9;
	logic [63:0] ZE12;
	
	assign SE9 = { {55{DAddr9[8]}}, DAddr9 };
	assign ZE12 = { 52'b0, Imm12};
	
	logic [63:0] immediate_val;
	logic ValSelect;
	
	genvar i5;
	
	// mux to select which immediate to use
	generate
		for (i5=0; i5<64; i5++) begin : eachImmediate
			mux2to1 mux5 (SE9[i5], ZE12[i5], ValSelect, immediate_val[i5]);
		end
	endgenerate
	
	logic ALUSrc;
	
	genvar i6;
	
	// mux to select register output or immediate
	generate
		for (i6=0; i6<64; i6++) begin : eachImmselect
			mux2to1 mux6 (B[i6], immediate_val[i6], ALUSrc, Bout[i6]);
		end
	endgenerate
					  
	assign Aout = A;

	genvar i11;
					  
	// Register fetch
	generate 
		for (i11=0; i11<64; i11++) begin : eachRegisterfetch
			D_FF dffR1 (Brf[i11], Bout[i11], reset, clk);
			D_FF dffR2 (Arf[i11], Aout[i11], reset, clk);
			D_FF dffR3 (ReadData2rf[i11], B[i11], reset, clk);
			D_FF dffR4 (ReadData1rf[i11], A[i11], reset, clk);
		end
	endgenerate
	
	logic [4:0] Rdrf;
	logic [4:0] Rmrf;
	logic [4:0] Rnrf;
	
	genvar i12;
	
	generate
		for (i12=0; i12<5; i12++) begin : eachRdrf
			D_FF dffRd1 (Rdrf[i12], Rd[i12], reset, clk);
			D_FF dffRm1 (Rmrf[i12], Rm[i12], reset, clk);
			D_FF dffRn1 (Rnrf[i12], Rn[i12], reset, clk);
		end
	endgenerate
	
	//Execute 
	alu alu1 (Arf, Brf, ALUOp, result, negative, zero, overflow, carry_out);
	
	logic [63:0] mulLow, mulHigh;
	
	mult multiply (ReadData1rf, ReadData2rf, 0, mulLow, mulHigh);
	
	logic direction;
	logic [5:0] distance;
	logic [63:0] shiftResult;
	logic [5:0] distanceEx;
	
	genvar i19;
	
	//save distance value for next cycle
	generate
		for (i19=0; i19<6; i19++) begin : eachDistance
			D_FF disFF (distanceEx[i19], distance[i19], reset, clk);
		end
	endgenerate
	
	shifter shift (ReadData1rf, direction, distanceEx, shiftResult);
	
	logic ShiftSelect;
	
   genvar i7;
	
	// mux to select mult or shift
	generate 
		for (i7=0; i7<64; i7++) begin : eachMulshift
			mux2to1 mux7 (mulLow[i7], shiftResult[i7], ShiftSelect, mulSelectOut[i7]);
		end
	endgenerate
	
	logic [63:0] mulSelectOutE;
	
	genvar i13;
	
	generate 
		for (i13=0; i13<64; i13++) begin : eachExecute
			D_FF dffE1 (mulSelectOutE[i13], mulSelectOut[i13], reset, clk);
			D_FF dffE3 (resultE[i13], result[i13], reset, clk);
			D_FF dffE4 (ReadData2E[i13], ReadData2rf[i13], reset, clk);
		end
	endgenerate
	
	logic [4:0] RdE;
	logic [4:0] RmE;
	logic [4:0] RnE;
	
	genvar i14;
	
	generate 
		for (i14=0; i14<5; i14++) begin : eachRdExecute
			D_FF dffRdE (RdE[i14], Rdrf[i14], reset, clk);
			D_FF dffRmE (RmE[i14], Rmrf[i14], reset, clk);
			D_FF dffRnE (RnE[i14], Rnrf[i14], reset, clk);
		end
	endgenerate
	
	
	
	logic MemtoReg;
	logic [63:0] memOrALU;
	
	genvar i8;
	
	// mux to select mem or alu
	generate
		for (i8=0; i8<64; i8++) begin : eachMem
			mux2to1 mux8 (resultE[i8], read_data[i8], MemtoReg, memOrALU[i8]);
		end
	endgenerate
	
	logic WhichToReg;
	
	genvar i9;
	
	// mux to select multShift or Mem/ALU
	generate
		for (i9=0; i9<64; i9++) begin : eachALUshift
			mux2to1 mux9 (memOrALU[i9], mulSelectOutE[i9], WhichToReg, WriteData[i9]);
		end
	endgenerate
	
	genvar i15;
	
	//Memory
	generate
		for (i15=0; i15<64; i15++) begin : eachMemory
			D_FF dffM1 (WriteDataMem[i15], WriteData[i15], reset, clk);
		end
	endgenerate
	
	genvar i16;
	
	generate
		for (i16=0; i16<5; i16++) begin : eachRdMem 
			D_FF dffrdm (RdMem[i16], RdE[i16], reset, clk);
		end
	endgenerate
	
	logic negativeF, overflowF, zeroF, carry_outF;
	
	//data memory instance
	datamem dmem (resultE, MemWrite, 1, ReadData2E, clk, 
					  4'd8, read_data);
	
	//control logic instance
	control ctrl (clk, instructionFF, Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemWrite, BrTaken, 
					  UncondBr, ValSelect, ALUOp, ShiftSelect, WhichToReg, direction, 
					  negative, overflow, zero, carry_out, cbzZ);
	
	//forwarding logic instance
	forwarding_unit fwd (clk, instructionFF, Rd, Rm, Rn, Rdrf, Rmrf, Rnrf, RdE, RmE, RnE, 
						  WARrn, WARrm);
	
	// assigned values
	assign CondAddr19 = instructionFF[23:5];
	assign BrAddr26 = instructionFF[25:0];
	assign Rn = instructionFF[9:5];
	assign Rd = instructionFF[4:0];
	assign Rm = instructionFF[20:16];
	assign Imm12 = instructionFF[21:10];
	assign DAddr9 = instructionFF[20:12];
	assign distance = instructionFF[15:10];
	

endmodule 