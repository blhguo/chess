module lsb_extractor(in33, out3);
	input [32:0] in33;
	output [2:0] out3;
	
	assign out3[0] = in33[0];
	assign out3[1] = in33[1];
	assign out3[2] = in33[2];
	
endmodule