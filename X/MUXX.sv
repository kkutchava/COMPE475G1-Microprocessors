module X (
  input [31:0] RDDorMMADDR, //RD data or memory address
  input [31:0] DM, //Data from memory
  input s, //select bit
  output [31:0] RD_data
);
  
  logic [31:0] rddata;
  
  always @(*) begin
    case(s)
      0: rddata = RDDorMMADDR;
      1: rddata = DM;
      default: rddata = 0;
    endcase
  end
      
      
  assign RD_data = rddata;
    
endmodule
