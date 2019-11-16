module ten_bit_block(x, y, Cin, Sout, Gout, Pout);
	input [9:0] x, y;
	input Cin;
	output [9:0] Sout;
	output Gout, Pout;
	wire p0, p1, p2, p3, p4, p5, p6, p7, p8, p9;
	or p0_or(p0, x[0], y[0]);
	or p1_or(p1, x[1], y[1]);
	or p2_or(p2, x[2], y[2]);
	or p3_or(p3, x[3], y[3]);
	or p4_or(p4, x[4], y[4]);
	or p5_or(p5, x[5], y[5]);
	or p6_or(p6, x[6], y[6]);
	or p7_or(p7, x[7], y[7]);
	or p8_or(p8, x[8], y[8]);
	or p9_or(p9, x[9], y[9]);

	
	wire g0, g1, g2, g3, g4, g5, g6, g7, g8, g9;
	and g0_and(g0, x[0], y[0]);
	and g1_and(g1, x[1], y[1]);
	and g2_and(g2, x[2], y[2]);
	and g3_and(g3, x[3], y[3]);
	and g4_and(g4, x[4], y[4]);
	and g5_and(g5, x[5], y[5]);
	and g6_and(g6, x[6], y[6]);
	and g7_and(g7, x[7], y[7]);
	and g8_and(g8, x[8], y[8]);
	and g9_and(g9, x[9], y[9]);
	
	wire c1, c2, c3, c4, c5, c6, c7, c8, c9;
	wire p0c0; 
	and p0c0_and(p0c0, p0, Cin);
	or c1_or(c1, g0, p0c0);
	
	wire p1g0;
	and p1g0_and(p1g0, p1, g0);
	wire p1p0c0;
	and p1p0c0_and(p1p0c0, p1, p0, Cin);
	or c2_or(c2, g1, p1g0, p1p0c0);
		
	wire p2g1;
	and p2g1_and(p2g1, p2, g1);
	wire p2p1g0;
	and p2p1g0_and(p2p1g0, p2, p1, g0);
	wire p2p1p0c0;
	and p2p1p0c0_and(p2p1p0c0, p2, p1, p0, Cin);
	or c3_or(c3, g2, p2p1p0c0, p2p1g0, p2g1);
	
	wire p3p2p1p0c0, p3p2p1g0, p3p2g1, p3g2;
	and p3g2_and(p3g2, p3, g2);
	and p3p2g1_and(p3p2g1, p3, p2, g1);
	and p3p2p1g0_and(p3p2p1g0, p3, p2, p1, g0);
	and p3p2p1p0c0_and(p3p2p1p0c0, p3, p2, p1, p0, Cin);
	or c4_or(c4, g3, p3p2p1p0c0, p3p2p1g0, p3p2g1, p3g2);
	
	wire p4p3p2p1p0c0, p4p3p2p1g0, p4p3p2g1, p4p3g2, p4g3;
	and p4g3_and(p4g3, p4, g3);
	and p4p3g2_and(p4p3g2, p4, p3, g2);
	and p4p3p2g1_and(p4p3p2g1, p4, p3, p2, g1);
	and p4p3p2p1g0_and(p4p3p2p1g0, p4, p3, p2, p1, g0);
	and p4p3p2p1p0c0_and(p4p3p2p1p0c0, p4, p3, p2, p1, p0, Cin);
	or c5_or(c5, g4, p4p3p2p1p0c0, p4p3p2p1g0, p4p3p2g1, p4p3g2, p4g3);
	
	wire p5p4p3p2p1p0c0, p5p4p3p2p1g0, p5p4p3p2g1, p5p4p3g2, p5p4g3, p5g4;
	and p5g4_and(p5g4, p5, g4);
	and p5p4g3_and(p5p4g3, p5, p4, g3);
	and p5p4p3g2_and(p5p4p3g2, p5, p4, p3, g2);
	and p5p4p3p2g1_and(p5p4p3p2g1, p5, p4, p3, p2, g1);
	and p5p4p3p2p1g0_and(p5p4p3p2p1g0, p5, p4, p3, p2, p1, g0);
	and p5p4p3p2p1p0c0_and(p5p4p3p2p1p0c0, p5, p4, p3, p2, p1, p0, Cin);
	or c6_or(c6, g5, p5p4p3p2p1p0c0, p5p4p3p2p1g0, p5p4p3p2g1, p5p4p3g2, p5p4g3, p5g4);
	
	wire p6p5p4p3p2p1p0c0, p6p5p4p3p2p1g0, p6p5p4p3p2g1, p6p5p4p3g2, p6p5p4g3, p6p5g4, p6g5;
	and p6g5_and(p6g5, p6, g5);
	and p6p5g4_and(p6p5g4, p6, p5, g4);
	and p6p5p4g3_and(p6p5p4g3, p6, p5, p4, g3);
	and p6p5p4p3g2_and(p6p5p4p3g2, p6, p5, p4, p3, g2);
	and p6p5p4p3p2g1_and(p6p5p4p3p2g1, p6, p5, p4, p3, p2, g1);
	and p6p5p4p3p2p1g0_and(p6p5p4p3p2p1g0, p6, p5, p4, p3, p2, p1, g0);
	and p6p5p4p3p2p1p0c0_and(p6p5p4p3p2p1p0c0, p6, p5, p4, p3, p2, p1, p0, Cin);
	or c7_or(c7, g6, p6p5p4p3p2p1p0c0, p6p5p4p3p2p1g0, p6p5p4p3p2g1, p6p5p4p3g2, p6p5p4g3, p6p5g4, p6g5);
	
	wire p7p6p5p4p3p2p1p0c0, p7p6p5p4p3p2p1g0, p7p6p5p4p3p2g1, p7p6p5p4p3g2, p7p6p5p4g3, p7p6p5g4, p7p6g5, p7g6;
	and p7g6_and(p7g6, p7, g6);
	and p7p6g5_and(p7p6g5, p7, p6, g5);
	and p7p6p5g4_and(p7p6p5g4, p7, p6, p5, g4);
	and p7p6p5p4g3_and(p7p6p5p4g3, p7, p6, p5, p4, g3);
	and p7p6p5p4p3g2_and(p7p6p5p4p3g2, p7, p6, p5, p4, p3, g2);
	and p7p6p5p4p3p2g1_and(p7p6p5p4p3p2g1, p7, p6, p5, p4, p3, p2, g1);
	and p7p6p5p4p3p2p1g0_and(p7p6p5p4p3p2p1g0, p7, p6, p5, p4, p3, p2, p1, g0);
	and p7p6p5p4p3p2p1p0c0_and(p7p6p5p4p3p2p1p0c0, p7, p6, p5, p4, p3, p2, p1, p0, Cin);
	or c8_or(c8, g7, p7p6p5p4p3p2p1p0c0, p7p6p5p4p3p2p1g0, p7p6p5p4p3p2g1, p7p6p5p4p3g2, p7p6p5p4g3, p7p6p5g4, p7p6g5, p7g6);
	
	wire p8p7p6p5p4p3p2p1p0c0, p8p7p6p5p4p3p2p1g0, p8p7p6p5p4p3p2g1, p8p7p6p5p4p3g2, p8p7p6p5p4g3, p8p7p6p5g4, p8p7p6g5, p8p7g6, p8g7;
	and p8g7_and(p8g7, p8, g7);
	and p8p7g6_and(p8p7g6, p8, p7, g6);
	and p8p7p6g5_and(p8p7p6g5, p8, p7, p6, g5);
	and p8p7p6p5g4_and(p8p7p6p5g4, p8, p7, p6, p5, g4);
	and p8p7p6p5p4g3_and(p8p7p6p5p4g3, p8, p7, p6, p5, p4, g3);
	and p8p7p6p5p4p3g2_and(p8p7p6p5p4p3g2, p8, p7, p6, p5, p4, p3, g2);
	and p8p7p6p5p4p3p2g1_and(p8p7p6p5p4p3p2g1, p8, p7, p6, p5, p4, p3, p2, g1);
	and p8p7p6p5p4p3p2p1g0_and(p8p7p6p5p4p3p2p1g0, p8, p7, p6, p5, p4, p3, p2, p1, g0);
	and p8p7p6p5p4p3p2p1p0c0_and(p8p7p6p5p4p3p2p1p0c0, p8, p7, p6, p5, p4, p3, p2, p1, p0, Cin);
	or c9_or(c9, g8, p8p7p6p5p4p3p2p1p0c0, p8p7p6p5p4p3p2p1g0, p8p7p6p5p4p3p2g1, p8p7p6p5p4p3g2, p8p7p6p5p4g3, p8p7p6p5g4, p8p7p6g5, p8p7g6, p8g7);
	
	wire p9p8p7p6p5p4p3p2p1g0, p9p8p7p6p5p4p3p2g1, p9p8p7p6p5p4p3g2, p9p8p7p6p5p4g3, p9p8p7p6p5g4, p9p8p7p6g5, p9p8p7g6, p9p8g7, p9g8;
	and p9g8_and(p9g8, p9, g8);
	and p9p8g7_and(p9p8g7, p9, p8, g7);
	and p9p8p7g6_and(p9p8p7g6, p9, p8, p7, g6);
	and p9p8p7p6g5_and(p9p8p7p6g5, p9, p8, p7, p6, g5);
	and p9p8p7p6p5g4_and(p9p8p7p6p5g4, p9, p8, p7, p6, p5, g4);
	and p9p8p7p6p5p4g3_and(p9p8p7p6p5p4g3, p9, p8, p7, p6, p5, p4, g3);
	and p9p8p7p6p5p4p3g2_and(p9p8p7p6p5p4p3g2, p9, p8, p7, p6, p5, p4, p3, g2);
	and p9p8p7p6p5p4p3p2g1_and(p9p8p7p6p5p4p3p2g1, p9, p8, p7, p6, p5, p4, p3, p2, g1);
	and p9p8p7p6p5p4p3p2p1g0_and(p9p8p7p6p5p4p3p2p1g0, p9, p8, p7, p6, p5, p4, p3, p2, p1, g0);
	or Gout_or(Gout, g9, p9p8p7p6p5p4p3p2p1g0, p9p8p7p6p5p4p3p2g1, p9p8p7p6p5p4p3g2, p9p8p7p6p5p4g3, p9p8p7p6p5g4, p9p8p7p6g5, p9p8p7g6, p9p8g7, p9g8);
	
	xor Sout0_xor(Sout[0], x[0], y[0], Cin);
	xor Sout1_xor(Sout[1], x[1], y[1], c1);
	xor Sout2_xor(Sout[2], x[2], y[2], c2);
	xor Sout3_xor(Sout[3], x[3], y[3], c3);
	xor Sout4_xor(Sout[4], x[4], y[4], c4);
	xor Sout5_xor(Sout[5], x[5], y[5], c5);
	xor Sout6_xor(Sout[6], x[6], y[6], c6);
	xor Sout7_xor(Sout[7], x[7], y[7], c7);
	xor Sout8_xor(Sout[8], x[8], y[8], c8);
	xor Sout9_xor(Sout[9], x[9], y[9], c9);
	
	and Pout_and(Pout, p9, p8, p7, p6, p5, p4, p3, p2, p1, p0);
	
endmodule




	

	