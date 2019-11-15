module la_t3(G0, G1, G2, P0, P1, P2, Cin, Cout);
	input G0, G1, G2, P0, P1, P2, Cin;
	output Cout;
	wire P2P1P0Cin;
	and P2P1P0Cin_and(P2P1P0Cin, P2, P1, P0, Cin);
	wire P2P1G0;
	and P2P1G0_and(P2P1G0, P2, P1, G0);
	wire P2G1;
	and P2G1_and(P2G1, P2, G1);
	or Cout_or(Cout, G2, P2G1, P2P1G0, P2P1P0Cin);
endmodule
	
