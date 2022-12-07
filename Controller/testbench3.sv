//testbench3 for controller
module testbench3();
	logic clk = 0;
	always begin 
		#10 clk = ~clk; 
	end
	           // alw  dt I cmd  S Rn   Rd    SHMT5 SH 4 Rm
				  // 1110 00 0 0000 1 0001 0010  00000 00 0 0011
	logic [31:0] instr = 32'b11100000000100010010000000000011; // AND reg2, reg1, reg3 => reg2 = reg1 & reg3
	logic [3:0]falgs = 4'b0000;
	logic sY;
	logic sX;
	logic [1:0]ssrc1Mux;
	logic regFile_wen;
	logic DMEM_wen;
	logic supdate_flags;
	logic [3:0]sShifter;
	logic [3:0]sALU;
	logic sA;
	logic sB;
	
	Cotroller inst(instr, falgs, sY, sX, ssrc1Mux, regFile_wen, DMEM_wen, supdate_flags, sShifter, sALU, sA, sB);
	
	initial begin
	
		#100;              
		instr = 32'b11100000100000010000001100010010; //add r0,r1,r2,lsl r3
		#100;
		instr = 32'b11101100000100010000000000000010; // 1110 11 00 000 1 0001 0000 0000000000010 => mul r0,r1,r2

		
	end
	
endmodule