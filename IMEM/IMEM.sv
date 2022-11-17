module IMEM 
  (
    input [31:0] PC_Out, //from RF 15s reg data. 

    output [31:0] theInstruction //for now, I will pass the whole instruction
  );
  //logic [31:0] myInsr;
//16 words, words are 32 bits
  logic [31:0] mem [15:0]; //where do I get these values :D ?
  //for instance lets write some value at mem 7
  assign mem[7] = 32'b11100000100000010000001100010010; //add r0,r1,r2,lsl r3

  
//Since we have only 16 words I will read only first 4 bits
  assign theInstruction = mem[PC_Out[3:0]];  //the whole instruction is sent
  
endmodule