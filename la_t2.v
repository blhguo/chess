module la_t2(G0, G1, P0, P1, Cin, Cout);
	input G0, G1, P0, P1, Cin;
	output Cout;
	wire P1P0Cin;
	and P1P0Cin_and(P1P0Cin, P1, P0, Cin);
	wire P1G0;
	and P1G0_and(P1G0, P1, G0);
	or Cout_or(Cout, G1, P1G0, P1P0Cin);
endmodule
	
