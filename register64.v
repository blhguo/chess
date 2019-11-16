module register64 (
    clk,
    input_enable,
    in64, out64, clr
);

   input clk, input_enable, clr;
   input [63:0] in64;

   output [63:0] out64;
	//wire input_enable;
	//and input_enable_gate(input_enable, clk, input_enable);
	wire [63:0] temp64;
	
    dffe_ref dffe63(temp64[63], in64[63], clk, input_enable, clr);
    dffe_ref dffe62(temp64[62], in64[62], clk, input_enable, clr);
    dffe_ref dffe61(temp64[61], in64[61], clk, input_enable, clr);
    dffe_ref dffe60(temp64[60], in64[60], clk, input_enable, clr);
    dffe_ref dffe59(temp64[59], in64[59], clk, input_enable, clr);
    dffe_ref dffe58(temp64[58], in64[58], clk, input_enable, clr);
    dffe_ref dffe57(temp64[57], in64[57], clk, input_enable, clr);
    dffe_ref dffe56(temp64[56], in64[56], clk, input_enable, clr);
    dffe_ref dffe55(temp64[55], in64[55], clk, input_enable, clr);
    dffe_ref dffe54(temp64[54], in64[54], clk, input_enable, clr);
    dffe_ref dffe53(temp64[53], in64[53], clk, input_enable, clr);
    dffe_ref dffe52(temp64[52], in64[52], clk, input_enable, clr);
    dffe_ref dffe51(temp64[51], in64[51], clk, input_enable, clr);
    dffe_ref dffe50(temp64[50], in64[50], clk, input_enable, clr);
    dffe_ref dffe49(temp64[49], in64[49], clk, input_enable, clr);
    dffe_ref dffe48(temp64[48], in64[48], clk, input_enable, clr);
    dffe_ref dffe47(temp64[47], in64[47], clk, input_enable, clr);
    dffe_ref dffe46(temp64[46], in64[46], clk, input_enable, clr);
    dffe_ref dffe45(temp64[45], in64[45], clk, input_enable, clr);
    dffe_ref dffe44(temp64[44], in64[44], clk, input_enable, clr);
    dffe_ref dffe43(temp64[43], in64[43], clk, input_enable, clr);
    dffe_ref dffe42(temp64[42], in64[42], clk, input_enable, clr);
    dffe_ref dffe41(temp64[41], in64[41], clk, input_enable, clr);
    dffe_ref dffe40(temp64[40], in64[40], clk, input_enable, clr);
    dffe_ref dffe39(temp64[39], in64[39], clk, input_enable, clr);
    dffe_ref dffe38(temp64[38], in64[38], clk, input_enable, clr);
    dffe_ref dffe37(temp64[37], in64[37], clk, input_enable, clr);
    dffe_ref dffe36(temp64[36], in64[36], clk, input_enable, clr);
    dffe_ref dffe35(temp64[35], in64[35], clk, input_enable, clr);
    dffe_ref dffe34(temp64[34], in64[34], clk, input_enable, clr);
    dffe_ref dffe33(temp64[33], in64[33], clk, input_enable, clr);
    dffe_ref dffe32(temp64[32], in64[32], clk, input_enable, clr);
    dffe_ref dffe31(temp64[31], in64[31], clk, input_enable, clr);
    dffe_ref dffe30(temp64[30], in64[30], clk, input_enable, clr);
    dffe_ref dffe29(temp64[29], in64[29], clk, input_enable, clr);
    dffe_ref dffe28(temp64[28], in64[28], clk, input_enable, clr);
    dffe_ref dffe27(temp64[27], in64[27], clk, input_enable, clr);
    dffe_ref dffe26(temp64[26], in64[26], clk, input_enable, clr);
    dffe_ref dffe25(temp64[25], in64[25], clk, input_enable, clr);
    dffe_ref dffe24(temp64[24], in64[24], clk, input_enable, clr);
    dffe_ref dffe23(temp64[23], in64[23], clk, input_enable, clr);
    dffe_ref dffe22(temp64[22], in64[22], clk, input_enable, clr);
    dffe_ref dffe21(temp64[21], in64[21], clk, input_enable, clr);
    dffe_ref dffe20(temp64[20], in64[20], clk, input_enable, clr);
    dffe_ref dffe19(temp64[19], in64[19], clk, input_enable, clr);
    dffe_ref dffe18(temp64[18], in64[18], clk, input_enable, clr);
    dffe_ref dffe17(temp64[17], in64[17], clk, input_enable, clr);
    dffe_ref dffe16(temp64[16], in64[16], clk, input_enable, clr);
    dffe_ref dffe15(temp64[15], in64[15], clk, input_enable, clr);
    dffe_ref dffe14(temp64[14], in64[14], clk, input_enable, clr);
    dffe_ref dffe13(temp64[13], in64[13], clk, input_enable, clr);
    dffe_ref dffe12(temp64[12], in64[12], clk, input_enable, clr);
    dffe_ref dffe11(temp64[11], in64[11], clk, input_enable, clr);
    dffe_ref dffe10(temp64[10], in64[10], clk, input_enable, clr);
    dffe_ref dffe9(temp64[9], in64[9], clk, input_enable, clr);
    dffe_ref dffe8(temp64[8], in64[8], clk, input_enable, clr);
    dffe_ref dffe7(temp64[7], in64[7], clk, input_enable, clr);
    dffe_ref dffe6(temp64[6], in64[6], clk, input_enable, clr);
    dffe_ref dffe5(temp64[5], in64[5], clk, input_enable, clr);
    dffe_ref dffe4(temp64[4], in64[4], clk, input_enable, clr);
    dffe_ref dffe3(temp64[3], in64[3], clk, input_enable, clr);
    dffe_ref dffe2(temp64[2], in64[2], clk, input_enable, clr);
    dffe_ref dffe1(temp64[1], in64[1], clk, input_enable, clr);
    dffe_ref dffe0(temp64[0], in64[0], clk, input_enable, clr);
	
	assign out64 = temp64;

   /* YOUR CODE HERE */

endmodule
