module Y (
  input [3:0] ARd, //Destination Register
  input [3:0] FJ15, //15, for jump
  input s, //select bit
  output [3:0] out
);
  
  logic [3:0] OUT;
	
  always @(*) begin
    case(s)
      0: OUT = ARd;
      1: OUT = FJ15;
      default: OUT = 0;
    endcase
  end
      
      
  assign out = OUT;
  	
endmodule

