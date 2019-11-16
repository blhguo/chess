module ctrl(lsb_multiplier, add, noop, dbl);
	input [2:0] lsb_multiplier;
	output add, noop, dbl;
	
	wire n0, n1, n2;
	not not0(n0, lsb_multiplier[0]);
	not not1(n1, lsb_multiplier[1]);
	not not2(n2, lsb_multiplier[2]);
	
	wire w1, w2;
	or add_or(w1, lsb_multiplier[0], lsb_multiplier[1]);
	and add_and(add, w1, n2);
	
	wire w3, w4;
	and noop_and1(w3, n0, n1, n2);
	and noop_and2(w4, lsb_multiplier[0], lsb_multiplier[1], lsb_multiplier[2]);
	or noop_or(noop, w3, w4);
	
	wire w5, w6;
	and dbl_and1(w5, lsb_multiplier[0], lsb_multiplier[1], n2);
	and dbl_and2(w6, n0, n1, lsb_multiplier[2]);
	or dbl_or(dbl, w5, w6);

endmodule