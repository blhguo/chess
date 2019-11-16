module fetch(pc_out_word, imem_out, pc_in_overwrite, pc_in_data, pc_in_overwrite_data, enable, clock, clr);
	input enable, clock, clr;
	
	input pc_in_overwrite;
	input [31:0] pc_in_overwrite_data;
	output [31:0] pc_out_word, pc_in_data;
	//marking imem_out as input because we are using external imem structure
	input [31:0] imem_out;
	
	wire [31:0] pc_data, pc_out_data, pc_out_incr;
	wire overflow;
	assign pc_data = pc_in_overwrite ? pc_in_overwrite_data : pc_out_word;
	
	wire [31:0] pc_data_incr;
	
	register pc(
    .clk(clock),
    .input_enable(enable),
    .in32(pc_data), .out32(pc_out_data), .clr(clr));
		
	cla_adder incr(pc_out_data, 32'd1, pc_data_incr, 1'b0, overflow);
	
	assign pc_in_data = pc_out_data;
	
	assign pc_out_word = pc_data_incr;
	
//	imem instruction_memory(.address(pc_out_data[11:0]), .clock(clock), .q(imem_out));
	

	/*
	wire [31:0] not_pc_in_data;
	
	not pc_in_data_not0(not_pc_in_data[0], pc_in_data[0]);
	not pc_in_data_not1(not_pc_in_data[1], pc_in_data[1]);   
	not pc_in_data_not2(not_pc_in_data[2], pc_in_data[2]);
	not pc_in_data_not3(not_pc_in_data[3], pc_in_data[3]);   
	not pc_in_data_not4(not_pc_in_data[4], pc_in_data[4]);
	not pc_in_data_not5(not_pc_in_data[5], pc_in_data[5]);    
	not pc_in_data_not6(not_pc_in_data[6], pc_in_data[6]);
	not pc_in_data_not7(not_pc_in_data[7], pc_in_data[7]);   
	not pc_in_data_not8(not_pc_in_data[8], pc_in_data[8]);
	not pc_in_data_not9(not_pc_in_data[9], pc_in_data[9]);    
	not pc_in_data_not10(not_pc_in_data[10], pc_in_data[10]);
	not pc_in_data_not11(not_pc_in_data[11], pc_in_data[11]);    
	not pc_in_data_not12(not_pc_in_data[12], pc_in_data[12]);
	not pc_in_data_not13(not_pc_in_data[13], pc_in_data[13]);    
	not pc_in_data_not14(not_pc_in_data[14], pc_in_data[14]);
	not pc_in_data_not15(not_pc_in_data[15], pc_in_data[15]);    
	not pc_in_data_not16(not_pc_in_data[16], pc_in_data[16]);
	not pc_in_data_not17(not_pc_in_data[17], pc_in_data[17]);   
	not pc_in_data_not18(not_pc_in_data[18], pc_in_data[18]);
	not pc_in_data_not19(not_pc_in_data[19], pc_in_data[19]);    
	not pc_in_data_not20(not_pc_in_data[20], pc_in_data[20]);
	not pc_in_data_not21(not_pc_in_data[21], pc_in_data[21]);
	not pc_in_data_not22(not_pc_in_data[22], pc_in_data[22]);   
	not pc_in_data_not23(not_pc_in_data[23], pc_in_data[23]);
	not pc_in_data_not24(not_pc_in_data[24], pc_in_data[24]);    
	not pc_in_data_not25(not_pc_in_data[25], pc_in_data[25]);
	not pc_in_data_not26(not_pc_in_data[26], pc_in_data[26]);    
	not pc_in_data_not27(not_pc_in_data[27], pc_in_data[27]);
	not pc_in_data_not28(not_pc_in_data[28], pc_in_data[28]);    
	not pc_in_data_not29(not_pc_in_data[29], pc_in_data[29]);
	not pc_in_data_not30(not_pc_in_data[30], pc_in_data[30]);    
	not pc_in_data_not31(not_pc_in_data[31], pc_in_data[31]);

	assign out = pc_in_enable ? not_pc_in_data : pc_out;
	assign imem_out = out;

	not not0(nout[0], out[0]);
	not not1(nout[1], out[1]);
	not not2(nout[2], out[2]);
	not not3(nout[3], out[3]);
	not not4(nout[4], out[4]);
	not not5(nout[5], out[5]);
	not not6(nout[6], out[6]);
	not not7(nout[7], out[7]);
	not not8(nout[8], out[8]);
	not not9(nout[9], out[9]);
	not not10(nout[10], out[10]);
	not not11(nout[11], out[11]);
	not not12(nout[12], out[12]);
	not not13(nout[13], out[13]);
	not not14(nout[14], out[14]);
	not not15(nout[15], out[15]);
	not not16(nout[16], out[16]);
	not not17(nout[17], out[17]);
	not not18(nout[18], out[18]);
	not not19(nout[19], out[19]);
	not not20(nout[20], out[20]);
	not not21(nout[21], out[21]);
	not not22(nout[22], out[22]);
	not not23(nout[23], out[23]);
	not not24(nout[24], out[24]);
	not not25(nout[25], out[25]);
	not not26(nout[26], out[26]);
	not not27(nout[27], out[27]);
	not not28(nout[28], out[28]);
	not not29(nout[29], out[29]);
	not not30(nout[30], out[30]);
	not not31(nout[31], out[31]);
	
	wire [30:0] t_clocks;

	assign t_clocks[0] = pc_in_enable ? clock : nout[0];
	assign t_clocks[1] = pc_in_enable ? clock : nout[1];    
	assign t_clocks[2] = pc_in_enable ? clock : nout[2];
	assign t_clocks[3] = pc_in_enable ? clock : nout[3];    
	assign t_clocks[4] = pc_in_enable ? clock : nout[4];
	assign t_clocks[5] = pc_in_enable ? clock : nout[5];    
	assign t_clocks[6] = pc_in_enable ? clock : nout[6];
	assign t_clocks[7] = pc_in_enable ? clock : nout[7];    
	assign t_clocks[8] = pc_in_enable ? clock : nout[8];
	assign t_clocks[9] = pc_in_enable ? clock : nout[9];    
	assign t_clocks[10] = pc_in_enable ? clock : nout[10];
	assign t_clocks[11] = pc_in_enable ? clock : nout[11];    
	assign t_clocks[12] = pc_in_enable ? clock : nout[12];
	assign t_clocks[13] = pc_in_enable ? clock : nout[13];    
	assign t_clocks[14] = pc_in_enable ? clock : nout[14];
	assign t_clocks[15] = pc_in_enable ? clock : nout[15];    
	assign t_clocks[16] = pc_in_enable ? clock : nout[16];
	assign t_clocks[17] = pc_in_enable ? clock : nout[17];    
	assign t_clocks[18] = pc_in_enable ? clock : nout[18];
	assign t_clocks[19] = pc_in_enable ? clock : nout[19];    
	assign t_clocks[20] = pc_in_enable ? clock : nout[20];
	assign t_clocks[21] = pc_in_enable ? clock : nout[21];    
	assign t_clocks[22] = pc_in_enable ? clock : nout[22];
	assign t_clocks[23] = pc_in_enable ? clock : nout[23];    
	assign t_clocks[24] = pc_in_enable ? clock : nout[24];
	assign t_clocks[25] = pc_in_enable ? clock : nout[25];    
	assign t_clocks[26] = pc_in_enable ? clock : nout[26];
	assign t_clocks[27] = pc_in_enable ? clock : nout[27];    
	assign t_clocks[28] = pc_in_enable ? clock : nout[28];
	assign t_clocks[29] = pc_in_enable ? clock : nout[29];    
	assign t_clocks[30] = pc_in_enable ? clock : nout[30];

	dffe_ref bit0(.q(pc_out[0]), .d(nout[0]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit1(.q(pc_out[1]), .d(nout[1]), .clk(t_clocks[0]), .en(enable), .clr(clr));
	dffe_ref bit2(.q(pc_out[2]), .d(nout[2]), .clk(t_clocks[1]), .en(enable), .clr(clr));
	dffe_ref bit3(.q(pc_out[3]), .d(nout[3]), .clk(t_clocks[2]), .en(enable), .clr(clr));    
	dffe_ref bit4(.q(pc_out[4]), .d(nout[4]), .clk(t_clocks[3]), .en(enable), .clr(clr));
	dffe_ref bit5(.q(pc_out[5]), .d(nout[5]), .clk(t_clocks[4]), .en(enable), .clr(clr));    
	dffe_ref bit6(.q(pc_out[6]), .d(nout[6]), .clk(t_clocks[5]), .en(enable), .clr(clr));
	dffe_ref bit7(.q(pc_out[7]), .d(nout[7]), .clk(t_clocks[6]), .en(enable), .clr(clr));    
	dffe_ref bit8(.q(pc_out[8]), .d(nout[8]), .clk(t_clocks[7]), .en(enable), .clr(clr));
	dffe_ref bit9(.q(pc_out[9]), .d(nout[9]), .clk(t_clocks[8]), .en(enable), .clr(clr));    
	dffe_ref bit10(.q(pc_out[10]), .d(nout[10]), .clk(t_clocks[9]), .en(enable), .clr(clr));
	dffe_ref bit11(.q(pc_out[11]), .d(nout[11]), .clk(t_clocks[10]), .en(enable), .clr(clr));    
	dffe_ref bit12(.q(pc_out[12]), .d(nout[12]), .clk(t_clocks[11]), .en(enable), .clr(clr));
	dffe_ref bit13(.q(pc_out[13]), .d(nout[13]), .clk(t_clocks[12]), .en(enable), .clr(clr));    
	dffe_ref bit14(.q(pc_out[14]), .d(nout[14]), .clk(t_clocks[13]), .en(enable), .clr(clr));
	dffe_ref bit15(.q(pc_out[15]), .d(nout[15]), .clk(t_clocks[14]), .en(enable), .clr(clr));    
	dffe_ref bit16(.q(pc_out[16]), .d(nout[16]), .clk(t_clocks[15]), .en(enable), .clr(clr));
	dffe_ref bit17(.q(pc_out[17]), .d(nout[17]), .clk(t_clocks[16]), .en(enable), .clr(clr));    
	dffe_ref bit18(.q(pc_out[18]), .d(nout[18]), .clk(t_clocks[17]), .en(enable), .clr(clr));
	dffe_ref bit19(.q(pc_out[19]), .d(nout[19]), .clk(t_clocks[18]), .en(enable), .clr(clr));    
	dffe_ref bit20(.q(pc_out[20]), .d(nout[20]), .clk(t_clocks[19]), .en(enable), .clr(clr));
	dffe_ref bit21(.q(pc_out[21]), .d(nout[21]), .clk(t_clocks[20]), .en(enable), .clr(clr));    
	dffe_ref bit22(.q(pc_out[22]), .d(nout[22]), .clk(t_clocks[21]), .en(enable), .clr(clr));
	dffe_ref bit23(.q(pc_out[23]), .d(nout[23]), .clk(t_clocks[22]), .en(enable), .clr(clr));    
	dffe_ref bit24(.q(pc_out[24]), .d(nout[24]), .clk(t_clocks[23]), .en(enable), .clr(clr));
	dffe_ref bit25(.q(pc_out[25]), .d(nout[25]), .clk(t_clocks[24]), .en(enable), .clr(clr));    
	dffe_ref bit26(.q(pc_out[26]), .d(nout[26]), .clk(t_clocks[25]), .en(enable), .clr(clr));
	dffe_ref bit27(.q(pc_out[27]), .d(nout[27]), .clk(t_clocks[26]), .en(enable), .clr(clr));    
	dffe_ref bit28(.q(pc_out[28]), .d(nout[28]), .clk(t_clocks[27]), .en(enable), .clr(clr));
	dffe_ref bit29(.q(pc_out[29]), .d(nout[29]), .clk(t_clocks[28]), .en(enable), .clr(clr));    
	dffe_ref bit30(.q(pc_out[30]), .d(nout[30]), .clk(t_clocks[29]), .en(enable), .clr(clr));
	dffe_ref bit31(.q(pc_out[31]), .d(nout[31]), .clk(t_clocks[30]), .en(enable), .clr(clr));
	*/
	
/*
	
	dffe_ref bit0(.q(pc_out[0]), .d(nout[0]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit1(.q(pc_out[1]), .d(nout[1]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit2(.q(pc_out[2]), .d(nout[2]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit3(.q(pc_out[3]), .d(nout[3]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit4(.q(pc_out[4]), .d(nout[4]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit5(.q(pc_out[5]), .d(nout[5]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit6(.q(pc_out[6]), .d(nout[6]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit7(.q(pc_out[7]), .d(nout[7]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit8(.q(pc_out[8]), .d(nout[8]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit9(.q(pc_out[9]), .d(nout[9]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit10(.q(pc_out[10]), .d(nout[10]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit11(.q(pc_out[11]), .d(nout[11]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit12(.q(pc_out[12]), .d(nout[12]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit13(.q(pc_out[13]), .d(nout[13]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit14(.q(pc_out[14]), .d(nout[14]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit15(.q(pc_out[15]), .d(nout[15]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit16(.q(pc_out[16]), .d(nout[16]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit17(.q(pc_out[17]), .d(nout[17]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit18(.q(pc_out[18]), .d(nout[18]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit19(.q(pc_out[19]), .d(nout[19]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit20(.q(pc_out[20]), .d(nout[20]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit21(.q(pc_out[21]), .d(nout[21]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit22(.q(pc_out[22]), .d(nout[22]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit23(.q(pc_out[23]), .d(nout[23]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit24(.q(pc_out[24]), .d(nout[24]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit25(.q(pc_out[25]), .d(nout[25]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit26(.q(pc_out[26]), .d(nout[26]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit27(.q(pc_out[27]), .d(nout[27]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit28(.q(pc_out[28]), .d(nout[28]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit29(.q(pc_out[29]), .d(nout[29]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit30(.q(pc_out[30]), .d(nout[30]), .clk(clock), .en(enable), .clr(clr));
	dffe_ref bit31(.q(pc_out[31]), .d(nout[31]), .clk(clock), .en(enable), .clr(clr));
*/
	
//
//	dffe_ref bit0(.q(out[0]), .d(nout[0]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit1(.q(out[1]), .d(nout[1]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit2(.q(out[2]), .d(nout[2]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit3(.q(out[3]), .d(nout[3]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit4(.q(out[4]), .d(nout[4]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit5(.q(out[5]), .d(nout[5]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit6(.q(out[6]), .d(nout[6]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit7(.q(out[7]), .d(nout[7]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit8(.q(out[8]), .d(nout[8]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit9(.q(out[9]), .d(nout[9]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit10(.q(out[10]), .d(nout[10]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit11(.q(out[11]), .d(nout[11]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit12(.q(out[12]), .d(nout[12]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit13(.q(out[13]), .d(nout[13]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit14(.q(out[14]), .d(nout[14]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit15(.q(out[15]), .d(nout[15]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit16(.q(out[16]), .d(nout[16]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit17(.q(out[17]), .d(nout[17]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit18(.q(out[18]), .d(nout[18]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit19(.q(out[19]), .d(nout[19]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit20(.q(out[20]), .d(nout[20]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit21(.q(out[21]), .d(nout[21]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit22(.q(out[22]), .d(nout[22]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit23(.q(out[23]), .d(nout[23]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit24(.q(out[24]), .d(nout[24]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit25(.q(out[25]), .d(nout[25]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit26(.q(out[26]), .d(nout[26]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit27(.q(out[27]), .d(nout[27]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit28(.q(out[28]), .d(nout[28]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit29(.q(out[29]), .d(nout[29]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit30(.q(out[30]), .d(nout[30]), .clk(clock), .en(enable), .clr(clr));
//	dffe_ref bit31(.q(out[31]), .d(nout[31]), .clk(clock), .en(enable), .clr(clr));

	//assign pc_out_word = pc_out << 2;
	
endmodule