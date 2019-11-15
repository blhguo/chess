module splitter16LSBOffset(in33, out16);
	input [32:0] in33;
	output [15:0] out16;
	
	assign out16 = in33[16:1];
endmodule