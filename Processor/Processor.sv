//Processor
module Processor();

	logic clk = 0;
	always begin 
		#10 clk = ~clk; 
	end
	
	logic [31:0] instruction; //from IMEM
	logic [3:0] ARn, ARs, ARm, ARd;
	logic [23:0] imm24; //to src2shift
	logic [31:0] PC_OUT; //from regfile
	logic [31:0] PC1, PC2; //PC+1 from pcINC module and from pcINC second module to B
	logic [31:0] Rn, Rs, Rm, Rd; //from regFile
	logic [31:0] DatafMEM; //data from DMEM to X
	logic [31:0] PC_NEXT, RD_DATA, X; //from A and B to regFile and, X to regFIle
	logic [3:0] Y; //from Y to regFIle
	logic [31:0] ALU_OUT; //from alu to dmem, X
	logic [31:0] src1, src2; //from src1mux and src2shift to ALU
	logic [3:0] newFlags, allFlags; //from alu to flags and from flags to controller 
	logic carr, updateFlags; //to alu from flags and from controller to flags
	logic sY; //from controller to Y
	logic sX; //from controller to X
	logic [1:0]ssrc1Mux; // from controller to drc1mux
	logic regFile_wen; //from controller to regFile
	logic DMEM_wen; //from controller to dmem
	logic [3:0]sShifter; //frpm controller to shifter
	logic [3:0]sALU; //from controller to alu
	logic sA; //from controller to A
	logic sB; //from controller to B
	logic c; //carry from shifter to alu
	
	
	
	assign ARn = instruction[19:16];
	assign ARs = instruction[11:8];
	assign ARm = instruction[3:0];
	assign ARd = instruction[15:12];
	assign carr = allFlags[0];
	assign imm24 = instruction[23:0];
	
	
	
	B inst0(PC2, X, sB, RD_DATA);
	A inst1(PC1, X, sA, PC_NEXT);
	X inst2(ALU_OUT, DatafMEM, sX, X);
	Y inst3(ARd, 14, sY, Y); //it does not really matter what I pass here, as it always set to 14, 14 is the correct valye anyway
	src1mux inst4(Rn, Rs, PC_OUT, ssrc1Mux, src1);
	PCinc inst5(PC_OUT, PC1);
	PCinc inst6(PC1, PC2);
	Reg_File inst7(ARn, ARs, ARm, Y, regFile_wen, PC_NEXT, RD_DATA, clk, Rn, Rs, Rm, Rd, PC_OUT);
	DMEM inst8(ALU_OUT, Rd, DMEM_wen, clk, DatafMEM);
	IMEM inst9(PC_OUT, instruction);
	src2shift inst10(Rs, Rm, imm24, sShifter, src2, c);
	ALU inst11(src1, src2, carr, sALU, c, newFlags, ALU_OUT);
	Cotroller inst12(instruction, allFlags, sY, sX, ssrc1Mux, regFile_wen, DMEM_wen, updateFlags, sShifter, sALU, sA, sB);
	Flags inst13(updateFlags, newFlags, clk, allFlags);
	
	
	
	
endmodule