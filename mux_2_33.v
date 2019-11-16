module mux_2_33(select, in0, in1, out);
	input select;
	input [32:0] in0, in1;
	output [32:0] out;
	assign out = select ? in1 : in0;
endmodule
