module div(dividend, divisor, clock, reset, result, overflow, ready);
	input [31:0] dividend, divisor;
	input clock, reset;
	output [31:0] result;
	output overflow, ready;
	wire enable = 1'b1;
	wire [5:0] counter;
	wire [31:0] zerosconst = 32'b0;

	wire [31:0] posdivisor, posdividend, inverteddividend, inverteddivisor, invertedposdivisor, trialsub, oldQ, newQ, newA;
	wire [63:0] newAQ, AQ, unsignedquotient, AQShifted, productb;
	wire isDivisorNeg, isDividendNeg, trialsubMSB, counterMSB, count;
	
	//Convert all args to pos, record signs
	
	assign isDivisorNeg = divisor[31];
	wire [31:0] inverteddivisor_temp;
	wire suboverflow3, suboverflow4;
	twos_complement_flipper32 flip1(divisor, inverteddivisor_temp);
	cla_adder posinputA(inverteddivisor_temp, zerosconst, inverteddivisor, 1'b1, suboverflow3);

	mux_2 signDivisor(isDivisorNeg, divisor, inverteddivisor, posdivisor);
	
	
	assign isDividendNeg = dividend[31];
	wire [31:0] inverteddividend_temp;
	
	twos_complement_flipper32 flip2(dividend, inverteddividend_temp);

	cla_adder posinputB(inverteddividend_temp, zerosconst, inverteddividend, 1'b1, suboverflow4);

	mux_2 signDividend(isDividendNeg, dividend, inverteddividend, posdividend);
	
	
	twos_complement_flipper32 flip3(posdivisor, invertedposdivisor);

	counter6 counterobj(enable, clock, counter, reset);
	or count_or(count, counter[0], counter[1], counter[2], counter[3], counter[4], counter[5]);
	assign counterMSB = counter[5];
	wire isReady;
	nor ready_or(isReady, counter[0], counter[1], counter[2], counter[3], counter[4]);
	and ready_and(ready, isReady, counter[5]);
	
	wire w1, w2, w3;
	wire highbit;
	not inverthighbit(highbit, dividend[31]);
	nor dividendnor(w1, highbit, dividend[30], dividend[29], dividend[28], dividend[27], dividend[26], dividend[25], dividend[24], dividend[23], dividend[22], dividend[21], dividend[20], dividend[19], dividend[18], dividend[17], dividend[16], dividend[15], dividend[14], dividend[13], dividend[12], dividend[11], dividend[10], dividend[9], dividend[8], dividend[7], dividend[6], dividend[5], dividend[4], dividend[3],dividend[2], dividend[1], dividend[0]);
	and divisorand(w2, w1, divisor[31], divisor[30], divisor[29], divisor[28], divisor[27], divisor[26], divisor[25], divisor[24], divisor[23], divisor[22], divisor[21], divisor[20], divisor[19], divisor[18], divisor[17], divisor[16], divisor[15], divisor[14], divisor[13], divisor[12], divisor[11], divisor[10], divisor[9], divisor[8], divisor[7], divisor[6], divisor[5], divisor[4], divisor[3],divisor[2], divisor[1], divisor[0]);
	nor divisornor(w3, divisor[31], divisor[30], divisor[29], divisor[28], divisor[27], divisor[26], divisor[25], divisor[24], divisor[23], divisor[22], divisor[21], divisor[20], divisor[19], divisor[18], divisor[17], divisor[16], divisor[15], divisor[14], divisor[13], divisor[12], divisor[11], divisor[10], divisor[9],divisor[8], divisor[7], divisor[6], divisor[5], divisor[4], divisor[3], divisor[2], divisor[1], divisor[0]);
	or overflowOr(overflow, w2, w3);
	
	wire [63:0] initAQ;
	assign initAQ[31:0] = posdividend;
	assign initAQ[63:32] = zerosconst;
	
	wire [63:0] startAQ;
	onebitshift_64 initShift(initAQ, startAQ);

	mux_2_64 isInitMux(count, startAQ, newAQ, productb);
	
	wire notCounterMSB;
	not notcntrmsb(notCounterMSB, counterMSB);
	register64  QuotientRegister(clock, notCounterMSB, productb, AQ, reset);
	assign unsignedquotient = AQ;
	
	onebitshift_64 AQShift(AQ, AQShifted);
	wire subberoverflow;
	
	cla_adder trialsubtraction(AQShifted[63:32], invertedposdivisor, trialsub, 1'b1, subberoverflow);

	assign trialsubMSB = trialsub[31];
	
	assign oldQ = AQShifted[31:0];
	
	mux_2 trialresult(trialsubMSB, trialsub, AQShifted[63:32], newA);
	
	assign newAQ[31:0] = newQ;
	assign newAQ[63:32] = newA;
	
	assign newQ[31:1] = oldQ[31:1];
	wire notTrialSubMSB;
	not trialnot(notTrialSubMSB, trialsubMSB);
	assign newQ[0] = notTrialSubMSB;
	
	
	wire isoutneg, suboverflow2;
	xor computeoutneg(isoutneg, isDivisorNeg, isDividendNeg);
	wire [31:0] unsignedquofip;
	twos_complement_flipper32 flip4(unsignedquotient[31:0], unsignedquofip);
	wire [31:0] negout;
	cla_adder computenegout(unsignedquofip, zerosconst, negout, 1'b1, suboverflow2);
	mux_2 isneg(isoutneg, unsignedquotient[31:0], negout, result);
	
endmodule