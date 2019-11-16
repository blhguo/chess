module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB
);

   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg;

   output [31:0] data_readRegA, data_readRegB;
	wire ctrl_reset_not;
	// not myNot(ctrl_reset_not, ctrl_reset);
	assign ctrl_reset_not = ctrl_reset;
	
	wire [31:0] RS1, RS2;
	fivebit_demux RS1_demux(.five_in(ctrl_readRegA), .out0(RS1[0]), .out1(RS1[1]), .out2(RS1[2]), .out3(RS1[3]), .out4(RS1[4]), .out5(RS1[5]), .out6(RS1[6]), .out7(RS1[7]), .out8(RS1[8]), .out9(RS1[9]), .out10(RS1[10]), .out11(RS1[11]), .out12(RS1[12]), .out13(RS1[13]), .out14(RS1[14]), .out15(RS1[15]), .out16(RS1[16]), .out17(RS1[17]), .out18(RS1[18]), .out19(RS1[19]), .out20(RS1[20]), .out21(RS1[21]), .out22(RS1[22]), .out23(RS1[23]), .out24(RS1[24]), .out25(RS1[25]), .out26(RS1[26]), .out27(RS1[27]), .out28(RS1[28]), .out29(RS1[29]), .out30(RS1[30]), .out31(RS1[31]));
	fivebit_demux RS2_demux(.five_in(ctrl_readRegB), .out0(RS2[0]), .out1(RS2[1]), .out2(RS2[2]), .out3(RS2[3]), .out4(RS2[4]), .out5(RS2[5]), .out6(RS2[6]), .out7(RS2[7]), .out8(RS2[8]), .out9(RS2[9]), .out10(RS2[10]), .out11(RS2[11]), .out12(RS2[12]), .out13(RS2[13]), .out14(RS2[14]), .out15(RS2[15]), .out16(RS2[16]), .out17(RS2[17]), .out18(RS2[18]), .out19(RS2[19]), .out20(RS2[20]), .out21(RS2[21]), .out22(RS2[22]), .out23(RS2[23]), .out24(RS2[24]), .out25(RS2[25]), .out26(RS2[26]), .out27(RS2[27]), .out28(RS2[28]), .out29(RS2[29]), .out30(RS2[30]), .out31(RS2[31]));

	wire [31:0] RD;
	fivebit_demux RD_demux(.five_in(ctrl_writeReg), .out0(RD[0]), .out1(RD[1]), .out2(RD[2]), .out3(RD[3]), .out4(RD[4]), .out5(RD[5]), .out6(RD[6]), .out7(RD[7]), .out8(RD[8]), .out9(RD[9]), .out10(RD[10]), .out11(RD[11]), .out12(RD[12]), .out13(RD[13]), .out14(RD[14]), .out15(RD[15]), .out16(RD[16]), .out17(RD[17]), .out18(RD[18]), .out19(RD[19]), .out20(RD[20]), .out21(RD[21]), .out22(RD[22]), .out23(RD[23]), .out24(RD[24]), .out25(RD[25]), .out26(RD[26]), .out27(RD[27]), .out28(RD[28]), .out29(RD[29]), .out30(RD[30]), .out31(RD[31]));

	wire [31:0] WE32;

	wire [31:0] regout0, regout1, regout2, regout3, regout4, regout5, regout6, regout7, regout8, regout9, regout10, regout11, regout12, regout13, regout14, regout15, regout16, regout17, regout18, regout19, regout20, regout21, regout22, regout23, regout24, regout25, regout26, regout27, regout28, regout29, regout30, regout31;
	
	and WE_and0(WE32[0], RD[0], ctrl_writeEnable);
	and WE_and1(WE32[1], RD[1], ctrl_writeEnable);
	and WE_and2(WE32[2], RD[2], ctrl_writeEnable);
	and WE_and3(WE32[3], RD[3], ctrl_writeEnable);
	and WE_and4(WE32[4], RD[4], ctrl_writeEnable);
	and WE_and5(WE32[5], RD[5], ctrl_writeEnable);
	and WE_and6(WE32[6], RD[6], ctrl_writeEnable);
	and WE_and7(WE32[7], RD[7], ctrl_writeEnable);
	and WE_and8(WE32[8], RD[8], ctrl_writeEnable);
	and WE_and9(WE32[9], RD[9], ctrl_writeEnable);
	and WE_and10(WE32[10], RD[10], ctrl_writeEnable);
	and WE_and11(WE32[11], RD[11], ctrl_writeEnable);
	and WE_and12(WE32[12], RD[12], ctrl_writeEnable);
	and WE_and13(WE32[13], RD[13], ctrl_writeEnable);
	and WE_and14(WE32[14], RD[14], ctrl_writeEnable);
	and WE_and15(WE32[15], RD[15], ctrl_writeEnable);
	and WE_and16(WE32[16], RD[16], ctrl_writeEnable);
	and WE_and17(WE32[17], RD[17], ctrl_writeEnable);
	and WE_and18(WE32[18], RD[18], ctrl_writeEnable);
	and WE_and19(WE32[19], RD[19], ctrl_writeEnable);
	and WE_and20(WE32[20], RD[20], ctrl_writeEnable);
	and WE_and21(WE32[21], RD[21], ctrl_writeEnable);
	and WE_and22(WE32[22], RD[22], ctrl_writeEnable);
	and WE_and23(WE32[23], RD[23], ctrl_writeEnable);
	and WE_and24(WE32[24], RD[24], ctrl_writeEnable);
	and WE_and25(WE32[25], RD[25], ctrl_writeEnable);
	and WE_and26(WE32[26], RD[26], ctrl_writeEnable);
	and WE_and27(WE32[27], RD[27], ctrl_writeEnable);
	and WE_and28(WE32[28], RD[28], ctrl_writeEnable);
	and WE_and29(WE32[29], RD[29], ctrl_writeEnable);
	and WE_and30(WE32[30], RD[30], ctrl_writeEnable);
	and WE_and31(WE32[31], RD[31], ctrl_writeEnable);
	
	
	register register0(clock, WE32[0], data_writeReg, regout0, 1'b1);
	register register1(clock, WE32[1], data_writeReg, regout1, ctrl_reset_not);
	register register2(clock, WE32[2], data_writeReg, regout2, ctrl_reset_not);
	register register3(clock, WE32[3], data_writeReg, regout3, ctrl_reset_not);
	register register4(clock, WE32[4], data_writeReg, regout4, ctrl_reset_not);
	register register5(clock, WE32[5], data_writeReg, regout5, ctrl_reset_not);
	register register6(clock, WE32[6], data_writeReg, regout6, ctrl_reset_not);
	register register7(clock, WE32[7], data_writeReg, regout7, ctrl_reset_not);
	register register8(clock, WE32[8], data_writeReg, regout8, ctrl_reset_not);
	register register9(clock, WE32[9], data_writeReg, regout9, ctrl_reset_not);
	register register10(clock, WE32[10], data_writeReg, regout10, ctrl_reset_not);
	register register11(clock, WE32[11], data_writeReg, regout11, ctrl_reset_not);
	register register12(clock, WE32[12], data_writeReg, regout12, ctrl_reset_not);
	register register13(clock, WE32[13], data_writeReg, regout13, ctrl_reset_not);
	register register14(clock, WE32[14], data_writeReg, regout14, ctrl_reset_not);
	register register15(clock, WE32[15], data_writeReg, regout15, ctrl_reset_not);
	register register16(clock, WE32[16], data_writeReg, regout16, ctrl_reset_not);
	register register17(clock, WE32[17], data_writeReg, regout17, ctrl_reset_not);
	register register18(clock, WE32[18], data_writeReg, regout18, ctrl_reset_not);
	register register19(clock, WE32[19], data_writeReg, regout19, ctrl_reset_not);
	register register20(clock, WE32[20], data_writeReg, regout20, ctrl_reset_not);
	register register21(clock, WE32[21], data_writeReg, regout21, ctrl_reset_not);
	register register22(clock, WE32[22], data_writeReg, regout22, ctrl_reset_not);
	register register23(clock, WE32[23], data_writeReg, regout23, ctrl_reset_not);
	register register24(clock, WE32[24], data_writeReg, regout24, ctrl_reset_not);
	register register25(clock, WE32[25], data_writeReg, regout25, ctrl_reset_not);
	register register26(clock, WE32[26], data_writeReg, regout26, ctrl_reset_not);
	register register27(clock, WE32[27], data_writeReg, regout27, ctrl_reset_not);
	register register28(clock, WE32[28], data_writeReg, regout28, ctrl_reset_not);
	register register29(clock, WE32[29], data_writeReg, regout29, ctrl_reset_not);
	register register30(clock, WE32[30], data_writeReg, regout30, ctrl_reset_not);
	register register31(clock, WE32[31], data_writeReg, regout31, ctrl_reset_not);
	
	
	wire [31:0] triReg0, triReg1, triReg2, triReg3, triReg4, triReg5, triReg6, triReg7, triReg8, triReg9, triReg10, triReg11, triReg12, triReg13, triReg14, triReg15, triReg16, triReg17, triReg18, triReg19, triReg20, triReg21, triReg22, triReg23, triReg24, triReg25, triReg26, triReg27, triReg28, triReg29, triReg30, triReg31;
	assign triReg0 = RS1[0] ? regout0 : 32'bz;
	assign triReg1 = RS1[1] ? regout1 : 32'bz;
	assign triReg2 = RS1[2] ? regout2 : 32'bz;
	assign triReg3 = RS1[3] ? regout3 : 32'bz;
	assign triReg4 = RS1[4] ? regout4 : 32'bz;
	assign triReg5 = RS1[5] ? regout5 : 32'bz;
	assign triReg6 = RS1[6] ? regout6 : 32'bz;
	assign triReg7 = RS1[7] ? regout7 : 32'bz;
	assign triReg8 = RS1[8] ? regout8 : 32'bz;
	assign triReg9 = RS1[9] ? regout9 : 32'bz;
	assign triReg10 = RS1[10] ? regout10 : 32'bz;
	assign triReg11 = RS1[11] ? regout11 : 32'bz;
	assign triReg12 = RS1[12] ? regout12 : 32'bz;
	assign triReg13 = RS1[13] ? regout13 : 32'bz;
	assign triReg14 = RS1[14] ? regout14 : 32'bz;
	assign triReg15 = RS1[15] ? regout15 : 32'bz;
	assign triReg16 = RS1[16] ? regout16 : 32'bz;
	assign triReg17 = RS1[17] ? regout17 : 32'bz;
	assign triReg18 = RS1[18] ? regout18 : 32'bz;
	assign triReg19 = RS1[19] ? regout19 : 32'bz;
	assign triReg20 = RS1[20] ? regout20 : 32'bz;
	assign triReg21 = RS1[21] ? regout21 : 32'bz;
	assign triReg22 = RS1[22] ? regout22 : 32'bz;
	assign triReg23 = RS1[23] ? regout23 : 32'bz;
	assign triReg24 = RS1[24] ? regout24 : 32'bz;
	assign triReg25 = RS1[25] ? regout25 : 32'bz;
	assign triReg26 = RS1[26] ? regout26 : 32'bz;
	assign triReg27 = RS1[27] ? regout27 : 32'bz;
	assign triReg28 = RS1[28] ? regout28 : 32'bz;
	assign triReg29 = RS1[29] ? regout29 : 32'bz;
	assign triReg30 = RS1[30] ? regout30 : 32'bz;
	assign triReg31 = RS1[31] ? regout31 : 32'bz;
	
	
	wire [31:0] triReg2_0, triReg2_1, triReg2_2, triReg2_3, triReg2_4, triReg2_5, triReg2_6, triReg2_7, triReg2_8, triReg2_9, triReg2_10, triReg2_11, triReg2_12, triReg2_13, triReg2_14, triReg2_15, triReg2_16, triReg2_17, triReg2_18, triReg2_19, triReg2_20, triReg2_21, triReg2_22, triReg2_23, triReg2_24, triReg2_25, triReg2_26, triReg2_27, triReg2_28, triReg2_29, triReg2_30, triReg2_31;
	assign triReg2_0 = RS2[0] ? regout0 : 32'bz;
	assign triReg2_1 = RS2[1] ? regout1 : 32'bz;
	assign triReg2_2 = RS2[2] ? regout2 : 32'bz;
	assign triReg2_3 = RS2[3] ? regout3 : 32'bz;
	assign triReg2_4 = RS2[4] ? regout4 : 32'bz;
	assign triReg2_5 = RS2[5] ? regout5 : 32'bz;
	assign triReg2_6 = RS2[6] ? regout6 : 32'bz;
	assign triReg2_7 = RS2[7] ? regout7 : 32'bz;
	assign triReg2_8 = RS2[8] ? regout8 : 32'bz;
	assign triReg2_9 = RS2[9] ? regout9 : 32'bz;
	assign triReg2_10 = RS2[10] ? regout10 : 32'bz;
	assign triReg2_11 = RS2[11] ? regout11 : 32'bz;
	assign triReg2_12 = RS2[12] ? regout12 : 32'bz;
	assign triReg2_13 = RS2[13] ? regout13 : 32'bz;
	assign triReg2_14 = RS2[14] ? regout14 : 32'bz;
	assign triReg2_15 = RS2[15] ? regout15 : 32'bz;
	assign triReg2_16 = RS2[16] ? regout16 : 32'bz;
	assign triReg2_17 = RS2[17] ? regout17 : 32'bz;
	assign triReg2_18 = RS2[18] ? regout18 : 32'bz;
	assign triReg2_19 = RS2[19] ? regout19 : 32'bz;
	assign triReg2_20 = RS2[20] ? regout20 : 32'bz;
	assign triReg2_21 = RS2[21] ? regout21 : 32'bz;
	assign triReg2_22 = RS2[22] ? regout22 : 32'bz;
	assign triReg2_23 = RS2[23] ? regout23 : 32'bz;
	assign triReg2_24 = RS2[24] ? regout24 : 32'bz;
	assign triReg2_25 = RS2[25] ? regout25 : 32'bz;
	assign triReg2_26 = RS2[26] ? regout26 : 32'bz;
	assign triReg2_27 = RS2[27] ? regout27 : 32'bz;
	assign triReg2_28 = RS2[28] ? regout28 : 32'bz;
	assign triReg2_29 = RS2[29] ? regout29 : 32'bz;
	assign triReg2_30 = RS2[30] ? regout30 : 32'bz;
	assign triReg2_31 = RS2[31] ? regout31 : 32'bz;
	
	assign data_readRegA = triReg0;
	assign data_readRegA = triReg1;
	assign data_readRegA = triReg2;
	assign data_readRegA = triReg3;
	assign data_readRegA = triReg4;
	assign data_readRegA = triReg5;
	assign data_readRegA = triReg6;
	assign data_readRegA = triReg7;
	assign data_readRegA = triReg8;
	assign data_readRegA = triReg9;
	assign data_readRegA = triReg10;
	assign data_readRegA = triReg11;
	assign data_readRegA = triReg12;
	assign data_readRegA = triReg13;
	assign data_readRegA = triReg14;
	assign data_readRegA = triReg15;
	assign data_readRegA = triReg16;
	assign data_readRegA = triReg17;
	assign data_readRegA = triReg18;
	assign data_readRegA = triReg19;
	assign data_readRegA = triReg20;
	assign data_readRegA = triReg21;
	assign data_readRegA = triReg22;
	assign data_readRegA = triReg23;
	assign data_readRegA = triReg24;
	assign data_readRegA = triReg25;
	assign data_readRegA = triReg26;
	assign data_readRegA = triReg27;
	assign data_readRegA = triReg28;
	assign data_readRegA = triReg29;
	assign data_readRegA = triReg30;
	assign data_readRegA = triReg31;
	
	assign data_readRegB = triReg2_0;
	assign data_readRegB = triReg2_1;
	assign data_readRegB = triReg2_2;
	assign data_readRegB = triReg2_3;
	assign data_readRegB = triReg2_4;
	assign data_readRegB = triReg2_5;
	assign data_readRegB = triReg2_6;
	assign data_readRegB = triReg2_7;
	assign data_readRegB = triReg2_8;
	assign data_readRegB = triReg2_9;
	assign data_readRegB = triReg2_10;
	assign data_readRegB = triReg2_11;
	assign data_readRegB = triReg2_12;
	assign data_readRegB = triReg2_13;
	assign data_readRegB = triReg2_14;
	assign data_readRegB = triReg2_15;
	assign data_readRegB = triReg2_16;
	assign data_readRegB = triReg2_17;
	assign data_readRegB = triReg2_18;
	assign data_readRegB = triReg2_19;
	assign data_readRegB = triReg2_20;
	assign data_readRegB = triReg2_21;
	assign data_readRegB = triReg2_22;
	assign data_readRegB = triReg2_23;
	assign data_readRegB = triReg2_24;
	assign data_readRegB = triReg2_25;
	assign data_readRegB = triReg2_26;
	assign data_readRegB = triReg2_27;
	assign data_readRegB = triReg2_28;
	assign data_readRegB = triReg2_29;
	assign data_readRegB = triReg2_30;
	assign data_readRegB = triReg2_31;

/* YOUR CODE HERE */

endmodule
