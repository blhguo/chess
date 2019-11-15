module register17 (
    clk,
    input_enable,
    in17, out17, clr
);

   input clk, input_enable, clr;
   input [16:0] in17;

   output [16:0] out17;
	//wire input_enable;
	//and input_enable_gate(input_enable, clk, input_enable);
	wire [16:0] temp17;
	
	dffe_ref dffe0(temp17[0], in17[0], clk, input_enable, clr);
	dffe_ref dffe1(temp17[1], in17[1], clk, input_enable, clr);
	dffe_ref dffe2(temp17[2], in17[2], clk, input_enable, clr);
	dffe_ref dffe3(temp17[3], in17[3], clk, input_enable, clr);
	dffe_ref dffe4(temp17[4], in17[4], clk, input_enable, clr);
	dffe_ref dffe5(temp17[5], in17[5], clk, input_enable, clr);
	dffe_ref dffe6(temp17[6], in17[6], clk, input_enable, clr);
	dffe_ref dffe7(temp17[7], in17[7], clk, input_enable, clr);
	dffe_ref dffe8(temp17[8], in17[8], clk, input_enable, clr);
	dffe_ref dffe9(temp17[9], in17[9], clk, input_enable, clr);
	dffe_ref dffe10(temp17[10], in17[10], clk, input_enable, clr);
	dffe_ref dffe11(temp17[11], in17[11], clk, input_enable, clr);
	dffe_ref dffe12(temp17[12], in17[12], clk, input_enable, clr);
	dffe_ref dffe13(temp17[13], in17[13], clk, input_enable, clr);
	dffe_ref dffe14(temp17[14], in17[14], clk, input_enable, clr);
	dffe_ref dffe15(temp17[15], in17[15], clk, input_enable, clr);
	dffe_ref dffe16(temp17[16], in17[16], clk, input_enable, clr);
	
	assign out17 = temp17;

   /* YOUR CODE HERE */

endmodule
