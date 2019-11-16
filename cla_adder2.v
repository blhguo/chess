module cla_adder2(x, y, Sout, cin, overflow);
	input [33:0] x, y;
	input cin;
	output [33:0] Sout;
	output overflow;
	
	wire [7:0] xin1, xin2, xin3, yin1, yin2, yin3, Sout1, Sout2, Sout3;
	wire [9:0] xin4, yin4, Sout4;
	wire Gout1, Gout2, Gout3, Gout4, Pout1, Pout2, Pout3, Pout4;
	
	assign xin1[0]= x[0];
	assign xin1[1]= x[1];
	assign xin1[2]= x[2];
	assign xin1[3]= x[3];
	assign xin1[4]= x[4];
	assign xin1[5]= x[5];
	assign xin1[6]= x[6];
	assign xin1[7]= x[7];
	
	assign yin1[0] = y[0];
	assign yin1[1] = y[1];
	assign yin1[2] = y[2];
	assign yin1[3] = y[3];
	assign yin1[4] = y[4];
	assign yin1[5] = y[5];
	assign yin1[6] = y[6];
	assign yin1[7] = y[7];
	
	Eight_bit_block block1(.x(xin1), .y(yin1), .Cin(cin), .Sout(Sout1), .Gout(Gout1), .Pout(Pout1));
	assign Sout[0] = Sout1[0];
	assign Sout[1] = Sout1[1];
	assign Sout[2] = Sout1[2];
	assign Sout[3] = Sout1[3];
	assign Sout[4] = Sout1[4];
	assign Sout[5] = Sout1[5];
	assign Sout[6] = Sout1[6];
	assign Sout[7] = Sout1[7];
	
	
	assign xin2[0]= x[8];
	assign xin2[1]= x[9];
	assign xin2[2]= x[10];
	assign xin2[3]= x[11];
	assign xin2[4]= x[12];
	assign xin2[5]= x[13];
	assign xin2[6]= x[14];
	assign xin2[7]= x[15];
	
	assign yin2[0] = y[8];
	assign yin2[1] = y[9];
	assign yin2[2] = y[10];
	assign yin2[3] = y[11];
	assign yin2[4] = y[12];
	assign yin2[5] = y[13];
	assign yin2[6] = y[14];
	assign yin2[7] = y[15];
	
	wire cin2;
	la_t1 la1(.G0(Gout1), .P0(Pout1), .Cin(cin), .Cout(cin2));
	
	Eight_bit_block block2(.x(xin2), .y(yin2), .Cin(cin2), .Sout(Sout2), .Gout(Gout2), .Pout(Pout2));
	assign Sout[8] = Sout2[0];
	assign Sout[9] = Sout2[1];
	assign Sout[10] = Sout2[2];
	assign Sout[11] = Sout2[3];
	assign Sout[12] = Sout2[4];
	assign Sout[13] = Sout2[5];
	assign Sout[14] = Sout2[6];
	assign Sout[15] = Sout2[7];
	
	
	assign xin3[0]= x[16];
	assign xin3[1]= x[17];
	assign xin3[2]= x[18];
	assign xin3[3]= x[19];
	assign xin3[4]= x[20];
	assign xin3[5]= x[21];
	assign xin3[6]= x[22];
	assign xin3[7]= x[23];
	
	assign yin3[0] = y[16];
	assign yin3[1] = y[17];
	assign yin3[2] = y[18];
	assign yin3[3] = y[19];
	assign yin3[4] = y[20];
	assign yin3[5] = y[21];
	assign yin3[6] = y[22];
	assign yin3[7] = y[23];
	
	wire cin3;
	la_t2 la2(.G0(Gout1), .G1(Gout2), .P0(Pout1), .P1(Pout2), .Cin(cin), .Cout(cin3));

	Eight_bit_block block3(.x(xin3), .y(yin3), .Cin(cin3), .Sout(Sout3), .Gout(Gout3), .Pout(Pout3));
	assign Sout[16] = Sout3[0];
	assign Sout[17] = Sout3[1];
	assign Sout[18] = Sout3[2];
	assign Sout[19] = Sout3[3];
	assign Sout[20] = Sout3[4];
	assign Sout[21] = Sout3[5];
	assign Sout[22] = Sout3[6];
	assign Sout[23] = Sout3[7];
	
	
	assign xin4[0]= x[24];
	assign xin4[1]= x[25];
	assign xin4[2]= x[26];
	assign xin4[3]= x[27];
	assign xin4[4]= x[28];
	assign xin4[5]= x[29];
	assign xin4[6]= x[30];
	assign xin4[7]= x[31];
	assign xin4[8]= x[32];
	assign xin4[9]= x[33];

	
	assign yin4[0] = y[24];
	assign yin4[1] = y[25];
	assign yin4[2] = y[26];
	assign yin4[3] = y[27];
	assign yin4[4] = y[28];
	assign yin4[5] = y[29];
	assign yin4[6] = y[30];
	assign yin4[7] = y[31];
	assign yin4[8] = y[32];
	assign yin4[9] = y[33];

	
	wire cin4;
	la_t3 la3(.G0(Gout1), .G1(Gout2), .G2(Gout3), .P0(Pout1), .P1(Pout2), .P2(Pout3), .Cin(cin), .Cout(cin4));

	ten_bit_block block4(.x(xin4), .y(yin4), .Cin(cin4), .Sout(Sout4), .Gout(Gout4), .Pout(Pout4));
	assign Sout[24] = Sout4[0];
	assign Sout[25] = Sout4[1];
	assign Sout[26] = Sout4[2];
	assign Sout[27] = Sout4[3];
	assign Sout[28] = Sout4[4];
	assign Sout[29] = Sout4[5];
	assign Sout[30] = Sout4[6];
	assign Sout[31] = Sout4[7];
	assign Sout[32] = Sout4[8];
	assign Sout[33] = Sout4[9];
	
	
	wire tempOverflow;
	la_t4 la4(.G0(Gout1), .G1(Gout2), .G2(Gout3), .G3(Gout4), .P0(Pout1), .P1(Pout2), .P2(Pout3), .P3(Pout4), .Cin(cin), .Cout(tempOverflow));
	
	wire not_endbit_x, not_endbit_y, not_endbit_s;
	not notendx(not_endbit_x, x[33]);
	not notendy(not_endbit_y, y[33]);
	not notends(not_endbit_s, Sout[33]);
	
	wire case1;
	and case1and(case1, not_endbit_x, not_endbit_y, Sout[33]);
	
	wire case2;
	and case2and(case2, x[33], y[33], not_endbit_s);
	
	or my_or(overflow, case1, case2);


endmodule