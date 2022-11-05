module X ( //name, and also bitwidths?
  input [3:0] RDDorMMADDR, //RD data ir memory address
  input [3:0] DM, //Data from memory
  input s, //select bit
  output [3:0] RD_data
);
  
  logic [3:0] rddata;
	
  always @(*) begin
    case(s)
      0: rddata = RDDorMMADDR;
      1: rddata = DM;
      default: rddata = 0;
    endcase
  end
      
      
  assign RD_data = rddata;
  	
endmodule

