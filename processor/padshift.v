module padshift(in32, out33);
	input [31:0] in32;
	output [32:0] out33;
	
	assign out33[32:1] = in32[31:0];
	assign out33[0] = 0;
endmodule