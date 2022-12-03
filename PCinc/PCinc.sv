//PCinc
module PCinc(
	input [31:0]PC_Out,
	output [31:0]PC_Next
);
	logic [31:0] pcnext;

	
	assign PC_Next = PC_Out + 1;
	
endmodule