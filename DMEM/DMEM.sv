module DMEM 
  (
    input [31:0] Mem_Addr, //coming from ALU memory address where to write
    input [31:0] RF_Rd_data, //data tobe written
	input wen, //enable writing to dmem
    input clk,

    output [31:0] memory_data //output data from the dmem
  );
  
  //16 words, words are 32 bits
  logic [31:0] mem [15:0];
    
  always @(posedge clk) begin
    if (wen) mem[Mem_Addr] <= RF_Rd_data; //write data - 1clk
  end
  
  assign memory_data = mem[Mem_Addr]; //imm assign output data
endmodule