module register34 (
    clk,
    input_enable,
    in34, out34, clr
);

   input clk, input_enable, clr;
   input [33:0] in34;

   output [33:0] out34;
	wire and_clk_ine;
	and and_clk_ine_gate(and_clk_ine, clk, input_enable);
	wire [33:0] temp34;
	
	dffe_ref dffe0(temp34[0], in34[0], clk, and_clk_ine, clr);
	dffe_ref dffe1(temp34[1], in34[1], clk, and_clk_ine, clr);
	dffe_ref dffe2(temp34[2], in34[2], clk, and_clk_ine, clr);
	dffe_ref dffe3(temp34[3], in34[3], clk, and_clk_ine, clr);
	dffe_ref dffe4(temp34[4], in34[4], clk, and_clk_ine, clr);
	dffe_ref dffe5(temp34[5], in34[5], clk, and_clk_ine, clr);
	dffe_ref dffe6(temp34[6], in34[6], clk, and_clk_ine, clr);
	dffe_ref dffe7(temp34[7], in34[7], clk, and_clk_ine, clr);
	dffe_ref dffe8(temp34[8], in34[8], clk, and_clk_ine, clr);
	dffe_ref dffe9(temp34[9], in34[9], clk, and_clk_ine, clr);
	dffe_ref dffe10(temp34[10], in34[10], clk, and_clk_ine, clr);
	dffe_ref dffe11(temp34[11], in34[11], clk, and_clk_ine, clr);
	dffe_ref dffe12(temp34[12], in34[12], clk, and_clk_ine, clr);
	dffe_ref dffe13(temp34[13], in34[13], clk, and_clk_ine, clr);
	dffe_ref dffe14(temp34[14], in34[14], clk, and_clk_ine, clr);
	dffe_ref dffe15(temp34[15], in34[15], clk, and_clk_ine, clr);
	dffe_ref dffe16(temp34[16], in34[16], clk, and_clk_ine, clr);
	dffe_ref dffe17(temp34[17], in34[17], clk, and_clk_ine, clr);
	dffe_ref dffe18(temp34[18], in34[18], clk, and_clk_ine, clr);
	dffe_ref dffe19(temp34[19], in34[19], clk, and_clk_ine, clr);
	dffe_ref dffe20(temp34[20], in34[20], clk, and_clk_ine, clr);
	dffe_ref dffe21(temp34[21], in34[21], clk, and_clk_ine, clr);
	dffe_ref dffe22(temp34[22], in34[22], clk, and_clk_ine, clr);
	dffe_ref dffe23(temp34[23], in34[23], clk, and_clk_ine, clr);
	dffe_ref dffe24(temp34[24], in34[24], clk, and_clk_ine, clr);
	dffe_ref dffe25(temp34[25], in34[25], clk, and_clk_ine, clr);
	dffe_ref dffe26(temp34[26], in34[26], clk, and_clk_ine, clr);
	dffe_ref dffe27(temp34[27], in34[27], clk, and_clk_ine, clr);
	dffe_ref dffe28(temp34[28], in34[28], clk, and_clk_ine, clr);
	dffe_ref dffe29(temp34[29], in34[29], clk, and_clk_ine, clr);
	dffe_ref dffe30(temp34[30], in34[30], clk, and_clk_ine, clr);
	dffe_ref dffe31(temp34[31], in34[31], clk, and_clk_ine, clr);
	dffe_ref dffe32(temp34[32], in34[32], clk, and_clk_ine, clr);
	dffe_ref dffe33(temp34[33], in34[33], clk, and_clk_ine, clr);
	
	assign out34 = temp34;

   /* YOUR CODE HERE */

endmodule
