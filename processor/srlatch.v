module srlatch(s, r, q, qnot);
	input s, r;
	output q, qnot;
	
	nor nor0(q, r, qnot);
	nor nor1(qnot, s, q);
	
endmodule