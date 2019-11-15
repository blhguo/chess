module writeback_stage(
		rdval_writeback, rd_writeback,
		alu_output_as_input, data_mem_read_as_input,
		R, I, JI, JII, opcode, rd, rs, rt, shiftamt, aluop, immediate, target,
		clk, enable, clr,
		R_t, I_t, JI_t, JII_t, opcode_t, rd_t, rs_t, rt_t, shiftamt_t, aluop_t, immediate_t, target_t
		);
	
	input [31:0] alu_output_as_input, data_mem_read_as_input;
	output [31:0] rdval_writeback;
	output [4:0] rd_writeback;
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
	
	//################################instruction parsing#######################################//
	wire [31:0] pc_out, pc_in;
	assign pc_out = 32'd0;
	assign pc_in = 32'd0;

	parsed_instructions parsed_instruction_registers(pc_out, pc_in, R, I, JI, JII, opcode, rd, rs, rt, shiftamt, aluop, immediate, target, clk, enable, clr,
									R_t, I_t, JI_t, JII_t, opcode_t, rd_t, rs_t, rt_t, shiftamt_t, aluop_t, immediate_t, target_t);
	
	//####################control if the writeback VALUE is from DMEM or ALU#######################//
	wire [4:0] opNot;
	twos_complement_flipper5 opcode_flipper(opcode, opNot);
	
	wire ctrl_writeback_val;
	and is_ctrl_writeback_val_and(ctrl_writeback_val, opNot[4], opcode[3], opNot[2], opNot[1], opNot[0]);
	
	wire [31:0] alu_output_as_output;
	register alu_output_as_output_register(clk, enable, alu_output_as_input, alu_output_as_output, clr);
	
	wire [31:0] data_mem_read_as_output;
	register data_mem_read_as_output_register(clk, enable, data_mem_read_as_input, data_mem_read_as_output, clr);
	
		
	assign rdval_writeback = ctrl_writeback_val ? data_mem_read_as_output : alu_output_as_output;
	
	//####################control if the writeback ADDRESS is extracted or ZERO address#######################//
	//By definition in the decode stage, if there is no writeback expected, then RD should be set already to zero and the attempted write should fail. 
	//The target is always correct, meaning no need for control. 
	assign rd_writeback = rd;
endmodule