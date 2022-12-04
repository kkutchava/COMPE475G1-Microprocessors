//testbench1 for src2shift module
module testbench1 ();
	logic clk = 0;
	always begin 
		#10 clk = ~clk; 
	end
	
	logic [31:0] Rs = 32'b00000000000000000000000000000011; //some value coming
	logic [31:0] Rm = 32'b00000000000000000000000000000001; //same
	logic [23:0] Imm24 = 24'b000000000000001010000000;
	logic [3:0] opState = 1; //lets assume shamt5LSL happens first
	
	logic [31:0] src2;
	logic c;
	
	src2shift inst(Rs, Rm, Imm24, opState, src2, c);
	
	reg signed [3:0] test1 = 4'b0001;
	logic [3:0] shift1 = 2;
	
	initial begin
		#40;
		opState = 0;
		Imm24 = 24'b000000000000000100000101;
		#40;
		opState = 2;
		Imm24 = 24'b000000000000000011000101;
		#40;
		opState = 7;
		Imm24 = 24'b000000000000000011100101;
		Rm = 32'b01000000000000000000000000000001;
		//#40;
		//test1 = signed'(test1 <<< shift1);
	end
	
endmodule