//testbench for Flags module
module testbench ();
	logic clk = 0;
	always begin 
		#10 clk = ~clk; 
	end
	
	logic s = 0;
	logic [3:0] nf = 4'b0110, out;
	Flags inst(s, nf, clk, out);
	
	initial begin
		#40;
		s = 1;
		#40;
	end
	
endmodule