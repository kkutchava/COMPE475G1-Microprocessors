//testbench1 for src2shift module
module testbench1 ();
	logic clk = 0;
	always begin 
		#10 clk = ~clk; 
	end
	
	logic [31:0] Rs = 32'b00000000000000000000000000000001; //some value coming
	logic [31:0] Rm = 32'b00000000000000000000000000000010; //same
	logic [23:0] Imm24 = 24'b000000000000001010000000;
	logic [3:0] opState = 1; //lets assume shamt5LSL happens first
	
	logic [31:0] src2;
	logic c;
	
	src2shift inst(Rs, Rm, Imm24, opState, src2, c);
	
	initial begin
		#40;
		opState = 0;
		Imm24 = 24'b000000000000001000000101;
	end
	
endmodule