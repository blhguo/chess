module counter4(enable, clock, out, clr);
	input enable, clock, clr;
	output [3:0] out;
	wire [3:0] nout;
	
	not not0(nout[0], out[0]);
	not not1(nout[1], out[1]);
	not not2(nout[2], out[2]);
	not not3(nout[3], out[3]);
	
	dffe_ref bit0(.q(out[0]), .d(nout[0]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit1(.q(out[1]), .d(nout[1]), .clk(nout[0]), .en(enable), .clr(clr));
	dffe_ref bit2(.q(out[2]), .d(nout[2]), .clk(nout[1]), .en(enable), .clr(clr));
	dffe_ref bit3(.q(out[3]), .d(nout[3]), .clk(nout[2]), .en(enable), .clr(clr));

endmodule