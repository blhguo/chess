module fivebit_demux(five_in, out0, out1, out2, out3, out4, out5, out6, out7, out8, out9, out10, out11, out12, out13, out14, out15, out16, out17, out18, out19, out20, out21, out22, out23, out24, out25, out26, out27,out28, out29, out30, out31);
   
   //Inputs
   input [4:0] five_in;
   //Output
   output out0, out1, out2, out3, out4, out5, out6, out7, out8, out9, out10, out11, out12, out13, out14, out15, out16, out17, out18, out19, out20, out21, out22, out23, out24, out25, out26, out27,out28, out29, out30, out31;
   
   //Register
	wire not0, not1, not2, not3, not4;
	not myNot0(not0, five_in[0]);
	not myNot1(not1, five_in[1]);
	not myNot2(not2, five_in[2]);
	not myNot3(not3, five_in[3]);
	not myNot4(not4, five_in[4]);

	
	and myAnd0(out0, not0, not1, not2, not3, not4);
	and myAnd1(out1, five_in[0], not1, not2, not3, not4);
	and myAnd2(out2, not0, five_in[1], not2, not3, not4);
	and myAnd3(out3, five_in[0], five_in[1], not2, not3, not4);
	and myAnd4(out4, not0, not1, five_in[2], not3, not4);
	and myAnd5(out5, five_in[0], not1, five_in[2], not3, not4);
	and myAnd6(out6, not0, five_in[1], five_in[2], not3, not4);
	and myAnd7(out7, five_in[0], five_in[1], five_in[2], not3, not4);
	and myAnd8(out8, not0, not1, not2, five_in[3], not4);
	and myAnd9(out9, five_in[0], not1, not2, five_in[3], not4);
	and myAnd10(out10, not0, five_in[1], not2, five_in[3], not4);
	and myAnd11(out11, five_in[0], five_in[1], not2, five_in[3], not4);
	and myAnd12(out12, not0, not1, five_in[2], five_in[3], not4);
	and myAnd13(out13, five_in[0], not1, five_in[2], five_in[3], not4);
	and myAnd14(out14, not0, five_in[1], five_in[2], five_in[3], not4);
	and myAnd15(out15, five_in[0], five_in[1], five_in[2], five_in[3], not4);
	and myAnd16(out16, not0, not1, not2, not3, five_in[4]);
	and myAnd17(out17, five_in[0], not1, not2, not3, five_in[4]);
	and myAnd18(out18, not0, five_in[1], not2, not3, five_in[4]);
	and myAnd19(out19, five_in[0], five_in[1], not2, not3, five_in[4]);
	and myAnd20(out20, not0, not1, five_in[2], not3, five_in[4]);
	and myAnd21(out21, five_in[0], not1, five_in[2], not3, five_in[4]);
	and myAnd22(out22, not0, five_in[1], five_in[2], not3, five_in[4]);
	and myAnd23(out23, five_in[0], five_in[1], five_in[2], not3, five_in[4]);
	and myAnd24(out24, not0, not1, not2, five_in[3], five_in[4]);
	and myAnd25(out25, five_in[0], not1, not2, five_in[3], five_in[4]);
	and myAnd26(out26, not0, five_in[1], not2, five_in[3], five_in[4]);
	and myAnd27(out27, five_in[0], five_in[1], not2, five_in[3], five_in[4]);
	and myAnd28(out28, not0, not1, five_in[2], five_in[3], five_in[4]);
	and myAnd29(out29, five_in[0], not1, five_in[2], five_in[3], five_in[4]);
	and myAnd30(out30, not0, five_in[1], five_in[2], five_in[3], five_in[4]);
	and myAnd31(out31, five_in[0], five_in[1], five_in[2], five_in[3], five_in[4]);
   
endmodule