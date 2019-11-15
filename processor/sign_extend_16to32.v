module sign_extend_16to32(extended_imm, immediate);
	input [16:0] immediate;
	output [31:0] extended_imm;
	
	assign extended_imm[16:0] = immediate;
	assign extended_imm[17] = immediate[16];
	assign extended_imm[18] = immediate[16];
	assign extended_imm[19] = immediate[16];
	assign extended_imm[20] = immediate[16];
	assign extended_imm[21] = immediate[16];
	assign extended_imm[22] = immediate[16];
	assign extended_imm[23] = immediate[16];
	assign extended_imm[24] = immediate[16];
	assign extended_imm[25] = immediate[16];
	assign extended_imm[26] = immediate[16];
	assign extended_imm[27] = immediate[16];
	assign extended_imm[28] = immediate[16];
	assign extended_imm[29] = immediate[16];
	assign extended_imm[30] = immediate[16];
	assign extended_imm[31] = immediate[16];
	
endmodule