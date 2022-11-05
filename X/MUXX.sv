<<<<<<< HEAD
module X (
  input [31:0] RDDorMMADDR, //RD data or memory address
  input [31:0] DM, //Data from memory
=======
module X ( //name, and also bitwidths?
  input [3:0] RDDorMMADDR, //RD data ir memory address
  input [3:0] DM, //Data from memory
>>>>>>> 5f2970c88a9e371cb0d68663b14d53a7dd3155c6
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
