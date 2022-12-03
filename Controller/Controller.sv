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

	enum {DATA, MEMORY, BRANCH} opState;
	assign opState = instr[27:26];
	
	always @(instr or flags) begin
		case(opState)
			DATA: begin
				//
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