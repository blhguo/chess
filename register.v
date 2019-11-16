module register (
    clk,
    input_enable,
    in32, out32, clr
);

   input clk, input_enable, clr;
   input [31:0] in32;

   output [31:0] out32;
	//wire input_enable;
	//and input_enable_gate(input_enable, clk, input_enable);
	wire [31:0] temp32;
	
	dffe_ref dffe0(temp32[0], in32[0], clk, input_enable, clr);
	dffe_ref dffe1(temp32[1], in32[1], clk, input_enable, clr);
	dffe_ref dffe2(temp32[2], in32[2], clk, input_enable, clr);
	dffe_ref dffe3(temp32[3], in32[3], clk, input_enable, clr);
	dffe_ref dffe4(temp32[4], in32[4], clk, input_enable, clr);
	dffe_ref dffe5(temp32[5], in32[5], clk, input_enable, clr);
	dffe_ref dffe6(temp32[6], in32[6], clk, input_enable, clr);
	dffe_ref dffe7(temp32[7], in32[7], clk, input_enable, clr);
	dffe_ref dffe8(temp32[8], in32[8], clk, input_enable, clr);
	dffe_ref dffe9(temp32[9], in32[9], clk, input_enable, clr);
	dffe_ref dffe10(temp32[10], in32[10], clk, input_enable, clr);
	dffe_ref dffe11(temp32[11], in32[11], clk, input_enable, clr);
	dffe_ref dffe12(temp32[12], in32[12], clk, input_enable, clr);
	dffe_ref dffe13(temp32[13], in32[13], clk, input_enable, clr);
	dffe_ref dffe14(temp32[14], in32[14], clk, input_enable, clr);
	dffe_ref dffe15(temp32[15], in32[15], clk, input_enable, clr);
	dffe_ref dffe16(temp32[16], in32[16], clk, input_enable, clr);
	dffe_ref dffe17(temp32[17], in32[17], clk, input_enable, clr);
	dffe_ref dffe18(temp32[18], in32[18], clk, input_enable, clr);
	dffe_ref dffe19(temp32[19], in32[19], clk, input_enable, clr);
	dffe_ref dffe20(temp32[20], in32[20], clk, input_enable, clr);
	dffe_ref dffe21(temp32[21], in32[21], clk, input_enable, clr);
	dffe_ref dffe22(temp32[22], in32[22], clk, input_enable, clr);
	dffe_ref dffe23(temp32[23], in32[23], clk, input_enable, clr);
	dffe_ref dffe24(temp32[24], in32[24], clk, input_enable, clr);
	dffe_ref dffe25(temp32[25], in32[25], clk, input_enable, clr);
	dffe_ref dffe26(temp32[26], in32[26], clk, input_enable, clr);
	dffe_ref dffe27(temp32[27], in32[27], clk, input_enable, clr);
	dffe_ref dffe28(temp32[28], in32[28], clk, input_enable, clr);
	dffe_ref dffe29(temp32[29], in32[29], clk, input_enable, clr);
	dffe_ref dffe30(temp32[30], in32[30], clk, input_enable, clr);
	dffe_ref dffe31(temp32[31], in32[31], clk, input_enable, clr);
	
	assign out32 = temp32;

   /* YOUR CODE HERE */

endmodule
