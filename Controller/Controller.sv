//Controller
module Cotroller (
	input [31:0] instr,
	input [3:0]falgs, //nzvc
	output sY,
	output sX,
	output [1:0]ssrc1Mux,
	output regFile_wen,
	output DMEM_wen,
	output supdate_flags,
	output [3:0]sShifter,
	output [3:0]sALU,
	output sA,
	output sB
);
	
	
	logic sY0;
	logic sX0;
	logic [1:0]ssrc1Mux0;
	logic regFile_wen0;
	logic DMEM_wen0;
	logic supdate_flags0;
	logic [3:0]sShifter0;
	logic [3:0]sALU0;
	logic sA0;
	logic sB0;

	typedef enum logic [1:0] {DATA, MEMORY, BRANCH} opState;
	typedef enum logic [3:0] {AND, XOR, MINUS, revMINUS, PLUS, cPLUS, cMINUS, revcMINUS, TEST, TESTeq, CMP, nCMP, OR, SHIFTS, CLEAR, NOT} cmdState;
	opState op;
	cmdState cmd;
	logic enable = 0; //enable based on cond and flags conditions
	
	//1. assign sY0 = 
	//2. always for sY00 
	//3. default values for outputs in the beginning of every always block
	
	//for flags condition
	always @(instr) begin
		case(instr[31:28]) //nzvc
			4'b0000: begin //EQ Equal Z
				if (falgs[2] == 1) enable = 1;
				else enable = 0;
			end
			
			4'b0001: begin //NE Not equal ~Z
				if (falgs[2] != 1) enable = 1;
				else enable = 0;
			end
			
			4'b0010: begin //CS/HS Carry set / unsigned higher or same C
				if (falgs[0] == 1) enable = 1;
				else enable = 0;
			end
			
			4'b0011: begin //CC/LO Carry clear / unsigned lower ~C
				if (falgs[0] != 1) enable = 1;
				else enable = 0;
			end
			
			4'b0100: begin //MI Minus / negative N
				if (falgs[3] == 1) enable = 1;
				else enable = 0;
			end
			
			4'b0101: begin //PL Plus / positive or zero ~N
				if (falgs[3] != 1) enable = 1;
				else enable = 0;
			end
			
			4'b0110: begin //Overflow / overflow set V
				if (falgs[1] == 1) enable = 1;
				else enable = 0;
			end
			
			4'b0111: begin //No overflow / overflow clear ~V
				if (falgs[1] != 1) enable = 1;
				else enable = 0;
			end
			
			4'b1000: begin //HI Unsigned higher (~Z)C
				if ((!falgs[2])&falgs[0]) enable = 1;
				else enable = 0;
			end
			
			4'b1001: begin //LS Unsigned lower or same Z OR ~C
				if (falgs[2]|(!falgs[0])) enable = 1;
				else enable = 0;
			end
			
			4'b1010: begin //GE Signed greater than or equal ~(N⊕V)
				if (!(falgs[3]^falgs[1])) enable = 1;
				else enable = 0;
			end
			
			4'b1011: begin // LT Signed less than N⊕V
				if (falgs[3]^falgs[1]) enable = 1;
				else enable = 0;
			end
			
			4'b1100: begin // GT Signed greater than ~Z~(N⊕V)
				if ((!(falgs[3]^falgs[1]))&(!falgs[2])) enable = 1;
				else enable = 0;
			end
			
			4'b1101: begin //LE Signed less than or equal Z OR (N⊕V)
				if ((falgs[3]^falgs[1])|(falgs[2])) enable = 1;
				else enable = 0;
			end
			
			4'b1110: begin //always
				enable = 1;
			end
		endcase
	end
	
	
	//we should check input flags if they match with condition codes and set enable accordingly
	always @(enable or instr) begin
		//all writes should be diabled (wens) if not stated otherwise
		//since it is something that couses the issue of writing some values at
		//undesired locations, so if we disable them, even if we set some instruqtion
		//and it is following the previous case, it won't be a problem since 
		//nothing "actually" gonna change, the old values will be left on the wires
		//and it won't be affecting anything and when needed we will just modify them
		regFile_wen0 = 0;
		DMEM_wen0 = 0;
		supdate_flags0 = 0;
		//also this should be by default and only change when we have branching instruction, for 
		//any oterh instructions we 
		//input with sA PC+1 from pcINC
		//input with sB ALU data 
		sA0 = 0; //regularly write PC_OUT
		sB0 = 1; //regularly write ALU data
		if (enable) begin
			op = opState'(instr[27:26]);
			cmd = cmdState'(instr[24:21]);
			case(op)
				DATA, 2'b11: begin
				/////////////////////////////
					//I think this part should be here as well because every shift operation
					//hapens for every other operation. src2 is defined by shifter therefore if no shift happens it
					//should be defined in the instruction 11:0 bits. So if shift does not happen it is decided not here
					//but in the shifter module itself
				////////////////////////////
					///////////////
						case(instr[25]) //I bit 25
							1'b1: begin //Immediate case I = 1
								sShifter0 = 0; //rotImm8
							end
							
							1'b0: begin //case I = 0
								case(instr[4]) 
									1'b0: begin //REG shifted by SHAMT5
										case(instr[6:5]) //shift type or ROT
											2'b00: begin //LSL
												sShifter0 = 1; 
											end
											
											2'b01: begin // LSR
												sShifter0 = 2; 
											end
											
											2'b10: begin //ASR
												sShifter0 = 3; 
											end
											
											2'b11: begin //ROR
												sShifter0 = 4;
											end
										endcase
									end
									
									1'b1: begin //REG shifted by REG
										case(instr[6:5]) //shift type or ROT
											2'b00: begin //LSL
												sShifter0 = 5; 
											end
											
											2'b01: begin // LSR
												sShifter0 = 6; 
											end
											
											2'b10: begin //ASR
												sShifter0 = 7; 
											end
											
											2'b11: begin //ROR
												sShifter0 = 8; 
											end
										endcase
									end
								endcase
							end
						endcase
					
					///////////////
				///////////////////////////

					ssrc1Mux0 = 2'b00; // choosing Rn for data access
					if (instr[20]) supdate_flags0 = 1;//S bit set flags bit
					else supdate_flags0 = 0; //0 otherwise, however it is already set, just to make sure
					sX0 = 0; //give reg file RD data
					sY0 = 0; //write to data from ALU to the Destination Register
					regFile_wen0 = 1; //enable to write to the register Rd
					
					
					//I won't use identifieer instr[7:4] = 1001, instead, I will use op = 11
					//to define multiplication, so now every other shift type for the secondd
					//operand could be defined for the multiplication as well
					//instr[27:26] == 2'b11 && instr[25:24] == 2'b00 && instr[23:21] == 3'b000
					if (instr[27:26] == 2'b11 && instr[25:24] == 2'b00 && instr[23:21] == 3'b000) begin //MUL INSTRUCTION
						//Rd = Rn * Rm
						sALU0 = 6; //MULT instruction
					end
					else begin
						case(cmd)
							AND: begin
								sALU0 = 7;
							end
							
							XOR: begin
								sALU0 = 8;
							end
							
							MINUS: begin
								sALU0 = 2;
							end
							
							revMINUS: begin
								sALU0 = 3;
							end
							
							PLUS: begin
								sALU0 = 0;
							end
							
							cPLUS: begin
								sALU0 = 1;
							end
							
							cMINUS: begin
								sALU0 = 4;
							end
							
							revcMINUS: begin
								sALU0 = 5;
							end
							
							TEST: begin
								//set flags based on Rn & Src2
								sALU0 = 7; //AND
								supdate_flags0 = 1; //update flags
								ssrc1Mux0 = 2'b00; //choose Rn
							end
							
							TESTeq: begin
								//set flags based on Rn ^ Src2
								sALU0 = 8; //XOR
								supdate_flags0 = 1; //update flags
								ssrc1Mux0 = 2'b00; //choose Rn
							end
							
							CMP: begin
								//set flags based on Rn - Src2
								sALU0 = 2; //MINUS
								supdate_flags0 = 1; //update flags
								ssrc1Mux0 = 2'b00; //choose Rn
							end
							
							nCMP: begin
								//set flags based on Rn + Src2
								sALU0 = 0; //PLUS
								supdate_flags0 = 1; //update flags
								ssrc1Mux0 = 2'b00; //choose Rn
							end
							
							OR: begin
								sALU0 = 9;
							end
							
							SHIFTS: begin
								sALU0 = 13; //because src2 is directly assigned to output Rd in ALU and we shifted them in src2shift
								case(instr[25]) //I bit 25
									//this case also involves MOVE instr since when I = 0 and instr[11:4] is 0 we have MOVE
									//and rot value instr[11:8] is also 0 meaning we won't have any rotations and also 
									//it is the case of rotImm8 and only instr[3:0] will be used for the imm value
									1'b1: begin //Immediate case I = 1
										sShifter0 = 0; //rotImm8
									end
									
									1'b0: begin //case I = 0
										case(instr[4]) 
											1'b0: begin //REG shifted by SHAMT5
												case(instr[6:5]) //shift type or ROT
													2'b00: begin //LSL
														sShifter0 = 1; 
													end
													
													2'b01: begin // LSR
														sShifter0 = 2; 
													end
													
													2'b10: begin //ASR
														sShifter0 = 3; 
													end
													
													2'b11: begin 
														if (instr[11:7] == 0) begin //RRX
															sALU0 = 12;
														end
															
														else begin //ROR
															sShifter0 = 4;
														end
													end
												endcase
											end
											
											1'b1: begin //REG shifted by REG
												case(instr[6:5]) //shift type or ROT
													2'b00: begin //LSL
														sShifter0 = 5; 
													end
													
													2'b01: begin // LSR
														sShifter0 = 6; 
													end
													
													2'b10: begin //ASR
														sShifter0 = 7; 
													end
													
													2'b11: begin //ROR
														sShifter0 = 8; 
													end
												endcase
											end
										endcase
									end
								endcase
							end
							
							CLEAR: begin
								sALU0 = 11;
							end
							
							NOT: begin
								sALU0 = 10;
							end
							
						endcase
					end
				end
					
				MEMORY: begin
					//during memory instruction src1 = Rn
					ssrc1Mux0 = 2'b00;
					//case U (23) 0 for min 1 for + 
					case(instr[23])
						1'b0: begin //MINUS
							sALU0 = 2;
						end
						
						1'b1: begin //PLUS
							sALU0 = 0;
						end
					endcase
					
					
					//case L (20) 1 for load  0 for store
					case(instr[20])
						1'b0: begin //STORE = WRITE
							DMEM_wen0 = 1; //enable write
							sY0 = 0; //give ARd as input to Reg_FILE
						end
						
						1'b1: begin //LOAD = READ
							DMEM_wen0 = 0; //disable write???
							sX0 = 1; //MUXX chooses data from memory to store in reg-s
							regFile_wen0 = 1; //enable to write to reg_FILE
							sY0 = 0; //give ARd as input to Reg_FILE
						end
					endcase
					
					
					//we have ONLY CASE PW=10 : Offset= base + offset, offset stays
					//and we only have case B 0 for 32 bit memory operations
					
					//choosing src2
					case(!instr[25]) //!I net I so it's reverse I 25 bit
						1'b0: begin
							sShifter0 = 9; //Imm12 
						end
						
						1'b1: begin
							case(instr[6:5]) //shift type or ROT
								2'b00: begin //LSL
									sShifter0 = 1; 
								end
								
								2'b01: begin // LSR
									sShifter0 = 2; 
								end
												
								2'b10: begin //ASR
									sShifter0 = 3; 
								end
												
								2'b11: begin 
									sShifter0 = 4; //ROR
								end
							endcase
						end
					endcase
				end
				
				BRANCH: begin
					sShifter0 = 10; //src2 = BranchImm24 = Imm24<<2
					ssrc1Mux0 = 2'b10; //src1 = PC_Out
					sALU0 = 0; //PLUS => src1+src2 = PC_OUT + Imm24<<2
					sX0 = 0; //RD data or memory address
					case(instr[24])
						1'b0: begin //branch
							sA0 = 1; //ALU_data
							sB0 = 0; //does not matter since:
							regFile_wen0 = 0; //that's why it doesn't matter
						end
						
						1'b1: begin //branch with link
							sA0 = 1; //reg file gets SP = PC_OUT + Imm24<<2
							sB0 = 0; //PC_Out Data + 1 (it should pass pcINC, so I will need two instance of that)
							regFile_wen0 = 1; //enable to write
							sY0 = 1; //write to reg 14
						end
					endcase
				end
						
			endcase
		end
	end
	
	assign sY = sY0;
	assign sX = sX0;
	assign ssrc1Mux = ssrc1Mux0;
	assign regFile_wen = regFile_wen0;
	assign DMEM_wen = DMEM_wen0;
	assign supdate_flags = supdate_flags0;
	assign sShifter = sShifter0;
	assign sALU = sALU0;
	assign sA = sA0;
	assign sB = sB0;

endmodule