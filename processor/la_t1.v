module la_t1(G0, P0, Cin, Cout);
	input G0, P0, Cin;
	output Cout;
	wire P0Cin;
	and P0Cin_and(P0Cin, P0, Cin);
	or Cout_or(Cout, G0, P0Cin);
	
endmodule
	
