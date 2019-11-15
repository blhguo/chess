module execute_stage(pc_out, pc_in, 
		execute_output, pc_out_overwrite_enable, data_out_regB, pc_out_overwrite_data,
		data_in_regA, data_in_regB,
		R, I, JI, JII, opcode, rd, rs, rt, shiftamt, aluop, immediate, target,
		clk, enable, clr,
		R_t, I_t, JI_t, JII_t, opcode_t, rd_t, rs_t, rt_t, shiftamt_t, aluop_t, immediate_t, target_t, 
		isBypassData_A, bypassData_A, 
		isBypassData_B, bypassData_B, 
		aluop_inc_swlw_inc_setx_jal, 
		overflow
		//, isBNE_or_isBLT_DEBUG
		//data_out_regA_internal_inc_bex_DEBUG, data_out_regB_internal_inc_bex_DEBUG, alu_output_DEBUG
		);
	
	
	//###############################DEBUG OUTPUTS###########################################//
	
	//output [31:0] data_out_regA_internal_inc_bex_DEBUG, data_out_regB_internal_inc_bex_DEBUG, alu_output_DEBUG;
	//output [31:0] isBNE_or_isBLT_DEBUG;
	//#####################Inputs and output definitions####################################//
	input [31:0] pc_in;
	output [31:0] pc_out;
	
	output [31:0] execute_output, data_out_regB, pc_out_overwrite_data;
	//output_z should be a boolean representing if the jump condition is valid/should we jump
	output pc_out_overwrite_enable;
	
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
	wire [31:0] data_out_regA_internal, data_out_regB_internal;
	
	wire [4:0] rd_internal;
	parsed_instructions parsed_instruction_registers(pc_out, pc_in, R, I, JI, JII, opcode, rd_internal, rs, rt, shiftamt, aluop, immediate, target, clk, enable, clr,
								R_t, I_t, JI_t, JII_t, opcode_t, rd_t, rs_t, rt_t, shiftamt_t, aluop_t, immediate_t, target_t);
	
	register latched_regA(clk,
								enable,
								data_in_regA, data_out_regA_internal, clr);
								
	register latched_regB(clk,
								enable,
								data_in_regB, data_out_regB_internal, clr);
								
	wire isNotEqual, isLessThan, alu_overflow;
	
	//compute the shifted extended immediate and return as output
	wire [31:0] extended_imm;
	sign_extend_16to32 extender(extended_imm, immediate);
	
	//wire [31:0] shifted_extended_imm;
	//not sure if need to shift right now.
	//assign shifted_extended_imm = extended_imm << 0;
	
	wire overflow_add_pc_imm;
	wire [31:0] extended_shifted_pc_added_immediate;

	cla_adder add_pc_imm(extended_imm, pc_out, extended_shifted_pc_added_immediate, 1'b1, overflow_add_pc_imm);
	
	//compute the internal version of data_out_regB
	//use the sign extend + mux if the operation is an immediate operation
		
	//######################CONTROL for ALU input B muxed##################################//
	
	
	wire [31:0] data_out_regA_internal_inc_bex, data_out_regB_internal_inc_bex;
		
	//end data_out_regB_internal logic
	//aluop might not be add op when using sw/lw, consider addi
	wire [4:0] aluop_inc_swlw;
	
	//this logic might be too permissive, if there are problems check it but curosy analysis is fine
	assign aluop_inc_swlw = I ? 5'd0 : aluop;
							/*
								wire is_sw;
								and is_sw_and(is_sw, opNot[4], opNot[3], opcode[2], opcode[1], opcode[0]);
								wire is_lw;
								and is_lw_and(is_lw, opNot[4], opcode[3], opNot[2], opNot[1], opNot[0]);
								
								
								alu main_alu(data_out_regA_internal_inc_bex, data_out_regB_internal_inc_bex, aluop_inc_swlw,
										shiftamt, alu_output, isNotEqual, isLessThan, overflow);
							*/


	//#######################compute pc_out_overwrite_enable###################################//
	
	//add a module to handle whether we should branch
	
	//assign pc_out_overwrite_data = JI ? target : extended_shifted_pc_added_immediate;
	
	wire isBNE;
	wire isBLT;
	wire [4:0] opNot;
	twos_complement_flipper5 opcode_flipper(opcode, opNot);
	
	and isBNE_and(isBNE, opNot[4], opNot[3], opNot[2], opcode[1], opNot[0], isNotEqual);
	and isBLT_and(isBLT, opNot[4], opNot[3], opcode[2], opcode[1], opNot[0], isLessThan);
	
	wire isBNE_non_exec;
	wire isBLT_non_exec;
	wire isBNE_or_isBLT_non_exec;
	and isBNE_non_exec_and(isBNE_non_exec, opNot[4], opNot[3], opNot[2], opcode[1], opNot[0]);
	and isBLT_non_exec_and(isBLT_non_exec, opNot[4], opNot[3], opcode[2], opcode[1], opNot[0]);
	or isBNE_isBLT_not_or_gate(isBNE_or_isBLT_non_exec, isBNE_non_exec, isBLT_non_exec);

	
	
	wire isBNE_or_isBLT;
	//wire [31:0] pc_out_overwrite_data_temp;
	or isBNE_isBLT_or_gate(isBNE_or_isBLT, isBNE, isBLT);
	wire not_isBNE_or_isBLT_non_exec;
	not not_isBNE_or_isBLT_gate(not_isBNE_or_isBLT_non_exec, isBNE_or_isBLT_non_exec);
	wire is_I_ex_isBNE_or_isBLT_non_exec;
	and is_I_ex_isBNE_or_isBLT_and(is_I_ex_isBNE_or_isBLT_non_exec, I, not_isBNE_or_isBLT_non_exec);
	
	assign data_out_regB = isBypassData_B ? bypassData_B : data_out_regB_internal;
	wire [31:0] data_out_regB_internal_inc_imm;
	assign data_out_regB_internal_inc_imm = is_I_ex_isBNE_or_isBLT_non_exec ? extended_imm : data_out_regB;

	//###############################DEBUG#############################################
	//assign isBNE_or_isBLT_DEBUG = extended_imm;
	//############################################################################
	wire is_j;
	and is_j_and(is_j, opNot[4], opNot[3], opNot[2], opNot[1], opcode[0]);
		
	wire is_jr;
	and is_jr_and(is_jr, opNot[4], opNot[3], opcode[2], opNot[1], opNot[0]);
	
	wire is_jal;
	and is_jal_and(is_jal, opNot[4], opNot[3], opNot[2], opcode[1], opcode[0]);
	
	wire is_alu_op;
	and is_alu_op_and(is_alu_op, opNot[4], opNot[3], opNot[2], opNot[1], opNot[0]);
	
	wire is_addi;
	and is_addi_and(is_addi, opNot[4], opNot[3], opcode[2], opNot[1], opcode[0]);
	wire is_alu_op_inc_addi;
	or is_alu_op_inc_addi_gate(is_alu_op_inc_addi, is_alu_op, is_addi);
	
	wire [4:0] aluop_inc_swlw_Not;
	twos_complement_flipper5 aluop_flipper(aluop_inc_swlw, aluop_inc_swlw_Not);
	
	wire is_mult;
	and is_mult_and(is_mult, is_alu_op, aluop_inc_swlw_Not[4], aluop_inc_swlw_Not[3], aluop_inc_swlw[2], aluop_inc_swlw[1], aluop_inc_swlw_Not[0]);
	
	wire is_div;
	and is_div_and(is_div, is_alu_op, aluop_inc_swlw_Not[4], aluop_inc_swlw_Not[3], aluop_inc_swlw[2], aluop_inc_swlw[1], aluop_inc_swlw[0]);
	
	wire is_alu_op_inc_addi_ex_multdiv;
	wire is_not_multdiv;
	nor is_not_multdiv_nor(is_not_multdiv, is_mult, is_div);
	and is_alu_op_inc_addi_ex_multdiv_gate(is_alu_op_inc_addi_ex_multdiv, is_alu_op_inc_addi, is_not_multdiv);
	
	wire is_add;
	and is_add_and(is_add, is_alu_op, aluop_inc_swlw_Not[4], aluop_inc_swlw_Not[3], aluop_inc_swlw_Not[2], aluop_inc_swlw_Not[1], aluop_inc_swlw_Not[0]);
	wire is_sub;
	and is_sub_and(is_sub, is_alu_op, aluop_inc_swlw_Not[4], aluop_inc_swlw_Not[3], aluop_inc_swlw[2], aluop_inc_swlw[1], aluop_inc_swlw[0]);
	
	
	wire is_bex;
	and is_bex_and(is_bex, opcode[4], opNot[3], opcode[2], opcode[1], opNot[0]);
	assign data_out_regB_internal_inc_bex = is_jal ? pc_out : is_setx ? target : data_out_regB_internal_inc_imm;
	assign data_out_regA_internal_inc_bex = is_jal ? 32'd1 : is_setx ? 32'd0 : isBypassData_A ? bypassData_A : data_out_regA_internal;
	wire is_bex_computed;
	and is_bex_computed_and(is_bex_computed, is_bex, isNotEqual);
	
	wire is_setx;
	and is_setx_and(is_setx, opcode[4], opNot[3], opcode[2], opNot[1], opcode[0]);
	wire is_setx_not;
	not is_setx_not_gate(is_setx_not, is_setx);
	
	assign pc_out_overwrite_data = isBNE_or_isBLT ? extended_shifted_pc_added_immediate : is_jr ? data_out_regA_internal_inc_bex : target;
	wire pc_out_overwrite_enable_temp;
	or pc_out_overwrite_enable_temp_or(pc_out_overwrite_enable_temp, isBNE_or_isBLT, is_jr, is_j, is_jal, is_bex_computed);
	and pc_out_overwrite_enable_temp_and(pc_out_overwrite_enable, pc_out_overwrite_enable_temp, is_setx_not);
	
	
	output [4:0] aluop_inc_swlw_inc_setx_jal;
	assign aluop_inc_swlw_inc_setx_jal = is_jal ? 5'd0 : is_setx ? 5'd0 : aluop_inc_swlw;
	
	
	
	//#######################done compute pc_out_overwrite_enable###################################//
	wire [31:0] alu_output;
	alu main_alu(data_out_regA_internal_inc_bex, data_out_regB_internal_inc_bex, aluop_inc_swlw_inc_setx_jal,
			shiftamt, alu_output, isNotEqual, isLessThan, alu_overflow);
	/*#############################DEBUG############################
	assign data_out_regA_internal_inc_bex_DEBUG = data_out_regA_internal_inc_bex;
	assign data_out_regB_internal_inc_bex_DEBUG = data_out_regB_internal_inc_bex;
	assign alu_output_DEBUG = alu_output;
	
	*/
	/*###########Mult code#######################################
	wire [31:0] multdiv_output;
	wire multdiv_overflow;
	wire multdiv_rdy;
	multdiv_ref main_multdiv(data_out_regA_internal_inc_bex, data_out_regB_internal_inc_bex, 
			is_mult, is_div, clk, multdiv_output, multdiv_overflow, multdiv_rdy);
	##############################################################*/

	wire is_alu_XO;
	and is_alu_XO_and(is_alu_XO, alu_overflow, is_alu_op_inc_addi_ex_multdiv);
	
	
	wire is_multdiv;
	not is_multdiv_not_gate(is_multdiv, is_not_multdiv);
	
	output overflow;
	assign overflow = is_alu_XO;
	wire is_not_overflow;
	not is_not_overflow_gate(is_not_overflow, overflow);

	wire [31:0] execute_output_internal;
	assign execute_output_internal = alu_output;

	//assign execute_output_internal = is_multdiv ? multdiv_output : alu_output;
	
	assign rd = overflow ? 5'd30 : is_multdiv ? 5'd0 : rd_internal;
	
	assign execute_output = is_not_overflow ? execute_output_internal : is_add ? 32'd1 : is_addi ? 32'd2 : is_sub ? 32'd3 : is_mult ? 32'd4 : 32'd5;
	//add chained if for status codes
	
	
	
endmodule