module detectOverflow(isA0, in33, in32, overflow);
	input [32:0] in33;
	input [31:0] in32;
	input isA0;
	output overflow;
	
	wire w1, w2, w3;
	nand big_nand(w1, in33[32], in32[31], in32[30], in32[29], in32[28], in32[27], in32[26], in32[25], in32[24], in32[23], in32[22], in32[21], in32[20], in32[19], in32[18], in32[17], in32[16], in32[15], in32[14], in32[13], in32[12], in32[11], in32[10], in32[9], in32[8], in32[7], in32[6], in32[5], in32[4], in32[3], in32[2], in32[1], in32[0]);
	or big_or(w2, in33[32], in32[31], in32[30], in32[29], in32[28], in32[27], in32[26], in32[25], in32[24], in32[23], in32[22], in32[21], in32[20], in32[19], in32[18], in32[17], in32[16], in32[15], in32[14], in32[13], in32[12], in32[11], in32[10], in32[9], in32[8], in32[7], in32[6], in32[5], in32[4], in32[3], in32[2], in32[1], in32[0]);
	not AisNot0(w3, isA0);
	and overflowand(overflow, w1, w2, w3);
endmodule