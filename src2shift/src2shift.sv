//src2shift
module src2shift(
	input [31:0] Rs,
	input [31:0] Rm,
	input [23:0] Imm24,
	input [3:0] opState, //from controller
	output [31:0] src2,
	output c //set here, must be sent out to ALU. C is set to the last bit shifted out of the value by the shifter, so it's welcome here
);

	//all cases - 12 (mod.: 11 !here!):
	//data - rot immediate8 - 1 case
	//data - reigster shamt5 - 5 cases (mod.: -1 RRX, see below why)
	//offtop: RRX will be done by ALU since it can not be done here
	//data - register-shifted register - 4 cases?
	//memory - imm12 - 1 case
	//memory - same as above - 0 cases
	//branching - imm24 - 1 case
	
	//*mod. explanation: RRX is moved to ALU, since the instruction requires
	//an access to the Rd, aka answ in ALU. It is not changing src2 and 
	//obviously not touching src1, it CHANGES ALU OUTPUT VALUE, and moreover it requires to set carry flag, 
	//so RRX has nothing to do here, it is moved out, gone, evicted, expeled, kicked out, banished, vertrieben
	
	//C/c aka carry is set here and then I am sending it to ALU 
	//apparently, carry flag is set when shifting happens and since
	//shifting is something that happens here (lol) I am gonna set it
	//here and sent it out. The last bit is set by first shiftng
	//original - 1 times, accessing this bit to be shifted and 
	//then shifting it out, so yeah dat's it.
	
	typedef enum logic [3:0]{rotImm8, shamt5LSL, shamt5LSR, shamt5ASR, 
			shamt5ROR, RsLSL, RsLSR, RsASR, RsROR, Imm12, BranchImm24, dirRm} state;
	state myState;
	//assign myState = opState;
	logic [31:0] answ;
	logic [31:0] immansw, shamt5RORansw, RsRORansw;
//	rightRotate inst({24'b000000000000000000000000, Imm24[7:0]},{1'b0,Imm24[11:8]},immansw);
//	rightRotate inst1(Rm,Imm24[11:7],shamt5RORansw);
//	rightRotate inst2(Rm,Rs[4:0],RsRORansw); 
	logic C; 
	
	assign c = C;
	assign src2 = answ;
	
	int count = 0;
	always @(opState) begin
		//myState = opState;
		case(opState)
			rotImm8: begin //rotate
				answ = {24'b000000000000000000000000, Imm24[7:0]};
				for (count = 0; count < 32; count = count + 1) begin
					if (count < Imm24[11:8]) answ = {answ[0], answ[31:1]}; //in case of MOV instr this won't exequte
				end
			end
			shamt5LSL: begin //Note.: 32 - imm24[11:7] and set C => answ[32 - imm24[11:7]]
				if (Imm24[11:7] != 0) begin
					C = Rm[32 - Imm24[11:7]];
					answ = Rm << (Imm24[11:7]); 
				end
			end
			shamt5LSR: begin
				if (Imm24[11:7] != 0) begin
					C = Rm[Imm24[11:7] - 1];
					answ = Rm >> (Imm24[11:7]);
				end
			end
			shamt5ASR: begin
				if (Imm24[11:7] != 0) begin
					C = Rm[Imm24[11:7] - 1];
					answ = Rm >>> (Imm24[11:7]);
				end
			end
			shamt5ROR: begin //rotate
				answ = Rm;
				for (count = 0; count < 32; count = count + 1) begin
					if (count < Imm24[11:7]) answ = {answ[0], answ[31:1]};
				end
			end
			RsLSL: begin
				if (Rs != 0) begin
					C = Rm[32 - Rs];
					answ = Rm << (Rs);
				end
			end
			RsLSR: begin
				if (Rs != 0) begin
					C = Rm[Rs - 1];
					answ = Rm >> (Rs);
				end
			end
			RsASR: begin
				if (Rs != 0) begin
					C = Rm[Rs - 1];
					answ = Rm >>> (Rs);
				end
			end
			RsROR: begin //rotate
				answ = Rm;
				for (count = 0; count < 32; count = count + 1) begin
					if (count < Rs[4:0]) answ = {answ[0], answ[31:1]}; //Rs[4:0] since it does not make sense to rotate more than 32 times
				end
			end
			Imm12:
				answ = {20'b00000000000000000000,Imm24[11:0]}; //must be 32 bits, so vawepep //also when adding imm val directly
			BranchImm24:
				answ = {8'b00000000,Imm24<<2}; //same idea - must be 32 bits. 2 shift because it was in slides
			dirRm: begin
				answ = Rm; //when adding two registers or something like that
			end
		endcase
	end
	
//this piece of code could be useful, if I changed the code, 
//I am not doing it, obviously, 
//but I put too much energy to just delete it like it does not worth anything
//::::
//	input [1:0] opState, //00 01 10 11 from controller
//	input I, //from controller (25th bit)	
//	case (state) 
//		DATA:
//			if (I) begin //1. immediate
//				///???
//			end
//			else begin 
//				if (!Imm24[4]) begin //2. register
//					if (Imm24[6:5] == 2'b00) begin //LSL
//						answ = Rm << Imm24[11:7];
//					end
//					if (Imm24[6:5] == 2'b01) begin //LSR
//						answ = Rm >> Imm24[11:7];
//					end
//					if (Imm24[6:5] == 2'b10) begin //ASR
//						answ = Rm >>> Imm24[11:7];
//					end
//					if (Imm24[6:5] == 2'b11 && Imm24[11:7] == 0) begin //RRX
//						//???
//					end
//					if (Imm24[6:5] == 2'b11 && Imm24[11:7] != 0) begin //ROR
//						//carry bit shift
//					end
//				end
//				else begin //3. register-shifted register
//					if (Imm24[6:5] == 2'b00) begin //LSL
//						answ = Rm << Rs;
//					end
//					if (Imm24[6:5] == 2'b01) begin //LSR
//						answ = Rm >> Rs;
//					end
//					if (Imm24[6:5] == 2'b10) begin //ASR
//						answ = Rm >>> Rs;
//					end
//					if (Imm24[6:5] == 2'b11 && Rs == 0) begin //RRX checking register
//						//???
//					end
//					if (Imm24[6:5] == 2'b11 && Rs != 0) begin //ROR checking register
//						//???
//					end
//				end
//			end
//		MEMORY:
//			if (Imm24[4]) begin //2. register
//				if (Imm24[6:5] == 2'b00) begin //LSL
//					answ = Rm << Imm24[11:7];
//				end
//				if (Imm24[6:5] == 2'b01) begin //LSR
//					answ = Rm >> Imm24[11:7];
//				end
//				if (Imm24[6:5] == 2'b10) begin //ASR
//					answ = Rm >>> Imm24[11:7];
//				end
//				if (Imm24[6:5] == 2'b11 && Imm24[11:7] == 0) begin //RRX
//					
//				end
//				if (Imm24[6:5] == 2'b11 && Imm24[11:7] != 0) begin //ROR
//					
//				end
//			end
//			else begin //3. register-shifted register
//				answ = {8'b00000000000000000000, IMmm24[11:0]};
//			end
//		BRANCH:
//			answ = {8'b00000000, IMmm24};
//	endcase
	
endmodule