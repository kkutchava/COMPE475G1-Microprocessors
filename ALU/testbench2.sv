//testbench2 for ALU
module testbench2 ();
	logic clk = 0;
	always begin 
		#10 clk = ~clk; 
	end
	//inputs
	logic [31:0] src1 = 30;
	logic [31:0] src2 = 40;
	logic carr = 1;
	logic [3:0]controller = 2; //cMinus
	logic c = 0;
	
	//ouputs
	logic [3:0] nzvc;
	logic [31:0] RdData_OR_memAddr;
	
	ALU inst(src1, src2, carr, controller, c, nzvc, RdData_OR_memAddr);
	
	initial begin
		#40;
		controller = 0;
		src1 = 32'b11111111111111111111111111111111;
		src2 = 1;
	end
	
endmodule