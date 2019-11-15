module twos_complement_flipper6(x, xout);
	input [5:0] x;
	output [5:0] xout;
	not notter0(xout[0], x[0]);
	not notter1(xout[1], x[1]);
	not notter2(xout[2], x[2]);
	not notter3(xout[3], x[3]);
	not notter4(xout[4], x[4]);
	not notter5(xout[5], x[5]);

endmodule