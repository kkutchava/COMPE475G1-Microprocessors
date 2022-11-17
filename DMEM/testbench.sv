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

	  logic clk = 0;
	logic [31:0] Mem_Addr;
    logic [31:0] RF_Rd_data;
	logic wen = 0;

    logic [31:0] memory_data;
  
  
  
  always begin 
	#10 clk = ~clk; 
  end
  
  DMEM inst(Mem_Addr, RF_Rd_data,wen,clk,memory_data);

     initial begin
		#10 wen = 1;
		Mem_Addr = 8;
		RF_Rd_data = 511;
		#10;
		Mem_Addr = 9;
		RF_Rd_data = 103;
		#20;
		wen = 0;
		Mem_Addr = 8; //read address 8
    end
endmodule
 