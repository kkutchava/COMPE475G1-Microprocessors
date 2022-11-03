module testbench();
  logic [3:0] ard = 4'b1100, fj15 = 4'b0011, out;
  logic s = 0;
  Y inst(ard, fj15, s, out);
  
  
  
  initial begin
      $dumpfile("dump.vcd"); 
      $dumpvars(1);
    $display ("output is: %d",out);
    #100
    s = 1;
    $display ("output is: %d",out);
	#100;
  end
  
endmodule