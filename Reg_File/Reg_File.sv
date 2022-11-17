module Reg_File 
  (
    input [3:0] IR_addr_Rn, //
    input [3:0] IR_addr_Rs, //
    input [3:0] IR_addr_Rm, //
    input [3:0] mux_addr_Rd_or_15, //if allowed write to this address
    input CNTRL_write_en_addr_Rd, //enable to write to address RD
    input [31:0] pc_next, //
    input [31:0] mux_ALU_result_or_DMEM_data,//if allowed write this data
    input clk,
    
    output [31:0] Rn,
    output [31:0] Rs,
    output [31:0] Rm,
    output [31:0] Rd,
    output [31:0] pc_out
  );
  
  
  logic [31:0] r [15:0];//16 registers with length 32 bit ==> 0, 1, ... , 15
  
  always @(posedge clk) begin 
    r[15] <= pc_next; //assign next value to reg 15
    if (CNTRL_write_en_addr_Rd) r[mux_addr_Rd_or_15] <= mux_ALU_result_or_DMEM_data;
  end
  
  //immediate assign output data
  assign pc_out = r[15];
  assign Rn = r[IR_addr_Rn];
  assign Rs = r[IR_addr_Rs];
  assign Rm = r[IR_addr_Rm];
  assign Rd = r[mux_addr_Rd_or_15];
  
endmodule
