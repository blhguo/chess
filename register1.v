module register1 (
    clk,
    input_enable,
    in1, out1, clr
);

   input clk, input_enable, clr;
   input in1;

   output out1;
	//wire input_enable;
	//and input_enable_gate(input_enable, clk, input_enable);
	wire temp1;
	
	dffe_ref dffe0(temp1, in1, clk, input_enable, clr);

	assign out1 = temp1;

   /* YOUR CODE HERE */

endmodule
