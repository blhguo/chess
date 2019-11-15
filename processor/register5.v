module register5 (
    clk,
    input_enable,
    in5, out5, clr
);

   input clk, input_enable, clr;
   input [4:0] in5;

   output [4:0] out5;
	//wire input_enable;
	//and input_enable_gate(input_enable, clk, input_enable);
	wire [4:0] temp5;
	
	dffe_ref dffe0(temp5[0], in5[0], clk, input_enable, clr);
	dffe_ref dffe1(temp5[1], in5[1], clk, input_enable, clr);
	dffe_ref dffe2(temp5[2], in5[2], clk, input_enable, clr);
	dffe_ref dffe3(temp5[3], in5[3], clk, input_enable, clr);
	dffe_ref dffe4(temp5[4], in5[4], clk, input_enable, clr);
	
	assign out5 = temp5;

   /* YOUR CODE HERE */

endmodule
