module IMEM 
  (
    input [31:0] PC_Out, //from RF 15s reg data. 

    output [31:0] theInstruction //for now, I will pass the whole instruction
  );
  //logic [31:0] myInsr;
//16 words, words are 32 bits
  logic [31:0] mem [15:0]; //where do I get these values :D ?
  //example below worked and was for testing purposes, u can check it in the waveform:
  //assign mem[0] = 32'b11100000100000010000001100010010; //add r0,r1,r2,lsl r3
  
  
  
  //in the end, I have to have this values:
  //r0 = 36
  //r1 = 9
  //r2 = 0
  //mem11 = 9
  
  //btw, I am 27th # in 470L excel sheet
  
  //1. I will hardwire 9 to reg1
  //   adds r0, r1, #27 //put r1 + 27 to r0 and set flags //r0 = r1 + 27 = 9 + 27 = 36 //r0 = 36
  //   1110 00 1 0100 1 0001 0000 0000 00011011
  assign mem[0] = 32'b11100010100100010000000000011011;
  
  
  //2. subs r2, r0, r1 lsl #2 //r2 = r0 - r1<<2 //r2 = 36 - 9<<2 = 36 - 6'b100100 = 36 - 36 = 0
  //1110 00 0 0010 1 0000 0010 00010 00 0 0001
  assign mem[1] = 32'b11100000010100000010000100000001;
  
  
  //3. str r2, [r1, imm12] //store r2's value to the location r1 + imm12 // r1 + imm12 = 9 + 2 = 11 // mem11 = 9
  // cond op I P U B W L Rn   Rd   imm12
  // 1110 01 1 1 1 0 0 0 0001 0010 000000000010  cond op I P U B W L Rn Rd imm12
  assign mem[2] = 32'b11100111100000010010000000000010;
  
  
  
  //4. beq label //brench to label = PC+Imm24<<2 //r15 = 4 + 2<<2 = 12
  // my flags are nzvc - 0101, cond - 0000 - EQ Equal Z
  //0000 10 10 000000000000000000000110
  assign mem[3] = 32'b00001010000000000000000000000010; //10<<2 = 1000 => 1000 + 0011 = 1011

  
//Since we have only 16 words I will read only first 4 bits
  assign theInstruction = mem[PC_Out[3:0]];  //the whole instruction is sent
  
endmodule