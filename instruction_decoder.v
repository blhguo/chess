module instruction_decoder(R, I, JI, JII, opcode, rd, rs, rt, shiftamt, aluop, immediate, target, instruction);
	input [31:0] instruction;
	output [4:0] opcode, rd, rs, rt, shiftamt, aluop;
	output [16:0] immediate;
	output [26:0] target;
	output R, I, JI, JII;
		
	assign opcode = instruction[31:27];
	/*
	assign rd = instruction[26:22];
	assign rs = instruction[21:17];
	assign rt = instruction[16:12];
	assign shiftamt = instruction[11:7];
	assign aluop = instruction[6:2];
	assign immediate = instruction[16:0];
	assign target = instruction[26:0];
	*/
	
	wire [4:0] opNot;
	twos_complement_flipper5 opcodeFlipper(opcode, opNot);
	
	and R_And(R, opNot[4], opNot[3], opNot[2], opNot[1], opNot[0]);
	
	wire I_and1, I_and2, I_and3;
	and I1_and(I_and1, opNot[4], opNot[3], opcode[1], opNot[0]);
	and I2_and(I_and2, opNot[4], opNot[3], opcode[2], opcode[0]);
	and I3_and(I_and3, opNot[4], opcode[3], opNot[2], opNot[1], opNot[0]);

	or I_or(I, I_and1, I_and2, I_and3);
	
	wire JI_and1, JI_and2, JI_and3;
	and JI1_and(JI_and1, opNot[4], opNot[3], opNot[2], opcode[0]);
	and JI2_and(JI_and2, opcode[4], opNot[3], opcode[2], opNot[1], opcode[0]);
	and JI3_and(JI_and3, opcode[4], opNot[3], opcode[2], opcode[1], opNot[0]);

	or JI_or(JI, JI_and1, JI_and2, JI_and3);
	
	and JII_And(JII, opNot[4], opNot[3], opcode[2], opNot[1], opNot[0]);

	//#########################################################################//
	wire is_sw;
	and is_sw_and(is_sw, opNot[4], opNot[3], opcode[2], opcode[1], opcode[0]);
	
	wire is_j;
	and is_j_and(is_j, opNot[4], opNot[3], opNot[2], opNot[1], opcode[0]);
	
	wire is_lw;
	and is_lw_and(is_lw, opNot[4], opcode[3], opNot[2], opNot[1], opNot[0]);
	
	wire is_BNE;
	wire is_BLT;
	and is_BNE_and(is_BNE, opNot[4], opNot[3], opNot[2], opcode[1], opNot[0]);
	and is_BLT_and(is_BLT, opNot[4], opNot[3], opcode[2], opcode[1], opNot[0]);
	
	wire is_jal;
	and is_jal_and(is_jal, opNot[4], opNot[3], opNot[2], opcode[1], opcode[0]);
	
	wire is_jr;
	and is_jr_and(is_jr, opNot[4], opNot[3], opcode[2], opNot[1], opNot[0]);
	
	wire is_bex;
	and is_bex_and(is_bex, opcode[4], opNot[3], opcode[2], opcode[1], opNot[0]);
	
	wire is_setx;
	and is_setx_and(is_setx, opcode[4], opNot[3], opcode[2], opNot[1], opcode[0]);
	
	wire isBNE_or_isBLT;
	or isBNE_or_isBLT_or(isBNE_or_isBLT, is_BNE, is_BLT);
	
	wire is_standard;
	nor is_s_nor(is_standard, is_sw, is_BNE, is_BLT, is_jr, is_bex, is_jal, is_setx, is_j, isBNE_or_isBLT);
	//########################################################################//
	
	assign rd = is_standard ? instruction[26:22] : is_setx ? 5'd30 : is_jal ? 5'd31 : 5'd0;
	assign rs = is_jr ? instruction[26:22] : is_bex ? 5'b11110 : isBNE_or_isBLT ? instruction[26:22] : instruction[21:17];
	assign rt = is_standard ? instruction[16:12] : isBNE_or_isBLT ? instruction[21:17] : instruction[26:22];
	assign shiftamt = instruction[11:7];
	assign aluop = instruction[6:2];
	assign immediate = instruction[16:0];
	assign target = instruction[26:0];
	
endmodule