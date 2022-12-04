//ALU
module ALU(
	input [31:0] src1,
	input [31:0] src2,
	input carr, //carry from flags 
	input [3:0]controller, //idk what's coming here
	input c, //carry flag from shifter
	output [3:0] nzvc, //negative zero overflow carry
	output [31:0] RdData_OR_memAddr
);



	typedef enum logic [3:0] {PLUS, cPLUS, MINUS, revMINUS, cMINUS, revcMINUS, MULT, AND, XOR, OR, NOT, CLEAR, RRX} state;
	state myState;
	logic [31:0] answ;
	logic [32:0] plusansw = 0;
	logic [63:0] multansw = 0;
	logic temp, C = 0;
	
	always @(controller) begin
		//for next instruction they should be 0
		plusansw = 0;
		multansw = 0;
		myState = state'(controller);
		case(controller)
			
			PLUS: begin
				plusansw = src1 + src2; 
				answ = plusansw[31:0];
			end
			
			cPLUS: begin 
				plusansw = src1 + src2 + carr; //used carry which is set certainly, so here I use this
				answ = plusansw[31:0];
			end
				
			MINUS:
				answ = src1 - src2;
				
			revMINUS:
				answ = src2 - src1;
				
			cMINUS:
				answ = src1 - src2 - !carr;
				
			revcMINUS:
				answ = src2 - src1 - !carr;
				
			MULT: begin
				multansw = src1 * src2; 
				answ = multansw[31:0];
			end
			
			AND:
				answ = src1 & src2;
			
			XOR:
				answ = src1 ^ src2;
			
			OR:
				answ = src1 | src2;
				
			NOT:
				answ = ~src1;
			
			CLEAR:
				answ = src1 & ~src2;
			
			RRX: begin 
				answ = {answ[0], answ[31:1]}; //rotate by 1 bit
				temp = carr; //set temp to carry bit
				C = answ[31]; //set carry bit to 32th bit value
				answ[31] = temp; //set 32th bit to carry bit value
			end
				
		endcase
	end
	
	
		//negative in 2's complement
	assign nzvc[3] = (answ[31] == 1) ? 1 : 0;
		
		//set if the result of the flag-setting instruction is zero.
	assign nzvc[2] = (answ == 0) ? 1 : 0;
		
		//set if the sum two pos nums lead to neg num or visa versa
		//note: it only happens when we have addition, subtraction, or multiplication (+their variations), 
		//bitwise operation DO NOT set this flag (checked)
	assign nzvc[1] = (((myState == PLUS || myState == cPLUS || myState == MULT) &&
						  ((src1[31] == 0 && src2[31] == 0 && answ[31] == 1) ||  // (+) + (+) = (-)
						  (src1[31] == 1 && src2[31] == 1 && answ[31] == 0))) || // (-) + (-) = (+)
						  ((myState == MINUS || myState == cMINUS) && //=> 
						  ((src1[31] == 1 && src2[31] == 0 && answ[31] == 0)) || //(-) - (+) = (+)
						  (src1[31] == 0 && src2[31] == 1 && answ[31] == 1)) || //(+) - (-) = (-)
						  ((myState == revMINUS || myState == revcMINUS) && 
						  ((src1[31] == 0 && src2[31] == 1 && answ[31] == 0) || //(-) - (+) = (+)
						  (src1[31] == 1 && src2[31] == 0 && answ[31] == 1)))) ? 1 : 0; //=> (+) - (-) = (-)
						  
						  
		
		//set if addition produces carry 
		//C is set to 0 if the subtraction produced a borrow, and to 1 otherwise
		//set if multiplication is not fit in 32 bits
		//C is set to the last bit shifted out of the value by the shifter so it must be done in shifter
		//For the BORROW bit: B = not-X AND Y = X
	assign nzvc[0] = ((multansw[63:32] != 0) || 
						  (plusansw[32] != 0) || c || C || 
						  (((myState == MINUS || myState == cMINUS) && !(src2>src1))) || 
						  (((myState == revMINUS || myState == revcMINUS) && !(src1>src2)))) ? 1 : 0;
	
	//assign state = controller; 
	assign RdData_OR_memAddr = answ;
	
endmodule