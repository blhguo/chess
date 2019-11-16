module register27 (
    clk,
    input_enable,
    in27, out27, clr
);

   input clk, input_enable, clr;
   input [26:0] in27;

   output [26:0] out27;
	//wire input_enable;
	//and input_enable_gate(input_enable, clk, input_enable);
	wire [26:0] temp27;
	
	dffe_ref dffe0(temp27[0], in27[0], clk, input_enable, clr);
	dffe_ref dffe1(temp27[1], in27[1], clk, input_enable, clr);
	dffe_ref dffe2(temp27[2], in27[2], clk, input_enable, clr);
	dffe_ref dffe3(temp27[3], in27[3], clk, input_enable, clr);
	dffe_ref dffe4(temp27[4], in27[4], clk, input_enable, clr);
	dffe_ref dffe5(temp27[5], in27[5], clk, input_enable, clr);
	dffe_ref dffe6(temp27[6], in27[6], clk, input_enable, clr);
	dffe_ref dffe7(temp27[7], in27[7], clk, input_enable, clr);
	dffe_ref dffe8(temp27[8], in27[8], clk, input_enable, clr);
	dffe_ref dffe9(temp27[9], in27[9], clk, input_enable, clr);
	dffe_ref dffe10(temp27[10], in27[10], clk, input_enable, clr);
	dffe_ref dffe11(temp27[11], in27[11], clk, input_enable, clr);
	dffe_ref dffe12(temp27[12], in27[12], clk, input_enable, clr);
	dffe_ref dffe13(temp27[13], in27[13], clk, input_enable, clr);
	dffe_ref dffe14(temp27[14], in27[14], clk, input_enable, clr);
	dffe_ref dffe15(temp27[15], in27[15], clk, input_enable, clr);
	dffe_ref dffe16(temp27[16], in27[16], clk, input_enable, clr);
	dffe_ref dffe17(temp27[17], in27[17], clk, input_enable, clr);
	dffe_ref dffe18(temp27[18], in27[18], clk, input_enable, clr);
	dffe_ref dffe19(temp27[19], in27[19], clk, input_enable, clr);
	dffe_ref dffe20(temp27[20], in27[20], clk, input_enable, clr);
	dffe_ref dffe21(temp27[21], in27[21], clk, input_enable, clr);
	dffe_ref dffe22(temp27[22], in27[22], clk, input_enable, clr);
	dffe_ref dffe23(temp27[23], in27[23], clk, input_enable, clr);
	dffe_ref dffe24(temp27[24], in27[24], clk, input_enable, clr);
	dffe_ref dffe25(temp27[25], in27[25], clk, input_enable, clr);
	dffe_ref dffe26(temp27[26], in27[26], clk, input_enable, clr);
	
	assign out27 = temp27;

   /* YOUR CODE HERE */

endmodule
