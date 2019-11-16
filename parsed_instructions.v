module parsed_instructions(pc_out, pc_in, R, I, JI, JII, opcode, rd, rs, rt, shiftamt, aluop, immediate, target, clk, enable, clr,
									R_t, I_t, JI_t, JII_t, opcode_t, rd_t, rs_t, rt_t, shiftamt_t, aluop_t, immediate_t, target_t);
	input [31:0] pc_in;
	output [31:0] pc_out;
	input clk, enable, clr;
	output [4:0] opcode, rd, rs, rt, shiftamt, aluop;
	output [16:0] immediate;
	output [26:0] target;
	output R, I, JI, JII;
	
	input [4:0] opcode_t, rd_t, rs_t, rt_t, shiftamt_t, aluop_t;
	input [16:0] immediate_t;
	input [26:0] target_t;
	input R_t, I_t, JI_t, JII_t;
	
//only need to call lower function once, on first parse in Decode stage
	
//	instruction_decoder decode(R_t, I_t, JI_t, JII_t, opcode_t, rd_t, rs_t, rt_t, shiftamt_t, aluop_t, immediate_t, target_t, instruction);

	register pc_reg(.clk(clk), .input_enable(enable), .in32(pc_in), .out32(pc_out), .clr(clr));
	
	register5 opcode_reg(.clk(clk), .input_enable(enable), .in5(opcode_t), .out5(opcode), .clr(clr));
	register5 rd_reg(.clk(clk), .input_enable(enable), .in5(rd_t), .out5(rd), .clr(clr));
	register5 rs_reg(.clk(clk), .input_enable(enable), .in5(rs_t), .out5(rs), .clr(clr));
	register5 rt_reg(.clk(clk), .input_enable(enable), .in5(rt_t), .out5(rt), .clr(clr));
	register5 shiftamt_reg(.clk(clk), .input_enable(enable), .in5(shiftamt_t), .out5(shiftamt), .clr(clr));
	register5 aluop_reg(.clk(clk), .input_enable(enable), .in5(aluop_t), .out5(aluop), .clr(clr));
	
	register17 immediate_reg(.clk(clk), .input_enable(enable), .in17(immediate_t), .out17(immediate), .clr(clr));
	
	register27 target_reg(.clk(clk), .input_enable(enable), .in27(target_t), .out27(target), .clr(clr));
	
	register1 R_reg(.clk(clk), .input_enable(enable), .in1(R_t), .out1(R), .clr(clr));
	register1 I_reg(.clk(clk), .input_enable(enable), .in1(I_t), .out1(I), .clr(clr));
	register1 JI_reg(.clk(clk), .input_enable(enable), .in1(JI_t), .out1(JI), .clr(clr));
	register1 JII_reg(.clk(clk), .input_enable(enable), .in1(JII_t), .out1(JII), .clr(clr));	
	
endmodule