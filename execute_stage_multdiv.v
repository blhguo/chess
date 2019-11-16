module execute_stage_multdiv(
		pc_out, pc_in, 
		execute_output, data_rdy,
		data_in_regA, data_in_regB,
		R, I, JI, JII, opcode, rd, rs, rt, shiftamt, aluop, immediate, target,
		clk, enable, clr,
		R_t, I_t, JI_t, JII_t, opcode_t, rd_t, rs_t, rt_t, shiftamt_t, aluop_t, immediate_t, target_t, 
		isBypassData_A, bypassData_A, 
		isBypassData_B, bypassData_B, 
		is_executing, 
		multdiv_overflow
		//data_out_regA_internal_inc_bex_DEBUG, data_out_regB_internal_inc_bex_DEBUG, alu_output_DEBUG
		);
	
	
	//###############################DEBUG OUTPUTS###########################################//
	
	//output [31:0] data_out_regA_internal_inc_bex_DEBUG, data_out_regB_internal_inc_bex_DEBUG, alu_output_DEBUG;
	//#####################Inputs and output definitions####################################//
	input [31:0] pc_in;
	output [31:0] pc_out;
	
	output [31:0] execute_output;
	output data_rdy;
	//output_z should be a boolean representing if the jump condition is valid/should we jump
	
	input [31:0] data_in_regA, data_in_regB;
	
	input clk, enable, clr;
	
	output [4:0] opcode, rd, rs, rt, shiftamt, aluop;
	output [16:0] immediate;
	output [26:0] target;
	output R, I, JI, JII;
	
	input [4:0] opcode_t, rd_t, rs_t, rt_t, shiftamt_t, aluop_t;
	input [16:0] immediate_t;
	input [26:0] target_t;
	input R_t, I_t, JI_t, JII_t;
	
	input isBypassData_A, isBypassData_B;
	input [31:0] bypassData_A, bypassData_B;
	
	//#####################Data_internal processing to determine what to pass to ALU####################################//

	//wires to take output Q of data_regA/B into the ALU
	wire [31:0] data_out_regA, data_out_regB;
	wire [31:0] data_out_regA_temp, data_out_regB_temp;

	
	wire [4:0] rd_internal;
	parsed_instructions parsed_instruction_registers(pc_out, pc_in, R, I, JI, JII, opcode, rd_internal, rs, rt, shiftamt, aluop, immediate, target, clk, enable, clr,
								R_t, I_t, JI_t, JII_t, opcode_t, rd_t, rs_t, rt_t, shiftamt_t, aluop_t, immediate_t, target_t);
	
	register latched_regA(clk,
								enable,
								data_in_regA, data_out_regA_temp, clr);
								
	register latched_regB(clk,
								enable,
								data_in_regB, data_out_regB_temp, clr);
								
	//Check if we should do anything with the data, is this actually a multdiv op
	
	wire [4:0] aluop_inc_swlw;
	
	//this logic might be too permissive, if there are problems check it but curosy analysis is fine
	assign aluop_inc_swlw = I ? 5'd0 : aluop;
	
	wire [4:0] opNot;
	twos_complement_flipper5 opcode_flipper(opcode, opNot);
	
	wire is_alu_op;
	and is_alu_op_and(is_alu_op, opNot[4], opNot[3], opNot[2], opNot[1], opNot[0]);
	
	wire [4:0] aluop_inc_swlw_Not;
	twos_complement_flipper5 aluop_flipper(aluop_inc_swlw, aluop_inc_swlw_Not);
								
	wire is_mult;
	and is_mult_and(is_mult, is_alu_op, aluop_inc_swlw_Not[4], aluop_inc_swlw_Not[3], aluop_inc_swlw[2], aluop_inc_swlw[1], aluop_inc_swlw_Not[0]);
	
	wire is_div;
	and is_div_and(is_div, is_alu_op, aluop_inc_swlw_Not[4], aluop_inc_swlw_Not[3], aluop_inc_swlw[2], aluop_inc_swlw[1], aluop_inc_swlw[0]);
	
	//wire is_multdiv_XO;
	wire is_multdiv;
	//wire multdiv_overflow;

	wire [31:0] multdiv_output;
	output multdiv_overflow;
	wire multdiv_rdy;
	
	or is_multdiv_gate(is_multdiv, is_mult, is_div);
	//and is_multdiv_XO_and(is_multdiv_XO, multdiv_overflow, is_multdiv);
	
	assign data_out_regA = isBypassData_A ? bypassData_A : data_out_regA_temp;
	assign data_out_regB = isBypassData_B ? bypassData_B : data_out_regB_temp;

	
	multdiv_ref main_multdiv(data_out_regA, data_out_regB, 
		is_mult, is_div, clk, multdiv_output, multdiv_overflow, multdiv_rdy);
								
	wire [4:0] rd_temp;
	register5 latched_data_rdst(is_multdiv,
								1'b1, 
								rd_internal, rd_temp, clr);
								
	assign rd = multdiv_overflow ? 5'd30 : rd_temp;
	
	wire is_mult_latched;
	register1 is_mult_latched_reg(is_multdiv, 1'b1, is_mult, is_mult_latched, clr);
	
	output is_executing;
	wire is_multdiv_or_ready;
	wire is_multdiv_and_not_exec;
	and is_multdiv_and_not_exec_gate(is_multdiv_and_not_exec, is_multdiv, ~is_executing);
	or is_multdiv_or_ready_gate(is_multdiv_or_ready, is_multdiv, data_rdy);
	
	wire is_executing_data_in;
	assign is_executing_data_in = is_multdiv ? 1'b1 : data_rdy ? 1'b0 : is_executing;
	
	register1 is_executing_reg(~clk, 1'b1, is_executing_data_in, is_executing, clr);
	
	assign execute_output = multdiv_overflow ? is_mult_latched ? 32'd4 : 32'd5 : multdiv_output;
	
	assign data_rdy = multdiv_rdy;
	
endmodule