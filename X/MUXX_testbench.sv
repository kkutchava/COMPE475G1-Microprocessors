module testbench();
  logic [3:0] rddormmaddr = 4'b1010, dm = 4'b0101, rddata;
  logic s = 0;
  X inst(rddormmaddr, dm, s, rddata);
  
  
  
  initial begin
      $dumpfile("dump.vcd"); 
      $dumpvars(1);
    $display ("output is: %d",rddata);
    #100
    s = 1;
    $display ("output is: %d",rddata);
	#100;
  end
  
endmodule