module src1mux (
  input [31:0] Rn, //for data and mem access
  input [31:0] Rs, //for mult
  input [31:0] PC_out, //for jump
  input [1:0] s, //select bit 00 01 10 
  output [31:0] src1
);
  
  logic [31:0] SRC1;
	
  always @(*) begin
    case(s)
      2'b00: SRC1 = Rn;
      2'b01: SRC1 = Rs;
      2'b10: SRC1 = PC_out;
      default: SRC1 = 0;
    endcase
  end
      
      
  assign src1 = SRC1;
  	
endmodule

