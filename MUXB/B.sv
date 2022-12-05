module B(
	input [31:0] PC_next, //from pcINC
	input [31:0] ALU_data, //from ALU
	input s, //from controller
	output [31:0] OUT
);
	logic [31:0] out;
  
   always @(*) begin
     case(s)
       0: out = PC_next;
       1: out = ALU_data;
       default: out = 0;
     endcase
   end
      
      
  assign OUT = out;
	
endmodule