module detectReady(counter4, isReady);
	input [3:0] counter4;
	output isReady;
	and isReady_and(isReady, counter4[0], counter4[1], counter4[2], counter4[3]);
endmodule