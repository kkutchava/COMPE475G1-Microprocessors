module testbench();

//  logic [3:0] IR_addr_Rn = 0;
//  logic [3:0] IR_addr_Rs = 1;
//  logic [3:0] IR_addr_Rm = 2;
//  logic [3:0] mux_addr_Rd_or_15 = 0;
//  logic CNTRL_write_en_addr_Rd = 1;
//  logic [31:0] pc_next;
//  logic [31:0] mux_ALU_result_or_DMEM_data = 177;
//    
//  logic clk = 0;
//  logic [31:0] Rn;
//  logic [31:0] Rs;
//  logic [31:0] Rm;
//  logic [31:0] Rd;
//  logic [31:0] pc_out;

	//  logic clk = 0;
    logic [31:0] PC_Out = 7;

    logic [31:0] theInstruction;
  
  
  
//  always begin 
//	#10 clk = ~clk; 
//  end
  
  IMEM inst(PC_Out, theInstruction);

     initial begin
		
		
    end
endmodule
 