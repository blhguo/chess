module splitter16MSB17LSB(in65, msb32, lsb33);
	input [64:0] in65;
	output [31:0] msb32;
	output [32:0] lsb33;

	assign msb32 = in65[64:33];
	assign lsb33 = in65[32:0];
	
endmodule