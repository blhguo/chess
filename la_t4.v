module la_t4(G0, G1, G2, G3, P0, P1, P2, P3, Cin, Cout);
	input G0, G1, G2, G3, P0, P1, P2, P3, Cin;
	output Cout;
	wire P3P2P1P0Cin;
	and P3P2P1P0Cin_and(P3P2P1P0Cin, P3, P2, P1, P0, Cin);
	wire P3P2P1G0;
	and P3P2P1G0_and(P3P2P1G0, P3, P2, P1, G0);
	wire P3P2G1;
	and P3P2G1_and(P3P2G1, P3, P2, G1);
	wire P3G2;
	and P3G2_and(P3G2, P3, G2);
	or Cout_or(Cout, G3, P3G2, P3P2G1, P3P2P1G0, P3P2P1P0Cin);
endmodule
	
