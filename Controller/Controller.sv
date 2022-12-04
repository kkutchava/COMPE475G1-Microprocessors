//Controller
module Cotroller (
	input [31:0] instr,
	input [3:0]flags,
	output sY,
	output sX,
	output [1:0]ssrc1Mux,
	output regFile_wen,
	output DMEM_wen,
	output supdate_flags,
	output [3:0]sShifter,
	output [3:0]sALU
);
	//[21 22 23 24]     cmd
	//[26 27]           op
	//[25]              I bit
	//[4]               reg or shamt

	typedef enum logic [1:0] {DATA, MEMORY, BRANCH} opState;
	typedef enum logic [3:0] {AND, XOR, MINUS, revMINUS, PLUS, cPLUS, cMINUS, revcMINUS, TEST, TESTeq, CMP, nCMP, OR, SHIFTS, CLEAR, NOT} cmdState;
	opState op;
	cmdState cmd;
	
	always @(instr or flags) begin
		op = opState'(instr[27:26]);
		cmd = cmdState'(instr[24:21]);
		case(op)
			DATA: begin
				case(cmd)
					AND: begin
						sALU = 7;
					end
					
					XOR: begin
						sALU = 8;
					end
					
					MINUS: begin
						sALU = 2;
					end
					
					revMINUS: begin
						sALU = 3;
					end
					
					PLUS: begin
						sALU = 0;
					end
					
					cPLUS: begin
						sALU = 1;
					end
					
					cMINUS: begin
						sALU = 4;
					end
					
					revcMINUS: begin
						sALU = 5;
					end
					
					TEST: begin
						//set flags based on Rn & Src2
						sALU = 7; //AND
						supdate_flags = 1; //update flags
						ssrc1Mux = 2'b00; //choose Rn
					end
					
					TESTeq: begin
						//set flags based on Rn ^ Src2
						sALU = 8; //XOR
						supdate_flags = 1; //update flags
						ssrc1Mux = 2'b00; //choose Rn
					end
					
					CMP: begin
						//set flags based on Rn - Src2
						sALU = 2; //MINUS
						supdate_flags = 1; //update flags
						ssrc1Mux = 2'b00; //choose Rn
					end
					
					nCMP: begin
						//set flags based on Rn + Src2
						sALU = 0; //PLUS
						supdate_flags = 1; //update flags
						ssrc1Mux = 2'b00; //choose Rn
					end
					
					OR: begin
						sALU = 9;
					end
					
					SHIFTS: begin
						case(instr[25]) //I bit 25
							1'b0: begin //Immediate
								sShifter = 0; //rotImm8
							end
							
							1'b1: begin //
								case(instr[4]) 
									1'b0: begin //REG shifted by SHAMT5
										case(instr[6:5]) //shift type or ROT
											2'b00: begin //LSL
												
											end
											
											2'b01: begin // LSR
												
											end
											
											2'b10: begin //ASR
												
											end
											
											2'b11: begin 
												if (instr[11:7] == 0) begin //RRX
													
												end
													
												else begin //ROR
													
												end
											end
										endcase
									end
									
									1'b1: begin //REG shifted by REG
										case(instr[6:5]) //shift type or ROT
											2'b00: begin //LSL
												
											end
											
											2'b01: begin // LSR
												
											end
											
											2'b10: begin //ASR
												
											end
											
											2'b11: begin //ROR
												
											end
										endcase
									end
								endcase
							end
						endcase
					end
					
					CLEAR: begin
						sALU = 11;
					end
					
					NOT: begin
						sALU = 10;
					end
					
				endcase
			end
				
			MEMORY: begin
				//
			end
			
			BRANCH: begin
				//
			end
					
		endcase
	end

endmodule