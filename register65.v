module register65 (
    clk,
    input_enable,
    in65, out65, clr
);

   input clk, input_enable, clr;
   input [64:0] in65;

   output [64:0] out65;
	//wire input_enable;
	//and input_enable_gate(input_enable, clk, input_enable);
	wire [64:0] temp65;
	
    dffe_ref dffe64(temp65[64], in65[64], clk, input_enable, clr);
    dffe_ref dffe63(temp65[63], in65[63], clk, input_enable, clr);
    dffe_ref dffe62(temp65[62], in65[62], clk, input_enable, clr);
    dffe_ref dffe61(temp65[61], in65[61], clk, input_enable, clr);
    dffe_ref dffe60(temp65[60], in65[60], clk, input_enable, clr);
    dffe_ref dffe59(temp65[59], in65[59], clk, input_enable, clr);
    dffe_ref dffe58(temp65[58], in65[58], clk, input_enable, clr);
    dffe_ref dffe57(temp65[57], in65[57], clk, input_enable, clr);
    dffe_ref dffe56(temp65[56], in65[56], clk, input_enable, clr);
    dffe_ref dffe55(temp65[55], in65[55], clk, input_enable, clr);
    dffe_ref dffe54(temp65[54], in65[54], clk, input_enable, clr);
    dffe_ref dffe53(temp65[53], in65[53], clk, input_enable, clr);
    dffe_ref dffe52(temp65[52], in65[52], clk, input_enable, clr);
    dffe_ref dffe51(temp65[51], in65[51], clk, input_enable, clr);
    dffe_ref dffe50(temp65[50], in65[50], clk, input_enable, clr);
    dffe_ref dffe49(temp65[49], in65[49], clk, input_enable, clr);
    dffe_ref dffe48(temp65[48], in65[48], clk, input_enable, clr);
    dffe_ref dffe47(temp65[47], in65[47], clk, input_enable, clr);
    dffe_ref dffe46(temp65[46], in65[46], clk, input_enable, clr);
    dffe_ref dffe45(temp65[45], in65[45], clk, input_enable, clr);
    dffe_ref dffe44(temp65[44], in65[44], clk, input_enable, clr);
    dffe_ref dffe43(temp65[43], in65[43], clk, input_enable, clr);
    dffe_ref dffe42(temp65[42], in65[42], clk, input_enable, clr);
    dffe_ref dffe41(temp65[41], in65[41], clk, input_enable, clr);
    dffe_ref dffe40(temp65[40], in65[40], clk, input_enable, clr);
    dffe_ref dffe39(temp65[39], in65[39], clk, input_enable, clr);
    dffe_ref dffe38(temp65[38], in65[38], clk, input_enable, clr);
    dffe_ref dffe37(temp65[37], in65[37], clk, input_enable, clr);
    dffe_ref dffe36(temp65[36], in65[36], clk, input_enable, clr);
    dffe_ref dffe35(temp65[35], in65[35], clk, input_enable, clr);
    dffe_ref dffe34(temp65[34], in65[34], clk, input_enable, clr);
    dffe_ref dffe33(temp65[33], in65[33], clk, input_enable, clr);
    dffe_ref dffe32(temp65[32], in65[32], clk, input_enable, clr);
    dffe_ref dffe31(temp65[31], in65[31], clk, input_enable, clr);
    dffe_ref dffe30(temp65[30], in65[30], clk, input_enable, clr);
    dffe_ref dffe29(temp65[29], in65[29], clk, input_enable, clr);
    dffe_ref dffe28(temp65[28], in65[28], clk, input_enable, clr);
    dffe_ref dffe27(temp65[27], in65[27], clk, input_enable, clr);
    dffe_ref dffe26(temp65[26], in65[26], clk, input_enable, clr);
    dffe_ref dffe25(temp65[25], in65[25], clk, input_enable, clr);
    dffe_ref dffe24(temp65[24], in65[24], clk, input_enable, clr);
    dffe_ref dffe23(temp65[23], in65[23], clk, input_enable, clr);
    dffe_ref dffe22(temp65[22], in65[22], clk, input_enable, clr);
    dffe_ref dffe21(temp65[21], in65[21], clk, input_enable, clr);
    dffe_ref dffe20(temp65[20], in65[20], clk, input_enable, clr);
    dffe_ref dffe19(temp65[19], in65[19], clk, input_enable, clr);
    dffe_ref dffe18(temp65[18], in65[18], clk, input_enable, clr);
    dffe_ref dffe17(temp65[17], in65[17], clk, input_enable, clr);
    dffe_ref dffe16(temp65[16], in65[16], clk, input_enable, clr);
    dffe_ref dffe15(temp65[15], in65[15], clk, input_enable, clr);
    dffe_ref dffe14(temp65[14], in65[14], clk, input_enable, clr);
    dffe_ref dffe13(temp65[13], in65[13], clk, input_enable, clr);
    dffe_ref dffe12(temp65[12], in65[12], clk, input_enable, clr);
    dffe_ref dffe11(temp65[11], in65[11], clk, input_enable, clr);
    dffe_ref dffe10(temp65[10], in65[10], clk, input_enable, clr);
    dffe_ref dffe9(temp65[9], in65[9], clk, input_enable, clr);
    dffe_ref dffe8(temp65[8], in65[8], clk, input_enable, clr);
    dffe_ref dffe7(temp65[7], in65[7], clk, input_enable, clr);
    dffe_ref dffe6(temp65[6], in65[6], clk, input_enable, clr);
    dffe_ref dffe5(temp65[5], in65[5], clk, input_enable, clr);
    dffe_ref dffe4(temp65[4], in65[4], clk, input_enable, clr);
    dffe_ref dffe3(temp65[3], in65[3], clk, input_enable, clr);
    dffe_ref dffe2(temp65[2], in65[2], clk, input_enable, clr);
    dffe_ref dffe1(temp65[1], in65[1], clk, input_enable, clr);
    dffe_ref dffe0(temp65[0], in65[0], clk, input_enable, clr);
	
	assign out65 = temp65;

   /* YOUR CODE HERE */

endmodule
