module register9 (
    clk,
    input_enable,
    in9, out9, clr
);

   input clk, input_enable, clr;
   input [8:0] in9;

   output [8:0] out9;
	wire and_clk_ine;
	and and_clk_ine_gate(and_clk_ine, clk, input_enable);
	wire [8:0] temp9;
	
	dffe_ref dffe0(temp9[0], in9[0], clk, and_clk_ine, clr);
	dffe_ref dffe1(temp9[1], in9[1], clk, and_clk_ine, clr);
	dffe_ref dffe2(temp9[2], in9[2], clk, and_clk_ine, clr);
	dffe_ref dffe3(temp9[3], in9[3], clk, and_clk_ine, clr);
	dffe_ref dffe4(temp9[4], in9[4], clk, and_clk_ine, clr);
	dffe_ref dffe5(temp9[5], in9[5], clk, and_clk_ine, clr);
	dffe_ref dffe6(temp9[6], in9[6], clk, and_clk_ine, clr);
	dffe_ref dffe7(temp9[7], in9[7], clk, and_clk_ine, clr);
	dffe_ref dffe8(temp9[8], in9[8], clk, and_clk_ine, clr);

	
	assign out9 = temp9;

   /* YOUR CODE HERE */

endmodule
