module joiner(in34, in33, out65);
	input [33:0] in34;
	input [32:0] in33;
	output [64:0] out65;
	
	assign out65[64:31] = in34;
	assign out65[30:0] = in33[32:2];
endmodule