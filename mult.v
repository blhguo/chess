module mult(multiplicand, multiplier, clock, reset, result, overflow, ready);
	input [31:0] multiplicand, multiplier;
	input clock, reset;
	output [31:0] result;
	output overflow, ready;
		
	wire [31:0] A;
	assign A = multiplicand;
	wire [31:0] B;
	assign B = multiplier;
	wire isAZero;
	wire [33:0] A34;
	wire [33:0] A34Shifted;
	wire [4:0] counter;
	wire enable;
	assign enable = 1'b1;
	wire [32:0] B33;
	wire isFirstLoad;
	wire isAShifting;
	wire isNoop;
	wire isAdd;
	wire [2:0] lsb_multiplier;
	
	wire [32:0] LSB33a;
	
	wire [1:0] operation;
	wire [33:0] subtractA, addA, NoopA, MSB34a;
	wire [33:0] MSB34b;
	wire [32:0] LSB33b;
	wire [31:0] MSB32a;
	wire [33:0] ShiftConsideredA34;
	
	wire [64:0] Productb, Producta;
	wire adderOverflow, subberOverflow;

	wire [33:0] flippedA;
	wire notclk;
	not nc(notclk, clock);
	
	//Check if the multiplicand is zero, if it is then we cannot overflow
	checkAisZero ACheck(A, isAZero);
	detectOverflow isOverflow(isAZero, LSB33a, MSB32a, overflow);

	//extend input A by two bits
	twobitsignextender extendA(A, A34);
	
	//Depending on our control center (isShifting), we may need A34 shifted. 
	onebitshift shiftA34(A34, A34Shifted);
	
	//instantiate the 4-bit counter to see how many operations have occurred. Currently always enabled
	counter5 my_counter(enable, clock, counter, reset);

	//pad b with one zero for the initializaiton; this value isn't used again. 
	padshift padB(B, B33);
	
	//detect whether the mux should select the shifted B (this is count=0) or the current running product
	or findIsFirstLoad(isFirstLoad, counter[0], counter[1], counter[2], counter[3], counter[4]);
	
	//Define the opcode being used. 00 is subtract, 01 is no operation, 10 is add, 11 is broken.
	assign operation[0] = isAdd;
	assign operation[1] = isNoop;
	
	//extend the current product's MSB by two bits to use in the adder. 
	twobitsignextender extendProduct(MSB32a, MSB34a);
	
	//Add
	cla_adder2 adder(MSB34a, ShiftConsideredA34, addA, 1'b0, adderOverflow);
	
	//Flip bits. Currently ignoring sum and sub overflow
	twos_complement_flipper34 flipA(ShiftConsideredA34, flippedA);
	
	//"add" but in reality subtract
	cla_adder2 subber(MSB34a, flippedA, subtractA, 1'b1, subberOverflow);
	
	//Nooperation means MSB34a is used directly, aka the current MSB of the running product is preserved
	assign NoopA = MSB34a;
	
	//Mux to operate off the opcode and select one of the operation values. Write into MSB23b
	mux_4_34 selectOperation(operation, subtractA, addA, NoopA, NoopA, MSB34b);
	
	//Append new MSB (may not have changed) to new LSB (67-2 bit number) save as new Product
	joiner createNewProduct(MSB34b, LSB33b, Productb);
	
	//currently always enabled, should fix later
	// Write new product into register as input, output should be current val of register. Always enabled right now.
	register65  ProductRegister(clock, enable, Productb, Producta, reset);
	
	//Print result, which is the current value in the register except we remove last bit that was only used for booths
	assign result = Producta[32:1];
	
	//Split the 65 bit read value out of register into MSB32a and LSB33a
	splitter32MSB33LSB splitResult(Producta, MSB32a, LSB33a);
	

	// need to define LSB33a to pass in as in1, in2, in3
	// if this is the first load, then load B33 into LSB33b, otherwise load the LSB of the current running product. 
	mux_2_33 loadBOr33LSB(isFirstLoad, B33, LSB33a, LSB33b);

	
	//Need to extract lsb_multiplier
	//Get the 3 LSB from the new running product, write to LSB_Multiplier. Use this as your control opcode
	lsb_extractor extractLSB(LSB33b, lsb_multiplier);

	//determine the control opcode
	ctrl lsb_ctrl(lsb_multiplier, isAdd, isNoop, isAShifting);
	
	//Depending on the control opcode, choose which A we should be working with. 
	mux_2_34 shiftASelector(isAShifting, A34, A34Shifted, ShiftConsideredA34);

	wire isReady;
	nor ready_or(isReady, counter[0], counter[1], counter[2], counter[3]);
	and ready_and(ready, isReady, counter[4]);	
	
endmodule