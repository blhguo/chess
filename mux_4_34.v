module mux_4_34(select, in0, in1, in2, in3, out);
	input [1:0] select;
	input [33:0] in0, in1, in2, in3;
	output [33:0] out;
	wire [33:0] w1, w2;
	mux_2_34 first_top(.select(select[0]), .in0(in0), .in1(in1), .out(w1));
	mux_2_34 first_bottom(.select(select[0]), .in0(in2), .in1(in3), .out(w2));
	mux_2_34 second(.select(select[1]), .in0(w1), .in1(w2), .out(out));
endmodule
