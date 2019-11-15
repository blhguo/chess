module mux_2_34(select, in0, in1, out);
	input select;
	input [33:0] in0, in1;
	output [33:0] out;
	assign out = select ? in1 : in0;
endmodule
