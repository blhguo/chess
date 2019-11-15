module memory_stage(
		alu_output_as_input, data_out_regB_as_input, data_out_regB_as_output,
		alu_output_as_output, data_mem_read_output,
		R, I, JI, JII, opcode, rd, rs, rt, shiftamt, aluop, immediate, target,
		clk, enable, clr,
		R_t, I_t, JI_t, JII_t, opcode_t, rd_t, rs_t, rt_t, shiftamt_t, aluop_t, immediate_t, target_t, 
		data_out_regB_as_input_bypass, is_data_out_regB_as_input_bypass
		);
	
	input [31:0] alu_output_as_input, data_out_regB_as_input;
	output [31:0] alu_output_as_output, data_out_regB_as_output; 
	
	//marking data_mem_read_output as input because we are using external dmem structure
	input [31:0] data_mem_read_output;

	//output_z should be a boolean representing if the jump condition is valid/should we jump
		
	input clk, enable, clr;
	
	//##################Instruction parsed values#######################//
	output [4:0] opcode, rd, rs, rt, shiftamt, aluop;
	output [16:0] immediate;
	output [26:0] target;
	output R, I, JI, JII;
	
	input [4:0] opcode_t, rd_t, rs_t, rt_t, shiftamt_t, aluop_t;
	input [16:0] immediate_t;
	input [26:0] target_t;
	input R_t, I_t, JI_t, JII_t;
	
	input [31:0] data_out_regB_as_input_bypass;
	input is_data_out_regB_as_input_bypass;
	
	//################################instruction parsing#######################################//
	
	wire [31:0] pc_out, pc_in;
	assign pc_out = 32'd0;
	assign pc_in = 32'd0;
	
	parsed_instructions parsed_instruction_registers(pc_out, pc_in, R, I, JI, JII, opcode, rd, rs, rt, shiftamt, aluop, immediate, target, clk, enable, clr,
									R_t, I_t, JI_t, JII_t, opcode_t, rd_t, rs_t, rt_t, shiftamt_t, aluop_t, immediate_t, target_t);
	
	wire [31:0] data_out_regB_as_output_temp;
	register data_out_regB_as_output_register(clk, enable, data_out_regB_as_input, data_out_regB_as_output_temp, clr);
	assign data_out_regB_as_output = is_data_out_regB_as_input_bypass ? data_out_regB_as_input_bypass : data_out_regB_as_output_temp;
	
	register alu_output_as_output_register(clk, enable, alu_output_as_input, alu_output_as_output, clr);

	wire [4:0] opNot;
	twos_complement_flipper5 opcode_flipper(opcode, opNot);
	/*
	wire is_sw;
	and is_sw_and(is_sw, opNot[4], opNot[3], opcode[2], opcode[1], opcode[0]);
	
	dmem data_memory(
		.address(alu_output_as_input),
		.clock(clk),
		.data(data_out_regB_as_input),
		//This enable needs to be a control signal
		.wren(is_sw),
		.q(data_mem_read_output));
	*/
	//assign alu_output_as_output = alu_output_as_input;
	
		
	
endmodule