module mux_32(select, in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, out);
	input [4:0] select;
	input [31:0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31;
	output [31:0] out;
	wire [31:0] w1, w2, w3, w4;
	mux_8 first_top(.select(select[2:0]), .in0(in0), .in1(in1), .in2(in2), .in3(in3), .in4(in4), .in5(in5), .in6(in6), .in7(in7), .out(w1));
	mux_8 first_bottom(.select(select[2:0]), .in0(in8), .in1(in9), .in2(in10), .in3(in11), .in4(in12), .in5(in13), .in6(in14), .in7(in15), .out(w2));
	mux_8 second_top(.select(select[2:0]), .in0(in16), .in1(in17), .in2(in18), .in3(in19), .in4(in20), .in5(in21), .in6(in22), .in7(in23), .out(w3));
	mux_8 second_bottom(.select(select[2:0]), .in0(in24), .in1(in25), .in2(in26), .in3(in27), .in4(in28), .in5(in29), .in6(in30), .in7(in31), .out(w4));
	mux_4 second(.select(select[4:3]), .in0(w1), .in1(w2), .in2(w3), .in3(w4), .out(out));
endmodule
