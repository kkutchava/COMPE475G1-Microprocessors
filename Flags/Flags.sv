//flags
module Flags (
	input update_flags, //select update or not
	input [3:0]new_flags, //flags from ALU
	input CLOCK_50,
	output [3:0]carry_OR_allFlags //to ALU or controller
);
		
		
	
	
	logic [3:0] nzvc = 0; //mt flags
	
	always @(posedge CLOCK_50) begin
		if (update_flags)
			nzvc <= new_flags;
	end
	
	assign carry_OR_allFlags = nzvc;
	
endmodule