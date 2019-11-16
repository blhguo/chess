module decode_stage(
		pc_out, pc_in, 
		data_out_regA, data_out_regB,
		R, I, JI, JII, opcode, rd, rs, rt, shiftamt, aluop, immediate, target,
		clk, enable, clr,
		R_t, I_t, JI_t, JII_t, opcode_t, rd_t, rs_t, rt_t, shiftamt_t, aluop_t, immediate_t, target_t,
		rd_writeback, rdval_writeback);
		
	input [31:0] pc_in;
	output [31:0] pc_out;
	
	//marking data_out_regs as input because we are using external regfile structure
	input [31:0] data_out_regA, data_out_regB;
	
	input clk, enable, clr;
	
	output [4:0] opcode, rd, rs, rt, shiftamt, aluop;
	output [16:0] immediate;
	output [26:0] target;
	output R, I, JI, JII;
	
	input [4:0] opcode_t, rd_t, rs_t, rt_t, shiftamt_t, aluop_t;
	input [16:0] immediate_t;
	input [26:0] target_t;
	input R_t, I_t, JI_t, JII_t;
		
	input [31:0] rdval_writeback;
	input [4:0] rd_writeback;
	
	
	//################################controls#######################################//
	wire ctrl_reset;
	assign ctrl_reset = 1'b0;
	
	//should be fine to always be writable, because if it should not be writable processor will be attempting to write to zero.
	wire ctrl_writeEnable;
	assign ctrl_writeEnable = 1'b1;

	
	//################################instruction parsing#######################################//

	parsed_instructions parsed_instruction_registers(pc_out, pc_in, R, I, JI, JII, opcode, rd, rs, rt, shiftamt, aluop, immediate, target, clk, enable, clr,
									R_t, I_t, JI_t, JII_t, opcode_t, rd_t, rs_t, rt_t, shiftamt_t, aluop_t, immediate_t, target_t);
	/*
	
	//regfile operates off of the outputs of the instruction_decoded register latched values
	regfile registerFile(
    clk,
	 //need to define ctrl_writeEnable control bit
    ctrl_writeEnable,
	 //need to think about reset regfile, a "flush" doesnt flush the regfile
    ctrl_reset,
	 //the register to write to, rd_write
	 rd_writeback,
	 //the registerA to read from
    rs,
	 //the registerB to read from
	 rt,
	 //data to write to registerD
	 rdval_writeback,
	 //data out from registerA
    data_out_regA,
	 //data out from registerB
	 data_out_regB);
	 
	 */
endmodule