module multdiv(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, clock, data_result, data_exception, data_resultRDY);
    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;
	 wire instructed;
	 or isInstructed(instructed, ctrl_MULT, ctrl_DIV);
    // Your code here
	 wire notclk;
	 not nc(notclk, clock);
	 wire mult_reset, div_reset;
	 srlatch ctrl(ctrl_DIV, ctrl_MULT, mult_reset, div_reset);
	 wire multOver, divOver, multReady, divReady;
	 wire [31:0] multResult, divResult, dresult;
	 wire mult_reset2, div_reset2;
	 or mul2(mult_reset2, instructed, mult_reset);
	 or div2(div_reset2, instructed, div_reset);
	 
	 wire [31:0] tempA, tempB;
	 register inputA(clock, instructed, data_operandA, tempA, 1'b0);
	 register inputB(clock, instructed, data_operandB, tempB, 1'b0);

	 mult myMult(tempA, tempB, clock, mult_reset2, multResult, multOver, multReady);
	 div myDiv(tempA, tempB, clock, div_reset2, divResult, divOver, divReady);

	 wire overflowdata;

	 assign overflowdata = mult_reset ? divOver : multOver;
	 register overflowlatch(clock, data_resultRDY, overflowdata, data_exception, 1'b0);

	 assign dresult = mult_reset ? divResult : multResult;
	 assign data_resultRDY = mult_reset ? divReady : multReady;
	 wire [31:0] tempdata;
	 register dataout(clock, data_resultRDY, dresult, tempdata, 1'b0);
	 assign data_result = mult_reset ? divResult : tempdata;
	 
	 
endmodule
