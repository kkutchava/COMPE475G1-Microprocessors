module testbench();
  logic [31:0] rn = 250, rs = 130, pcout = 11, src1;
  logic [1:0] s = 0;
  src1mux inst(rn, rs, pcout, s, src1);
  
  
  
  initial begin
      $dumpfile("dump.vcd"); 
      $dumpvars(1);
    $display ("output is: %d",src1);
    #100
    s = 1;
    $display ("output is: %d",src1);
	#100;
    s = 2;
    $display ("output is: %d",src1);
	#100;
  end
  
endmodule